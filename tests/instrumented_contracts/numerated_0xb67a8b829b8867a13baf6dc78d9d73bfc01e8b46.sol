1 pragma solidity ^0.4.25;
2 
3 /* solium-disable error-reason */
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two numbers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /**
70  * @title Roles
71  * @dev Library for managing addresses assigned to a Role.
72  */
73 library Roles {
74     struct Role {
75         mapping (address => bool) bearer;
76     }
77 
78     /**
79      * @dev give an account access to this role
80      */
81     function add(Role storage role, address account) internal {
82         require(account != address(0));
83         require(!has(role, account));
84 
85         role.bearer[account] = true;
86     }
87 
88     /**
89      * @dev remove an account's access to this role
90      */
91     function remove(Role storage role, address account) internal {
92         require(account != address(0));
93         require(has(role, account));
94 
95         role.bearer[account] = false;
96     }
97 
98     /**
99      * @dev check if an account has this role
100      * @return bool
101      */
102     function has(Role storage role, address account) internal view returns (bool) {
103         require(account != address(0));
104         return role.bearer[account];
105     }
106 }
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 interface IERC20 {
113     function totalSupply() external view returns (uint256);
114 
115     function balanceOf(address who) external view returns (uint256);
116 
117     function allowance(address owner, address spender) external view returns (uint256);
118 
119     function transfer(address to, uint256 value) external returns (bool);
120 
121     function approve(address spender, uint256 value) external returns (bool);
122 
123     function transferFrom(address from, address to, uint256 value) external returns (bool);
124 
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
135  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  *
137  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
138  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
139  * compliant implementations may not do it.
140  */
141 contract ERC20 is IERC20 {
142     using SafeMath for uint256;
143 
144     mapping (address => uint256) private _balances;
145 
146     mapping (address => mapping (address => uint256)) private _allowed;
147 
148     uint256 private _totalSupply;
149 
150     /**
151      * @dev Total number of tokens in existence
152      */
153     function totalSupply() public view returns (uint256) {
154         return _totalSupply;
155     }
156 
157     /**
158      * @dev Gets the balance of the specified address.
159      * @param owner The address to query the balance of.
160      * @return An uint256 representing the amount owned by the passed address.
161      */
162     function balanceOf(address owner) public view returns (uint256) {
163         return _balances[owner];
164     }
165 
166     /**
167      * @dev Function to check the amount of tokens that an owner allowed to a spender.
168      * @param owner address The address which owns the funds.
169      * @param spender address The address which will spend the funds.
170      * @return A uint256 specifying the amount of tokens still available for the spender.
171      */
172     function allowance(address owner, address spender) public view returns (uint256) {
173         return _allowed[owner][spender];
174     }
175 
176     /**
177      * @dev Transfer token for a specified address
178      * @param to The address to transfer to.
179      * @param value The amount to be transferred.
180      */
181     function transfer(address to, uint256 value) public returns (bool) {
182         _transfer(msg.sender, to, value);
183         return true;
184     }
185 
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      * Beware that changing an allowance with this method brings the risk that someone may use both the old
189      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      * @param spender The address which will spend the funds.
193      * @param value The amount of tokens to be spent.
194      */
195     function approve(address spender, uint256 value) public returns (bool) {
196         require(spender != address(0));
197 
198         _allowed[msg.sender][spender] = value;
199         emit Approval(msg.sender, spender, value);
200         return true;
201     }
202 
203     /**
204      * @dev Transfer tokens from one address to another.
205      * Note that while this function emits an Approval event, this is not required as per the specification,
206      * and other compliant implementations may not emit the event.
207      * @param from address The address which you want to send tokens from
208      * @param to address The address which you want to transfer to
209      * @param value uint256 the amount of tokens to be transferred
210      */
211     function transferFrom(address from, address to, uint256 value) public returns (bool) {
212         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
213         _transfer(from, to, value);
214         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
215         return true;
216     }
217 
218     /**
219      * @dev Increase the amount of tokens that an owner allowed to a spender.
220      * approve should be called when allowed_[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * Emits an Approval event.
225      * @param spender The address which will spend the funds.
226      * @param addedValue The amount of tokens to increase the allowance by.
227      */
228     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
229         require(spender != address(0));
230 
231         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
232         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
233         return true;
234     }
235 
236     /**
237      * @dev Decrease the amount of tokens that an owner allowed to a spender.
238      * approve should be called when allowed_[_spender] == 0. To decrement
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * Emits an Approval event.
243      * @param spender The address which will spend the funds.
244      * @param subtractedValue The amount of tokens to decrease the allowance by.
245      */
246     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
247         require(spender != address(0));
248 
249         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
250         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251         return true;
252     }
253 
254     /**
255      * @dev Transfer token for a specified addresses
256      * @param from The address to transfer from.
257      * @param to The address to transfer to.
258      * @param value The amount to be transferred.
259      */
260     function _transfer(address from, address to, uint256 value) internal {
261         require(to != address(0));
262 
263         _balances[from] = _balances[from].sub(value);
264         _balances[to] = _balances[to].add(value);
265         emit Transfer(from, to, value);
266     }
267 
268     /**
269      * @dev Internal function that mints an amount of the token and assigns it to
270      * an account. This encapsulates the modification of balances such that the
271      * proper events are emitted.
272      * @param account The account that will receive the created tokens.
273      * @param value The amount that will be created.
274      */
275     function _mint(address account, uint256 value) internal {
276         require(account != address(0));
277 
278         _totalSupply = _totalSupply.add(value);
279         _balances[account] = _balances[account].add(value);
280         emit Transfer(address(0), account, value);
281     }
282 }
283 
284 /**
285  * @title PauserRole
286  * @dev Base contract which allows children to implement an emergency stop mechanism.
287  */
288 contract PauserRole {
289     using Roles for Roles.Role;
290 
291     event PauserAdded(address indexed account);
292     event PauserRemoved(address indexed account);
293 
294     Roles.Role private _pausers;
295 
296     constructor () internal {
297         _addPauser(msg.sender);
298     }
299 
300     modifier onlyPauser() {
301         require(isPauser(msg.sender));
302         _;
303     }
304 
305     function isPauser(address account) public view returns (bool) {
306         return _pausers.has(account);
307     }
308 
309     function addPauser(address account) public onlyPauser {
310         _addPauser(account);
311     }
312 
313     function renouncePauser() public {
314         _removePauser(msg.sender);
315     }
316 
317     function _addPauser(address account) internal {
318         _pausers.add(account);
319         emit PauserAdded(account);
320     }
321 
322     function _removePauser(address account) internal {
323         _pausers.remove(account);
324         emit PauserRemoved(account);
325     }
326 }
327 
328 /**
329  * @title Pausable
330  * @dev Base contract which allows children to implement an emergency stop mechanism.
331  */
332 contract Pausable is PauserRole {
333     event Paused(address account);
334     event Unpaused(address account);
335 
336     bool private _paused;
337 
338     constructor () internal {
339         _paused = false;
340     }
341 
342     /**
343      * @return true if the contract is paused, false otherwise.
344      */
345     function paused() public view returns (bool) {
346         return _paused;
347     }
348 
349     /**
350      * @dev Modifier to make a function callable only when the contract is not paused.
351      */
352     modifier whenNotPaused() {
353         require(!_paused);
354         _;
355     }
356 
357     /**
358      * @dev Modifier to make a function callable only when the contract is paused.
359      */
360     modifier whenPaused() {
361         require(_paused);
362         _;
363     }
364 
365     /**
366      * @dev called by the owner to pause, triggers stopped state
367      */
368     function pause() public onlyPauser whenNotPaused {
369         _paused = true;
370         emit Paused(msg.sender);
371     }
372 
373     /**
374      * @dev called by the owner to unpause, returns to normal state
375      */
376     function unpause() public onlyPauser whenPaused {
377         _paused = false;
378         emit Unpaused(msg.sender);
379     }
380 }
381 
382 /**
383  * @title Pausable token
384  * @dev ERC20 modified with pausable transfers.
385  */
386 contract ERC20Pausable is ERC20, Pausable {
387     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
388         return super.transfer(to, value);
389     }
390 
391     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
392         return super.transferFrom(from, to, value);
393     }
394 
395     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
396         return super.approve(spender, value);
397     }
398 
399     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
400         return super.increaseAllowance(spender, addedValue);
401     }
402 
403     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
404         return super.decreaseAllowance(spender, subtractedValue);
405     }
406 }
407 
408 /**
409  * @title FthToken
410  */
411 contract FthToken is ERC20Pausable {
412     string public constant name = "FTH Token";
413     string public constant symbol = "FTH";
414     uint8 public constant decimals = 18;
415 
416     uint256 private _supply = 2100000 * (10 ** uint256(decimals));
417 
418     constructor (address wallet) public {
419         require(wallet != address(0));
420 
421         if (! isPauser(wallet)) {
422             _addPauser(wallet);
423         }
424 
425         _mint(wallet, _supply);
426     }
427 }