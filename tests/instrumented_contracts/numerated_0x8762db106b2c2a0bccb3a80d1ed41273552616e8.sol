1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     _transfer(msg.sender, to, value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param spender The address which will spend the funds.
166    * @param value The amount of tokens to be spent.
167    */
168   function approve(address spender, uint256 value) public returns (bool) {
169     require(spender != address(0));
170 
171     _allowed[msg.sender][spender] = value;
172     emit Approval(msg.sender, spender, value);
173     return true;
174   }
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param from address The address which you want to send tokens from
179    * @param to address The address which you want to transfer to
180    * @param value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(
183     address from,
184     address to,
185     uint256 value
186   )
187     public
188     returns (bool)
189   {
190     require(value <= _allowed[from][msg.sender]);
191 
192     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
193     _transfer(from, to, value);
194     return true;
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed_[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param spender The address which will spend the funds.
204    * @param addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseAllowance(
207     address spender,
208     uint256 addedValue
209   )
210     public
211     returns (bool)
212   {
213     require(spender != address(0));
214 
215     _allowed[msg.sender][spender] = (
216       _allowed[msg.sender][spender].add(addedValue));
217     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed_[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param spender The address which will spend the funds.
228    * @param subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseAllowance(
231     address spender,
232     uint256 subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     require(spender != address(0));
238 
239     _allowed[msg.sender][spender] = (
240       _allowed[msg.sender][spender].sub(subtractedValue));
241     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
242     return true;
243   }
244 
245   /**
246   * @dev Transfer token for a specified addresses
247   * @param from The address to transfer from.
248   * @param to The address to transfer to.
249   * @param value The amount to be transferred.
250   */
251   function _transfer(address from, address to, uint256 value) internal {
252     require(value <= _balances[from]);
253     require(to != address(0));
254 
255     _balances[from] = _balances[from].sub(value);
256     _balances[to] = _balances[to].add(value);
257     emit Transfer(from, to, value);
258   }
259 
260   /**
261    * @dev Internal function that mints an amount of the token and assigns it to
262    * an account. This encapsulates the modification of balances such that the
263    * proper events are emitted.
264    * @param account The account that will receive the created tokens.
265    * @param value The amount that will be created.
266    */
267   function _mint(address account, uint256 value) internal {
268     require(account != 0);
269     _totalSupply = _totalSupply.add(value);
270     _balances[account] = _balances[account].add(value);
271     emit Transfer(address(0), account, value);
272   }
273 
274   /**
275    * @dev Internal function that burns an amount of the token of a given
276    * account.
277    * @param account The account whose tokens will be burnt.
278    * @param value The amount that will be burnt.
279    */
280   function _burn(address account, uint256 value) internal {
281     require(account != 0);
282     require(value <= _balances[account]);
283 
284     _totalSupply = _totalSupply.sub(value);
285     _balances[account] = _balances[account].sub(value);
286     emit Transfer(account, address(0), value);
287   }
288 
289   /**
290    * @dev Internal function that burns an amount of the token of a given
291    * account, deducting from the sender's allowance for said account. Uses the
292    * internal burn function.
293    * @param account The account whose tokens will be burnt.
294    * @param value The amount that will be burnt.
295    */
296   function _burnFrom(address account, uint256 value) internal {
297     require(value <= _allowed[account][msg.sender]);
298 
299     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300     // this function needs to emit an event with the updated approval.
301     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
302       value);
303     _burn(account, value);
304   }
305 }
306 
307 /**
308  * @title Roles
309  * @dev Library for managing addresses assigned to a Role.
310  */
311 library Roles {
312   struct Role {
313     mapping (address => bool) bearer;
314   }
315 
316   /**
317    * @dev give an account access to this role
318    */
319   function add(Role storage role, address account) internal {
320     require(account != address(0));
321     require(!has(role, account));
322 
323     role.bearer[account] = true;
324   }
325 
326   /**
327    * @dev remove an account's access to this role
328    */
329   function remove(Role storage role, address account) internal {
330     require(account != address(0));
331     require(has(role, account));
332 
333     role.bearer[account] = false;
334   }
335 
336   /**
337    * @dev check if an account has this role
338    * @return bool
339    */
340   function has(Role storage role, address account)
341     internal
342     view
343     returns (bool)
344   {
345     require(account != address(0));
346     return role.bearer[account];
347   }
348 }
349 
350 contract PauserRole {
351   using Roles for Roles.Role;
352 
353   event PauserAdded(address indexed account);
354   event PauserRemoved(address indexed account);
355 
356   Roles.Role private pausers;
357 
358   constructor() internal {
359     _addPauser(msg.sender);
360   }
361 
362   modifier onlyPauser() {
363     require(isPauser(msg.sender));
364     _;
365   }
366 
367   function isPauser(address account) public view returns (bool) {
368     return pausers.has(account);
369   }
370 
371   function addPauser(address account) public onlyPauser {
372     _addPauser(account);
373   }
374 
375   function renouncePauser() public {
376     _removePauser(msg.sender);
377   }
378 
379   function _addPauser(address account) internal {
380     pausers.add(account);
381     emit PauserAdded(account);
382   }
383 
384   function _removePauser(address account) internal {
385     pausers.remove(account);
386     emit PauserRemoved(account);
387   }
388 }
389 
390 /**
391  * @title Pausable
392  * @dev Base contract which allows children to implement an emergency stop mechanism.
393  */
394 contract Pausable is PauserRole {
395   event Paused(address account);
396   event Unpaused(address account);
397 
398   bool private _paused;
399 
400   constructor() internal {
401     _paused = false;
402   }
403 
404   /**
405    * @return true if the contract is paused, false otherwise.
406    */
407   function paused() public view returns(bool) {
408     return _paused;
409   }
410 
411   /**
412    * @dev Modifier to make a function callable only when the contract is not paused.
413    */
414   modifier whenNotPaused() {
415     require(!_paused);
416     _;
417   }
418 
419   /**
420    * @dev Modifier to make a function callable only when the contract is paused.
421    */
422   modifier whenPaused() {
423     require(_paused);
424     _;
425   }
426 
427   /**
428    * @dev called by the owner to pause, triggers stopped state
429    */
430   function pause() public onlyPauser whenNotPaused {
431     _paused = true;
432     emit Paused(msg.sender);
433   }
434 
435   /**
436    * @dev called by the owner to unpause, returns to normal state
437    */
438   function unpause() public onlyPauser whenPaused {
439     _paused = false;
440     emit Unpaused(msg.sender);
441   }
442 }
443 
444 /**
445  * @title Pausable token
446  * @dev ERC20 modified with pausable transfers.
447  **/
448 contract ERC20Pausable is ERC20, Pausable {
449 
450   function transfer(
451     address to,
452     uint256 value
453   )
454     public
455     whenNotPaused
456     returns (bool)
457   {
458     return super.transfer(to, value);
459   }
460 
461   function transferFrom(
462     address from,
463     address to,
464     uint256 value
465   )
466     public
467     whenNotPaused
468     returns (bool)
469   {
470     return super.transferFrom(from, to, value);
471   }
472 
473   function approve(
474     address spender,
475     uint256 value
476   )
477     public
478     whenNotPaused
479     returns (bool)
480   {
481     return super.approve(spender, value);
482   }
483 
484   function increaseAllowance(
485     address spender,
486     uint addedValue
487   )
488     public
489     whenNotPaused
490     returns (bool success)
491   {
492     return super.increaseAllowance(spender, addedValue);
493   }
494 
495   function decreaseAllowance(
496     address spender,
497     uint subtractedValue
498   )
499     public
500     whenNotPaused
501     returns (bool success)
502   {
503     return super.decreaseAllowance(spender, subtractedValue);
504   }
505 }
506 
507 
508 contract ReserveRightsToken is ERC20Pausable {
509   string public name = "Reserve Rights";
510   string public symbol = "RSR";
511   uint8 public decimals = 18;
512 
513   // Tokens belonging to Reserve team members and early investors are locked until network launch.
514   mapping (address => bool) public reserveTeamMemberOrEarlyInvestor;
515   event AccountLocked(address indexed lockedAccount);
516 
517   // Hard-coded addresses from the previous deployment, which should be locked and contain token allocations. 
518   address[] previousAddresses = [
519     0x8ad9c8ebe26eadab9251b8fc36cd06a1ec399a7f,
520     0xb268c230720d16c69a61cbee24731e3b2a3330a1,
521     0x082705fabf49bd30de8f0222821f6d940713b89d,
522     0xc3aa4ced5dea58a3d1ca76e507515c79ca1e4436,
523     0x66f25f036eb4463d8a45c6594a325f9e89baa6db,
524     0x9e454fe7d8e087fcac4ec8c40562de781004477e,
525     0x4fcc7ca22680aed155f981eeb13089383d624aa9,
526     0x5a66650e5345d76eb8136ea1490cbcce1c08072e,
527     0x698a10b5d0972bffea306ba5950bd74d2af3c7ca,
528     0xdf437625216cca3d7148e18d09f4aab0d47c763b,
529     0x24b4a6847ccb32972de40170c02fda121ddc6a30,
530     0x8d29a24f91df381feb4ee7f05405d3fb888c643e,
531     0x5a7350d95b9e644dcab4bc642707f43a361bf628,
532     0xfc2e9a5cd1bb9b3953ffa7e6ddf0c0447eb95f11,
533     0x3ac7a6c3a2ff08613b611485f795d07e785cbb95,
534     0x47fc47cbcc5217740905e16c4c953b2f247369d2,
535     0xd282337950ac6e936d0f0ebaaff1ffc3de79f3d5,
536     0xde59cd3aa43a2bf863723662b31906660c7d12b6,
537     0x5f84660cabb98f7b7764cd1ae2553442da91984e,
538     0xefbaaf73fc22f70785515c1e2be3d5ba2fb8e9b0,
539     0x63c5ffb388d83477a15eb940cfa23991ca0b30f0,
540     0x14f018cce044f9d3fb1e1644db6f2fab70f6e3cb,
541     0xbe30069d27a250f90c2ee5507bcaca5f868265f7,
542     0xcfef27288bedcd587a1ed6e86a996c8c5b01d7c1,
543     0x5f57bbccc7ffa4c46864b5ed999a271bc36bb0ce,
544     0xbae85de9858375706dde5907c8c9c6ee22b19212,
545     0x5cf4bbb0ff093f3c725abec32fba8f34e4e98af1,
546     0xcb2d434bf72d3cd43d0c368493971183640ffe99,
547     0x02fc8e99401b970c265480140721b28bb3af85ab,
548     0xe7ad11517d7254f6a0758cee932bffa328002dd0,
549     0x6b39195c164d693d3b6518b70d99877d4f7c87ef,
550     0xc59119d8e4d129890036a108aed9d9fe94db1ba9,
551     0xd28661e4c75d177d9c1f3c8b821902c1abd103a6,
552     0xba385610025b1ea8091ae3e4a2e98913e2691ff7,
553     0xcd74834b8f3f71d2e82c6240ae0291c563785356,
554     0x657a127639b9e0ccccfbe795a8e394d5ca158526
555   ];
556 
557   constructor(address previousContract, address reservePrimaryWallet) public {
558     IERC20 previousToken = IERC20(previousContract);
559 
560     _mint(reservePrimaryWallet, previousToken.balanceOf(reservePrimaryWallet));
561 
562     for (uint i = 0; i < previousAddresses.length; i++) {
563       reserveTeamMemberOrEarlyInvestor[previousAddresses[i]] = true;
564       _mint(previousAddresses[i], previousToken.balanceOf(previousAddresses[i]));
565       emit AccountLocked(previousAddresses[i]);
566     }
567   }
568 
569   function transfer(address to, uint256 value) public returns (bool) {
570     // Tokens belonging to Reserve team members and early investors are locked until network launch.
571     require(!reserveTeamMemberOrEarlyInvestor[msg.sender]);
572     return super.transfer(to, value);
573   }
574 
575   function transferFrom(address from, address to, uint256 value) public returns (bool) {
576     // Tokens belonging to Reserve team members and early investors are locked until network launch.
577     require(!reserveTeamMemberOrEarlyInvestor[from]);
578     return super.transferFrom(from, to, value);
579   }
580 
581   /// This function is intended to be used only by Reserve team members and investors.
582   /// You can call it yourself, but you almost certainly don’t want to.
583   /// Anyone who calls this function will cause their own tokens to be subject to
584   /// a long lockup. Reserve team members and some investors do this to commit
585   /// ourselves to not dumping tokens early. If you are not a Reserve team member
586   /// or investor, you don’t need to limit yourself in this way.
587   ///
588   /// THIS FUNCTION LOCKS YOUR TOKENS. ONLY USE IT IF YOU KNOW WHAT YOU ARE DOING.
589   function lockMyTokensForever(string consent) public returns (bool) {
590     require(keccak256(abi.encodePacked(consent)) == keccak256(abi.encodePacked(
591       "I understand that I am locking my account forever, or at least until the next token upgrade."
592     )));
593     reserveTeamMemberOrEarlyInvestor[msg.sender] = true;
594     emit AccountLocked(msg.sender);
595   }
596 }