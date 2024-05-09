1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title SimpleToken
214  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
215  * Note they can later distribute these tokens as they wish using `transfer` and other
216  * `StandardToken` functions.
217  */
218 contract LibraToken is StandardToken {
219 
220     string public constant name = "LibraToken"; // solium-disable-line uppercase
221     string public constant symbol = "LBA"; // solium-disable-line uppercase
222     uint8 public constant decimals = 18; // solium-disable-line uppercase
223 
224     uint256 public constant INITIAL_SUPPLY = (10 ** 9) * (10 ** uint256(decimals));
225 
226     /**
227     * @dev Constructor that gives msg.sender all of existing tokens.
228     */
229     function LibraToken() public {
230         totalSupply_ = INITIAL_SUPPLY;
231         balances[msg.sender] = INITIAL_SUPPLY;
232         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
233     }
234 
235 }
236 
237 /**
238  * @title Ownable
239  * @dev The Ownable contract has an owner address, and provides basic authorization control
240  * functions, this simplifies the implementation of "user permissions".
241  */
242 contract Ownable {
243   address public owner;
244 
245 
246   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
247 
248 
249   /**
250    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
251    * account.
252    */
253   function Ownable() public {
254     owner = msg.sender;
255   }
256 
257   /**
258    * @dev Throws if called by any account other than the owner.
259    */
260   modifier onlyOwner() {
261     require(msg.sender == owner);
262     _;
263   }
264 
265   /**
266    * @dev Allows the current owner to transfer control of the contract to a newOwner.
267    * @param newOwner The address to transfer ownership to.
268    */
269   function transferOwnership(address newOwner) public onlyOwner {
270     require(newOwner != address(0));
271     OwnershipTransferred(owner, newOwner);
272     owner = newOwner;
273   }
274 
275 }
276 
277 contract LibraTokenVault is Ownable {
278     using SafeMath for uint256;
279 
280     //Wallet Addresses for allocation
281     address public teamReserveWallet = 0x373c69fDedE072A3F5ab1843a0e5fE0102Cc6793;
282     address public firstReserveWallet = 0x99C83f62DBE1a488f9C9d370DA8e86EC55224eB4;
283     address public secondReserveWallet = 0x90DfF11810dA6227d348C86C59257C1C0033D307;
284 
285     //Token Allocations
286     uint256 public teamReserveAllocation = 2 * (10 ** 8) * (10 ** 18);
287     uint256 public firstReserveAllocation = 15 * (10 ** 7) * (10 ** 18);
288     uint256 public secondReserveAllocation = 15 * (10 ** 7) * (10 ** 18);
289 
290     //Total Token Allocations
291     uint256 public totalAllocation = 5 * (10 ** 8) * (10 ** 18);
292 
293     uint256 public teamTimeLock = 2 * 365 days;
294     uint256 public teamVestingStages = 8;
295     uint256 public firstReserveTimeLock = 2 * 365 days;
296     uint256 public secondReserveTimeLock = 3 * 365 days;
297 
298     /** Reserve allocations */
299     mapping(address => uint256) public allocations;
300 
301     /** When timeLocks are over (UNIX Timestamp)  */  
302     mapping(address => uint256) public timeLocks;
303 
304     /** How many tokens each reserve wallet has claimed */
305     mapping(address => uint256) public claimed;
306 
307     /** When this vault was locked (UNIX Timestamp)*/
308     uint256 public lockedAt = 0;
309 
310     LibraToken public token;
311 
312     /** Allocated reserve tokens */
313     event Allocated(address wallet, uint256 value);
314 
315     /** Distributed reserved tokens */
316     event Distributed(address wallet, uint256 value);
317 
318     /** Tokens have been locked */
319     event Locked(uint256 lockTime);
320 
321     //Any of the three reserve wallets
322     modifier onlyReserveWallets {
323         require(allocations[msg.sender] > 0);
324         _;
325     }
326 
327     //Only Libra team reserve wallet
328     modifier onlyTeamReserve {
329         require(msg.sender == teamReserveWallet);
330         require(allocations[msg.sender] > 0);
331         _;
332     }
333 
334     //Only first and second token reserve wallets
335     modifier onlyTokenReserve {
336         require(msg.sender == firstReserveWallet || msg.sender == secondReserveWallet);
337         require(allocations[msg.sender] > 0);
338         _;
339     }
340 
341     //Has not been locked yet
342     modifier notLocked {
343         require(lockedAt == 0);
344         _;
345     }
346 
347     modifier locked {
348         require(lockedAt > 0);
349         _;
350     }
351 
352     //Token allocations have not been set
353     modifier notAllocated {
354         require(allocations[teamReserveWallet] == 0);
355         require(allocations[firstReserveWallet] == 0);
356         require(allocations[secondReserveWallet] == 0);
357         _;
358     }
359 
360     function LibraTokenVault(ERC20 _token) public {
361 
362         owner = msg.sender;
363         token = LibraToken(_token);
364         
365     }
366 
367     function allocate() public notLocked notAllocated onlyOwner {
368 
369         //Makes sure Token Contract has the exact number of tokens
370         require(token.balanceOf(address(this)) == totalAllocation);
371         
372         allocations[teamReserveWallet] = teamReserveAllocation;
373         allocations[firstReserveWallet] = firstReserveAllocation;
374         allocations[secondReserveWallet] = secondReserveAllocation;
375 
376         Allocated(teamReserveWallet, teamReserveAllocation);
377         Allocated(firstReserveWallet, firstReserveAllocation);
378         Allocated(secondReserveWallet, secondReserveAllocation);
379 
380         lock();
381     }
382 
383     //Lock the vault for the three wallets
384     function lock() internal notLocked onlyOwner {
385 
386         lockedAt = block.timestamp;
387 
388         timeLocks[teamReserveWallet] = lockedAt.add(teamTimeLock);
389         timeLocks[firstReserveWallet] = lockedAt.add(firstReserveTimeLock);
390         timeLocks[secondReserveWallet] = lockedAt.add(secondReserveTimeLock);
391 
392         Locked(lockedAt);
393     }
394 
395     //In the case locking failed, then allow the owner to reclaim the tokens on the contract.
396     //Recover Tokens in case incorrect amount was sent to contract.
397     function recoverFailedLock() external notLocked notAllocated onlyOwner {
398 
399         // Transfer all tokens on this contract back to the owner
400         require(token.transfer(owner, token.balanceOf(address(this))));
401     }
402 
403     // Total number of tokens currently in the vault
404     function getTotalBalance() public view returns (uint256 tokensCurrentlyInVault) {
405 
406         return token.balanceOf(address(this));
407 
408     }
409 
410     // Number of tokens that are still locked
411     function getLockedBalance() public view onlyReserveWallets returns (uint256 tokensLocked) {
412 
413         return allocations[msg.sender].sub(claimed[msg.sender]);
414 
415     }
416 
417     //Claim tokens for first/second reserve wallets
418     function claimTokenReserve() onlyTokenReserve locked public {
419 
420         address reserveWallet = msg.sender;
421 
422         // Can't claim before Lock ends
423         require(block.timestamp > timeLocks[reserveWallet]);
424 
425         // Must Only claim once
426         require(claimed[reserveWallet] == 0);
427 
428         uint256 amount = allocations[reserveWallet];
429 
430         claimed[reserveWallet] = amount;
431 
432         require(token.transfer(reserveWallet, amount));
433 
434         Distributed(reserveWallet, amount);
435     }
436 
437     //Claim tokens for Libra team reserve wallet
438     function claimTeamReserve() onlyTeamReserve locked public {
439 
440         uint256 vestingStage = teamVestingStage();
441 
442         //Amount of tokens the team should have at this vesting stage
443         uint256 totalUnlocked = vestingStage.mul(allocations[teamReserveWallet]).div(teamVestingStages);
444 
445         require(totalUnlocked <= allocations[teamReserveWallet]);
446 
447         //Previously claimed tokens must be less than what is unlocked
448         require(claimed[teamReserveWallet] < totalUnlocked);
449 
450         uint256 payment = totalUnlocked.sub(claimed[teamReserveWallet]);
451 
452         claimed[teamReserveWallet] = totalUnlocked;
453 
454         require(token.transfer(teamReserveWallet, payment));
455 
456         Distributed(teamReserveWallet, payment);
457     }
458 
459     //Current Vesting stage for Libra team 
460     function teamVestingStage() public view onlyTeamReserve returns(uint256){
461         
462         // Every 3 months
463         uint256 vestingMonths = teamTimeLock.div(teamVestingStages); 
464 
465         uint256 stage = (block.timestamp.sub(lockedAt)).div(vestingMonths);
466 
467         //Ensures team vesting stage doesn't go past teamVestingStages
468         if(stage > teamVestingStages){
469             stage = teamVestingStages;
470         }
471 
472         return stage;
473 
474     }
475 
476     // Checks if msg.sender can collect tokens
477     function canCollect() public view onlyReserveWallets returns(bool) {
478 
479         return block.timestamp > timeLocks[msg.sender] && claimed[msg.sender] == 0;
480 
481     }
482 
483 }