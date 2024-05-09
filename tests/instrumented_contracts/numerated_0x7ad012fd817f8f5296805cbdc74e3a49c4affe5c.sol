1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Math
6  * @dev Assorted math operations
7  */
8 library Math {
9   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
10     return a >= b ? a : b;
11   }
12 
13   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
14     return a < b ? a : b;
15   }
16 
17   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
18     return a >= b ? a : b;
19   }
20 
21   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a < b ? a : b;
23   }
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
38     // benefit is lost if 'b' is also tested.
39     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40     if (a == 0) {
41       return 0;
42     }
43 
44     c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     // uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return a / b;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 
78 /**
79  * @title Roles
80  * @author Francisco Giordano (@frangio)
81  * @dev Library for managing addresses assigned to a Role.
82  *      See RBAC.sol for example usage.
83  */
84 library Roles {
85   struct Role {
86     mapping (address => bool) bearer;
87   }
88 
89   /**
90    * @dev give an address access to this role
91    */
92   function add(Role storage role, address addr)
93     internal
94   {
95     role.bearer[addr] = true;
96   }
97 
98   /**
99    * @dev remove an address' access to this role
100    */
101   function remove(Role storage role, address addr)
102     internal
103   {
104     role.bearer[addr] = false;
105   }
106 
107   /**
108    * @dev check if an address has this role
109    * // reverts
110    */
111   function check(Role storage role, address addr)
112     view
113     internal
114   {
115     require(has(role, addr));
116   }
117 
118   /**
119    * @dev check if an address has this role
120    * @return bool
121    */
122   function has(Role storage role, address addr)
123     view
124     internal
125     returns (bool)
126   {
127     return role.bearer[addr];
128   }
129 }
130 
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
212 }
213 
214 
215 /**
216  * @title Interface of Price oracle
217  * @dev Implements methods of price oracle used in the crowdsale
218  * @author OnGrid Systems
219  */
220 contract PriceOracleIface {
221   uint256 public ethPriceInCents;
222 
223   function getUsdCentsFromWei(uint256 _wei) public view returns (uint256) {
224   }
225 }
226 
227 
228 /**
229  * @title Interface of ERC-20 token
230  * @dev Implements transfer methods and event used throughout crowdsale
231  * @author OnGrid Systems
232  */
233 contract TransferableTokenIface {
234   function transfer(address to, uint256 value) public returns (bool) {
235   }
236 
237   function balanceOf(address who) public view returns (uint256) {
238   }
239 
240   event Transfer(address indexed from, address indexed to, uint256 value);
241 }
242 
243 
244 /**
245  * @title CrowdSale contract for Vera.jobs
246  * @dev Keep the list of investors passed KYC, receive ethers to fallback,
247  * calculate correspinding amount of tokens, add bonus (depending on the deposit size)
248  * then transfers tokens to the investor's account
249  * @author OnGrid Systems
250  */
251 contract VeraCrowdsale is RBAC {
252   using SafeMath for uint256;
253 
254   // Price of one token (1.00000...) in USD cents
255   uint256 public tokenPriceInCents = 200;
256 
257   // Minimal amount of USD cents to invest. Transactions of less value will be reverted.
258   uint256 public minDepositInCents = 800000;
259 
260   // Amount of USD cents raised. Continuously increments on each transaction.
261   // Note: may be irrelevant because the actual amount of harvested ethers depends on ETH/USD price at the moment.
262   uint256 public centsRaised;
263 
264   // Amount of tokens distributed by this contract.
265   // Note: doesn't include previous phases of tokensale.
266   uint256 public tokensSold;
267 
268   // Address of VERA ERC-20 token contract
269   TransferableTokenIface public token;
270 
271   // Address of ETH price feed
272   PriceOracleIface public priceOracle;
273 
274   // Wallet address collecting received ETH
275   address public wallet;
276 
277   // constants defining roles for access control
278   string public constant ROLE_ADMIN = "admin";
279   string public constant ROLE_BACKEND = "backend";
280   string public constant ROLE_KYC_VERIFIED_INVESTOR = "kycVerified";
281 
282   // Value bonus configuration
283   struct AmountBonus {
284 
285     // To understand which bonuses were applied bonus contains binary flag.
286     // If several bonuses applied ids get summarized in resulting event.
287     // Use values with a single 1-bit like 0x01, 0x02, 0x04, 0x08
288     uint256 id;
289 
290     // amountFrom and amountTo define deposit value range.
291     // Bonus percentage applies if deposit amount in cents is within the boundaries
292     uint256 amountFrom;
293     uint256 amountTo;
294     uint256 bonusPercent;
295   }
296 
297   // The list of available bonuses. Filled by the constructor on contract initialization
298   AmountBonus[] public amountBonuses;
299 
300   /**
301    * Event for token purchase logging
302    * @param investor who received tokens
303    * @param ethPriceInCents ETH price at the moment of purchase
304    * @param valueInCents deposit calculated to USD cents
305    * @param bonusPercent total bonus percent (sum of all bonuses)
306    * @param bonusIds flags of all the bonuses applied to the purchase
307    */
308   event TokenPurchase(
309     address indexed investor,
310     uint256 ethPriceInCents,
311     uint256 valueInCents,
312     uint256 bonusPercent,
313     uint256 bonusIds
314   );
315 
316   /**
317    * @dev modifier to scope access to admins
318    * // reverts if called not by admin
319    */
320   modifier onlyAdmin()
321   {
322     checkRole(msg.sender, ROLE_ADMIN);
323     _;
324   }
325 
326   /**
327    * @dev modifier to scope access of backend keys stored on
328    * investor's portal
329    * // reverts if called not by backend
330    */
331   modifier onlyBackend()
332   {
333     checkRole(msg.sender, ROLE_BACKEND);
334     _;
335   }
336 
337   /**
338    * @dev modifier allowing calls from investors successfully passed KYC verification
339    * // reverts if called by investor who didn't pass KYC via investor's portal
340    */
341   modifier onlyKYCVerifiedInvestor()
342   {
343     checkRole(msg.sender, ROLE_KYC_VERIFIED_INVESTOR);
344     _;
345   }
346 
347   /**
348    * @dev Constructor initializing Crowdsale contract
349    * @param _token address of the token ERC-20 contract.
350    * @param _priceOracle ETH price feed
351    * @param _wallet address where received ETH get forwarded
352    */
353   constructor(
354     TransferableTokenIface _token,
355     PriceOracleIface _priceOracle,
356     address _wallet
357   )
358     public
359   {
360     require(_token != address(0), "Need token contract address");
361     require(_priceOracle != address(0), "Need price oracle contract address");
362     require(_wallet != address(0), "Need wallet address");
363     addRole(msg.sender, ROLE_ADMIN);
364     token = _token;
365     priceOracle = _priceOracle;
366     wallet = _wallet;
367     // solium-disable-next-line arg-overflow
368     amountBonuses.push(AmountBonus(0x1, 800000, 1999999, 20));
369     // solium-disable-next-line arg-overflow
370     amountBonuses.push(AmountBonus(0x2, 2000000, 2**256 - 1, 30));
371   }
372 
373   /**
374    * @dev Fallback function receiving ETH sent to the contract address
375    * sender must be KYC (Know Your Customer) verified investor.
376    */
377   function ()
378     external
379     payable
380     onlyKYCVerifiedInvestor
381   {
382     uint256 valueInCents = priceOracle.getUsdCentsFromWei(msg.value);
383     buyTokens(msg.sender, valueInCents);
384     wallet.transfer(msg.value);
385   }
386 
387   /**
388    * @dev Withdraws all remaining (not sold) tokens from the crowdsale contract
389    * @param _to address of tokens receiver
390    */
391   function withdrawTokens(address _to) public onlyAdmin {
392     uint256 amount = token.balanceOf(address(this));
393     require(amount > 0, "no tokens on the contract");
394     token.transfer(_to, amount);
395   }
396 
397   /**
398    * @dev Called when investor's portal (backend) receives non-ethereum payment
399    * @param _investor address of investor
400    * @param _cents received deposit amount in cents
401    */
402   function buyTokensViaBackend(address _investor, uint256 _cents)
403     public
404     onlyBackend
405   {
406     if (! RBAC.hasRole(_investor, ROLE_KYC_VERIFIED_INVESTOR)) {
407       addKycVerifiedInvestor(_investor);
408     }
409     buyTokens(_investor, _cents);
410   }
411 
412   /**
413    * @dev Computes total bonuses amount by value
414    * @param _cents deposit amount in USD cents
415    * @return total bonus percent (sum of applied bonus percents), bonusIds (sum of applied bonus flags)
416    */
417   function computeBonuses(uint256 _cents)
418     public
419     view
420     returns (uint256, uint256)
421   {
422     uint256 bonusTotal;
423     uint256 bonusIds;
424     for (uint i = 0; i < amountBonuses.length; i++) {
425       if (_cents >= amountBonuses[i].amountFrom &&
426       _cents <= amountBonuses[i].amountTo) {
427         bonusTotal += amountBonuses[i].bonusPercent;
428         bonusIds += amountBonuses[i].id;
429       }
430     }
431     return (bonusTotal, bonusIds);
432   }
433 
434   /**
435    * @dev Calculates amount of tokens by cents
436    * @param _cents deposit amount in USD cents
437    * @return amount of tokens investor receive for the deposit
438    */
439   function computeTokens(uint256 _cents) public view returns (uint256) {
440     uint256 tokens = _cents.mul(10 ** 18).div(tokenPriceInCents);
441     (uint256 bonusPercent, ) = computeBonuses(_cents);
442     uint256 bonusTokens = tokens.mul(bonusPercent).div(100);
443     if (_cents >= minDepositInCents) {
444       return tokens.add(bonusTokens);
445     }
446   }
447 
448   /**
449    * @dev Add admin role to an address
450    * @param addr address
451    */
452   function addAdmin(address addr)
453     public
454     onlyAdmin
455   {
456     addRole(addr, ROLE_ADMIN);
457   }
458 
459   /**
460    * @dev Revoke admin privileges from an address
461    * @param addr address
462    */
463   function delAdmin(address addr)
464     public
465     onlyAdmin
466   {
467     removeRole(addr, ROLE_ADMIN);
468   }
469 
470   /**
471    * @dev Add backend privileges to an address
472    * @param addr address
473    */
474   function addBackend(address addr)
475     public
476     onlyAdmin
477   {
478     addRole(addr, ROLE_BACKEND);
479   }
480 
481   /**
482    * @dev Revoke backend privileges from an address
483    * @param addr address
484    */
485   function delBackend(address addr)
486     public
487     onlyAdmin
488   {
489     removeRole(addr, ROLE_BACKEND);
490   }
491 
492   /**
493    * @dev Mark investor's address as KYC-verified person
494    * @param addr address
495    */
496   function addKycVerifiedInvestor(address addr)
497     public
498     onlyBackend
499   {
500     addRole(addr, ROLE_KYC_VERIFIED_INVESTOR);
501   }
502 
503   /**
504    * @dev Revoke KYC verification from the person
505    * @param addr address
506    */
507   function delKycVerifiedInvestor(address addr)
508     public
509     onlyBackend
510   {
511     removeRole(addr, ROLE_KYC_VERIFIED_INVESTOR);
512   }
513 
514   /**
515    * @dev Calculates and applies bonuses and implements actual token transfer and events
516    * @param _investor address of the beneficiary receiving tokens
517    * @param _cents amount of deposit in cents
518    */
519   function buyTokens(address _investor, uint256 _cents) internal {
520     (uint256 bonusPercent, uint256 bonusIds) = computeBonuses(_cents);
521     uint256 tokens = computeTokens(_cents);
522     require(tokens > 0, "value is not enough");
523     token.transfer(_investor, tokens);
524     centsRaised = centsRaised.add(_cents);
525     tokensSold = tokensSold.add(tokens);
526     emit TokenPurchase(
527       _investor,
528       priceOracle.ethPriceInCents(),
529       _cents,
530       bonusPercent,
531       bonusIds
532     );
533   }
534 }