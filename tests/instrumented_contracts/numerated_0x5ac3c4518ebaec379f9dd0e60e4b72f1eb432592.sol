1 pragma solidity ^0.4.24;
2 
3 // File: contracts/math/Math.sol
4 
5 /**
6  * @title Math
7  * @dev Assorted math operations
8  */
9 library Math {
10   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
11     return a >= b ? a : b;
12   }
13 
14   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
15     return a < b ? a : b;
16   }
17 
18   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
19     return a >= b ? a : b;
20   }
21 
22   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
23     return a < b ? a : b;
24   }
25 }
26 
27 // File: contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     if (a == 0) {
40       return 0;
41     }
42     c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return a / b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69     c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 // File: contracts/rbac/Roles.sol
76 
77 /**
78  * @title Roles
79  * @author Francisco Giordano (@frangio)
80  * @dev Library for managing addresses assigned to a Role.
81  *      See RBAC.sol for example usage.
82  */
83 library Roles {
84   struct Role {
85     mapping (address => bool) bearer;
86   }
87 
88   /**
89    * @dev give an address access to this role
90    */
91   function add(Role storage role, address addr)
92     internal
93   {
94     role.bearer[addr] = true;
95   }
96 
97   /**
98    * @dev remove an address' access to this role
99    */
100   function remove(Role storage role, address addr)
101     internal
102   {
103     role.bearer[addr] = false;
104   }
105 
106   /**
107    * @dev check if an address has this role
108    * // reverts
109    */
110   function check(Role storage role, address addr)
111     view
112     internal
113   {
114     require(has(role, addr));
115   }
116 
117   /**
118    * @dev check if an address has this role
119    * @return bool
120    */
121   function has(Role storage role, address addr)
122     view
123     internal
124     returns (bool)
125   {
126     return role.bearer[addr];
127   }
128 }
129 
130 // File: contracts/rbac/RBAC.sol
131 
132 /**
133  * @title RBAC (Role-Based Access Control)
134  * @author Matt Condon (@Shrugs)
135  * @dev Stores and provides setters and getters for roles and addresses.
136  * @dev Supports unlimited numbers of roles and addresses.
137  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
138  * This RBAC method uses strings to key roles. It may be beneficial
139  *  for you to write your own implementation of this interface using Enums or similar.
140  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
141  *  to avoid typos.
142  */
143 contract RBAC {
144   using Roles for Roles.Role;
145 
146   mapping (string => Roles.Role) private roles;
147 
148   event RoleAdded(address addr, string roleName);
149   event RoleRemoved(address addr, string roleName);
150 
151   /**
152    * @dev reverts if addr does not have role
153    * @param addr address
154    * @param roleName the name of the role
155    * // reverts
156    */
157   function checkRole(address addr, string roleName)
158     view
159     public
160   {
161     roles[roleName].check(addr);
162   }
163 
164   /**
165    * @dev determine if addr has role
166    * @param addr address
167    * @param roleName the name of the role
168    * @return bool
169    */
170   function hasRole(address addr, string roleName)
171     view
172     public
173     returns (bool)
174   {
175     return roles[roleName].has(addr);
176   }
177 
178   /**
179    * @dev add a role to an address
180    * @param addr address
181    * @param roleName the name of the role
182    */
183   function addRole(address addr, string roleName)
184     internal
185   {
186     roles[roleName].add(addr);
187     emit RoleAdded(addr, roleName);
188   }
189 
190   /**
191    * @dev remove a role from an address
192    * @param addr address
193    * @param roleName the name of the role
194    */
195   function removeRole(address addr, string roleName)
196     internal
197   {
198     roles[roleName].remove(addr);
199     emit RoleRemoved(addr, roleName);
200   }
201 
202   /**
203    * @dev modifier to scope access to a single role (uses msg.sender as addr)
204    * @param roleName the name of the role
205    * // reverts
206    */
207   modifier onlyRole(string roleName)
208   {
209     checkRole(msg.sender, roleName);
210     _;
211   }
212 
213   /**
214    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
215    * @param roleNames the names of the roles to scope access to
216    * // reverts
217    *
218    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
219    *  see: https://github.com/ethereum/solidity/issues/2467
220    */
221   // modifier onlyRoles(string[] roleNames) {
222   //     bool hasAnyRole = false;
223   //     for (uint8 i = 0; i < roleNames.length; i++) {
224   //         if (hasRole(msg.sender, roleNames[i])) {
225   //             hasAnyRole = true;
226   //             break;
227   //         }
228   //     }
229 
230   //     require(hasAnyRole);
231 
232   //     _;
233   // }
234 }
235 
236 // File: contracts/VeraCrowdsale.sol
237 
238 /**
239  * @title Interface of Price oracle
240  * @dev Implements methods of price oracle used in the crowdsale
241  * @author OnGrid Systems
242  */
243 contract PriceOracleIface {
244   uint256 public ethPriceInCents;
245 
246   function getUsdCentsFromWei(uint256 _wei) public view returns (uint256) {
247   }
248 }
249 
250 
251 /**
252  * @title Interface of ERC-20 token
253  * @dev Implements transfer methods and event used throughout crowdsale
254  * @author OnGrid Systems
255  */
256 contract TransferableTokenIface {
257   function transfer(address to, uint256 value) public returns (bool) {
258   }
259 
260   function balanceOf(address who) public view returns (uint256) {
261   }
262 
263   event Transfer(address indexed from, address indexed to, uint256 value);
264 }
265 
266 
267 /**
268  * @title CrowdSale contract for Vera.jobs
269  * @dev Keep the list of investors passed KYC, receive ethers to fallback,
270  * calculate correspinding amount of tokens, add bonus (depending on the deposit size)
271  * then transfers tokens to the investor's account
272  * @author OnGrid Systems
273  */
274 contract VeraCrowdsale is RBAC {
275   using SafeMath for uint256;
276 
277   // Price of one token (1.00000...) in USD cents
278   uint256 public tokenPriceInCents = 200;
279 
280   // Minimal amount of USD cents to invest. Transactions of less value will be reverted.
281   uint256 public minDepositInCents = 1000;
282 
283   // Amount of USD cents raised. Continuously increments on each transaction.
284   // Note: may be irrelevant because the actual amount of harvested ethers depends on ETH/USD price at the moment.
285   uint256 public centsRaised;
286 
287   // Amount of tokens distributed by this contract.
288   // Note: doesn't include previous phases of tokensale.
289   uint256 public tokensSold;
290 
291   // Address of VERA ERC-20 token contract
292   TransferableTokenIface public token;
293 
294   // Address of ETH price feed
295   PriceOracleIface public priceOracle;
296 
297   // Wallet address collecting received ETH
298   address public wallet;
299 
300   // constants defining roles for access control
301   string public constant ROLE_ADMIN = "admin";
302   string public constant ROLE_BACKEND = "backend";
303   string public constant ROLE_KYC_VERIFIED_INVESTOR = "kycVerified";
304 
305   // Value bonus configuration
306   struct AmountBonus {
307 
308     // To understand which bonuses were applied bonus contains binary flag.
309     // If several bonuses applied ids get summarized in resulting event.
310     // Use values with a single 1-bit like 0x01, 0x02, 0x04, 0x08
311     uint256 id;
312 
313     // amountFrom and amountTo define deposit value range.
314     // Bonus percentage applies if deposit amount in cents is within the boundaries
315     uint256 amountFrom;
316     uint256 amountTo;
317     uint256 bonusPercent;
318   }
319 
320   // The list of available bonuses. Filled by the constructor on contract initialization
321   AmountBonus[] public amountBonuses;
322 
323   /**
324    * Event for token purchase logging
325    * @param investor who received tokens
326    * @param ethPriceInCents ETH price at the moment of purchase
327    * @param valueInCents deposit calculated to USD cents
328    * @param bonusPercent total bonus percent (sum of all bonuses)
329    * @param bonusIds flags of all the bonuses applied to the purchase
330    */
331   event TokenPurchase(
332     address indexed investor,
333     uint256 ethPriceInCents,
334     uint256 valueInCents,
335     uint256 bonusPercent,
336     uint256 bonusIds
337   );
338 
339   /**
340    * @dev modifier to scope access to admins
341    * // reverts if called not by admin
342    */
343   modifier onlyAdmin()
344   {
345     checkRole(msg.sender, ROLE_ADMIN);
346     _;
347   }
348 
349   /**
350    * @dev modifier to scope access of backend keys stored on
351    * investor's portal
352    * // reverts if called not by backend
353    */
354   modifier onlyBackend()
355   {
356     checkRole(msg.sender, ROLE_BACKEND);
357     _;
358   }
359 
360   /**
361    * @dev modifier allowing calls from investors successfully passed KYC verification
362    * // reverts if called by investor who didn't pass KYC via investor's portal
363    */
364   modifier onlyKYCVerifiedInvestor()
365   {
366     checkRole(msg.sender, ROLE_KYC_VERIFIED_INVESTOR);
367     _;
368   }
369 
370   /**
371    * @dev Constructor initializing Crowdsale contract
372    * @param _token address of the token ERC-20 contract.
373    * @param _priceOracle ETH price feed
374    * @param _wallet address where received ETH get forwarded
375    */
376   constructor(
377     TransferableTokenIface _token,
378     PriceOracleIface _priceOracle,
379     address _wallet
380   )
381     public
382   {
383     require(_token != address(0), "Need token contract address");
384     require(_priceOracle != address(0), "Need price oracle contract address");
385     require(_wallet != address(0), "Need wallet address");
386     addRole(msg.sender, ROLE_ADMIN);
387     token = _token;
388     priceOracle = _priceOracle;
389     wallet = _wallet;
390     // solium-disable-next-line arg-overflow
391     amountBonuses.push(AmountBonus(0x1, 800000, 1999999, 20));
392     // solium-disable-next-line arg-overflow
393     amountBonuses.push(AmountBonus(0x2, 2000000, 2**256 - 1, 30));
394   }
395 
396   /**
397    * @dev Fallback function receiving ETH sent to the contract address
398    * sender must be KYC (Know Your Customer) verified investor.
399    */
400   function ()
401     external
402     payable
403     onlyKYCVerifiedInvestor
404   {
405     uint256 valueInCents = priceOracle.getUsdCentsFromWei(msg.value);
406     buyTokens(msg.sender, valueInCents);
407     wallet.transfer(msg.value);
408   }
409 
410   /**
411    * @dev Withdraws all remaining (not sold) tokens from the crowdsale contract
412    * @param _to address of tokens receiver
413    */
414   function withdrawTokens(address _to) public onlyAdmin {
415     uint256 amount = token.balanceOf(address(this));
416     require(amount > 0, "no tokens on the contract");
417     token.transfer(_to, amount);
418   }
419 
420   /**
421    * @dev Called when investor's portal (backend) receives non-ethereum payment
422    * @param _investor address of investor
423    * @param _cents received deposit amount in cents
424    */
425   function buyTokensViaBackend(address _investor, uint256 _cents)
426     public
427     onlyBackend
428   {
429     if (! RBAC.hasRole(_investor, ROLE_KYC_VERIFIED_INVESTOR)) {
430       addKycVerifiedInvestor(_investor);
431     }
432     buyTokens(_investor, _cents);
433   }
434 
435   /**
436    * @dev Computes total bonuses amount by value
437    * @param _cents deposit amount in USD cents
438    * @return total bonus percent (sum of applied bonus percents), bonusIds (sum of applied bonus flags)
439    */
440   function computeBonuses(uint256 _cents)
441     public
442     view
443     returns (uint256, uint256)
444   {
445     uint256 bonusTotal;
446     uint256 bonusIds;
447     for (uint i = 0; i < amountBonuses.length; i++) {
448       if (_cents >= amountBonuses[i].amountFrom &&
449       _cents <= amountBonuses[i].amountTo) {
450         bonusTotal += amountBonuses[i].bonusPercent;
451         bonusIds += amountBonuses[i].id;
452       }
453     }
454     return (bonusTotal, bonusIds);
455   }
456 
457   /**
458    * @dev Calculates amount of tokens by cents
459    * @param _cents deposit amount in USD cents
460    * @return amount of tokens investor receive for the deposit
461    */
462   function computeTokens(uint256 _cents) public view returns (uint256) {
463     uint256 tokens = _cents.mul(10 ** 18).div(tokenPriceInCents);
464     (uint256 bonusPercent, ) = computeBonuses(_cents);
465     uint256 bonusTokens = tokens.mul(bonusPercent).div(100);
466     if (_cents >= minDepositInCents) {
467       return tokens.add(bonusTokens);
468     }
469   }
470 
471   /**
472    * @dev Add admin role to an address
473    * @param addr address
474    */
475   function addAdmin(address addr)
476     public
477     onlyAdmin
478   {
479     addRole(addr, ROLE_ADMIN);
480   }
481 
482   /**
483    * @dev Revoke admin privileges from an address
484    * @param addr address
485    */
486   function delAdmin(address addr)
487     public
488     onlyAdmin
489   {
490     removeRole(addr, ROLE_ADMIN);
491   }
492 
493   /**
494    * @dev Add backend privileges to an address
495    * @param addr address
496    */
497   function addBackend(address addr)
498     public
499     onlyAdmin
500   {
501     addRole(addr, ROLE_BACKEND);
502   }
503 
504   /**
505    * @dev Revoke backend privileges from an address
506    * @param addr address
507    */
508   function delBackend(address addr)
509     public
510     onlyAdmin
511   {
512     removeRole(addr, ROLE_BACKEND);
513   }
514 
515   /**
516    * @dev Mark investor's address as KYC-verified person
517    * @param addr address
518    */
519   function addKycVerifiedInvestor(address addr)
520     public
521     onlyBackend
522   {
523     addRole(addr, ROLE_KYC_VERIFIED_INVESTOR);
524   }
525 
526   /**
527    * @dev Revoke KYC verification from the person
528    * @param addr address
529    */
530   function delKycVerifiedInvestor(address addr)
531     public
532     onlyBackend
533   {
534     removeRole(addr, ROLE_KYC_VERIFIED_INVESTOR);
535   }
536 
537   /**
538    * @dev Calculates and applies bonuses and implements actual token transfer and events
539    * @param _investor address of the beneficiary receiving tokens
540    * @param _cents amount of deposit in cents
541    */
542   function buyTokens(address _investor, uint256 _cents) internal {
543     (uint256 bonusPercent, uint256 bonusIds) = computeBonuses(_cents);
544     uint256 tokens = computeTokens(_cents);
545     require(tokens > 0, "value is not enough");
546     token.transfer(_investor, tokens);
547     centsRaised = centsRaised.add(_cents);
548     tokensSold = tokensSold.add(tokens);
549     emit TokenPurchase(
550       _investor,
551       priceOracle.ethPriceInCents(),
552       _cents,
553       bonusPercent,
554       bonusIds
555     );
556   }
557 }