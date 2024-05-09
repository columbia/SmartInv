1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
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
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31      * @dev Multiplies two unsigned integers, reverts on overflow.
32      */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49      */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Adds two unsigned integers, reverts on overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81      * reverts when dividing by zero.
82      */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title Roles
91  * @dev Library for managing addresses assigned to a Role.
92  */
93 library Roles {
94     struct Role {
95         mapping (address => bool) bearer;
96     }
97 
98     /**
99      * @dev Give an account access to this role.
100      */
101     function add(Role storage role, address account) internal {
102         require(account != address(0));
103         require(!has(role, account));
104 
105         role.bearer[account] = true;
106     }
107 
108     /**
109      * @dev Remove an account's access to this role.
110      */
111     function remove(Role storage role, address account) internal {
112         require(account != address(0));
113         require(has(role, account));
114 
115         role.bearer[account] = false;
116     }
117 
118     /**
119      * @dev Check if an account has this role.
120      * @return bool
121      */
122     function has(Role storage role, address account) internal view returns (bool) {
123         require(account != address(0));
124         return role.bearer[account];
125     }
126 }
127 
128 
129 contract ERC20 is IERC20 {
130     using SafeMath for uint256;
131 
132     mapping (address => uint256) private _balances;
133 
134     mapping (address => mapping (address => uint256)) private _allowed;
135 
136     uint256 private _totalSupply;
137 
138     /**
139      * @dev Total number of tokens in existence.
140      */
141     function totalSupply() public view returns (uint256) {
142         return _totalSupply;
143     }
144 
145     /**
146      * @dev Gets the balance of the specified address.
147      * @param owner The address to query the balance of.
148      * @return A uint256 representing the amount owned by the passed address.
149      */
150     function balanceOf(address owner) public view returns (uint256) {
151         return _balances[owner];
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param owner address The address which owns the funds.
157      * @param spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address owner, address spender) public view returns (uint256) {
161         return _allowed[owner][spender];
162     }
163 
164     /**
165      * @dev Transfer token to a specified address.
166      * @param to The address to transfer to.
167      * @param value The amount to be transferred.
168      */
169     function transfer(address to, uint256 value) public returns (bool) {
170         _transfer(msg.sender, to, value);
171         return true;
172     }
173 
174     /**
175      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176      * Beware that changing an allowance with this method brings the risk that someone may use both the old
177      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      * @param spender The address which will spend the funds.
181      * @param value The amount of tokens to be spent.
182      */
183     function approve(address spender, uint256 value) public returns (bool) {
184         _approve(msg.sender, spender, value);
185         return true;
186     }
187 
188     /**
189      * @dev Transfer tokens from one address to another.
190      * Note that while this function emits an Approval event, this is not required as per the specification,
191      * and other compliant implementations may not emit the event.
192      * @param from address The address which you want to send tokens from
193      * @param to address The address which you want to transfer to
194      * @param value uint256 the amount of tokens to be transferred
195      */
196     function transferFrom(address from, address to, uint256 value) public returns (bool) {
197         _transfer(from, to, value);
198         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
199         return true;
200     }
201 
202     /**
203      * @dev Increase the amount of tokens that an owner allowed to a spender.
204      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param addedValue The amount of tokens to increase the allowance by.
211      */
212     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
213         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
214         return true;
215     }
216 
217     /**
218      * @dev Decrease the amount of tokens that an owner allowed to a spender.
219      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
220      * allowed value is better to use this function to avoid 2 calls (and wait until
221      * the first transaction is mined)
222      * From MonolithDAO Token.sol
223      * Emits an Approval event.
224      * @param spender The address which will spend the funds.
225      * @param subtractedValue The amount of tokens to decrease the allowance by.
226      */
227     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
228         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
229         return true;
230     }
231 
232     /**
233      * @dev Transfer token for a specified addresses.
234      * @param from The address to transfer from.
235      * @param to The address to transfer to.
236      * @param value The amount to be transferred.
237      */
238     function _transfer(address from, address to, uint256 value) internal {
239         require(to != address(0));
240 
241         _balances[from] = _balances[from].sub(value);
242         _balances[to] = _balances[to].add(value);
243         emit Transfer(from, to, value);
244     }
245 
246     /**
247      * @dev Internal function that mints an amount of the token and assigns it to
248      * an account. This encapsulates the modification of balances such that the
249      * proper events are emitted.
250      * @param account The account that will receive the created tokens.
251      * @param value The amount that will be created.
252      */
253     function _mint(address account, uint256 value) internal {
254         require(account != address(0));
255 
256         _totalSupply = _totalSupply.add(value);
257         _balances[account] = _balances[account].add(value);
258         emit Transfer(address(0), account, value);
259     }
260 
261     /**
262      * @dev Internal function that burns an amount of the token of a given
263      * account.
264      * @param account The account whose tokens will be burnt.
265      * @param value The amount that will be burnt.
266      */
267     function _burn(address account, uint256 value) internal {
268         require(account != address(0));
269 
270         _totalSupply = _totalSupply.sub(value);
271         _balances[account] = _balances[account].sub(value);
272         emit Transfer(account, address(0), value);
273     }
274 
275     /**
276      * @dev Approve an address to spend another addresses' tokens.
277      * @param owner The address that owns the tokens.
278      * @param spender The address that will spend the tokens.
279      * @param value The number of tokens that can be spent.
280      */
281     function _approve(address owner, address spender, uint256 value) internal {
282         require(spender != address(0));
283         require(owner != address(0));
284 
285         _allowed[owner][spender] = value;
286         emit Approval(owner, spender, value);
287     }
288 
289     /**
290      * @dev Internal function that burns an amount of the token of a given
291      * account, deducting from the sender's allowance for said account. Uses the
292      * internal burn function.
293      * Emits an Approval event (reflecting the reduced allowance).
294      * @param account The account whose tokens will be burnt.
295      * @param value The amount that will be burnt.
296      */
297     function _burnFrom(address account, uint256 value) internal {
298         _burn(account, value);
299         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
300     }
301 }
302 
303 
304 contract ERC20Burnable is ERC20 {
305     /**
306      * @dev Burns a specific amount of tokens.
307      * @param value The amount of token to be burned.
308      */
309     function burn(uint256 value) public {
310         _burn(msg.sender, value);
311     }
312 
313     /**
314      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
315      * @param from address The account whose tokens will be burned.
316      * @param value uint256 The amount of token to be burned.
317      */
318     function burnFrom(address from, uint256 value) public {
319         _burnFrom(from, value);
320     }
321 }
322 
323 contract MinterRole {
324     using Roles for Roles.Role;
325 
326     event MinterAdded(address indexed account);
327     event MinterRemoved(address indexed account);
328 
329     Roles.Role private _minters;
330 
331     constructor () internal {
332         _addMinter(msg.sender);
333     }
334 
335     modifier onlyMinter() {
336         require(isMinter(msg.sender));
337         _;
338     }
339 
340     function isMinter(address account) public view returns (bool) {
341         return _minters.has(account);
342     }
343 
344     function addMinter(address account) public onlyMinter {
345         _addMinter(account);
346     }
347 
348     function renounceMinter() public {
349         _removeMinter(msg.sender);
350     }
351 
352     function _addMinter(address account) internal {
353         _minters.add(account);
354         emit MinterAdded(account);
355     }
356 
357     function _removeMinter(address account) internal {
358         _minters.remove(account);
359         emit MinterRemoved(account);
360     }
361 }
362 
363 contract ERC20Mintable is ERC20, MinterRole {
364     /**
365      * @dev Function to mint tokens
366      * @param to The address that will receive the minted tokens.
367      * @param value The amount of tokens to mint.
368      * @return A boolean that indicates if the operation was successful.
369      */
370 
371     uint256 public maxSupply;
372     uint256 public tokensMinted;
373 
374     constructor  (uint256 _maxSupply) public {
375         require(_maxSupply > 0);
376         maxSupply = _maxSupply;
377     }
378 
379     function mint(address to, uint256 value) public onlyMinter returns (bool) {
380         require(tokensMinted.add(value) <= maxSupply);
381         tokensMinted = tokensMinted.add(value);
382         _mint(to, value);
383         return true;
384     }
385 
386 }
387 
388 
389 contract RoobeeToken is ERC20Burnable, ERC20Mintable {
390 
391     string public constant name = "ROOBEE";
392     string public constant symbol = "ROOBEE";
393     uint8 public constant decimals = 18;
394 
395     struct FreezeParams {
396         uint256 timestamp;
397         uint256 value;
398         bool subsequentUnlock;
399     }
400 
401     mapping (address => FreezeParams) private _freezed;
402 
403     constructor () public ERC20Mintable(5400000000 * 1e18) {
404     }
405 
406     function freezeOf(address owner) public view returns (uint256) {
407         if (_freezed[owner].timestamp <= now){
408             if (_freezed[owner].subsequentUnlock){
409                 uint256  monthsPassed;
410                 monthsPassed = now.sub(_freezed[owner].timestamp).div(30 days);
411                 if (monthsPassed >= 10)
412                 {
413                     return 0;
414                 }
415                 else
416                 {
417                     return _freezed[owner].value.mul(10-monthsPassed).div(10);
418                 }
419             }
420             else {
421                 return 0;
422             }
423         }
424         else
425         {
426             return _freezed[owner].value;
427         }
428     }
429 
430     function freezeFor(address owner) public view returns (uint256) {
431         return _freezed[owner].timestamp;
432     }
433 
434     function getAvailableBalance(address from) public view returns (uint256) {
435 
436         return balanceOf(from).sub(freezeOf(from));
437     }
438 
439     function mintWithFreeze(address _to, uint256 _value, uint256 _unfreezeTimestamp, bool _subsequentUnlock) public onlyMinter returns (bool) {
440         require(now < _unfreezeTimestamp);
441         _setHold(_to, _value, _unfreezeTimestamp, _subsequentUnlock);
442         mint(_to, _value);
443         return true;
444     }
445 
446     function _setHold(address to, uint256 value, uint256 unfreezeTimestamp, bool subsequentUnlock) private {
447         FreezeParams memory freezeData;
448         freezeData = _freezed[to];
449         // freeze timestamp is unchangable
450         if (freezeData.timestamp == 0) {
451             freezeData.timestamp = unfreezeTimestamp;
452             freezeData.subsequentUnlock = subsequentUnlock;
453         }
454         freezeData.value = freezeData.value.add(value);
455         _freezed[to] = freezeData;
456     }
457 
458     function transfer(address to, uint256 value) public returns (bool) {
459         require(getAvailableBalance(msg.sender) >= value);
460         return super.transfer(to, value);
461     }
462 
463     function transferFrom(address from, address to, uint256 value) public returns (bool) {
464         require(getAvailableBalance(from) >= value);
465         return super.transferFrom(from, to, value);
466     }
467 
468     function burn(uint256 value) public {
469         require(getAvailableBalance(msg.sender) >= value);
470         super.burn(value);
471     }
472 
473     function burnFrom(address from, uint256 value) public  {
474         require(getAvailableBalance(from) >= value);
475         super.burnFrom(from, value);
476     }
477 
478     function approveAndCall(address _spender, uint256 _value, string memory _extraData
479     ) public returns (bool success) {
480         approve(_spender, _value);
481 
482         // This portion is copied from ConsenSys's Standard Token Contract. It
483         //  calls the approvalFallback function that is part of the contract that
484         //  is being approved (`_spender`). The function should look like:
485         //  `approvalFallback(address _from, uint256 _value, address
486         //  _token, string memory _extraData)` It is assumed that the call
487         //  *should* succeed, otherwise the plain vanilla approve would be used
488         CallReceiver(_spender).approvalFallback(
489            msg.sender,
490            _value,
491            address(this),
492            _extraData
493         );
494         return true;
495     }
496 
497 }
498 
499 contract CallReceiver {
500     function approvalFallback(address _from, uint256 _value, address _token, string memory _extraData) public ;
501 }