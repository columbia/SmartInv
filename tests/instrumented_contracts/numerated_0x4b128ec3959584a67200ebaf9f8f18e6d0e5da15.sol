1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://eips.ethereum.org/EIPS/eip-20
7  */
8 interface IERC20 {
9     function transfer(address to, uint256 value) external returns (bool);
10 
11     function approve(address spender, uint256 value) external returns (bool);
12 
13     function transferFrom(address from, address to, uint256 value) external returns (bool);
14 
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address who) external view returns (uint256);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Standard ERC20 token
28  *
29  * @dev Implementation of the basic standard token.
30  * https://eips.ethereum.org/EIPS/eip-20
31  * Originally based on code by FirstBlood:
32  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
33  *
34  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
35  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
36  * compliant implementations may not do it.
37  */
38 contract ERC20 is IERC20 {
39     using SafeMath for uint256;
40 
41     mapping (address => Account) _balances;
42 
43     mapping (address => mapping (address => uint256)) private _allowances;
44 
45     uint256 private _totalSupply;
46     
47     struct Account {
48         uint256 total;
49         uint256 locked;
50         uint32 release_time;
51     }
52     /**
53      * @dev Total number of tokens in existence.
54      */
55     function totalSupply() public view returns (uint256) {
56         return _totalSupply;
57     }
58 
59     /**
60      * @dev Gets the balance of the specified address.
61      * @param owner The address to query the balance of.
62      * @return A uint256 representing the amount owned by the passed address.
63      */
64     function balanceOf(address owner) public view returns (uint256) {
65         return _balances[owner].total;
66     }
67     
68     function lockedOf(address owner) public view returns(uint256) {
69         return _balances[owner].locked;
70     }
71 
72     /**
73      * @dev Function to check the amount of tokens that an owner allowed to a spender.
74      * @param owner address The address which owns the funds.
75      * @param spender address The address which will spend the funds.
76      * @return A uint256 specifying the amount of tokens still available for the spender.
77      */
78     function allowance(address owner, address spender) public view returns (uint256) {
79         return _allowances[owner][spender];
80     }
81 
82     /**
83      * @dev Transfer token to a specified address.
84      * @param to The address to transfer to.
85      * @param value The amount to be transferred.
86      */
87     function transfer(address to, uint256 value) public returns (bool) {
88         _transfer(msg.sender, to, value);
89         return true;
90     }
91 
92     /**
93      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
94      * Beware that changing an allowance with this method brings the risk that someone may use both the old
95      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
96      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
97      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98      * @param spender The address which will spend the funds.
99      * @param value The amount of tokens to be spent.
100      */
101     function approve(address spender, uint256 value) public returns (bool) {
102         _approve(msg.sender, spender, value);
103         return true;
104     }
105 
106     /**
107      * @dev Transfer tokens from one address to another.
108      * Note that while this function emits an Approval event, this is not required as per the specification,
109      * and other compliant implementations may not emit the event.
110      * @param from address The address which you want to send tokens from
111      * @param to address The address which you want to transfer to
112      * @param value uint256 the amount of tokens to be transferred
113      */
114     function transferFrom(address from, address to, uint256 value) public returns (bool) {
115         _transfer(from, to, value);
116         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
117         return true;
118     }
119 
120     /**
121      * @dev Increase the amount of tokens that an owner allowed to a spender.
122      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
123      * allowed value is better to use this function to avoid 2 calls (and wait until
124      * the first transaction is mined)
125      * From MonolithDAO Token.sol
126      * Emits an Approval event.
127      * @param spender The address which will spend the funds.
128      * @param addedValue The amount of tokens to increase the allowance by.
129      */
130     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
131         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
132         return true;
133     }
134 
135     /**
136      * @dev Decrease the amount of tokens that an owner allowed to a spender.
137      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
138      * allowed value is better to use this function to avoid 2 calls (and wait until
139      * the first transaction is mined)
140      * From MonolithDAO Token.sol
141      * Emits an Approval event.
142      * @param spender The address which will spend the funds.
143      * @param subtractedValue The amount of tokens to decrease the allowance by.
144      */
145     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
146         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
147         return true;
148     }
149 
150     /**
151      * @dev Transfer token for a specified addresses.
152      * @param from The address to transfer from.
153      * @param to The address to transfer to.
154      * @param value The amount to be transferred.
155      */
156     function _transfer(address from, address to, uint256 value) internal {
157         require(from != address(0), "ERC20: transfer from the zero address");
158         require(to != address(0), "ERC20: transfer to the zero address");
159         uint256 total;
160         if(_balances[from].locked>0) {
161             //release time reached
162             if(_balances[from].release_time<block.timestamp) {
163                 _balances[from].locked = 0;
164                 total = _balances[from].total;
165             }else {
166                 total = _balances[from].total.sub(_balances[from].locked);
167             }
168         }else {
169             total = _balances[from].total;
170         }
171         _balances[from].total = total.sub(value).add(_balances[from].locked);
172         _balances[to].total = _balances[to].total.add(value);
173         emit Transfer(from, to, value);
174     }
175 
176     /**
177      * @dev Internal function that mints an amount of the token and assigns it to
178      * an account. This encapsulates the modification of balances such that the
179      * proper events are emitted.
180      * @param account The account that will receive the created tokens.
181      * @param value The amount that will be created.
182      */
183     function _mint(address account, uint256 value) internal {
184         require(account != address(0), "ERC20: mint to the zero address");
185 
186         _totalSupply = _totalSupply.add(value);
187         _balances[account].total = _balances[account].total.add(value);
188         emit Transfer(address(0), account, value);
189     }
190 
191     /**
192      * @dev Internal function that burns an amount of the token of a given
193      * account.
194      * @param account The account whose tokens will be burnt.
195      * @param value The amount that will be burnt.
196      */
197     function _burn(address account, uint256 value) internal {
198         require(account != address(0), "ERC20: burn from the zero address");
199         uint256 total;
200         if(_balances[account].locked>0) {
201             //release time reached
202             if(_balances[account].release_time<block.timestamp) {
203                 _balances[account].locked = 0;
204                 total = _balances[account].total;
205             }else {
206                 total = _balances[account].total.sub(_balances[account].locked);
207             }
208         }else {
209             total = _balances[account].total;
210         }
211         
212         _totalSupply = _totalSupply.sub(value);
213         _balances[account].total = total.sub(value).add(_balances[account].locked);
214         emit Transfer(account, address(0), value);
215     }
216 
217     /**
218      * @dev Approve an address to spend another addresses' tokens.
219      * @param owner The address that owns the tokens.
220      * @param spender The address that will spend the tokens.
221      * @param value The number of tokens that can be spent.
222      */
223     function _approve(address owner, address spender, uint256 value) internal {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226 
227         _allowances[owner][spender] = value;
228         emit Approval(owner, spender, value);
229     }
230 
231     /**
232      * @dev Internal function that burns an amount of the token of a given
233      * account, deducting from the sender's allowance for said account. Uses the
234      * internal burn function.
235      * Emits an Approval event (reflecting the reduced allowance).
236      * @param account The account whose tokens will be burnt.
237      * @param value The amount that will be burnt.
238      */
239     function _burnFrom(address account, uint256 value) internal {
240         _burn(account, value);
241         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
242     }
243     
244     /**
245      * @param account target address
246      * @param value amount to lock
247      * @param release_time timestamp to release lock
248      */
249     function _lockTransfer(address account, uint256 value,uint32 release_time) internal {
250         transfer(account, value);
251         require(_balances[account].total >= _balances[account].locked.add(value));
252         _balances[account].locked = _balances[account].locked.add(value);
253         _balances[account].release_time = release_time;
254     }
255     
256 }
257 
258 /**
259  * @title SafeMath
260  * @dev Unsigned math operations with safety checks that revert on error.
261  */
262 library SafeMath {
263     /**
264      * @dev Multiplies two unsigned integers, reverts on overflow.
265      */
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
268         // benefit is lost if 'b' is also tested.
269         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
270         if (a == 0) {
271             return 0;
272         }
273 
274         uint256 c = a * b;
275         require(c / a == b, "SafeMath: multiplication overflow");
276 
277         return c;
278     }
279 
280     /**
281      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
282      */
283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
284         // Solidity only automatically asserts when dividing by 0
285         require(b > 0, "SafeMath: division by zero");
286         uint256 c = a / b;
287         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
288 
289         return c;
290     }
291 
292     /**
293      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
294      */
295     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296         require(b <= a, "SafeMath: subtraction overflow");
297         uint256 c = a - b;
298 
299         return c;
300     }
301 
302     /**
303      * @dev Adds two unsigned integers, reverts on overflow.
304      */
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         require(c >= a, "SafeMath: addition overflow");
308 
309         return c;
310     }
311 
312     /**
313      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
314      * reverts when dividing by zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b != 0, "SafeMath: modulo by zero");
318         return a % b;
319     }
320 }
321 
322 
323 contract PauserRole {
324     using Roles for Roles.Role;
325 
326     event PauserAdded(address indexed account);
327     event PauserRemoved(address indexed account);
328 
329     Roles.Role private _pausers;
330 
331     constructor () internal {
332         _addPauser(msg.sender);
333     }
334 
335     modifier onlyPauser() {
336         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
337         _;
338     }
339 
340     function isPauser(address account) public view returns (bool) {
341         return _pausers.has(account);
342     }
343 
344     function addPauser(address account) public onlyPauser {
345         _addPauser(account);
346     }
347 
348     function renouncePauser() public {
349         _removePauser(msg.sender);
350     }
351 
352     function _addPauser(address account) internal {
353         _pausers.add(account);
354         emit PauserAdded(account);
355     }
356 
357     function _removePauser(address account) internal {
358         _pausers.remove(account);
359         emit PauserRemoved(account);
360     }
361 }
362 
363 /**
364  * @title Pausable
365  * @dev Base contract which allows children to implement an emergency stop mechanism.
366  */
367 contract Pausable is PauserRole {
368     event Paused(address account);
369     event Unpaused(address account);
370 
371     bool private _paused;
372 
373     constructor () internal {
374         _paused = false;
375     }
376 
377     /**
378      * @return True if the contract is paused, false otherwise.
379      */
380     function paused() public view returns (bool) {
381         return _paused;
382     }
383 
384     /**
385      * @dev Modifier to make a function callable only when the contract is not paused.
386      */
387     modifier whenNotPaused() {
388         require(!_paused, "Pausable: paused");
389         _;
390     }
391 
392     /**
393      * @dev Modifier to make a function callable only when the contract is paused.
394      */
395     modifier whenPaused() {
396         require(_paused, "Pausable: not paused");
397         _;
398     }
399 
400     /**
401      * @dev Called by a pauser to pause, triggers stopped state.
402      */
403     function pause() public onlyPauser whenNotPaused {
404         _paused = true;
405         emit Paused(msg.sender);
406     }
407 
408     /**
409      * @dev Called by a pauser to unpause, returns to normal state.
410      */
411     function unpause() public onlyPauser whenPaused {
412         _paused = false;
413         emit Unpaused(msg.sender);
414     }
415 }
416 
417 
418 /**
419  * @title Roles
420  * @dev Library for managing addresses assigned to a Role.
421  */
422 library Roles {
423     struct Role {
424         mapping (address => bool) bearer;
425     }
426 
427     /**
428      * @dev Give an account access to this role.
429      */
430     function add(Role storage role, address account) internal {
431         require(!has(role, account), "Roles: account already has role");
432         role.bearer[account] = true;
433     }
434 
435     /**
436      * @dev Remove an account's access to this role.
437      */
438     function remove(Role storage role, address account) internal {
439         require(has(role, account), "Roles: account does not have role");
440         role.bearer[account] = false;
441     }
442 
443     /**
444      * @dev Check if an account has this role.
445      * @return bool
446      */
447     function has(Role storage role, address account) internal view returns (bool) {
448         require(account != address(0), "Roles: account is the zero address");
449         return role.bearer[account];
450     }
451 }
452 
453 /**
454  * @title Pausable token
455  * @dev ERC20 modified with pausable transfers.
456  */
457 contract ERC20Pausable is ERC20, Pausable {
458     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
459         return super.transfer(to, value);
460     }
461 
462     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
463         return super.transferFrom(from, to, value);
464     }
465 
466     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
467         return super.approve(spender, value);
468     }
469 
470     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
471         return super.increaseAllowance(spender, addedValue);
472     }
473 
474     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
475         return super.decreaseAllowance(spender, subtractedValue);
476     }
477 }
478 
479 contract ERC20Burnable is ERC20 {
480     /**
481      * @dev Burns a specific amount of tokens.
482      * @param value The amount of token to be burned.
483      */
484     function burn(uint256 value) public {
485         _burn(msg.sender, value);
486     }
487 
488     /**
489      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
490      * @param from address The account whose tokens will be burned.
491      * @param value uint256 The amount of token to be burned.
492      */
493     function burnFrom(address from, uint256 value) public {
494         _burnFrom(from, value);
495     }
496 }
497 
498 
499 contract ETEC is ERC20Pausable,ERC20Burnable {
500 
501     uint32[] public _release_points = [1572537600,1575129600,1577808000,1580486400,1582992000,1585670400,1588262400,1590940800,1593532800,1596211200,1598889600,1601481600,1604160000,1606752000,1609430400,1612108800,1614528000,1617206400,1619798400,1622476800,1625068800,1627747200,1630425600,1633017600,1635696000,1638288000,1640966400,1643644800,1646064000,1648742400,1651334400,1654012800,1656604800,1659283200,1661961600,1664553600];
502     uint8 public _next_point = 0;
503     uint256 public _burn_amount_pertime = 10000000 * (10**decimals);
504     address public _burn_address = 0xAccF8C4C8F5EAd10eeBEad972438E34D5a475158;
505     
506 
507     string public constant name    = "Electronic Cigarette Chain";  //The Token's name
508     uint256 public constant decimals = 18;               //Number of decimals of the smallest unit
509     string public constant symbol  = "ETEC";            //An identifier 
510 
511     // uint256 private _totalSupply = ;
512     
513     constructor () public {
514         _mint(msg.sender, 1000000000 * (10**decimals));
515         transfer(0xC7D3AE49d6998487428e85b7241786F83D60D9f7, 860000000*(10**decimals));
516         _lockTransfer(0x7229352116a03412968Dd54919c9cf1Ac73C5Bef, 140000000*(10**decimals), 1664553600);
517     }
518     
519     function transfer(address to, uint256 value) public returns (bool) {
520         _auto_burn();
521         return super.transfer(to, value);
522     }
523     
524     function _auto_burn() internal {
525         if(_next_point < _release_points.length && block.timestamp > _release_points[_next_point] && balanceOf(_burn_address)>=_burn_amount_pertime) {
526             _burn(_burn_address, _burn_amount_pertime);
527             _next_point = _next_point + 1;
528         }
529     }
530 
531 }