1 pragma solidity 0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: lib/solidity-rationals/contracts/Rationals.sol
52 
53 library R {
54 
55     struct Rational {
56         uint n;  // numerator
57         uint d;  // denominator
58     }
59 
60 }
61 
62 
63 library Rationals {
64     using SafeMath for uint;
65 
66     function rmul(uint256 amount, R.Rational memory r) internal pure returns (uint256) {
67         return amount.mul(r.n).div(r.d);
68     }
69 
70 }
71 
72 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80   address public owner;
81 
82 
83   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   function Ownable() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address newOwner) public onlyOwner {
107     require(newOwner != address(0));
108     emit OwnershipTransferred(owner, newOwner);
109     owner = newOwner;
110   }
111 
112 }
113 
114 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
115 
116 /**
117  * @title Pausable
118  * @dev Base contract which allows children to implement an emergency stop mechanism.
119  */
120 contract Pausable is Ownable {
121   event Pause();
122   event Unpause();
123 
124   bool public paused = false;
125 
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is not paused.
129    */
130   modifier whenNotPaused() {
131     require(!paused);
132     _;
133   }
134 
135   /**
136    * @dev Modifier to make a function callable only when the contract is paused.
137    */
138   modifier whenPaused() {
139     require(paused);
140     _;
141   }
142 
143   /**
144    * @dev called by the owner to pause, triggers stopped state
145    */
146   function pause() onlyOwner whenNotPaused public {
147     paused = true;
148     emit Pause();
149   }
150 
151   /**
152    * @dev called by the owner to unpause, returns to normal state
153    */
154   function unpause() onlyOwner whenPaused public {
155     paused = false;
156     emit Unpause();
157   }
158 }
159 
160 // File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol
161 
162 /**
163  * @title Roles
164  * @author Francisco Giordano (@frangio)
165  * @dev Library for managing addresses assigned to a Role.
166  *      See RBAC.sol for example usage.
167  */
168 library Roles {
169   struct Role {
170     mapping (address => bool) bearer;
171   }
172 
173   /**
174    * @dev give an address access to this role
175    */
176   function add(Role storage role, address addr)
177     internal
178   {
179     role.bearer[addr] = true;
180   }
181 
182   /**
183    * @dev remove an address' access to this role
184    */
185   function remove(Role storage role, address addr)
186     internal
187   {
188     role.bearer[addr] = false;
189   }
190 
191   /**
192    * @dev check if an address has this role
193    * // reverts
194    */
195   function check(Role storage role, address addr)
196     view
197     internal
198   {
199     require(has(role, addr));
200   }
201 
202   /**
203    * @dev check if an address has this role
204    * @return bool
205    */
206   function has(Role storage role, address addr)
207     view
208     internal
209     returns (bool)
210   {
211     return role.bearer[addr];
212   }
213 }
214 
215 // File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol
216 
217 /**
218  * @title RBAC (Role-Based Access Control)
219  * @author Matt Condon (@Shrugs)
220  * @dev Stores and provides setters and getters for roles and addresses.
221  * @dev Supports unlimited numbers of roles and addresses.
222  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
223  * This RBAC method uses strings to key roles. It may be beneficial
224  *  for you to write your own implementation of this interface using Enums or similar.
225  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
226  *  to avoid typos.
227  */
228 contract RBAC {
229   using Roles for Roles.Role;
230 
231   mapping (string => Roles.Role) private roles;
232 
233   event RoleAdded(address addr, string roleName);
234   event RoleRemoved(address addr, string roleName);
235 
236   /**
237    * @dev reverts if addr does not have role
238    * @param addr address
239    * @param roleName the name of the role
240    * // reverts
241    */
242   function checkRole(address addr, string roleName)
243     view
244     public
245   {
246     roles[roleName].check(addr);
247   }
248 
249   /**
250    * @dev determine if addr has role
251    * @param addr address
252    * @param roleName the name of the role
253    * @return bool
254    */
255   function hasRole(address addr, string roleName)
256     view
257     public
258     returns (bool)
259   {
260     return roles[roleName].has(addr);
261   }
262 
263   /**
264    * @dev add a role to an address
265    * @param addr address
266    * @param roleName the name of the role
267    */
268   function addRole(address addr, string roleName)
269     internal
270   {
271     roles[roleName].add(addr);
272     emit RoleAdded(addr, roleName);
273   }
274 
275   /**
276    * @dev remove a role from an address
277    * @param addr address
278    * @param roleName the name of the role
279    */
280   function removeRole(address addr, string roleName)
281     internal
282   {
283     roles[roleName].remove(addr);
284     emit RoleRemoved(addr, roleName);
285   }
286 
287   /**
288    * @dev modifier to scope access to a single role (uses msg.sender as addr)
289    * @param roleName the name of the role
290    * // reverts
291    */
292   modifier onlyRole(string roleName)
293   {
294     checkRole(msg.sender, roleName);
295     _;
296   }
297 
298   /**
299    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
300    * @param roleNames the names of the roles to scope access to
301    * // reverts
302    *
303    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
304    *  see: https://github.com/ethereum/solidity/issues/2467
305    */
306   // modifier onlyRoles(string[] roleNames) {
307   //     bool hasAnyRole = false;
308   //     for (uint8 i = 0; i < roleNames.length; i++) {
309   //         if (hasRole(msg.sender, roleNames[i])) {
310   //             hasAnyRole = true;
311   //             break;
312   //         }
313   //     }
314 
315   //     require(hasAnyRole);
316 
317   //     _;
318   // }
319 }
320 
321 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
322 
323 /**
324  * @title ERC20Basic
325  * @dev Simpler version of ERC20 interface
326  * @dev see https://github.com/ethereum/EIPs/issues/179
327  */
328 contract ERC20Basic {
329   function totalSupply() public view returns (uint256);
330   function balanceOf(address who) public view returns (uint256);
331   function transfer(address to, uint256 value) public returns (bool);
332   event Transfer(address indexed from, address indexed to, uint256 value);
333 }
334 
335 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
336 
337 /**
338  * @title ERC20 interface
339  * @dev see https://github.com/ethereum/EIPs/issues/20
340  */
341 contract ERC20 is ERC20Basic {
342   function allowance(address owner, address spender) public view returns (uint256);
343   function transferFrom(address from, address to, uint256 value) public returns (bool);
344   function approve(address spender, uint256 value) public returns (bool);
345   event Approval(address indexed owner, address indexed spender, uint256 value);
346 }
347 
348 // File: contracts/Exchange.sol
349 
350 /**
351  * @title Atomic exchange to facilitate swaps from ETH or DAI to a token.
352  * Users an oracle bot to update market prices.
353  */
354 contract Exchange is Pausable, RBAC {
355     using SafeMath for uint256;
356 
357     string constant ROLE_ORACLE = "oracle";
358 
359     ERC20 baseToken;
360     ERC20 dai;  // 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359
361     address public oracle;
362     R.Rational public ethRate;
363     R.Rational public daiRate;
364 
365     event TradeETH(uint256 amountETH, uint256 amountBaseToken);
366     event TradeDAI(uint256 amountDAI, uint256 amountBaseToken);
367     event RateUpdatedETH(uint256 n, uint256 d);
368     event RateUpdatedDAI(uint256 n, uint256 d);
369     event OracleSet(address oracle);
370 
371     /**
372      * Constructor for exchange.
373      *
374      * @param _baseToken Address of the token to exchange for
375      * @param _dai Address of DAI token
376      * @param _oracle Address of oracle tasked with periodically setting market rates
377      * @param _ethRateN Numerator of the ETH to token exchange rate
378      * @param _ethRateD Denominator of the ETH to token exchange rate
379      * @param _daiRateN Numerator of the DAI to token exchange rate
380      * @param _daiRateD Denominator of the DAI to token exchange rate
381      */
382     function Exchange(
383         address _baseToken,
384         address _dai,
385         address _oracle,
386         uint256 _ethRateN,
387         uint256 _ethRateD,
388         uint256 _daiRateN,
389         uint256 _daiRateD
390     ) public {
391         baseToken = ERC20(_baseToken);
392         dai = ERC20(_dai);
393         addRole(_oracle, ROLE_ORACLE);
394         oracle = _oracle;
395         ethRate = R.Rational(_ethRateN, _ethRateD);
396         daiRate = R.Rational(_daiRateN, _daiRateD);
397     }
398 
399     /**
400      * Trades ETH for tokens at ethRate.
401      *
402      * @param expectedAmountBaseToken Amount of tokens expected to receive.
403      * This prevents front-running race conditions from occurring when ethRate
404      * is updated.
405      */
406     function tradeETH(uint256 expectedAmountBaseToken) public whenNotPaused() payable {
407         uint256 amountBaseToken = calculateAmountForETH(msg.value);
408         require(amountBaseToken == expectedAmountBaseToken);
409         require(baseToken.transfer(msg.sender, amountBaseToken));
410         emit TradeETH(msg.value, amountBaseToken);
411     }
412 
413     /**
414      * Trades DAI for tokens at daiRate. User must first approve DAI to be
415      * transferred by Exchange.
416      *
417      * @param amountDAI Amount of DAI to exchange
418      * @param expectedAmountBaseToken Amount of tokens expected to receive.
419      * This prevents front-running race conditions from occurring when daiRate
420      * is updated.
421      */
422     function tradeDAI(uint256 amountDAI, uint256 expectedAmountBaseToken) public whenNotPaused() {
423         uint256 amountBaseToken = calculateAmountForDAI(amountDAI);
424         require(amountBaseToken == expectedAmountBaseToken);
425         require(dai.transferFrom(msg.sender, address(this), amountDAI));
426         require(baseToken.transfer(msg.sender, amountBaseToken));
427         emit TradeDAI(amountDAI, amountBaseToken);
428     }
429 
430     /**
431      * Calculates exchange amount for ETH to token.
432      *
433      * @param amountETH Amount of ETH, in base units
434      */
435     function calculateAmountForETH(uint256 amountETH) public view returns (uint256) {
436         return Rationals.rmul(amountETH, ethRate);
437     }
438 
439     /**
440      * Calculates exchange amount for DAI to token.
441      *
442      * @param amountDAI Amount of DAI, in base units
443      */
444     function calculateAmountForDAI(uint256 amountDAI) public view returns (uint256) {
445         return Rationals.rmul(amountDAI, daiRate);
446     }
447 
448     /**
449      * Sets the exchange rate from ETH to token.
450      *
451      * @param n Numerator for ethRate
452      * @param d Denominator for ethRate
453      */
454     function setETHRate(uint256 n, uint256 d) external onlyRole(ROLE_ORACLE) {
455         ethRate = R.Rational(n, d);
456         emit RateUpdatedETH(n, d);
457     }
458 
459     /**
460      * Sets the exchange rate from ETH to token.
461      *
462      * @param n Numerator for daiRate
463      * @param d Denominator for daiRate
464      */
465     function setDAIRate(uint256 n, uint256 d) external onlyRole(ROLE_ORACLE) {
466         daiRate = R.Rational(n, d);
467         emit RateUpdatedDAI(n, d);
468     }
469 
470     /**
471      * Recovers DAI, leftover tokens, or other.
472      *
473      * @param token Address of token to withdraw
474      * @param amount Amount of tokens to withdraw
475      */
476     function withdrawERC20s(address token, uint256 amount) external onlyOwner {
477         ERC20 erc20 = ERC20(token);
478         require(erc20.transfer(owner, amount));
479     }
480 
481     /**
482      * Changes the oracle.
483      *
484      * @param _oracle Address of new oracle
485      */
486     function setOracle(address _oracle) external onlyOwner {
487         removeRole(oracle, ROLE_ORACLE);
488         addRole(_oracle, ROLE_ORACLE);
489         oracle = _oracle;
490         emit OracleSet(_oracle);
491     }
492 
493     /// @notice Owner: Withdraw Ether
494     function withdrawEther() external onlyOwner {
495         owner.transfer(address(this).balance);
496     }
497 
498 }