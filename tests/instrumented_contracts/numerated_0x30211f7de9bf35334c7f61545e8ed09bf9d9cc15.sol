1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Ownership functionality for authorization controls and user permissions
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 // ----------------------------------------------------------------------------
33 // Pause functionality
34 // ----------------------------------------------------------------------------
35 contract Pausable is Owned {
36   event Pause();
37   event Unpause();
38 
39   bool public paused = false;
40 
41 
42   // Modifier to make a function callable only when the contract is not paused.
43   modifier whenNotPaused() {
44     require(!paused);
45     _;
46   }
47 
48   // Modifier to make a function callable only when the contract is paused.
49   modifier whenPaused() {
50     require(paused);
51     _;
52   }
53 
54   // Called by the owner to pause, triggers stopped state
55   function pause() onlyOwner whenNotPaused public {
56     paused = true;
57     emit Pause();
58   }
59 
60   // Called by the owner to unpause, returns to normal state
61   function unpause() onlyOwner whenPaused public {
62     paused = false;
63     emit Unpause();
64   }
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that revert on error
70  */
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, reverts on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80 
81     uint256 c = a * b;
82     require(c / a == b);
83 
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     require(b > 0); // Solidity only automatically asserts when dividing by 0
92     uint256 c = a / b;
93 
94     return c;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     require(b <= a);
102     uint256 c = a - b;
103 
104     return c;
105   }
106 
107   /**
108   * @dev Adds two numbers, reverts on overflow.
109   */
110   function add(uint256 a, uint256 b) internal pure returns (uint256) {
111     uint256 c = a + b;
112     require(c >= a);
113 
114     return c;
115   }
116 
117   /**
118   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
119   * reverts when dividing by zero.
120   */
121   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
122     require(b != 0);
123     return a % b;
124   }
125 }
126 
127 
128 // ----------------------------------------------------------------------------
129 // ERC20 Standard Interface
130 // ----------------------------------------------------------------------------
131 contract ERC20 {
132     function totalSupply() public constant returns (uint);
133     function balanceOf(address tokenOwner) public constant returns (uint balance);
134     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
135     function transfer(address to, uint tokens) public returns (bool success);
136     function approve(address spender, uint tokens) public returns (bool success);
137     function transferFrom(address from, address to, uint tokens) public returns (bool success);
138 
139     event Transfer(address indexed from, address indexed to, uint tokens);
140     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
141 }
142 
143 // ----------------------------------------------------------------------------
144 // 'AVEX' 'Aevolve' token contract
145 // Symbol      : AVEX
146 // Name        : Aevolve
147 // Total supply: 1,210,000,000
148 // Decimals    : 18
149 // ----------------------------------------------------------------------------
150 
151 // ----------------------------------------------------------------------------
152 // ERC20 Token. Specifies symbol, name, decimals, and total supply
153 // ----------------------------------------------------------------------------
154 contract Aevolve is Owned, Pausable, ERC20 {
155     using SafeMath for uint256;
156 
157     string public symbol;
158     string public  name;
159     uint8 public decimals;
160     uint public _totalSupply;
161 
162 
163     mapping(address => uint) public balances;
164     mapping(address => mapping(address => uint)) internal allowed;
165 
166     event Burned(address indexed burner, uint256 value);
167     event Mint(address indexed to, uint256 amount);
168 
169 
170     // ------------------------------------------------------------------------
171     // Constructor
172     // ------------------------------------------------------------------------
173     constructor() public {
174         symbol = "AVEX";
175         name = "Aevolve";
176         decimals = 18;
177         _totalSupply = 1210000000 * 10**uint(decimals);
178         balances[owner] = _totalSupply;
179         emit Transfer(address(0), owner, _totalSupply);
180     }
181 
182     // ------------------------------------------------------------------------
183     // Total supply
184     // ------------------------------------------------------------------------
185     function totalSupply() public constant returns (uint) {
186         return _totalSupply;
187     }
188 
189     // ------------------------------------------------------------------------
190     // Get the token balance for account `tokenOwner`
191     // ------------------------------------------------------------------------
192     function balanceOf(address tokenOwner) public constant returns (uint balance) {
193         return balances[tokenOwner];
194     }
195 
196     // ------------------------------------------------------------------------
197     // Transfer the balance from token owner's account to `_to` account
198     // - Owner's account must have sufficient balance to transfer
199     // - 0 value transfers are allowed
200     // ------------------------------------------------------------------------
201     function transfer(address _to, uint256 _value) public returns (bool) {
202       require(_value <= balances[msg.sender]);
203       require(_to != address(0));
204 
205       balances[msg.sender] = balances[msg.sender].sub(_value);
206       balances[_to] = balances[_to].add(_value);
207       emit Transfer(msg.sender, _to, _value);
208       return true;
209  }
210 
211     // ------------------------------------------------------------------------
212     // Token owner can approve for `spender` to transferFrom(...) `tokens`
213     // from the token owner's account
214     // ------------------------------------------------------------------------
215     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
216         require(spender != address(0));
217 
218         allowed[msg.sender][spender] = tokens;
219         emit Approval(msg.sender, spender, tokens);
220         return true;
221     }
222 
223     // ------------------------------------------------------------------------
224     // Transfer `tokens` from the `from` account to the `to` account
225     //
226     // The calling account must already have sufficient tokens approve(...)-d
227     // for spending from the `from` account and
228     // - From account must have sufficient balance to transfer
229     // - Spender must have sufficient allowance to transfer
230     // ------------------------------------------------------------------------
231     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
232         require(to != address(0));
233 
234         //check edge cases
235         if (allowed[from][msg.sender] >= tokens
236             && balances[from] >= tokens
237             && tokens > 0) {
238 
239             //update balances and allowances
240             balances[from] = balances[from].sub(tokens);
241             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
242             balances[to] = balances[to].add(tokens);
243 
244             //log event
245             emit Transfer(from, to, tokens);
246             return true;
247         }
248         else {
249             return false;
250         }
251     }
252 
253     // ------------------------------------------------------------------------
254     // Returns the amount of tokens approved by the owner that can be
255     // transferred to the spender's account
256     // ------------------------------------------------------------------------
257     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
258         return allowed[tokenOwner][spender];
259     }
260 
261 
262     // ------------------------------------------------------------------------
263     // Burns a specific number of tokens
264     // ------------------------------------------------------------------------
265     function burn(uint256 _value) public onlyOwner {
266         require(_value > 0);
267 
268         address burner = msg.sender;
269         balances[burner] = balances[burner].sub(_value);
270         _totalSupply = _totalSupply.sub(_value);
271         emit Burned(burner, _value);
272     }
273 
274 
275     // ------------------------------------------------------------------------
276     // Doesn't Accept Eth
277     // ------------------------------------------------------------------------
278     function () public payable {
279         revert();
280     }
281 }
282 
283 
284 /**
285  * @title TokenVesting
286  * @dev A token holder contract that can release its token balance gradually like a
287  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
288  * owner.
289  */
290 contract TokenVesting is Owned, Pausable, ERC20, Aevolve {
291   using SafeMath for uint256;
292 
293 
294   event Released(uint256 amount);
295   event Revoked();
296 
297   // beneficiary of tokens after they are released
298   address public beneficiary;
299 
300   uint256 public cliff;
301   uint256 public start;
302   uint256 public duration;
303 
304   bool public revocable;
305 
306   mapping (address => uint256) public released;
307   mapping (address => bool) public revoked;
308 
309   /**
310    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
311    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
312    * of the balance will have vested.
313    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
314    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
315    * @param _start the time (as Unix time) at which point vesting starts
316    * @param _duration duration in seconds of the period in which the tokens will vest
317    * @param _revocable whether the vesting is revocable or not
318    */
319   constructor(
320     address _beneficiary,
321     uint256 _start,
322     uint256 _cliff,
323     uint256 _duration,
324     bool _revocable
325   )
326     public
327   {
328     require(_beneficiary != address(0));
329     require(_cliff <= _duration);
330 
331     beneficiary = _beneficiary;
332     revocable = _revocable;
333     duration = _duration;
334     cliff = _start.add(_cliff);
335     start = _start;
336   }
337 
338   /**
339    * @notice Transfers vested tokens to beneficiary.
340    * @param _token ERC20 token which is being vested
341    */
342   function release(ERC20 _token) public {
343     uint256 unreleased = releasableAmount(_token);
344 
345     require(unreleased > 0);
346 
347     released[_token] = released[_token].add(unreleased);
348 
349     _token.transfer(beneficiary, unreleased);
350 
351     emit Released(unreleased);
352   }
353 
354   /**
355    * @notice Allows the owner to revoke the vesting. Tokens already vested
356    * remain in the contract, the rest are returned to the owner.
357    * @param _token ERC20 token which is being vested
358    */
359   function revoke(ERC20 _token) public onlyOwner {
360     require(revocable);
361     require(!revoked[_token]);
362 
363     uint256 balance = _token.balanceOf(address(this));
364 
365     uint256 unreleased = releasableAmount(_token);
366     uint256 refund = balance.sub(unreleased);
367 
368     revoked[_token] = true;
369 
370     _token.transfer(owner, refund);
371 
372     emit Revoked();
373   }
374 
375   /**
376    * @dev Calculates the amount that has already vested but hasn't been released yet.
377    * @param _token ERC20 token which is being vested
378    */
379   function releasableAmount(ERC20 _token) public view returns (uint256) {
380     // returns vested amount minus amount that has been released
381     return vestedAmount(_token).sub(released[_token]);
382   }
383 
384   /**
385    * @dev Calculates the amount that has already vested.
386    * @param _token ERC20 token which is being vested
387    */
388   function vestedAmount(ERC20 _token) public view returns (uint256) {
389     uint256 currentBalance = _token.balanceOf(address(this)); // balance of this contract
390     uint256 totalBalance = currentBalance.add(released[_token]); // initial balance of this contract
391 
392     if (block.timestamp < cliff) { // can't withdraw if we haven't hit cliff
393       return 0;
394 
395       // if past end of vesting period or it has been revoked, return balance of contract
396     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
397       return totalBalance;
398 
399     } else {
400       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
401     }
402   }
403 }
404 
405 /**
406 *@dev Following the contract factory design, this contract allows owner to mass
407 * create vesting contracts and distribute tokens to them
408 */
409 contract VestingFactory is Owned, Pausable  {
410 	using SafeMath for uint256;
411 
412 	// Array of all vesting contracts
413 	TokenVesting[] public vestingContracts;
414 
415 	// Mapping individual wallet address to vesting contract
416 	mapping(address => address) public beneficiaryContracts;
417 
418 	// initialize token
419 	Aevolve public token;
420 
421 	/*Events*/
422 	event contractCreation(address _creator, address _contract, address _beneficiary);
423 
424 	// construct the VestingFactory with Aevolve token
425 	constructor (
426 		Aevolve _token
427 	) public {
428 		token = _token;
429 	}
430 
431 	/* @dev Mass deploy vesting contracts
432 	* @param beneficiaries is an array of wallet addresses that receive tokens
433 	* @param numTokens is an array of the number of tokens that beneficiaries receive
434 	* @param start is the date and time that tokens begin to vest
435 	* @param duration in seconds of the cliff in which tokens will begin to vest
436 	*/
437 	function deployVesting(address[] beneficiaries, uint256[] numTokens, uint256 start, uint256 cliff, uint256 duration) public onlyOwner {
438 		// Check that array lengths match
439 		require(beneficiaries.length == numTokens.length);
440 
441 		// temp variable to store vesting contract
442 		TokenVesting vestingContract;
443 
444 		// temp variable to store address of beneficiary through the loop, used for efficiency
445 		address benAddress;
446 
447 		// Loop through investors and create their vesting vestingContracts
448 		for(uint256 i = 0; i < beneficiaries.length; i++) {
449 
450 			// Checks that they do not already have a vesting contract
451 			if (beneficiaryContracts[beneficiaries[i]] == 0x0) {
452 				benAddress = beneficiaries[i];
453 				vestingContract = new TokenVesting(benAddress, start, cliff, duration, false);
454 
455 				// Update data structures used to track vesting contracts
456 				vestingContracts.push(vestingContract);
457 				beneficiaryContracts[benAddress] = vestingContract;
458 
459 				emit contractCreation(address(this), address(vestingContract), benAddress);
460 
461 				// Send their tokens to their vesting contract
462 				token.transfer(vestingContract, numTokens[i]);
463 			}
464 		}
465 	}
466 
467 	// @dev mass release vested tokens
468 	function massRelease() public onlyOwner {
469 		require(vestingContracts.length > 0);
470 		for(uint256 i = 0; i < vestingContracts.length; i++) {
471       // Check that there are tokens to release
472       if(vestingContracts[i].releasableAmount(token) != 0) {
473         vestingContracts[i].release(token);
474       }
475 		}
476 	}
477 
478 	// @dev transfer tokens out of contract
479 	function tokenTransfer(address recipient, uint256 amount) public onlyOwner {
480 		token.transfer(recipient, amount);
481 	}
482 
483 	// @dev Return the vesting contract for an individual
484 	function getVestingContracts(address beneficiary) public returns (address){
485 		return beneficiaryContracts[beneficiary];
486 	}
487 
488 }