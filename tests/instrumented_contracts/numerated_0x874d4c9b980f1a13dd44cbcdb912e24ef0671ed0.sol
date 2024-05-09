1 pragma solidity ^0.5.2;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error.
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80      * account.
81      */
82     constructor () internal {
83         _owner = msg.sender;
84         emit OwnershipTransferred(address(0), _owner);
85     }
86 
87     /**
88      * @return the address of the owner.
89      */
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * @dev Throws if called by any account other than the owner.
96      */
97     modifier onlyOwner() {
98         require(isOwner());
99         _;
100     }
101 
102     /**
103      * @return true if `msg.sender` is the owner of the contract.
104      */
105     function isOwner() public view returns (bool) {
106         return msg.sender == _owner;
107     }
108 
109     /**
110      * @dev Allows the current owner to relinquish control of the contract.
111      * @notice Renouncing to ownership will leave the contract without an owner.
112      * It will not be possible to call the functions with the `onlyOwner`
113      * modifier anymore.
114      */
115     function renounceOwnership() public onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     /**
121      * @dev Allows the current owner to transfer control of the contract to a newOwner.
122      * @param newOwner The address to transfer ownership to.
123      */
124     function transferOwnership(address newOwner) public onlyOwner {
125         _transferOwnership(newOwner);
126     }
127 
128     /**
129      * @dev Transfers control of the contract to a newOwner.
130      * @param newOwner The address to transfer ownership to.
131      */
132     function _transferOwnership(address newOwner) internal {
133         require(newOwner != address(0));
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 interface IERC20 {
144     function totalSupply() external view returns (uint256);
145 
146     function balanceOf(address who) external view returns (uint256);
147 
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     function transfer(address to, uint256 value) external returns (bool);
151 
152     function approve(address spender, uint256 value) external returns (bool);
153 
154     function transferFrom(address from, address to, uint256 value) external returns (bool);
155 
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 /**
162  * @title Helps contracts guard against reentrancy attacks.
163  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
164  * @dev If you mark a function `nonReentrant`, you should also
165  * mark it `external`.
166  */
167 contract ReentrancyGuard {
168     /// @dev counter to allow mutex lock with only one SSTORE operation
169     uint256 private _guardCounter;
170 
171     constructor () internal {
172         // The counter starts at one to prevent changing it from zero to a non-zero
173         // value, which is a more expensive operation.
174         _guardCounter = 1;
175     }
176 
177     /**
178      * @dev Prevents a contract from calling itself, directly or indirectly.
179      * Calling a `nonReentrant` function from another `nonReentrant`
180      * function is not supported. It is possible to prevent this from happening
181      * by making the `nonReentrant` function external, and make it call a
182      * `private` function that does the actual work.
183      */
184     modifier nonReentrant() {
185         _guardCounter += 1;
186         uint256 localCounter = _guardCounter;
187         _;
188         require(localCounter == _guardCounter);
189     }
190 }
191 
192 /**
193  * @title Pausable
194  * @dev Base contract which allows children to implement an emergency stop mechanism.
195  */
196 contract Pausable is Ownable {
197     event Paused(address account);
198     event Unpaused(address account);
199 
200     bool private _paused;
201 
202     constructor () internal {
203         _paused = false;
204     }
205 
206     /**
207      * @return True if the contract is paused, false otherwise.
208      */
209     function paused() public view returns (bool) {
210         return _paused;
211     }
212 
213     /**
214      * @dev Modifier to make a function callable only when the contract is not paused.
215      */
216     modifier whenNotPaused() {
217         require(!_paused);
218         _;
219     }
220 
221     /**
222      * @dev Modifier to make a function callable only when the contract is paused.
223      */
224     modifier whenPaused() {
225         require(_paused);
226         _;
227     }
228 
229     /**
230      * @dev Called by a pauser to pause, triggers stopped state.
231      */
232     function pause() public onlyOwner whenNotPaused {
233         _paused = true;
234         emit Paused(msg.sender);
235     }
236 
237     /**
238      * @dev Called by a pauser to unpause, returns to normal state.
239      */
240     function unpause() public onlyOwner whenPaused {
241         _paused = false;
242         emit Unpaused(msg.sender);
243     }
244 }
245 
246 /**
247  * @title GuiderToken
248  * @dev ERC20 Token 
249  */
250 contract GuiderToken is IERC20, Ownable, ReentrancyGuard, Pausable  {
251    using SafeMath for uint256;
252    
253     mapping (address => uint256) private _balances;
254 
255     mapping (address => mapping (address => uint256)) private _allowed;
256 
257     uint256 private _totalSupply;
258     
259     string private _name = "Guider";
260     string private _symbol = "GDR";
261     uint8 private _decimals = 18;
262     uint256 private _initSupplyIPON = 300000000;
263     uint256 private _initSupply = _initSupplyIPON.mul(10 **uint256(_decimals));
264     
265     /**
266      * @dev Constructor that gives msg.sender initialSupply of existing tokens.
267      */
268     constructor () public GuiderToken(
269     ) {
270         _mint(msg.sender, initSupply());
271     }
272     
273      /**
274      * @return the name of the token.
275      */
276     function name() public view returns (string memory) {
277         return _name;
278     }
279 
280     /**
281      * @return the symbol of the token.
282      */
283     function symbol() public view returns (string memory) {
284         return _symbol;
285     }
286 
287     /**
288      * @return the number of decimals of the token.
289      */
290     function decimals() public view returns (uint8) {
291         return _decimals;
292     }
293     
294     /**
295      * @return the initial Supply of the token.
296      */
297     function initSupply() public view returns (uint256) {
298         return _initSupply;
299     }
300    
301     /**
302     * @dev Total number of tokens in existence
303     */
304     function totalSupply() public view returns (uint256) {
305         return _totalSupply;
306     }
307 
308     /**
309     * @dev Gets the balance of the specified address.
310     * @param owner The address to query the balance of.
311     * @return An uint256 representing the amount owned by the passed address.
312     */
313     function balanceOf(address owner) public view returns (uint256) {
314         return _balances[owner];
315     }
316     
317     /**
318      * @dev Function to check the amount of tokens that an owner allowed to a spender.
319      * @param owner address The address which owns the funds.
320      * @param spender address The address which will spend the funds.
321      * @return A uint256 specifying the amount of tokens still available for the spender.
322      */
323     function allowance(address owner, address spender) public view returns (uint256) {
324         return _allowed[owner][spender];
325     }
326 
327     /**
328      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
329      * Beware that changing an allowance with this method brings the risk that someone may use both the old
330      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333      * @param spender The address which will spend the funds.
334      * @param value The amount of tokens to be spent.
335      */
336     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
337         require(spender != address(0));
338         _allowed[msg.sender][spender] = value;
339         emit Approval(msg.sender, spender, value);
340         return true;
341     }
342 
343     /**
344      * @dev Increase the amount of tokens that an owner allowed to a spender.
345      * approve should be called when allowed_[_spender] == 0. To increment
346      * allowed value is better to use this function to avoid 2 calls (and wait until
347      * the first transaction is mined)
348      * From MonolithDAO Token.sol
349      * Emits an Approval event.
350      * @param spender The address which will spend the funds.
351      * @param addedValue The amount of tokens to increase the allowance by.
352      */
353     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
354         require(spender != address(0));
355         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
356         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
357         return true;
358     }
359 
360     /**
361      * @dev Decrease the amount of tokens that an owner allowed to a spender.
362      * approve should be called when allowed_[_spender] == 0. To decrement
363      * allowed value is better to use this function to avoid 2 calls (and wait until
364      * the first transaction is mined)
365      * From MonolithDAO Token.sol
366      * Emits an Approval event.
367      * @param spender The address which will spend the funds.
368      * @param subtractedValue The amount of tokens to decrease the allowance by.
369      */
370     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
371         require(spender != address(0));
372         
373         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
374         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
375         return true;
376     }
377 
378     /**
379     * @dev Transfer token for a specified addresses
380     * @param from The address to transfer from.
381     * @param to The address to transfer to.
382     * @param value The amount to be transferred.
383     */
384     function _transfer(address from, address to, uint256 value) internal {
385         require(to != address(0));
386 
387         _balances[from] = _balances[from].sub(value);
388         _balances[to] = _balances[to].add(value);
389         emit Transfer(from, to, value);
390     }
391 
392     /**
393      * @dev Internal function that mints an amount of the token and assigns it to
394      * an account. This encapsulates the modification of balances such that the
395      * proper events are emitted.
396      * @param account The account that will receive the created tokens.
397      * @param value The amount that will be created.
398      */
399     function _mint(address account, uint256 value) internal {
400         require(account != address(0));
401 
402         _totalSupply = _totalSupply.add(value);
403         _balances[account] = _balances[account].add(value);
404         emit Transfer(address(0), account, value);
405     }
406 
407     /**
408      * @dev Internal function that burns an amount of the token of a given
409      * account.
410      * @param account The account whose tokens will be burnt.
411      * @param value The amount that will be burnt.
412      */
413     function _burn(address account, uint256 value) internal {
414         require(account != address(0));
415         _totalSupply = _totalSupply.sub(value);
416         _balances[account] = _balances[account].sub(value);
417         emit Transfer(account, address(0), value);
418     }
419 
420    /**
421      * @dev Function to burn tokens
422      * @param to The address to burn tokens.
423      * @param value The amount of tokens to burn.
424      * @return A boolean that indicates if the operation was successful.
425      */
426     function burn(address to, uint256 value) public onlyOwner returns (bool) {
427         _burn(to, value);
428         return true;
429     }
430     
431     /**
432     * @dev Transfer token for a specified address.onlyOwner
433     * @param to The address to transfer to.
434     * @param value The amount to be transferred.
435     */
436     function OwnerTransfer(address to, uint256 value) public onlyOwner returns (bool) {
437       
438         _transfer(msg.sender, to, value);
439         return true;
440     }
441     
442     /**
443     * @dev Transfer token for a specified address
444     * @param to The address to transfer to.
445     * @param value The amount to be transferred.
446     */
447     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
448       
449         _transfer(msg.sender, to, value);
450         return true;
451     }
452     
453     /**
454      * @dev Transfer tokens from one address to another.
455      * Note that while this function emits an Approval event, this is not required as per the specification,
456      * and other compliant implementations may not emit the event.
457      * @param from address The address which you want to send tokens from
458      * @param to address The address which you want to transfer to
459      * @param value uint256 the amount of tokens to be transferred
460      */
461     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
462       
463         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
464         _transfer(from, to, value);
465         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
466         return true;
467     }
468 }