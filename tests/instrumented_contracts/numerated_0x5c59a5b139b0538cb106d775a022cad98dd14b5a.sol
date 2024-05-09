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
63 library Roles {
64     struct Role {
65         mapping (address => bool) bearer;
66     }
67 
68     /**
69      * @dev give an account access to this role
70      */
71     function add(Role storage role, address account) internal {
72         require(account != address(0));
73         require(!has(role, account));
74 
75         role.bearer[account] = true;
76     }
77 
78     /**
79      * @dev remove an account's access to this role
80      */
81     function remove(Role storage role, address account) internal {
82         require(account != address(0));
83         require(has(role, account));
84 
85         role.bearer[account] = false;
86     }
87 
88     /**
89      * @dev check if an account has this role
90      * @return bool
91      */
92     function has(Role storage role, address account) internal view returns (bool) {
93         require(account != address(0));
94         return role.bearer[account];
95     }
96 }
97 
98 contract Ownable {
99     address public owner;
100     address public newOwner;
101 
102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     constructor() public {
105         owner = msg.sender;
106         newOwner = address(0);
107     }
108 
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113 
114     modifier onlyNewOwner() {
115         require(msg.sender != address(0));
116         require(msg.sender == newOwner);
117         _;
118     }
119 
120     function isOwner(address account) public view returns (bool) {
121         if( account == owner ){
122             return true;
123         }
124         else {
125             return false;
126         }
127     }
128 
129     function transferOwnership(address _newOwner) public onlyOwner {
130         require(_newOwner != address(0));
131         newOwner = _newOwner;
132     }
133 
134     function acceptOwnership() public onlyNewOwner returns(bool) {
135         emit OwnershipTransferred(owner, newOwner);
136         owner = newOwner;
137         newOwner = address(0);
138     }
139 }
140 
141 contract PauserRole is Ownable {
142     using Roles for Roles.Role;
143 
144     event PauserAdded(address indexed account);
145     event PauserRemoved(address indexed account);
146 
147     Roles.Role private _pausers;
148 
149     constructor () internal {
150         _addPauser(msg.sender);
151     }
152 
153     modifier onlyPauser() {
154         require(isPauser(msg.sender)|| isOwner(msg.sender));
155         _;
156     }
157 
158     function isPauser(address account) public view returns (bool) {
159         return _pausers.has(account);
160     }
161 
162     function addPauser(address account) public onlyPauser {
163         _addPauser(account);
164     }
165 
166     function removePauser(address account) public onlyOwner {
167         _removePauser(account);
168     }
169 
170     function renouncePauser() public {
171         _removePauser(msg.sender);
172     }
173 
174     function _addPauser(address account) internal {
175         _pausers.add(account);
176         emit PauserAdded(account);
177     }
178 
179     function _removePauser(address account) internal {
180         _pausers.remove(account);
181         emit PauserRemoved(account);
182     }
183 }
184 
185 interface IERC20 {
186     function transfer(address to, uint256 value) external returns (bool);
187 
188     function approve(address spender, uint256 value) external returns (bool);
189 
190     function transferFrom(address from, address to, uint256 value) external returns (bool);
191 
192     function totalSupply() external view returns (uint256);
193 
194     function balanceOf(address who) external view returns (uint256);
195 
196     function allowance(address owner, address spender) external view returns (uint256);
197 
198     event Transfer(address indexed from, address indexed to, uint256 value);
199 
200     event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 contract ERC20 is IERC20 {
204     using SafeMath for uint256;
205 
206     mapping (address => uint256) internal _balances;
207 
208     mapping (address => mapping (address => uint256)) internal _allowed;
209 
210     uint256 private _totalSupply;
211 
212     /**
213     * @dev Total number of tokens in existence
214     */
215     function totalSupply() public view returns (uint256) {
216         return _totalSupply;
217     }
218 
219     /**
220     * @dev Gets the balance of the specified address.
221     * @param owner The address to query the balance of.
222     * @return An uint256 representing the amount owned by the passed address.
223     */
224     function balanceOf(address owner) public view returns (uint256) {
225         return _balances[owner];
226     }
227 
228     /**
229      * @dev Function to check the amount of tokens that an owner allowed to a spender.
230      * @param owner address The address which owns the funds.
231      * @param spender address The address which will spend the funds.
232      * @return A uint256 specifying the amount of tokens still available for the spender.
233      */
234     function allowance(address owner, address spender) public view returns (uint256) {
235         return _allowed[owner][spender];
236     }
237 
238     /**
239     * @dev Transfer token for a specified address
240     * @param to The address to transfer to.
241     * @param value The amount to be transferred.
242     */
243     function transfer(address to, uint256 value) public returns (bool) {
244         _transfer(msg.sender, to, value);
245         return true;
246     }
247 
248     /**
249      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250      * Beware that changing an allowance with this method brings the risk that someone may use both the old
251      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254      * @param spender The address which will spend the funds.
255      * @param value The amount of tokens to be spent.
256      */
257     function approve(address spender, uint256 value) public returns (bool) {
258         require(spender != address(0));
259 
260         _allowed[msg.sender][spender] = value;
261         emit Approval(msg.sender, spender, value);
262         return true;
263     }
264 
265     /**
266      * @dev Transfer tokens from one address to another.
267      * Note that while this function emits an Approval event, this is not required as per the specification,
268      * and other compliant implementations may not emit the event.
269      * @param from address The address which you want to send tokens from
270      * @param to address The address which you want to transfer to
271      * @param value uint256 the amount of tokens to be transferred
272      */
273     function transferFrom(address from, address to, uint256 value) public returns (bool) {
274         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
275         _transfer(from, to, value);
276         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
277         return true;
278     }
279 
280     /**
281      * @dev Increase the amount of tokens that an owner allowed to a spender.
282      * approve should be called when allowed_[_spender] == 0. To increment
283      * allowed value is better to use this function to avoid 2 calls (and wait until
284      * the first transaction is mined)
285      * From MonolithDAO Token.sol
286      * Emits an Approval event.
287      * @param spender The address which will spend the funds.
288      * @param addedValue The amount of tokens to increase the allowance by.
289      */
290     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
291         require(spender != address(0));
292 
293         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
294         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
295         return true;
296     }
297 
298     /**
299      * @dev Decrease the amount of tokens that an owner allowed to a spender.
300      * approve should be called when allowed_[_spender] == 0. To decrement
301      * allowed value is better to use this function to avoid 2 calls (and wait until
302      * the first transaction is mined)
303      * From MonolithDAO Token.sol
304      * Emits an Approval event.
305      * @param spender The address which will spend the funds.
306      * @param subtractedValue The amount of tokens to decrease the allowance by.
307      */
308     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
309         require(spender != address(0));
310 
311         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
312         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
313         return true;
314     }
315 
316     /**
317     * @dev Transfer token for a specified addresses
318     * @param from The address to transfer from.
319     * @param to The address to transfer to.
320     * @param value The amount to be transferred.
321     */
322     function _transfer(address from, address to, uint256 value) internal {
323         require(to != address(0));
324 
325         _balances[from] = _balances[from].sub(value);
326         _balances[to] = _balances[to].add(value);
327         emit Transfer(from, to, value);
328     }
329 
330     /**
331      * @dev Internal function that mints an amount of the token and assigns it to
332      * an account. This encapsulates the modification of balances such that the
333      * proper events are emitted.
334      * @param account The account that will receive the created tokens.
335      * @param value The amount that will be created.
336      */
337     function _mint(address account, uint256 value) internal {
338         require(account != address(0));
339 
340         _totalSupply = _totalSupply.add(value);
341         _balances[account] = _balances[account].add(value);
342         emit Transfer(address(0), account, value);
343     }
344 }
345 
346 contract ERC20Detailed is ERC20 {
347     string private _name;
348     string private _symbol;
349     uint8 private _decimals;
350 
351     constructor (string memory name, string memory symbol, uint8 decimals) public {
352         _name = name;
353         _symbol = symbol;
354         _decimals = decimals;
355     }
356 
357     /**
358      * @return the name of the token.
359      */
360     function name() public view returns (string memory) {
361         return _name;
362     }
363 
364     /**
365      * @return the symbol of the token.
366      */
367     function symbol() public view returns (string memory) {
368         return _symbol;
369     }
370 
371     /**
372      * @return the number of decimals of the token.
373      */
374     function decimals() public view returns (uint8) {
375         return _decimals;
376     }
377 }
378 
379 contract ORT is ERC20Detailed, PauserRole {
380 
381     struct LockInfo {
382         uint256 _releaseTime;
383         uint256 _amount;
384     }
385 
386     mapping (address => LockInfo[]) public timelockList;
387 
388     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
389     event Unlock(address indexed holder, uint256 value);
390 
391     constructor() ERC20Detailed("XREATORS", "ORT", 18) public  {
392         _mint(msg.sender, 500000000 * (10 ** 18));
393     }
394 
395     function balanceOf(address owner) public view returns (uint256) {
396         uint256 totalBalance = super.balanceOf(owner);
397         if( timelockList[owner].length >0 ){
398             for(uint i=0; i<timelockList[owner].length;i++){
399                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
400             }
401         }
402 
403         return totalBalance;
404     }
405 
406     function transfer(address to, uint256 value) public returns (bool) {
407         if (timelockList[msg.sender].length > 0 ) {
408             _autoUnlock(msg.sender);
409         }
410         return super.transfer(to, value);
411     }
412 
413     function transferFrom(address from, address to, uint256 value) public returns (bool) {
414         if (timelockList[from].length > 0) {
415             _autoUnlock(from);
416         }
417         return super.transferFrom(from, to, value);
418     }
419 
420     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
421         _transfer(msg.sender, holder, value);
422         _lock(holder,value,releaseTime);
423         return true;
424     }
425 
426     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
427         require( timelockList[holder].length > idx, "There is not lock info.");
428         _unlock(holder,idx);
429         return true;
430     }
431 
432     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
433         _balances[holder] = _balances[holder].sub(value);
434         timelockList[holder].push( LockInfo(releaseTime, value) );
435 
436         emit Lock(holder, value, releaseTime);
437         return true;
438     }
439 
440     function _unlock(address holder, uint256 idx) internal returns(bool) {
441         LockInfo storage lockinfo = timelockList[holder][idx];
442         uint256 releaseAmount = lockinfo._amount;
443 
444         delete timelockList[holder][idx];
445         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
446         timelockList[holder].length -=1;
447 
448         emit Unlock(holder, releaseAmount);
449         _balances[holder] = _balances[holder].add(releaseAmount);
450 
451         return true;
452     }
453 
454     function _autoUnlock(address holder) internal returns(bool) {
455         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
456             if (timelockList[holder][idx]._releaseTime <= now) {
457                 // If lockupinfo was deleted, loop restart at same position.
458                 if( _unlock(holder, idx) ) {
459                     idx -=1;
460                 }
461             }
462         }
463         return true;
464     }
465 }