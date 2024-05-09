1 pragma solidity ^0.5.3;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/daveappleton/Documents/akombalabs/RevenueShareToken/contracts/ECToken.sol
6 // flattened :  Wednesday, 20-Mar-19 22:51:33 UTC
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     /**
27      * @dev Multiplies two unsigned integers, reverts on overflow.
28      */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
45      */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Adds two unsigned integers, reverts on overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     /**
76      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77      * reverts when dividing by zero.
78      */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 }
84 
85 contract Ownable {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92      * account.
93      */
94     constructor () internal {
95         _owner = msg.sender;
96         emit OwnershipTransferred(address(0), _owner);
97     }
98 
99     /**
100      * @return the address of the owner.
101      */
102     function owner() public view returns (address) {
103         return _owner;
104     }
105 
106     /**
107      * @dev Throws if called by any account other than the owner.
108      */
109     modifier onlyOwner() {
110         require(isOwner());
111         _;
112     }
113 
114     /**
115      * @return true if `msg.sender` is the owner of the contract.
116      */
117     function isOwner() public view returns (bool) {
118         return msg.sender == _owner;
119     }
120 
121     /**
122      * @dev Allows the current owner to relinquish control of the contract.
123      * It will not be possible to call the functions with the `onlyOwner`
124      * modifier anymore.
125      * @notice Renouncing ownership will leave the contract without an owner,
126      * thereby removing any functionality that is only available to the owner.
127      */
128     function renounceOwnership() public onlyOwner {
129         emit OwnershipTransferred(_owner, address(0));
130         _owner = address(0);
131     }
132 
133     /**
134      * @dev Allows the current owner to transfer control of the contract to a newOwner.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function transferOwnership(address newOwner) public onlyOwner {
138         _transferOwnership(newOwner);
139     }
140 
141     /**
142      * @dev Transfers control of the contract to a newOwner.
143      * @param newOwner The address to transfer ownership to.
144      */
145     function _transferOwnership(address newOwner) internal {
146         require(newOwner != address(0));
147         emit OwnershipTransferred(_owner, newOwner);
148         _owner = newOwner;
149     }
150 }
151 
152 library Roles {
153     struct Role {
154         mapping (address => bool) bearer;
155     }
156 
157     /**
158      * @dev give an account access to this role
159      */
160     function add(Role storage role, address account) internal {
161         require(account != address(0));
162         require(!has(role, account));
163 
164         role.bearer[account] = true;
165     }
166 
167     /**
168      * @dev remove an account's access to this role
169      */
170     function remove(Role storage role, address account) internal {
171         require(account != address(0));
172         require(has(role, account));
173 
174         role.bearer[account] = false;
175     }
176 
177     /**
178      * @dev check if an account has this role
179      * @return bool
180      */
181     function has(Role storage role, address account) internal view returns (bool) {
182         require(account != address(0));
183         return role.bearer[account];
184     }
185 }
186 
187 contract Batcher is Ownable{
188 
189     address public batcher;
190 
191     event NewMinter(address newMinter);
192 
193     modifier ownerOrBatcher()  {
194         require ((msg.sender == batcher) || isOwner(),"not authorised");
195         _;
196     }
197 
198     function setBatcher (address newBatcher) external onlyOwner {
199         batcher = newBatcher;
200         emit NewMinter(batcher);
201     }
202 
203 }
204 contract ERC20 is IERC20 {
205     using SafeMath for uint256;
206 
207     mapping (address => uint256) private _balances;
208 
209     mapping (address => mapping (address => uint256)) private _allowed;
210 
211     uint256 private _totalSupply;
212 
213     /**
214      * @dev Total number of tokens in existence
215      */
216     function totalSupply() public view returns (uint256) {
217         return _totalSupply;
218     }
219 
220     /**
221      * @dev Gets the balance of the specified address.
222      * @param owner The address to query the balance of.
223      * @return A uint256 representing the amount owned by the passed address.
224      */
225     function balanceOf(address owner) public view returns (uint256) {
226         return _balances[owner];
227     }
228 
229     /**
230      * @dev Function to check the amount of tokens that an owner allowed to a spender.
231      * @param owner address The address which owns the funds.
232      * @param spender address The address which will spend the funds.
233      * @return A uint256 specifying the amount of tokens still available for the spender.
234      */
235     function allowance(address owner, address spender) public view returns (uint256) {
236         return _allowed[owner][spender];
237     }
238 
239     /**
240      * @dev Transfer token to a specified address
241      * @param to The address to transfer to.
242      * @param value The amount to be transferred.
243      */
244     function transfer(address to, uint256 value) public returns (bool) {
245         _transfer(msg.sender, to, value);
246         return true;
247     }
248 
249     /**
250      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251      * Beware that changing an allowance with this method brings the risk that someone may use both the old
252      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      * @param spender The address which will spend the funds.
256      * @param value The amount of tokens to be spent.
257      */
258     function approve(address spender, uint256 value) public returns (bool) {
259         _approve(msg.sender, spender, value);
260         return true;
261     }
262 
263     /**
264      * @dev Transfer tokens from one address to another.
265      * Note that while this function emits an Approval event, this is not required as per the specification,
266      * and other compliant implementations may not emit the event.
267      * @param from address The address which you want to send tokens from
268      * @param to address The address which you want to transfer to
269      * @param value uint256 the amount of tokens to be transferred
270      */
271     function transferFrom(address from, address to, uint256 value) public returns (bool) {
272         _transfer(from, to, value);
273         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
274         return true;
275     }
276 
277     /**
278      * @dev Increase the amount of tokens that an owner allowed to a spender.
279      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
280      * allowed value is better to use this function to avoid 2 calls (and wait until
281      * the first transaction is mined)
282      * From MonolithDAO Token.sol
283      * Emits an Approval event.
284      * @param spender The address which will spend the funds.
285      * @param addedValue The amount of tokens to increase the allowance by.
286      */
287     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
288         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
289         return true;
290     }
291 
292     /**
293      * @dev Decrease the amount of tokens that an owner allowed to a spender.
294      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
295      * allowed value is better to use this function to avoid 2 calls (and wait until
296      * the first transaction is mined)
297      * From MonolithDAO Token.sol
298      * Emits an Approval event.
299      * @param spender The address which will spend the funds.
300      * @param subtractedValue The amount of tokens to decrease the allowance by.
301      */
302     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
303         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
304         return true;
305     }
306 
307     /**
308      * @dev Transfer token for a specified addresses
309      * @param from The address to transfer from.
310      * @param to The address to transfer to.
311      * @param value The amount to be transferred.
312      */
313     function _transfer(address from, address to, uint256 value) internal {
314         require(to != address(0));
315 
316         _balances[from] = _balances[from].sub(value);
317         _balances[to] = _balances[to].add(value);
318         emit Transfer(from, to, value);
319     }
320 
321     /**
322      * @dev Internal function that mints an amount of the token and assigns it to
323      * an account. This encapsulates the modification of balances such that the
324      * proper events are emitted.
325      * @param account The account that will receive the created tokens.
326      * @param value The amount that will be created.
327      */
328     function _mint(address account, uint256 value) internal {
329         require(account != address(0));
330 
331         _totalSupply = _totalSupply.add(value);
332         _balances[account] = _balances[account].add(value);
333         emit Transfer(address(0), account, value);
334     }
335 
336     /**
337      * @dev Internal function that burns an amount of the token of a given
338      * account.
339      * @param account The account whose tokens will be burnt.
340      * @param value The amount that will be burnt.
341      */
342     function _burn(address account, uint256 value) internal {
343         require(account != address(0));
344 
345         _totalSupply = _totalSupply.sub(value);
346         _balances[account] = _balances[account].sub(value);
347         emit Transfer(account, address(0), value);
348     }
349 
350     /**
351      * @dev Approve an address to spend another addresses' tokens.
352      * @param owner The address that owns the tokens.
353      * @param spender The address that will spend the tokens.
354      * @param value The number of tokens that can be spent.
355      */
356     function _approve(address owner, address spender, uint256 value) internal {
357         require(spender != address(0));
358         require(owner != address(0));
359 
360         _allowed[owner][spender] = value;
361         emit Approval(owner, spender, value);
362     }
363 
364     /**
365      * @dev Internal function that burns an amount of the token of a given
366      * account, deducting from the sender's allowance for said account. Uses the
367      * internal burn function.
368      * Emits an Approval event (reflecting the reduced allowance).
369      * @param account The account whose tokens will be burnt.
370      * @param value The amount that will be burnt.
371      */
372     function _burnFrom(address account, uint256 value) internal {
373         _burn(account, value);
374         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
375     }
376 
377     function _sendBatchCS(address[] memory _recipients, uint[] memory _values) internal returns (bool) {
378         require(_recipients.length == _values.length, "Inconsistent array lengths");
379         uint senderBalance = _balances[msg.sender];
380         for (uint i = 0; i < _values.length; i++) {
381             uint value = _values[i];
382             address to = _recipients[i];
383             require(senderBalance >= value,"Not enough balance");        
384             senderBalance = senderBalance - value;
385             _balances[to] += value;
386             emit Transfer(msg.sender, to, value);
387         }
388         _balances[msg.sender] = senderBalance;
389         return true;
390     }
391 }
392 
393 contract PauserRole {
394     using Roles for Roles.Role;
395 
396     event PauserAdded(address indexed account);
397     event PauserRemoved(address indexed account);
398 
399     Roles.Role private _pausers;
400 
401     constructor () internal {
402         _addPauser(msg.sender);
403     }
404 
405     modifier onlyPauser() {
406         require(isPauser(msg.sender));
407         _;
408     }
409 
410     function isPauser(address account) public view returns (bool) {
411         return _pausers.has(account);
412     }
413 
414     function addPauser(address account) public onlyPauser {
415         _addPauser(account);
416     }
417 
418     function renouncePauser() public {
419         _removePauser(msg.sender);
420     }
421 
422     function _addPauser(address account) internal {
423         _pausers.add(account);
424         emit PauserAdded(account);
425     }
426 
427     function _removePauser(address account) internal {
428         _pausers.remove(account);
429         emit PauserRemoved(account);
430     }
431 }
432 
433 contract Pausable is PauserRole {
434     event Paused(address account);
435     event Unpaused(address account);
436 
437     bool private _paused;
438 
439     constructor () internal {
440         _paused = false;
441     }
442 
443     /**
444      * @return true if the contract is paused, false otherwise.
445      */
446     function paused() public view returns (bool) {
447         return _paused;
448     }
449 
450     /**
451      * @dev Modifier to make a function callable only when the contract is not paused.
452      */
453     modifier whenNotPaused() {
454         require(!_paused);
455         _;
456     }
457 
458     /**
459      * @dev Modifier to make a function callable only when the contract is paused.
460      */
461     modifier whenPaused() {
462         require(_paused);
463         _;
464     }
465 
466     /**
467      * @dev called by the owner to pause, triggers stopped state
468      */
469     function pause() public onlyPauser whenNotPaused {
470         _paused = true;
471         emit Paused(msg.sender);
472     }
473 
474     /**
475      * @dev called by the owner to unpause, returns to normal state
476      */
477     function unpause() public onlyPauser whenPaused {
478         _paused = false;
479         emit Unpaused(msg.sender);
480     }
481 }
482 
483 contract ERC20Pausable is ERC20, Pausable {
484     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
485         return super.transfer(to, value);
486     }
487 
488     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
489         return super.transferFrom(from, to, value);
490     }
491 
492     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
493         return super.approve(spender, value);
494     }
495 
496     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
497         return super.increaseAllowance(spender, addedValue);
498     }
499 
500     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
501         return super.decreaseAllowance(spender, subtractedValue);
502     }
503 }
504 
505 contract rx is ERC20{
506     function onTransfer(uint) public payable returns (bool);
507 }
508 
509 
510 contract EtherCardDiscount is ERC20Pausable, Ownable, Batcher {
511     string public name     = "EtherCard Discount Token";
512     string public symbol   = "ether.card";
513     uint8  public decimals = 0;
514 
515  
516     constructor(address theOwner) public {
517         batcher = 0xB6f9E6D9354b0c04E0556A168a8Af07b2439865E;
518         transferOwnership(theOwner);
519         _mint(theOwner,100);
520     }
521 
522 
523     function mint(address to, uint256 value) public onlyOwner returns (bool) {
524         _mint(to, value);
525         return true;
526     }
527 
528     function burn(uint256 value) public {
529         _burn(msg.sender, value);
530     }
531 
532     function sendBatchCS(address[] memory _recipients, uint[] memory _values) public ownerOrBatcher returns (bool) {
533         return _sendBatchCS(_recipients, _values);
534     }
535 
536 }