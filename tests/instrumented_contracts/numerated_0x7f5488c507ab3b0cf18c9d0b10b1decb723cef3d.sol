1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract Ownable {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor () internal {
72         address msgSender = msg.sender;
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     /**
78      * @dev Returns the address of the current owner.
79      */
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(_owner == msg.sender, "Ownable: caller is not the owner");
89         _;
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public onlyOwner {
100         emit OwnershipTransferred(_owner, address(0));
101         _owner = address(0);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Can only be called by the current owner.
107      */
108     function transferOwnership(address newOwner) public onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113 }
114 
115 contract Pausable is Ownable {
116     event Paused(address account);
117     event Unpaused(address account);
118 
119     bool private _paused;
120 
121     constructor () internal {
122         _paused = false;
123     }
124 
125     /**
126      * @return true if the contract is paused, false otherwise.
127      */
128     function paused() public view returns (bool) {
129         return _paused;
130     }
131 
132     /**
133      * @dev Modifier to make a function callable only when the contract is not paused.
134      */
135     modifier whenNotPaused() {
136         require(!_paused);
137         _;
138     }
139 
140     /**
141      * @dev Modifier to make a function callable only when the contract is paused.
142      */
143     modifier whenPaused() {
144         require(_paused);
145         _;
146     }
147 
148     /**
149      * @dev called by the owner to pause, triggers stopped state
150      */
151     function pause() public onlyOwner whenNotPaused {
152         _paused = true;
153         emit Paused(msg.sender);
154     }
155 
156     /**
157      * @dev called by the owner to unpause, returns to normal state
158      */
159     function unpause() public onlyOwner whenPaused {
160         _paused = false;
161         emit Unpaused(msg.sender);
162     }
163 }
164 
165 interface IERC20 {
166     function transfer(address to, uint256 value) external returns (bool);
167 
168     function approve(address spender, uint256 value) external returns (bool);
169 
170     function transferFrom(address from, address to, uint256 value) external returns (bool);
171 
172     function totalSupply() external view returns (uint256);
173 
174     function balanceOf(address who) external view returns (uint256);
175 
176     function allowance(address owner, address spender) external view returns (uint256);
177 
178     event Transfer(address indexed from, address indexed to, uint256 value);
179 
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 contract ERC20 is IERC20 {
184     using SafeMath for uint256;
185 
186     mapping (address => uint256) internal _balances;
187 
188     mapping (address => mapping (address => uint256)) internal _allowed;
189 
190     uint256 private _totalSupply;
191 
192     /**
193     * @dev Total number of tokens in existence
194     */
195     function totalSupply() public view returns (uint256) {
196         return _totalSupply;
197     }
198 
199     /**
200     * @dev Gets the balance of the specified address.
201     * @param owner The address to query the balance of.
202     * @return An uint256 representing the amount owned by the passed address.
203     */
204     function balanceOf(address owner) public view returns (uint256) {
205         return _balances[owner];
206     }
207 
208     /**
209      * @dev Function to check the amount of tokens that an owner allowed to a spender.
210      * @param owner address The address which owns the funds.
211      * @param spender address The address which will spend the funds.
212      * @return A uint256 specifying the amount of tokens still available for the spender.
213      */
214     function allowance(address owner, address spender) public view returns (uint256) {
215         return _allowed[owner][spender];
216     }
217 
218     /**
219     * @dev Transfer token for a specified address
220     * @param to The address to transfer to.
221     * @param value The amount to be transferred.
222     */
223     function transfer(address to, uint256 value) public returns (bool) {
224         _transfer(msg.sender, to, value);
225         return true;
226     }
227 
228     /**
229      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230      * Beware that changing an allowance with this method brings the risk that someone may use both the old
231      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234      * @param spender The address which will spend the funds.
235      * @param value The amount of tokens to be spent.
236      */
237     function approve(address spender, uint256 value) public returns (bool) {
238         require(spender != address(0));
239 
240         _allowed[msg.sender][spender] = value;
241         emit Approval(msg.sender, spender, value);
242         return true;
243     }
244 
245     /**
246      * @dev Transfer tokens from one address to another.
247      * Note that while this function emits an Approval event, this is not required as per the specification,
248      * and other compliant implementations may not emit the event.
249      * @param from address The address which you want to send tokens from
250      * @param to address The address which you want to transfer to
251      * @param value uint256 the amount of tokens to be transferred
252      */
253     function transferFrom(address from, address to, uint256 value) public returns (bool) {
254         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
255         _transfer(from, to, value);
256         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
257         return true;
258     }
259 
260     /**
261      * @dev Increase the amount of tokens that an owner allowed to a spender.
262      * approve should be called when allowed_[_spender] == 0. To increment
263      * allowed value is better to use this function to avoid 2 calls (and wait until
264      * the first transaction is mined)
265      * From MonolithDAO Token.sol
266      * Emits an Approval event.
267      * @param spender The address which will spend the funds.
268      * @param addedValue The amount of tokens to increase the allowance by.
269      */
270     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
271         require(spender != address(0));
272 
273         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
274         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
275         return true;
276     }
277 
278     /**
279      * @dev Decrease the amount of tokens that an owner allowed to a spender.
280      * approve should be called when allowed_[_spender] == 0. To decrement
281      * allowed value is better to use this function to avoid 2 calls (and wait until
282      * the first transaction is mined)
283      * From MonolithDAO Token.sol
284      * Emits an Approval event.
285      * @param spender The address which will spend the funds.
286      * @param subtractedValue The amount of tokens to decrease the allowance by.
287      */
288     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
289         require(spender != address(0));
290 
291         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
292         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
293         return true;
294     }
295 
296     /**
297     * @dev Transfer token for a specified addresses
298     * @param from The address to transfer from.
299     * @param to The address to transfer to.
300     * @param value The amount to be transferred.
301     */
302     function _transfer(address from, address to, uint256 value) internal {
303         require(to != address(0));
304 
305         _balances[from] = _balances[from].sub(value);
306         _balances[to] = _balances[to].add(value);
307         emit Transfer(from, to, value);
308     }
309 
310     /**
311      * @dev Internal function that mints an amount of the token and assigns it to
312      * an account. This encapsulates the modification of balances such that the
313      * proper events are emitted.
314      * @param account The account that will receive the created tokens.
315      * @param value The amount that will be created.
316      */
317     function _mint(address account, uint256 value) internal {
318         require(account != address(0));
319 
320         _totalSupply = _totalSupply.add(value);
321         _balances[account] = _balances[account].add(value);
322         emit Transfer(address(0), account, value);
323     }
324 
325     /**
326      * @dev Internal function that burns an amount of the token of a given
327      * account.
328      * @param account The account whose tokens will be burnt.
329      * @param value The amount that will be burnt.
330      */
331     function _burn(address account, uint256 value) internal {
332         require(account != address(0));
333 
334         _totalSupply = _totalSupply.sub(value);
335         _balances[account] = _balances[account].sub(value);
336         emit Transfer(account, address(0), value);
337     }
338 
339     /**
340      * @dev Internal function that burns an amount of the token of a given
341      * account, deducting from the sender's allowance for said account. Uses the
342      * internal burn function.
343      * Emits an Approval event (reflecting the reduced allowance).
344      * @param account The account whose tokens will be burnt.
345      * @param value The amount that will be burnt.
346      */
347     function _burnFrom(address account, uint256 value) internal {
348         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
349         _burn(account, value);
350         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
351     }
352 }
353 
354 contract ERC20Pausable is ERC20, Pausable {
355     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
356         return super.transfer(to, value);
357     }
358 
359     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
360         return super.transferFrom(from, to, value);
361     }
362     
363     /*
364      * approve/increaseApprove/decreaseApprove can be set when Paused state
365      */
366      
367     /*
368      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
369      *     return super.approve(spender, value);
370      * }
371      *
372      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
373      *     return super.increaseAllowance(spender, addedValue);
374      * }
375      *
376      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
377      *     return super.decreaseAllowance(spender, subtractedValue);
378      * }
379      */
380 }
381 
382 contract ERC20Detailed is IERC20 {
383     string private _name;
384     string private _symbol;
385     uint8 private _decimals;
386 
387     constructor (string memory name, string memory symbol, uint8 decimals) public {
388         _name = name;
389         _symbol = symbol;
390         _decimals = decimals;
391     }
392 
393     /**
394      * @return the name of the token.
395      */
396     function name() public view returns (string memory) {
397         return _name;
398     }
399 
400     /**
401      * @return the symbol of the token.
402      */
403     function symbol() public view returns (string memory) {
404         return _symbol;
405     }
406 
407     /**
408      * @return the number of decimals of the token.
409      */
410     function decimals() public view returns (uint8) {
411         return _decimals;
412     }
413 }
414 
415 contract KStarCoin is ERC20Detailed, ERC20Pausable {
416 
417     struct LockInfo {
418         uint256 _releaseTime;
419         uint256 _amount;
420     }
421     
422     mapping (address => LockInfo[]) public timelockList;
423 	mapping (address => bool) public frozenAccount;
424     
425     event Freeze(address indexed holder);
426     event Unfreeze(address indexed holder);
427     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
428     event Unlock(address indexed holder, uint256 value);
429 
430     modifier notFrozen(address _holder) {
431         require(!frozenAccount[_holder]);
432         _;
433     }
434     
435     constructor() ERC20Detailed("KStarCoin", "KSC", 18) public {
436         _mint(msg.sender, 1000000000 * (10 ** 18));
437     }
438     
439     function balanceOf(address owner) public view returns (uint256) {
440         uint256 totalBalance = super.balanceOf(owner);
441         if( timelockList[owner].length >0 ){
442             for(uint i=0; i<timelockList[owner].length;i++){
443                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
444             }
445         }
446         
447         return totalBalance;
448     }
449     
450     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
451         if (timelockList[msg.sender].length > 0 ) {
452             _autoUnlock(msg.sender);            
453         }
454         return super.transfer(to, value);
455     }
456 
457     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
458         if (timelockList[from].length > 0) {
459             _autoUnlock(from);            
460         }
461         return super.transferFrom(from, to, value);
462     }
463     
464     function freezeAccount(address holder) public onlyOwner returns (bool) {
465         require(!frozenAccount[holder]);
466         frozenAccount[holder] = true;
467         emit Freeze(holder);
468         return true;
469     }
470 
471     function unfreezeAccount(address holder) public onlyOwner returns (bool) {
472         require(frozenAccount[holder]);
473         frozenAccount[holder] = false;
474         emit Unfreeze(holder);
475         return true;
476     }
477     
478     function lock(address holder, uint256 value, uint256 releaseTime) public onlyOwner returns (bool) {
479         require(_balances[holder] >= value,"There is not enough balances of holder.");
480         _lock(holder,value,releaseTime);        
481         
482         return true;
483     }
484     
485     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyOwner returns (bool) {
486         _transfer(msg.sender, holder, value);
487         _lock(holder,value,releaseTime);
488         return true;
489     }
490     
491     function unlock(address holder, uint256 idx) public onlyOwner returns (bool) {
492         require( timelockList[holder].length > idx, "There is not lock info.");
493         _unlock(holder,idx);
494         return true;
495     }
496     
497     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
498         _balances[holder] = _balances[holder].sub(value);
499         timelockList[holder].push( LockInfo(releaseTime, value) );
500         
501         emit Lock(holder, value, releaseTime);
502         return true;
503     }
504     
505     function _unlock(address holder, uint256 idx) internal returns(bool) {
506         LockInfo storage lockinfo = timelockList[holder][idx];
507         uint256 releaseAmount = lockinfo._amount;
508 
509         delete timelockList[holder][idx];
510         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
511         timelockList[holder].length -=1;
512         
513         emit Unlock(holder, releaseAmount);
514         _balances[holder] = _balances[holder].add(releaseAmount);
515         
516         return true;
517     }
518     
519     function _autoUnlock(address holder) internal returns(bool) {
520         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
521             if (timelockList[holder][idx]._releaseTime <= now) {
522                 // If lockupinfo was deleted, loop restart at same position.
523                 if( _unlock(holder, idx) ) {
524                     idx -=1;
525                 }
526             }
527         }
528         return true;
529     }    
530 }