1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 contract Pausable is Ownable {
104   event Pause();
105   event Unpause();
106 
107   bool public paused = false;
108 
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is not paused.
112    */
113   modifier whenNotPaused() {
114     require(!paused);
115     _;
116   }
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is paused.
120    */
121   modifier whenPaused() {
122     require(paused);
123     _;
124   }
125 
126   /**
127    * @dev called by the owner to pause, triggers stopped state
128    */
129   function pause() onlyOwner whenNotPaused public {
130     paused = true;
131     emit Pause();
132   }
133 
134   /**
135    * @dev called by the owner to unpause, returns to normal state
136    */
137   function unpause() onlyOwner whenPaused public {
138     paused = false;
139     emit Unpause();
140   }
141 }
142 
143 contract PublicSale is Pausable {
144     using SafeMath for uint256;
145     using SafeERC20 for ERC20;
146 
147     uint256 public maxgas;
148     uint256 public maxcap;      // sale hardcap
149     uint256 public exceed;      // indivisual hardcap
150     uint256 public minimum;     // indivisual softcap
151     uint256 public rate;        // exchange rate
152 
153     bool public ignited = false;  // is sale started?
154     uint256 public weiRaised = 0; // check sale status
155 
156     address public wallet;      // wallet for withdrawal
157     Whitelist public List;      // whitelist
158     ERC20 public Token;         // token
159 
160     constructor (
161         uint256 _maxcap,
162         uint256 _exceed,
163         uint256 _minimum,
164         uint256 _rate,
165         uint256 _maxgas,
166         address _wallet,
167         address _whitelist,
168         address _token
169     ) public {
170         require(_wallet != address(0));
171         require(_whitelist != address(0));
172         require(_token != address(0));
173 
174         maxcap = _maxcap;
175         exceed = _exceed;
176         minimum = _minimum;
177         rate = _rate;
178 
179         maxgas = _maxgas;
180         wallet = _wallet;
181 
182         Token = ERC20(_token);
183         List = Whitelist(_whitelist);
184     }
185 
186     /* fallback function */
187     function () external payable {
188         collect();
189     }
190 
191 //  address
192     event Change(address addr, string name);
193     event ChangeMaxGas(uint256 gas);
194 
195     function setMaxGas(uint256 gas)
196         external
197         onlyOwner
198     {
199         require(gas > 0);
200         maxgas = gas;
201         emit ChangeMaxGas(gas);
202     }
203 
204     function setWhitelist(address whitelist)
205         external
206         onlyOwner
207     {
208         require(whitelist != address(0));
209 
210         List = Whitelist(whitelist);
211         emit Change(whitelist, "whitelist");
212     }
213 
214     function setWallet(address newWallet)
215         external
216         onlyOwner
217     {
218         require(newWallet != address(0));
219 
220         wallet = newWallet;
221         emit Change(newWallet, "wallet");
222     }
223 
224 //  sale controller
225     event Ignite();
226     event Extinguish();
227 
228     function ignite()
229         external
230         onlyOwner
231     {
232         ignited = true;
233         emit Ignite();
234     }
235 
236     function extinguish()
237         external
238         onlyOwner
239     {
240         ignited = false;
241         emit Extinguish();
242     }
243 
244 //  collect eth
245     event Purchase(address indexed buyer, uint256 purchased, uint256 refund, uint256 tokens);
246 
247     mapping (address => uint256) public buyers;
248 
249     function collect()
250         public
251         payable
252         whenNotPaused
253     {
254         address buyer = msg.sender;
255         uint256 amount = msg.value;
256 
257         require(ignited);
258         require(List.whitelist(buyer));
259         require(buyer != address(0));
260         require(buyers[buyer].add(amount) >= minimum);
261         require(buyers[buyer] < exceed);
262         require(weiRaised < maxcap);
263         require(tx.gasprice <= maxgas);
264 
265         uint256 purchase;
266         uint256 refund;
267 
268         (purchase, refund) = getPurchaseAmount(buyer, amount);
269 
270         weiRaised = weiRaised.add(purchase);
271         if(weiRaised >= maxcap) ignited = false;
272 
273         buyers[buyer] = buyers[buyer].add(purchase);
274 
275         buyer.transfer(refund);
276         Token.safeTransfer(buyer, purchase.mul(rate));
277 
278         emit Purchase(buyer, purchase, refund, purchase.mul(rate));
279     }
280 
281 //  util functions for collect
282     function getPurchaseAmount(address _buyer, uint256 _amount)
283         private
284         view
285         returns (uint256, uint256)
286     {
287         uint256 d1 = maxcap.sub(weiRaised);
288         uint256 d2 = exceed.sub(buyers[_buyer]);
289 
290         uint256 d = (d1 > d2) ? d2 : d1;
291 
292         return (_amount > d) ? (d, _amount.sub(d)) : (_amount, 0);
293     }
294 
295 //  finalize
296     bool public finalized = false;
297 
298     function finalize()
299         external
300         onlyOwner
301         whenNotPaused
302     {
303         require(!finalized);
304 
305         withdrawEther();
306         withdrawToken();
307 
308         finalized = true;
309     }
310 
311 //  withdraw
312     event WithdrawToken(address indexed from, uint256 amount);
313     event WithdrawEther(address indexed from, uint256 amount);
314 
315     function withdrawToken()
316         public
317         onlyOwner
318         whenNotPaused
319     {
320         require(!ignited);
321         Token.safeTransfer(wallet, Token.balanceOf(address(this)));
322         emit WithdrawToken(wallet, Token.balanceOf(address(this)));
323     }
324 
325     function withdrawEther()
326         public
327         onlyOwner
328         whenNotPaused
329     {
330         require(!ignited);
331         wallet.transfer(address(this).balance);
332         emit WithdrawEther(wallet, address(this).balance);
333     }
334 }
335 
336 contract RBAC {
337   using Roles for Roles.Role;
338 
339   mapping (string => Roles.Role) private roles;
340 
341   event RoleAdded(address addr, string roleName);
342   event RoleRemoved(address addr, string roleName);
343 
344   /**
345    * @dev reverts if addr does not have role
346    * @param addr address
347    * @param roleName the name of the role
348    * // reverts
349    */
350   function checkRole(address addr, string roleName)
351     view
352     public
353   {
354     roles[roleName].check(addr);
355   }
356 
357   /**
358    * @dev determine if addr has role
359    * @param addr address
360    * @param roleName the name of the role
361    * @return bool
362    */
363   function hasRole(address addr, string roleName)
364     view
365     public
366     returns (bool)
367   {
368     return roles[roleName].has(addr);
369   }
370 
371   /**
372    * @dev add a role to an address
373    * @param addr address
374    * @param roleName the name of the role
375    */
376   function addRole(address addr, string roleName)
377     internal
378   {
379     roles[roleName].add(addr);
380     emit RoleAdded(addr, roleName);
381   }
382 
383   /**
384    * @dev remove a role from an address
385    * @param addr address
386    * @param roleName the name of the role
387    */
388   function removeRole(address addr, string roleName)
389     internal
390   {
391     roles[roleName].remove(addr);
392     emit RoleRemoved(addr, roleName);
393   }
394 
395   /**
396    * @dev modifier to scope access to a single role (uses msg.sender as addr)
397    * @param roleName the name of the role
398    * // reverts
399    */
400   modifier onlyRole(string roleName)
401   {
402     checkRole(msg.sender, roleName);
403     _;
404   }
405 
406   /**
407    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
408    * @param roleNames the names of the roles to scope access to
409    * // reverts
410    *
411    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
412    *  see: https://github.com/ethereum/solidity/issues/2467
413    */
414   // modifier onlyRoles(string[] roleNames) {
415   //     bool hasAnyRole = false;
416   //     for (uint8 i = 0; i < roleNames.length; i++) {
417   //         if (hasRole(msg.sender, roleNames[i])) {
418   //             hasAnyRole = true;
419   //             break;
420   //         }
421   //     }
422 
423   //     require(hasAnyRole);
424 
425   //     _;
426   // }
427 }
428 
429 contract Whitelist is Ownable, RBAC {
430   event WhitelistedAddressAdded(address addr);
431   event WhitelistedAddressRemoved(address addr);
432 
433   string public constant ROLE_WHITELISTED = "whitelist";
434 
435   /**
436    * @dev Throws if called by any account that's not whitelisted.
437    */
438   modifier onlyWhitelisted() {
439     checkRole(msg.sender, ROLE_WHITELISTED);
440     _;
441   }
442 
443   /**
444    * @dev add an address to the whitelist
445    * @param addr address
446    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
447    */
448   function addAddressToWhitelist(address addr)
449     onlyOwner
450     public
451   {
452     addRole(addr, ROLE_WHITELISTED);
453     emit WhitelistedAddressAdded(addr);
454   }
455 
456   /**
457    * @dev getter to determine if address is in whitelist
458    */
459   function whitelist(address addr)
460     public
461     view
462     returns (bool)
463   {
464     return hasRole(addr, ROLE_WHITELISTED);
465   }
466 
467   /**
468    * @dev add addresses to the whitelist
469    * @param addrs addresses
470    * @return true if at least one address was added to the whitelist,
471    * false if all addresses were already in the whitelist
472    */
473   function addAddressesToWhitelist(address[] addrs)
474     onlyOwner
475     public
476   {
477     for (uint256 i = 0; i < addrs.length; i++) {
478       addAddressToWhitelist(addrs[i]);
479     }
480   }
481 
482   /**
483    * @dev remove an address from the whitelist
484    * @param addr address
485    * @return true if the address was removed from the whitelist,
486    * false if the address wasn't in the whitelist in the first place
487    */
488   function removeAddressFromWhitelist(address addr)
489     onlyOwner
490     public
491   {
492     removeRole(addr, ROLE_WHITELISTED);
493     emit WhitelistedAddressRemoved(addr);
494   }
495 
496   /**
497    * @dev remove addresses from the whitelist
498    * @param addrs addresses
499    * @return true if at least one address was removed from the whitelist,
500    * false if all addresses weren't in the whitelist in the first place
501    */
502   function removeAddressesFromWhitelist(address[] addrs)
503     onlyOwner
504     public
505   {
506     for (uint256 i = 0; i < addrs.length; i++) {
507       removeAddressFromWhitelist(addrs[i]);
508     }
509   }
510 
511 }
512 
513 library Roles {
514   struct Role {
515     mapping (address => bool) bearer;
516   }
517 
518   /**
519    * @dev give an address access to this role
520    */
521   function add(Role storage role, address addr)
522     internal
523   {
524     role.bearer[addr] = true;
525   }
526 
527   /**
528    * @dev remove an address' access to this role
529    */
530   function remove(Role storage role, address addr)
531     internal
532   {
533     role.bearer[addr] = false;
534   }
535 
536   /**
537    * @dev check if an address has this role
538    * // reverts
539    */
540   function check(Role storage role, address addr)
541     view
542     internal
543   {
544     require(has(role, addr));
545   }
546 
547   /**
548    * @dev check if an address has this role
549    * @return bool
550    */
551   function has(Role storage role, address addr)
552     view
553     internal
554     returns (bool)
555   {
556     return role.bearer[addr];
557   }
558 }
559 
560 contract ERC20Basic {
561   function totalSupply() public view returns (uint256);
562   function balanceOf(address who) public view returns (uint256);
563   function transfer(address to, uint256 value) public returns (bool);
564   event Transfer(address indexed from, address indexed to, uint256 value);
565 }
566 
567 contract ERC20 is ERC20Basic {
568   function allowance(address owner, address spender)
569     public view returns (uint256);
570 
571   function transferFrom(address from, address to, uint256 value)
572     public returns (bool);
573 
574   function approve(address spender, uint256 value) public returns (bool);
575   event Approval(
576     address indexed owner,
577     address indexed spender,
578     uint256 value
579   );
580 }
581 
582 library SafeERC20 {
583   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
584     require(token.transfer(to, value));
585   }
586 
587   function safeTransferFrom(
588     ERC20 token,
589     address from,
590     address to,
591     uint256 value
592   )
593     internal
594   {
595     require(token.transferFrom(from, to, value));
596   }
597 
598   function safeApprove(ERC20 token, address spender, uint256 value) internal {
599     require(token.approve(spender, value));
600   }
601 }