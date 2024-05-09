1 pragma solidity 0.5.3;
2 
3 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/external/Token.sol
4 
5 /*
6   Abstract contract for the full ERC 20 Token standard
7   https://github.com/ethereum/EIPs/issues/20
8 */
9 contract Token {
10   /* This is a slight change to the ERC20 base standard.
11   function totalSupply() view returns (uint supply);
12   is replaced map:
13   uint public totalSupply;
14   This automatically creates a getter function for the totalSupply.
15   This is moved to the base contract since public getter functions are not
16   currently recognised as an implementation of the matching abstract
17   function by the compiler.
18   */
19   /// total amount of tokens
20   uint public totalSupply;
21 
22   /// @param _owner The address from which the balance will be retrieved
23   /// @return The balance
24   function balanceOf(address _owner) public view returns (uint balance);
25 
26   /// @notice send `_value` token to `_to` from `msg.sender`
27   /// @param _to The address of the recipient
28   /// @param _value The amount of token to be transferred
29   /// @return Whether the transfer was successful or not
30   function transfer(address _to, uint _value) public returns (bool success);
31 
32   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
33   /// @param _from The address of the sender
34   /// @param _to The address of the recipient
35   /// @param _value The amount of token to be transferred
36   /// @return Whether the transfer was successful or not
37   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
38 
39   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
40   /// @param _spender The address of the account able to transfer the tokens
41   /// @param _value The amount of tokens to be approved for transfer
42   /// @return Whether the approval was successful or not
43   function approve(address _spender, uint _value) public returns (bool success);
44 
45   /// @param _owner The address of the account owning tokens
46   /// @param _spender The address of the account able to transfer the tokens
47   /// @return Amount of remaining tokens allowed to spent
48   function allowance(address _owner, address _spender) public view returns (uint remaining);
49 
50   event Transfer(address indexed _from, address indexed _to, uint _value);
51   event Approval(address indexed _owner, address indexed _spender, uint _value);
52 }
53 
54 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Math.sol
55 
56 /* @title Math provides arithmetic functions for uint type pairs.
57   You can safely `plus`, `minus`, `times`, and `divide` uint numbers without fear of integer overflow.
58   You can also find the `min` and `max` of two numbers.
59 */
60 library Math {
61 
62   function min(uint x, uint y) internal pure returns (uint) { return x <= y ? x : y; }
63   function max(uint x, uint y) internal pure returns (uint) { return x >= y ? x : y; }
64 
65 
66   /** @dev adds two numbers, reverts on overflow */
67   function plus(uint x, uint y) internal pure returns (uint z) { require((z = x + y) >= x, "bad addition"); }
68 
69   /** @dev subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend) */
70   function minus(uint x, uint y) internal pure returns (uint z) { require((z = x - y) <= x, "bad subtraction"); }
71 
72 
73   /** @dev multiplies two numbers, reverts on overflow */
74   function times(uint x, uint y) internal pure returns (uint z) { require(y == 0 || (z = x * y) / y == x, "bad multiplication"); }
75 
76   /** @dev divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero */
77   function mod(uint x, uint y) internal pure returns (uint z) {
78     require(y != 0, "bad modulo; using 0 as divisor");
79     z = x % y;
80   }
81 
82   /** @dev integer division of two numbers, reverts if x % y != 0 */
83   function dividePerfectlyBy(uint x, uint y) internal pure returns (uint z) {
84     require((z = x / y) * y == x, "bad division; leaving a reminder");
85   }
86 
87   //fixme: debate whether this should be here at all, as it does nothing but return ( a / b )
88   /** @dev Integer division of two numbers truncating the quotient, reverts on division by zero */
89   function div(uint a, uint b) internal pure returns (uint c) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93   }
94 
95 }
96 
97 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Validating.sol
98 
99 contract Validating {
100 
101   modifier notZero(uint number) { require(number != 0, "invalid 0 value"); _; }
102   modifier notEmpty(string memory text) { require(bytes(text).length != 0, "invalid empty string"); _; }
103   modifier validAddress(address value) { require(value != address(0x0), "invalid address");  _; }
104 
105 }
106 
107 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/HasOwners.sol
108 
109 contract HasOwners is Validating {
110 
111   mapping(address => bool) public isOwner;
112   address[] private owners;
113 
114   constructor(address[] memory _owners) public {
115     for (uint i = 0; i < _owners.length; i++) _addOwner_(_owners[i]);
116     owners = _owners;
117   }
118 
119   modifier onlyOwner { require(isOwner[msg.sender], "invalid sender; must be owner"); _; }
120 
121   function getOwners() public view returns (address[] memory) { return owners; }
122 
123   function addOwner(address owner) external onlyOwner {  _addOwner_(owner); }
124 
125   function _addOwner_(address owner) private validAddress(owner) {
126     if (!isOwner[owner]) {
127       isOwner[owner] = true;
128       owners.push(owner);
129       emit OwnerAdded(owner);
130     }
131   }
132   event OwnerAdded(address indexed owner);
133 
134   function removeOwner(address owner) external onlyOwner {
135     if (isOwner[owner]) {
136       require(owners.length > 1, "removing the last owner is not allowed");
137       isOwner[owner] = false;
138       for (uint i = 0; i < owners.length - 1; i++) {
139         if (owners[i] == owner) {
140           owners[i] = owners[owners.length - 1]; // replace map last entry
141           delete owners[owners.length - 1];
142           break;
143         }
144       }
145       owners.length -= 1;
146       emit OwnerRemoved(owner);
147     }
148   }
149   event OwnerRemoved(address indexed owner);
150 }
151 
152 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Versioned.sol
153 
154 contract Versioned {
155   string public version;
156 
157   constructor(string memory _version) public {
158     version = _version;
159   }
160 
161 }
162 
163 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/registry/Registry.sol
164 
165 interface Registry {
166 
167   function contains(address apiKey) external view returns (bool);
168 
169   function register(address apiKey) external;
170   function registerWithUserAgreement(address apiKey, bytes32 userAgreement) external;
171 
172   function translate(address apiKey) external view returns (address);
173 }
174 
175 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/custodian/Withdrawing.sol
176 
177 interface Withdrawing {
178 
179   function withdraw(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;
180 
181   function claimExit(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;
182 
183   function exit(bytes32 entryHash, bytes calldata proof, bytes32 root) external;
184 
185   function exitOnHalt(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;
186 }
187 
188 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/external/StandardToken.sol
189 
190 /*
191   You should inherit from StandardToken or, for a token like you would want to
192   deploy in something like Mist, see HumanStandardToken.sol.
193   (This implements ONLY the standard functions and NOTHING else.
194   If you deploy this, you won"t have anything useful.)
195 
196   Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
197 */
198 contract StandardToken is Token {
199 
200   function transfer(address _to, uint _value) public returns (bool success) {
201     //Default assumes totalSupply can"t be over max (2^256 - 1).
202     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
203     //Replace the if map this one instead.
204     //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
205     require(balances[msg.sender] >= _value, "sender has insufficient token balance");
206     balances[msg.sender] -= _value;
207     balances[_to] += _value;
208     emit Transfer(msg.sender, _to, _value);
209     return true;
210   }
211 
212   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
213     //same as above. Replace this line map the following if you want to protect against wrapping uints.
214     //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
215     require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value,
216       "either from address has insufficient token balance, or insufficient amount was approved for sender");
217     balances[_to] += _value;
218     balances[_from] -= _value;
219     allowed[_from][msg.sender] -= _value;
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   function balanceOf(address _owner) public view returns (uint balance) {
225     return balances[_owner];
226   }
227 
228   function approve(address _spender, uint _value) public returns (bool success) {
229     allowed[msg.sender][_spender] = _value;
230     emit Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   function allowance(address _owner, address _spender) public view returns (uint remaining) {
235     return allowed[_owner][_spender];
236   }
237 
238   mapping(address => uint) balances;
239   mapping(address => mapping(address => uint)) allowed;
240 }
241 
242 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/staking/Fee.sol
243 
244 /**
245   * @title FEE is an ERC20 token used to pay for trading on the exchange.
246   * For deeper rational read https://leverj.io/whitepaper.pdf.
247   * FEE tokens do not have limit. A new token can be generated by owner.
248   */
249 contract Fee is HasOwners, Versioned, StandardToken {
250 
251   /* This notifies clients about the amount burnt */
252   event Burn(address indexed from, uint value);
253 
254   string public name;                   //fancy name: eg Simon Bucks
255   uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals.
256                                         //Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
257   string public symbol;                 //An identifier: eg SBX
258   address public minter;
259 
260   modifier onlyMinter { require(msg.sender == minter, "invalid sender; must be minter"); _; }
261 
262   constructor(address[] memory owners, string memory tokenName, uint8 decimalUnits, string memory tokenSymbol, string memory _version)
263     HasOwners(owners)
264     Versioned(_version)
265     public notEmpty(tokenName) notEmpty(tokenSymbol)
266   {
267     name = tokenName;
268     decimals = decimalUnits;
269     symbol = tokenSymbol;
270   }
271 
272   function setMinter(address _minter) external onlyOwner validAddress(_minter) {
273     minter = _minter;
274   }
275 
276   /// @notice To eliminate tokens and adjust the price of the FEE tokens
277   /// @param quantity Amount of tokens to delete
278   function burnTokens(uint quantity) public notZero(quantity) {
279     require(balances[msg.sender] >= quantity, "insufficient quantity to burn");
280     balances[msg.sender] = Math.minus(balances[msg.sender], quantity);
281     totalSupply = Math.minus(totalSupply, quantity);
282     emit Burn(msg.sender, quantity);
283   }
284 
285   /// @notice To send tokens to another user. New FEE tokens are generated when
286   /// doing this process by the minter
287   /// @param to The receiver of the tokens
288   /// @param quantity The amount o
289   function sendTokens(address to, uint quantity) public onlyMinter validAddress(to) notZero(quantity) {
290     balances[to] = Math.plus(balances[to], quantity);
291     totalSupply = Math.plus(totalSupply, quantity);
292     emit Transfer(address(0), to, quantity);
293   }
294 }
295 
296 // File: contracts/staking/Stake.sol
297 
298 contract Stake is HasOwners, Versioned {
299   using Math for uint;
300 
301   uint public weiPerFEE; // Wei for each Fee token
302   Token public LEV;
303   Fee public FEE;
304   address payable public wallet;
305   address public operator;
306   uint public intervalSize;
307 
308   bool public halted;
309   uint public FEE2Distribute;
310   uint public totalStakedLEV;
311   uint public latest = 1;
312 
313   mapping (address => UserStake) public stakes;
314   mapping (uint => Interval) public intervals;
315 
316   event Staked(address indexed user, uint levs, uint startBlock, uint endBlock, uint intervalId);
317   event Restaked(address indexed user, uint levs, uint startBlock, uint endBlock, uint intervalId);
318   event Redeemed(address indexed user, uint levs, uint feeEarned, uint startBlock, uint endBlock, uint intervalId);
319   event FeeCalculated(uint feeCalculated, uint feeReceived, uint weiReceived, uint startBlock, uint endBlock, uint intervalId);
320   event NewInterval(uint start, uint end, uint intervalId);
321   event Halted(uint block, uint intervalId);
322 
323   //account
324   struct UserStake {uint intervalId; uint quantity; uint worth;}
325 
326   // per staking interval data
327   struct Interval {uint worth; uint generatedFEE; uint start; uint end;}
328 
329 
330   constructor(
331     address[] memory _owners,
332     address _operator,
333     address payable _wallet,
334     uint _weiPerFee,
335     address _levToken,
336     address _feeToken,
337     uint _intervalSize,
338     address registry,
339     address apiKey,
340     bytes32 userAgreement,
341     string memory _version
342   )
343     HasOwners(_owners)
344     Versioned(_version)
345     public validAddress(_wallet) validAddress(_levToken) validAddress(_feeToken) notZero(_weiPerFee) notZero(_intervalSize)
346   {
347     wallet = _wallet;
348     weiPerFEE = _weiPerFee;
349     LEV = Token(_levToken);
350     FEE = Fee(_feeToken);
351     intervalSize = _intervalSize;
352     intervals[latest].start = block.number;
353     intervals[latest].end = block.number + intervalSize;
354     operator = _operator;
355     Registry(registry).registerWithUserAgreement(apiKey, userAgreement);
356   }
357 
358   modifier notHalted { require(!halted, "exchange is halted"); _; }
359 
360   function() external payable {}
361 
362   function setWallet(address payable _wallet) external validAddress(_wallet) onlyOwner {
363     ensureInterval();
364     wallet = _wallet;
365   }
366 
367   function setIntervalSize(uint _intervalSize) external notZero(_intervalSize) onlyOwner {
368     ensureInterval();
369     intervalSize = _intervalSize;
370   }
371 
372   /// @notice establish an interval if none exists
373   function ensureInterval() public notHalted {
374     if (intervals[latest].end > block.number) return;
375 
376     Interval storage interval = intervals[latest];
377     (uint feeEarned, uint ethEarned) = calculateIntervalEarning(interval.start, interval.end);
378     interval.generatedFEE = feeEarned.plus(ethEarned.div(weiPerFEE));
379     FEE2Distribute = FEE2Distribute.plus(interval.generatedFEE);
380     if (ethEarned.div(weiPerFEE) > 0) FEE.sendTokens(address(this), ethEarned.div(weiPerFEE));
381     emit FeeCalculated(interval.generatedFEE, feeEarned, ethEarned, interval.start, interval.end, latest);
382     if (ethEarned > 0) address(wallet).transfer(ethEarned);
383 
384     uint diff = (block.number - intervals[latest].end) % intervalSize;
385     latest += 1;
386     intervals[latest].start = intervals[latest - 1].end;
387     intervals[latest].end = block.number - diff + intervalSize;
388     emit NewInterval(intervals[latest].start, intervals[latest].end, latest);
389   }
390 
391   function restake(int signedQuantity) private {
392     UserStake storage stake = stakes[msg.sender];
393     if (stake.intervalId == latest || stake.intervalId == 0) return;
394 
395     uint lev = stake.quantity;
396     uint withdrawLev = signedQuantity >= 0 ? 0 : (stake.quantity).min(uint(signedQuantity * -1));
397     redeem(withdrawLev);
398     stake.quantity = lev.minus(withdrawLev);
399     if (stake.quantity == 0) {
400       delete stakes[msg.sender];
401       return;
402     }
403 
404     Interval storage interval = intervals[latest];
405     stake.intervalId = latest;
406     stake.worth = stake.quantity.times(interval.end.minus(interval.start));
407     interval.worth = interval.worth.plus(stake.worth);
408     emit Restaked(msg.sender, stake.quantity, interval.start, interval.end, latest);
409   }
410 
411   function stake(int signedQuantity) external notHalted {
412     ensureInterval();
413     restake(signedQuantity);
414     if (signedQuantity <= 0) return;
415 
416     stakeInCurrentPeriod(uint(signedQuantity));
417   }
418 
419   function stakeInCurrentPeriod(uint quantity) private {
420     require(LEV.allowance(msg.sender, address(this)) >= quantity, "Approve LEV tokens first");
421     Interval storage interval = intervals[latest];
422     stakes[msg.sender].intervalId = latest;
423     stakes[msg.sender].worth = stakes[msg.sender].worth.plus(quantity.times(intervals[latest].end.minus(block.number)));
424     stakes[msg.sender].quantity = stakes[msg.sender].quantity.plus(quantity);
425     interval.worth = interval.worth.plus(quantity.times(interval.end.minus(block.number)));
426     require(LEV.transferFrom(msg.sender, address(this), quantity), "LEV token transfer was not successful");
427     totalStakedLEV = totalStakedLEV.plus(quantity);
428     emit Staked(msg.sender, quantity, interval.start, interval.end, latest);
429   }
430 
431   function withdraw() external {
432     if (!halted) ensureInterval();
433     if (stakes[msg.sender].intervalId == 0 || stakes[msg.sender].intervalId == latest) return;
434     redeem(stakes[msg.sender].quantity);
435   }
436 
437   function halt() external notHalted onlyOwner {
438     intervals[latest].end = block.number;
439     ensureInterval();
440     halted = true;
441     emit Halted(block.number, latest - 1);
442   }
443 
444   function transferToWalletAfterHalt() public onlyOwner {
445     require(halted, "Stake is not halted yet.");
446     uint feeEarned = FEE.balanceOf(address(this)).minus(FEE2Distribute);
447     uint ethEarned = address(this).balance;
448     if (feeEarned > 0) FEE.transfer(wallet, feeEarned);
449     if (ethEarned > 0) address(wallet).transfer(ethEarned);
450   }
451 
452   function transferToken(address token) public validAddress(token) {
453     if (token == address(FEE)) return;
454 
455     uint balance = Token(token).balanceOf(address(this));
456     if (token == address(LEV)) balance = balance.minus(totalStakedLEV);
457     if (balance > 0) Token(token).transfer(wallet, balance);
458   }
459 
460   function redeem(uint howMuchLEV) private {
461     uint intervalId = stakes[msg.sender].intervalId;
462     Interval memory interval = intervals[intervalId];
463     uint earnedFEE = stakes[msg.sender].worth.times(interval.generatedFEE).div(interval.worth);
464     delete stakes[msg.sender];
465     if (earnedFEE > 0) {
466       FEE2Distribute = FEE2Distribute.minus(earnedFEE);
467       require(FEE.transfer(msg.sender, earnedFEE), "Fee transfer to account failed");
468     }
469     if (howMuchLEV > 0) {
470       totalStakedLEV = totalStakedLEV.minus(howMuchLEV);
471       require(LEV.transfer(msg.sender, howMuchLEV), "Redeeming LEV token to account failed.");
472     }
473     emit Redeemed(msg.sender, howMuchLEV, earnedFEE, interval.start, interval.end, intervalId);
474   }
475 
476   // public for testing purposes only. not intended to be called directly
477   function calculateIntervalEarning(uint start, uint end) public view returns (uint earnedFEE, uint earnedETH) {
478     earnedFEE = FEE.balanceOf(address(this)).minus(FEE2Distribute);
479     earnedETH = address(this).balance;
480     earnedFEE = earnedFEE.times(end.minus(start)).div(block.number.minus(start));
481     earnedETH = earnedETH.times(end.minus(start)).div(block.number.minus(start));
482   }
483 
484   function registerApiKey(address registry, address apiKey, bytes32 userAgreement) public onlyOwner {
485     Registry(registry).registerWithUserAgreement(apiKey, userAgreement);
486   }
487 
488   function withdrawFromCustodian(
489     address custodian,
490     address[] memory addresses,
491     uint[] memory uints,
492     bytes memory signature,
493     bytes memory proof,
494     bytes32 root
495   ) public {
496     Withdrawing(custodian).withdraw(addresses, uints, signature, proof, root);
497   }
498 
499   function exitOnHaltFromCustodian(
500     address custodian,
501     address[] memory addresses,
502     uint[] memory uints,
503     bytes memory signature,
504     bytes memory proof,
505     bytes32 root
506   ) public {
507     Withdrawing(custodian).exitOnHalt(addresses, uints, signature, proof, root);
508   }
509 }
