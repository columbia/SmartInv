1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract PauserRole {
22     using Roles for Roles.Role;
23     event PauserAdded(address indexed account);
24     event PauserRemoved(address indexed account);
25 
26     Roles.Role private _pausers;
27 
28     constructor () internal {
29         _addPauser(msg.sender);
30     }
31 
32     modifier onlyPauser() {
33         require(isPauser(msg.sender));
34         _;
35     }
36 
37     function isPauser(address account) public view returns (bool) {
38         return _pausers.has(account);
39     }
40 
41     function addPauser(address account) public onlyPauser {
42         _addPauser(account);
43     }
44 
45     function renouncePauser() public {
46         _removePauser(msg.sender);
47     }
48 
49     function _addPauser(address account) internal {
50         _pausers.add(account);
51         emit PauserAdded(account);
52     }
53 
54     function _removePauser(address account) internal {
55         _pausers.remove(account);
56         emit PauserRemoved(account);
57     }
58 }
59 
60 contract Pausable is PauserRole {
61     event Paused(address account);
62     event Unpaused(address account);
63 
64     bool private _paused;
65 
66     constructor () internal {
67         _paused = false;
68     }
69 
70     /**
71      * @return true if the contract is paused, false otherwise.
72      */
73     function paused() public view returns (bool) {
74         return _paused;
75     }
76 
77     /**
78      * @dev Modifier to make a function callable only when the contract is not paused.
79      */
80     modifier whenNotPaused() {
81         require(!_paused);
82         _;
83     }
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is paused.
87      */
88     modifier whenPaused() {
89         require(_paused);
90         _;
91     }
92 
93     /**
94      * @dev called by the owner to pause, triggers stopped state
95      */
96     function pause() public onlyPauser whenNotPaused {
97         _paused = true;
98         emit Paused(msg.sender);
99     }
100 
101     /**
102      * @dev called by the owner to unpause, returns to normal state
103      */
104     function unpause() public onlyPauser whenPaused {
105         _paused = false;
106         emit Unpaused(msg.sender);
107     }
108 }
109 contract ERC20 is IERC20 {
110     using SafeMath for uint256;
111 
112     mapping (address => uint256) private _balances;
113 
114     mapping (address => mapping (address => uint256)) private _allowed;
115 
116     uint256 private _totalSupply;
117 
118     /**
119      * @dev Total number of tokens in existence
120      */
121     function totalSupply() public view returns (uint256) {
122         return _totalSupply;
123     }
124 
125     /**
126      * @dev Gets the balance of the specified address.
127      * @param owner The address to query the balance of.
128      * @return A uint256 representing the amount owned by the passed address.
129      */
130     function balanceOf(address owner) public view returns (uint256) {
131         return _balances[owner];
132     }
133 
134     /**
135      * @dev Function to check the amount of tokens that an owner allowed to a spender.
136      * @param owner address The address which owns the funds.
137      * @param spender address The address which will spend the funds.
138      * @return A uint256 specifying the amount of tokens still available for the spender.
139      */
140     function allowance(address owner, address spender) public view returns (uint256) {
141         return _allowed[owner][spender];
142     }
143 
144     /**
145      * @dev Transfer token to a specified address
146      * @param to The address to transfer to.
147      * @param value The amount to be transferred.
148      */
149     function transfer(address to, uint256 value) public returns (bool) {
150         _transfer(msg.sender, to, value);
151         return true;
152     }
153 
154     /**
155      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156      * Beware that changing an allowance with this method brings the risk that someone may use both the old
157      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      * @param spender The address which will spend the funds.
161      * @param value The amount of tokens to be spent.
162      */
163     function approve(address spender, uint256 value) public returns (bool) {
164         _approve(msg.sender, spender, value);
165         return true;
166     }
167 
168     /**
169      * @dev Transfer tokens from one address to another.
170      * Note that while this function emits an Approval event, this is not required as per the specification,
171      * and other compliant implementations may not emit the event.
172      * @param from address The address which you want to send tokens from
173      * @param to address The address which you want to transfer to
174      * @param value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address from, address to, uint256 value) public returns (bool) {
177         _transfer(from, to, value);
178         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
179         return true;
180     }
181 
182     /**
183      * @dev Increase the amount of tokens that an owner allowed to a spender.
184      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * Emits an Approval event.
189      * @param spender The address which will spend the funds.
190      * @param addedValue The amount of tokens to increase the allowance by.
191      */
192     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
193         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
208         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
209         return true;
210     }
211 
212     /**
213      * @dev Transfer token for a specified addresses
214      * @param from The address to transfer from.
215      * @param to The address to transfer to.
216      * @param value The amount to be transferred.
217      */
218     function _transfer(address from, address to, uint256 value) internal {
219         require(to != address(0));
220 
221         _balances[from] = _balances[from].sub(value);
222         _balances[to] = _balances[to].add(value);
223         emit Transfer(from, to, value);
224     }
225 
226     /**
227      * @dev Internal function that mints an amount of the token and assigns it to
228      * an account. This encapsulates the modification of balances such that the
229      * proper events are emitted.
230      * @param account The account that will receive the created tokens.
231      * @param value The amount that will be created.
232      */
233     function _mint(address account, uint256 value) internal {
234         require(account != address(0));
235 
236         _totalSupply = _totalSupply.add(value);
237         _balances[account] = _balances[account].add(value);
238         emit Transfer(address(0), account, value);
239     }
240 
241     /**
242      * @dev Internal function that burns an amount of the token of a given
243      * account.
244      * @param account The account whose tokens will be burnt.
245      * @param value The amount that will be burnt.
246      */
247     function _burn(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.sub(value);
251         _balances[account] = _balances[account].sub(value);
252         emit Transfer(account, address(0), value);
253     }
254 
255     /**
256      * @dev Approve an address to spend another addresses' tokens.
257      * @param owner The address that owns the tokens.
258      * @param spender The address that will spend the tokens.
259      * @param value The number of tokens that can be spent.
260      */
261     function _approve(address owner, address spender, uint256 value) internal {
262         require(spender != address(0));
263         require(owner != address(0));
264 
265         _allowed[owner][spender] = value;
266         emit Approval(owner, spender, value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _burn(account, value);
279         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
280     }
281 }
282 
283 contract ERC20Pausable is ERC20, Pausable {
284     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
285         return super.transfer(to, value);
286     }
287 
288     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
289         return super.transferFrom(from, to, value);
290     }
291 
292     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
293         return super.approve(spender, value);
294     }
295 
296     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
297         return super.increaseAllowance(spender, addedValue);
298     }
299 
300     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
301         return super.decreaseAllowance(spender, subtractedValue);
302     }
303 }
304 contract ERC20Detailed is IERC20 {
305     string private _name;
306     string private _symbol;
307     uint8 private _decimals;
308 
309     constructor (string memory name, string memory symbol, uint8 decimals) public {
310         _name = name;
311         _symbol = symbol;
312         _decimals = decimals;
313     }
314 
315     /**
316      * @return the name of the token.
317      */
318     function name() public view returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @return the symbol of the token.
324      */
325     function symbol() public view returns (string memory) {
326         return _symbol;
327     }
328 
329     /**
330      * @return the number of decimals of the token.
331      */
332     function decimals() public view returns (uint8) {
333         return _decimals;
334     }
335 }
336 
337 contract ERC20Burnable is ERC20 {
338     /**
339      * @dev Burns a specific amount of tokens.
340      * @param value The amount of token to be burned.
341      */
342     function burn(uint256 value) public {
343         _burn(msg.sender, value);
344     }
345 
346     /**
347      * @dev Burns a specific amount of tokens from the target address and decrements allowance
348      * @param from address The account whose tokens will be burned.
349      * @param value uint256 The amount of token to be burned.
350      */
351     function burnFrom(address from, uint256 value) public {
352         _burnFrom(from, value);
353     }
354 }
355 library SafeMath {
356     /**
357      * @dev Multiplies two unsigned integers, reverts on overflow.
358      */
359     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
360         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
361         // benefit is lost if 'b' is also tested.
362         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
363         if (a == 0) {
364             return 0;
365         }
366 
367         uint256 c = a * b;
368         require(c / a == b);
369 
370         return c;
371     }
372 
373     /**
374      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
375      */
376     function div(uint256 a, uint256 b) internal pure returns (uint256) {
377         // Solidity only automatically asserts when dividing by 0
378         require(b > 0);
379         uint256 c = a / b;
380         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
381 
382         return c;
383     }
384 
385     /**
386      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
387      */
388     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
389         require(b <= a);
390         uint256 c = a - b;
391 
392         return c;
393     }
394 
395     /**
396      * @dev Adds two unsigned integers, reverts on overflow.
397      */
398     function add(uint256 a, uint256 b) internal pure returns (uint256) {
399         uint256 c = a + b;
400         require(c >= a);
401 
402         return c;
403     }
404 
405     /**
406      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
407      * reverts when dividing by zero.
408      */
409     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
410         require(b != 0);
411         return a % b;
412     }
413 }
414 
415 library Roles {
416     struct Role {
417         mapping (address => bool) bearer;
418     }
419 
420     /**
421      * @dev give an account access to this role
422      */
423     function add(Role storage role, address account) internal {
424         require(account != address(0));
425         require(!has(role, account));
426 
427         role.bearer[account] = true;
428     }
429 
430     /**
431      * @dev remove an account's access to this role
432      */
433     function remove(Role storage role, address account) internal {
434         require(account != address(0));
435         require(has(role, account));
436 
437         role.bearer[account] = false;
438     }
439 
440     /**
441      * @dev check if an account has this role
442      * @return bool
443      */
444     function has(Role storage role, address account) internal view returns (bool) {
445         require(account != address(0));
446         return role.bearer[account];
447     }
448 }
449 
450 contract SherCoinToken is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable {
451 
452 	uint8 public constant DECIMALS = 18;
453   uint256 public constant INITIAL_SUPPLY = 1500000000 * (10 ** uint256(DECIMALS));
454 
455   /**
456    * @dev Constructor that gives msg.sender all of existing tokens.
457    */
458   constructor() public ERC20Detailed("Sher", "SHER", DECIMALS) {
459     _mint(msg.sender, INITIAL_SUPPLY);
460   }
461 }