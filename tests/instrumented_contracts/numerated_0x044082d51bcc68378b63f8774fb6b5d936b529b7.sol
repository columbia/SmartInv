1 pragma solidity 0.5.4;
2 
3 
4 library SafeMath {
5 
6     uint256 constant internal MAX_UINT = 2 ** 256 - 1; // max uint256
7 
8     /**
9      * @dev Multiplies two numbers, reverts on overflow.
10      */
11     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
12         if (_a == 0) {
13             return 0;
14         }
15         require(MAX_UINT / _a >= _b);
16         return _a * _b;
17     }
18 
19     /**
20      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
21      */
22     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
23         require(_b != 0);
24         return _a / _b;
25     }
26 
27     /**
28      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
31         require(_b <= _a);
32         return _a - _b;
33     }
34 
35     /**
36      * @dev Adds two numbers, reverts on overflow.
37      */
38     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
39         require(MAX_UINT - _a >= _b);
40         return _a + _b;
41     }
42 
43 }
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52     address public owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58      * account.
59      */
60     constructor () public {
61         owner = msg.sender;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     /**
73      * @dev Allows the current owner to transfer control of the contract to a newOwner.
74      * @param newOwner The address to transfer ownership to.
75      */
76     function transferOwnership(address newOwner) public onlyOwner {
77         _transferOwnership(newOwner);
78     }
79 
80     /**
81      * @dev Transfers control of the contract to a newOwner.
82      * @param newOwner The address to transfer ownership to.
83      */
84     function _transferOwnership(address newOwner) internal {
85         require(newOwner != address(0));
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 }
90 
91 
92 contract Pausable is Ownable {
93     event Pause();
94     event Unpause();
95 
96     bool public paused = false;
97 
98     /**
99      * @dev Modifier to make a function callable only when the contract is not paused.
100      */
101     modifier whenNotPaused() {
102         require(!paused);
103         _;
104     }
105 
106     /**
107      * @dev Modifier to make a function callable only when the contract is paused.
108      */
109     modifier whenPaused() {
110         require(paused);
111         _;
112     }
113 
114     /**
115      * @dev called by the owner to pause, triggers stopped state
116      */
117     function pause() public onlyOwner whenNotPaused {
118         paused = true;
119         emit Pause();
120     }
121 
122     /**
123      * @dev called by the owner to unpause, returns to normal state
124      */
125     function unpause() public onlyOwner whenPaused {
126         paused = false;
127         emit Unpause();
128     }
129 }
130 
131 
132 contract StandardToken {
133     using SafeMath for uint256;
134 
135     mapping(address => uint256) internal balances;
136 
137     mapping(address => mapping(address => uint256)) internal allowed;
138 
139     uint256 public totalSupply;
140 
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144 
145     /**
146      * @dev Gets the balance of the specified address.
147      * @param _owner The address to query the the balance of.
148      * @return An uint256 representing the amount owned by the passed address.
149      */
150     function balanceOf(address _owner) public view returns(uint256) {
151         return balances[_owner];
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param _owner address The address which owns the funds.
157      * @param _spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address _owner, address _spender) public view returns(uint256) {
161         return allowed[_owner][_spender];
162     }
163 
164     /**
165      * @dev Transfer token for a specified address
166      * @param _to The address to transfer to.
167      * @param _value The amount to be transferred.
168      */
169     function transfer(address _to, uint256 _value) public returns(bool) {
170         require(_to != address(0));
171         require(_value <= balances[msg.sender]);
172 
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         emit Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     /**
180      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181      * Beware that changing an allowance with this method brings the risk that someone may use both the old
182      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      * @param _spender The address which will spend the funds.
186      * @param _value The amount of tokens to be spent.
187      */
188     function approve(address _spender, uint256 _value) public returns(bool) {
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Transfer tokens from one address to another
196      * @param _from address The address which you want to send tokens from
197      * @param _to address The address which you want to transfer to
198      * @param _value uint256 the amount of tokens to be transferred
199      */
200     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
201         require(_to != address(0));
202         require(_value <= balances[_from]);
203         require(_value <= allowed[_from][msg.sender]);
204 
205         balances[_from] = balances[_from].sub(_value);
206         balances[_to] = balances[_to].add(_value);
207         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208         emit Transfer(_from, _to, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Increase the amount of tokens that an owner allowed to a spender.
214      * approve should be called when allowed[_spender] == 0. To increment
215      * allowed value is better to use this function to avoid 2 calls (and wait until
216      * the first transaction is mined)
217      * From MonolithDAO Token.sol
218      * @param _spender The address which will spend the funds.
219      * @param _addedValue The amount of tokens to increase the allowance by.
220      */
221     function increaseApproval(address _spender, uint256 _addedValue) public returns(bool) {
222         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227     /**
228      * @dev Decrease the amount of tokens that an owner allowed to a spender.
229      * approve should be called when allowed[_spender] == 0. To decrement
230      * allowed value is better to use this function to avoid 2 calls (and wait until
231      * the first transaction is mined)
232      * From MonolithDAO Token.sol
233      * @param _spender The address which will spend the funds.
234      * @param _subtractedValue The amount of tokens to decrease the allowance by.
235      */
236     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns(bool) {
237         uint256 oldValue = allowed[msg.sender][_spender];
238         if (_subtractedValue >= oldValue) {
239             allowed[msg.sender][_spender] = 0;
240         } else {
241             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242         }
243         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         return true;
245     }
246 
247     function _burn(address account, uint256 value) internal {
248         require(account != address(0));
249         totalSupply = totalSupply.sub(value);
250         balances[account] = balances[account].sub(value);
251         emit Transfer(account, address(0), value);
252     }
253 
254     /**
255      * @dev Internal function that burns an amount of the token of a given
256      * account, deducting from the sender's allowance for said account. Uses the
257      * internal burn function.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burnFrom(address account, uint256 value) internal {
262         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
263         // this function needs to emit an event with the updated approval.
264         allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);
265         _burn(account, value);
266     }
267 
268 }
269 
270 
271 contract BurnableToken is StandardToken {
272 
273     /**
274      * @dev Burns a specific amount of tokens.
275      * @param value The amount of token to be burned.
276      */
277     function burn(uint256 value) public {
278         _burn(msg.sender, value);
279     }
280 
281     /**
282      * @dev Burns a specific amount of tokens from the target address and decrements allowance
283      * @param from address The address which you want to send tokens from
284      * @param value uint256 The amount of token to be burned
285      */
286     function burnFrom(address from, uint256 value) public {
287         _burnFrom(from, value);
288     }
289 }
290 
291 
292 /**
293  * @title Pausable token
294  * @dev ERC20 modified with pausable transfers.
295  */
296 contract PausableToken is StandardToken, Pausable {
297     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
298         return super.transfer(to, value);
299     }
300 
301     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
302         return super.transferFrom(from, to, value);
303     }
304 
305     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
306         return super.approve(spender, value);
307     }
308 
309     function increaseApproval(address spender, uint256 addedValue) public whenNotPaused returns (bool success) {
310         return super.increaseApproval(spender, addedValue);
311     }
312 
313     function decreaseApproval(address spender, uint256 subtractedValue) public whenNotPaused returns (bool success) {
314         return super.decreaseApproval(spender, subtractedValue);
315     }
316 }
317 
318 
319 /**
320  * @title token
321  * @dev Standard template for ERC20 Token
322  */
323 contract Token is PausableToken, BurnableToken {
324     string public name; 
325     string public symbol; 
326     uint8 public decimals;
327 
328     /**
329      * @dev Constructor, to initialize the basic information of token
330      * @param _name The name of token
331      * @param _symbol The symbol of token
332      * @param _decimals The dicemals of token
333      * @param _INIT_TOTALSUPPLY The total supply of token
334      */
335     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _INIT_TOTALSUPPLY) public {
336         totalSupply = _INIT_TOTALSUPPLY * 10 ** uint256(_decimals);
337         balances[owner] = totalSupply; // Transfers all tokens to owner
338         name = _name;
339         symbol = _symbol;
340         decimals = _decimals;
341     }
342 }
343 
344 
345 /**
346  * @dev Interface of BDR contract
347  */
348 interface BDRContract {
349     function tokenFallback(address _from, uint256 _value, bytes calldata _data) external;
350     function transfer(address _to, uint256 _value) external returns (bool);
351     function decimals() external returns (uint8);
352 }
353 
354 
355 /**
356  * @title IOAEX ENTITY TOKEN
357  */
358 contract IOAEX is Token {
359     // The address of BDR contract
360     BDRContract public BDRInstance;
361     // The total amount of locked tokens at the specified address
362     mapping(address => uint256) public totalLockAmount;
363     // The released amount of the specified address
364     mapping(address => uint256) public releasedAmount;
365     // 
366     mapping(address => timeAndAmount[]) public allocations;
367     // Stores the timestamp and the amount of tokens released each time
368     struct timeAndAmount {
369         uint256 releaseTime;
370         uint256 releaseAmount;
371     }
372     
373     // events
374     event LockToken(address _beneficiary, uint256 totalLockAmount);
375     event ReleaseToken(address indexed user, uint256 releaseAmount, uint256 releaseTime);
376     event ExchangeBDR(address from, uint256 value);
377     event SetBDRContract(address BDRInstanceess);
378 
379     /**
380      * @dev Throws if called by any account other than the BDR contract
381      */
382     modifier onlyBDRContract() {
383         require(msg.sender == address(BDRInstance));
384         _;
385     }
386 
387     /**
388      * @dev Constructor, to initialize the basic information of token
389      */
390     constructor (string memory _name, string memory _symbol, uint8 _decimals, uint256 _INIT_TOTALSUPPLY) Token (_name, _symbol, _decimals, _INIT_TOTALSUPPLY) public {
391 
392     }
393 
394     /**
395      * @dev Sets the address of BDR contract
396      */
397     function setBDRContract(address BDRAddress) public onlyOwner {
398         require(BDRAddress != address(0));
399         BDRInstance = BDRContract(BDRAddress);
400         emit SetBDRContract(BDRAddress);
401     }
402     
403     /**
404      * @dev The owner can call this function to send tokens to the specified address, but these tokens are only available for more than the specified time
405      * @param _beneficiary The address to receive tokens
406      * @param _releaseTimes Array, the timestamp for releasing token
407      * @param _releaseAmount Array, the amount for releasing token 
408      */
409     function lockToken(address _beneficiary, uint256[] memory _releaseTimes, uint256[] memory _releaseAmount) public onlyOwner returns(bool) {
410         
411         require(totalLockAmount[_beneficiary] == 0); // The beneficiary is not in any lock-plans at the current timestamp.
412         require(_beneficiary != address(0)); // The beneficiary cannot be an empty address
413         require(_releaseTimes.length == _releaseAmount.length); // These two lists are equal in length.
414         releasedAmount[_beneficiary] = 0;
415         for (uint256 i = 0; i < _releaseTimes.length; i++) {
416             totalLockAmount[_beneficiary] = totalLockAmount[_beneficiary].add(_releaseAmount[i]);
417             require(_releaseAmount[i] > 0); // The amount to release is greater than 0.
418             require(_releaseTimes[i] >= now); // Each release time is not lower than the current timestamp.
419             // Saves the lock-token information
420             allocations[_beneficiary].push(timeAndAmount(_releaseTimes[i], _releaseAmount[i]));
421         }
422         balances[owner] = balances[owner].sub(totalLockAmount[_beneficiary]); // Removes this part of the locked token from the owner
423         emit LockToken(_beneficiary, totalLockAmount[_beneficiary]);
424         return true;
425     }
426 
427     /**
428      * Releases token
429      */
430     function releaseToken() public returns (bool) {
431         release(msg.sender); 
432     }
433 
434     /**
435      * @dev The basic function of releasing token
436      */
437     function release(address addr) internal {
438         require(totalLockAmount[addr] > 0); // The address has joined a lock-plan.
439 
440         uint256 amount = releasableAmount(addr); // Gets the amount of release and updates the lock-plans data
441         // Unlocks token. Converting locked tokens into normal tokens
442         balances[addr] = balances[addr].add(amount);
443         // Updates the amount of released tokens.
444         releasedAmount[addr] = releasedAmount[addr].add(amount);
445         // If the token on this address has been completely released, clears the Record of locking token
446         if (releasedAmount[addr] == totalLockAmount[addr]) {
447             delete allocations[addr];
448             totalLockAmount[addr] = 0;
449         }
450         emit ReleaseToken(addr, amount, now);
451     }
452 
453     /**
454      * @dev Gets the amount that can be released at current timestamps 
455      * @param addr A specified address.
456      */
457     function releasableAmount(address addr) public view returns (uint256) {
458         if(totalLockAmount[addr] == 0) {
459             return 0;
460         }
461         uint256 num = 0;
462         for (uint256 i = 0; i < allocations[addr].length; i++) {
463             if (now >= allocations[addr][i].releaseTime) { // Determines the releasable stage under the current timestamp.
464                 num = num.add(allocations[addr][i].releaseAmount);
465             }
466         }
467         return num.sub(releasedAmount[addr]); // the amount of current timestamps that can be released - the released amount.
468     }
469     
470     /**
471      * @dev Gets the amount of tokens that are still locked at current timestamp.
472      * @param addr A specified address.
473      */
474     function balanceOfLocked(address addr) public view returns(uint256) {
475         if (totalLockAmount[addr] > releasedAmount[addr]) {
476             return totalLockAmount[addr].sub(releasedAmount[addr]);
477         } else {
478             return 0;
479         }
480         
481     }
482 
483     /**
484      * @dev Transfers token to a specified address. 
485      *      If 'msg.sender' has releasable tokens, this part of the token will be released automatically.
486      *      If the target address of transferring is BDR contract, the operation of changing BDR tokens will be executed.
487      * @param to The target address of transfer, which may be the BDR contract
488      * @param value The amount of tokens transferred
489      */
490     function transfer(address to, uint value) public returns (bool) {
491         if(releasableAmount(msg.sender) > 0) {
492             release(msg.sender); // Calls 'release' function
493         }
494         super.transfer(to, value); // Transfers tokens to address 'to'
495         if(to == address(BDRInstance)) {
496             BDRInstance.tokenFallback(msg.sender, value, bytes("")); // Calls 'tokenFallback' function in BDR contract to exchange tokens
497             emit ExchangeBDR(msg.sender, value);
498         }
499         return true;
500     }
501 
502     /**
503      * @dev Transfers tokens from one address to another.
504      *      If 'from' has releasable tokens, this part of the token will be released automatically.
505      *      If the target address of transferring is  BDR contract, the operation of changing BDR tokens will be executed.
506      * @param from The address which you want to send tokens from
507      * @param to The address which you want to transfer to
508      * @param value The amount of tokens to be transferred
509      */
510     function transferFrom(address from, address to, uint value) public returns (bool) {
511         if(releasableAmount(from) > 0) {
512             release(from); // Calls the 'release' function
513         }
514         super.transferFrom(from, to, value); // Transfers token to address 'to'
515         if(to == address(BDRInstance)) {
516             BDRInstance.tokenFallback(from, value, bytes("")); // Calls 'tokenFallback' function in BDR contract to exchange tokens
517             emit ExchangeBDR(from, value);
518         }
519         return true;
520     }
521 
522     /**
523      * @dev Function that is called by the BDR contract to exchange 'Abc' tokens
524      */
525     function tokenFallback(address from, uint256 value, bytes calldata) external onlyBDRContract {
526         require(from != address(0));
527         require(value != uint256(0));
528         
529         uint256 AbcValue = value.mul(10**uint256(decimals)).div(10**uint256(BDRInstance.decimals())); // Calculates the number of 'Abc' tokens that can be exchanged
530         require(AbcValue <= balances[address(BDRInstance)]);
531         balances[address(BDRInstance)] = balances[address(BDRInstance)].sub(AbcValue);
532         balances[from] = balances[from].add(AbcValue);
533         emit Transfer(owner, from, AbcValue);
534     }
535     
536 }