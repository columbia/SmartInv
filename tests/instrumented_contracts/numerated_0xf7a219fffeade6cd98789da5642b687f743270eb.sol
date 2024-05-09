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
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor() public {
70         owner = msg.sender;
71         newOwner = address(0);
72     }
73 
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78     modifier onlyNewOwner() {
79         require(msg.sender != address(0));
80         require(msg.sender == newOwner);
81         _;
82     }
83     
84     function isOwner(address account) public view returns (bool) {
85         if( account == owner ){
86             return true;
87         }
88         else {
89             return false;
90         }
91     }
92 
93     function transferOwnership(address _newOwner) public onlyOwner {
94         require(_newOwner != address(0));
95         newOwner = _newOwner;
96     }
97 
98     function acceptOwnership() public onlyNewOwner returns(bool) {
99         emit OwnershipTransferred(owner, newOwner);        
100         owner = newOwner;
101         newOwner = address(0);
102     }
103 }
104 
105 contract Pausable is Ownable {
106     event Paused(address account);
107     event Unpaused(address account);
108 
109     bool private _paused;
110 
111     constructor () internal {
112         _paused = false;
113     }
114 
115     /**
116      * @return true if the contract is paused, false otherwise.
117      */
118     function paused() public view returns (bool) {
119         return _paused;
120     }
121 
122     /**
123      * @dev Modifier to make a function callable only when the contract is not paused.
124      */
125     modifier whenNotPaused() {
126         require(!_paused);
127         _;
128     }
129 
130     /**
131      * @dev Modifier to make a function callable only when the contract is paused.
132      */
133     modifier whenPaused() {
134         require(_paused);
135         _;
136     }
137 
138     /**
139      * @dev called by the owner to pause, triggers stopped state
140      */
141     function pause() public onlyOwner whenNotPaused {
142         _paused = true;
143         emit Paused(msg.sender);
144     }
145 
146     /**
147      * @dev called by the owner to unpause, returns to normal state
148      */
149     function unpause() public onlyOwner whenPaused {
150         _paused = false;
151         emit Unpaused(msg.sender);
152     }
153 }
154 
155 interface IERC20 {
156     function transfer(address to, uint256 value) external returns (bool);
157 
158     function approve(address spender, uint256 value) external returns (bool);
159 
160     function transferFrom(address from, address to, uint256 value) external returns (bool);
161 
162     function totalSupply() external view returns (uint256);
163 
164     function balanceOf(address who) external view returns (uint256);
165 
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 contract ERC20 is IERC20 {
174     using SafeMath for uint256;
175 
176     mapping (address => uint256) internal _balances;
177 
178     mapping (address => mapping (address => uint256)) internal _allowed;
179 
180     uint256 private _totalSupply;
181 
182     /**
183     * @dev Total number of tokens in existence
184     */
185     function totalSupply() public view returns (uint256) {
186         return _totalSupply;
187     }
188 
189     /**
190     * @dev Gets the balance of the specified address.
191     * @param owner The address to query the balance of.
192     * @return An uint256 representing the amount owned by the passed address.
193     */
194     function balanceOf(address owner) public view returns (uint256) {
195         return _balances[owner];
196     }
197 
198     /**
199      * @dev Function to check the amount of tokens that an owner allowed to a spender.
200      * @param owner address The address which owns the funds.
201      * @param spender address The address which will spend the funds.
202      * @return A uint256 specifying the amount of tokens still available for the spender.
203      */
204     function allowance(address owner, address spender) public view returns (uint256) {
205         return _allowed[owner][spender];
206     }
207 
208     /**
209     * @dev Transfer token for a specified address
210     * @param to The address to transfer to.
211     * @param value The amount to be transferred.
212     */
213     function transfer(address to, uint256 value) public returns (bool) {
214         _transfer(msg.sender, to, value);
215         return true;
216     }
217 
218     /**
219      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220      * Beware that changing an allowance with this method brings the risk that someone may use both the old
221      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224      * @param spender The address which will spend the funds.
225      * @param value The amount of tokens to be spent.
226      */
227     function approve(address spender, uint256 value) public returns (bool) {
228         require(spender != address(0));
229 
230         _allowed[msg.sender][spender] = value;
231         emit Approval(msg.sender, spender, value);
232         return true;
233     }
234 
235     /**
236      * @dev Transfer tokens from one address to another.
237      * Note that while this function emits an Approval event, this is not required as per the specification,
238      * and other compliant implementations may not emit the event.
239      * @param from address The address which you want to send tokens from
240      * @param to address The address which you want to transfer to
241      * @param value uint256 the amount of tokens to be transferred
242      */
243     function transferFrom(address from, address to, uint256 value) public returns (bool) {
244         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
245         _transfer(from, to, value);
246         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
247         return true;
248     }
249 
250     /**
251      * @dev Increase the amount of tokens that an owner allowed to a spender.
252      * approve should be called when allowed_[_spender] == 0. To increment
253      * allowed value is better to use this function to avoid 2 calls (and wait until
254      * the first transaction is mined)
255      * From MonolithDAO Token.sol
256      * Emits an Approval event.
257      * @param spender The address which will spend the funds.
258      * @param addedValue The amount of tokens to increase the allowance by.
259      */
260     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
261         require(spender != address(0));
262 
263         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
264         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
265         return true;
266     }
267 
268     /**
269      * @dev Decrease the amount of tokens that an owner allowed to a spender.
270      * approve should be called when allowed_[_spender] == 0. To decrement
271      * allowed value is better to use this function to avoid 2 calls (and wait until
272      * the first transaction is mined)
273      * From MonolithDAO Token.sol
274      * Emits an Approval event.
275      * @param spender The address which will spend the funds.
276      * @param subtractedValue The amount of tokens to decrease the allowance by.
277      */
278     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
279         require(spender != address(0));
280 
281         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
282         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
283         return true;
284     }
285 
286     /**
287     * @dev Transfer token for a specified addresses
288     * @param from The address to transfer from.
289     * @param to The address to transfer to.
290     * @param value The amount to be transferred.
291     */
292     function _transfer(address from, address to, uint256 value) internal {
293         require(to != address(0));
294 
295         _balances[from] = _balances[from].sub(value);
296         _balances[to] = _balances[to].add(value);
297         emit Transfer(from, to, value);
298     }
299 
300     /**
301      * @dev Internal function that mints an amount of the token and assigns it to
302      * an account. This encapsulates the modification of balances such that the
303      * proper events are emitted.
304      * @param account The account that will receive the created tokens.
305      * @param value The amount that will be created.
306      */
307     function _mint(address account, uint256 value) internal {
308         require(account != address(0));
309 
310         _totalSupply = _totalSupply.add(value);
311         _balances[account] = _balances[account].add(value);
312         emit Transfer(address(0), account, value);
313     }
314 
315     /**
316      * @dev Internal function that burns an amount of the token of a given
317      * account.
318      * @param account The account whose tokens will be burnt.
319      * @param value The amount that will be burnt.
320      */
321     function _burn(address account, uint256 value) internal {
322         require(account != address(0));
323 
324         _totalSupply = _totalSupply.sub(value);
325         _balances[account] = _balances[account].sub(value);
326         emit Transfer(account, address(0), value);
327     }
328 
329     /**
330      * @dev Internal function that burns an amount of the token of a given
331      * account, deducting from the sender's allowance for said account. Uses the
332      * internal burn function.
333      * Emits an Approval event (reflecting the reduced allowance).
334      * @param account The account whose tokens will be burnt.
335      * @param value The amount that will be burnt.
336      */
337     function _burnFrom(address account, uint256 value) internal {
338         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
339         _burn(account, value);
340         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
341     }
342 }
343 
344 contract ERC20Pausable is ERC20, Pausable {
345     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
346         return super.transfer(to, value);
347     }
348 
349     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
350         return super.transferFrom(from, to, value);
351     }
352     
353     /*
354      * approve/increaseApprove/decreaseApprove can be set when Paused state
355      */
356      
357     /*
358      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
359      *     return super.approve(spender, value);
360      * }
361      *
362      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
363      *     return super.increaseAllowance(spender, addedValue);
364      * }
365      *
366      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
367      *     return super.decreaseAllowance(spender, subtractedValue);
368      * }
369      */
370 }
371 
372 contract ERC20Detailed is IERC20 {
373     string private _name;
374     string private _symbol;
375     uint8 private _decimals;
376 
377     constructor (string memory name, string memory symbol, uint8 decimals) public {
378         _name = name;
379         _symbol = symbol;
380         _decimals = decimals;
381     }
382 
383     /**
384      * @return the name of the token.
385      */
386     function name() public view returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @return the symbol of the token.
392      */
393     function symbol() public view returns (string memory) {
394         return _symbol;
395     }
396 
397     /**
398      * @return the number of decimals of the token.
399      */
400     function decimals() public view returns (uint8) {
401         return _decimals;
402     }
403 }
404 
405 contract Rhea is ERC20Detailed, ERC20Pausable {
406     
407     struct LockInfo {
408         uint256 _releaseTime;
409         uint256 _amount;
410     }
411     
412     mapping (address => LockInfo[]) public timelockList;
413 	mapping (address => bool) public frozenAccount;
414     
415     event Freeze(address indexed holder);
416     event Unfreeze(address indexed holder);
417     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
418     event Unlock(address indexed holder, uint256 value);
419 
420     modifier notFrozen(address _holder) {
421         require(!frozenAccount[_holder]);
422         _;
423     }
424     
425     constructor() ERC20Detailed("Rhea Protocol", "RHEA",18) public  {
426         
427         _mint(msg.sender, 600000000 * (10 ** 18));
428     }
429     
430     function balanceOf(address owner) public view returns (uint256) {
431         
432         uint256 totalBalance = super.balanceOf(owner);
433         if( timelockList[owner].length >0 ){
434             for(uint i=0; i<timelockList[owner].length;i++){
435                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
436             }
437         }
438         
439         return totalBalance;
440     }
441     
442     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
443         if (timelockList[msg.sender].length > 0 ) {
444             _autoUnlock(msg.sender);            
445         }
446         return super.transfer(to, value);
447     }
448 
449     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
450         if (timelockList[from].length > 0) {
451             _autoUnlock(from);            
452         }
453         return super.transferFrom(from, to, value);
454     }
455     
456     function freezeAccount(address holder) public onlyOwner returns (bool) {
457         require(!frozenAccount[holder]);
458         frozenAccount[holder] = true;
459         emit Freeze(holder);
460         return true;
461     }
462 
463     function unfreezeAccount(address holder) public onlyOwner returns (bool) {
464         require(frozenAccount[holder]);
465         frozenAccount[holder] = false;
466         emit Unfreeze(holder);
467         return true;
468     }
469     
470     function lock(address holder, uint256 value, uint256 releaseTime) public onlyOwner returns (bool) {
471         require(_balances[holder] >= value,"There is not enough balances of holder.");
472         _lock(holder,value,releaseTime);
473         
474         
475         return true;
476     }
477     
478     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyOwner returns (bool) {
479         _transfer(msg.sender, holder, value);
480         _lock(holder,value,releaseTime);
481         return true;
482     }
483     
484     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
485         _balances[holder] = _balances[holder].sub(value);
486         timelockList[holder].push( LockInfo(releaseTime, value) );
487         
488         emit Lock(holder, value, releaseTime);
489         return true;
490     }
491     
492     function _unlock(address holder, uint256 idx) internal returns(bool) {
493         LockInfo storage lockinfo = timelockList[holder][idx];
494         uint256 releaseAmount = lockinfo._amount;
495 
496         delete timelockList[holder][idx];
497         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
498         timelockList[holder].length -=1;
499         
500         emit Unlock(holder, releaseAmount);
501         _balances[holder] = _balances[holder].add(releaseAmount);
502         
503         return true;
504     }
505     
506     function _autoUnlock(address holder) internal returns(bool) {
507         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
508             if (timelockList[holder][idx]._releaseTime <= now) {
509                 // If lockupinfo was deleted, loop restart at same position.
510                 if( _unlock(holder, idx) ) {
511                     idx -=1;
512                 }
513             }
514         }
515         return true;
516     }
517     
518 }