1 pragma solidity ^0.5.4;
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
89 
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * https://eips.ethereum.org/EIPS/eip-20
96  * Originally based on code by FirstBlood:
97  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  *
99  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
100  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
101  * compliant implementations may not do it.
102  */
103 contract ERC20 is IERC20 {
104     using SafeMath for uint256;
105 
106     mapping (address => uint256) private _balances;
107 
108     mapping (address => mapping (address => uint256)) private _allowed;
109 
110     uint256 private _totalSupply;
111 
112     /**
113      * @dev Total number of tokens in existence
114      */
115     function totalSupply() public view returns (uint256) {
116         return _totalSupply;
117     }
118 
119     /**
120      * @dev Gets the balance of the specified address.
121      * @param owner The address to query the balance of.
122      * @return A uint256 representing the amount owned by the passed address.
123      */
124     function balanceOf(address owner) public view returns (uint256) {
125         return _balances[owner];
126     }
127 
128     /**
129      * @dev Function to check the amount of tokens that an owner allowed to a spender.
130      * @param owner address The address which owns the funds.
131      * @param spender address The address which will spend the funds.
132      * @return A uint256 specifying the amount of tokens still available for the spender.
133      */
134     function allowance(address owner, address spender) public view returns (uint256) {
135         return _allowed[owner][spender];
136     }
137 
138     /**
139      * @dev Transfer token to a specified address
140      * @param to The address to transfer to.
141      * @param value The amount to be transferred.
142      */
143     function transfer(address to, uint256 value) public returns (bool) {
144         _transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     /**
149      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150      * Beware that changing an allowance with this method brings the risk that someone may use both the old
151      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      * @param spender The address which will spend the funds.
155      * @param value The amount of tokens to be spent.
156      */
157     function approve(address spender, uint256 value) public returns (bool) {
158         _approve(msg.sender, spender, value);
159         return true;
160     }
161 
162     /**
163      * @dev Transfer tokens from one address to another.
164      * Note that while this function emits an Approval event, this is not required as per the specification,
165      * and other compliant implementations may not emit the event.
166      * @param from address The address which you want to send tokens from
167      * @param to address The address which you want to transfer to
168      * @param value uint256 the amount of tokens to be transferred
169      */
170     function transferFrom(address from, address to, uint256 value) public returns (bool) {
171         _transfer(from, to, value);
172         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
173         return true;
174     }
175 
176     /**
177      * @dev Increase the amount of tokens that an owner allowed to a spender.
178      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
179      * allowed value is better to use this function to avoid 2 calls (and wait until
180      * the first transaction is mined)
181      * From MonolithDAO Token.sol
182      * Emits an Approval event.
183      * @param spender The address which will spend the funds.
184      * @param addedValue The amount of tokens to increase the allowance by.
185      */
186     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
187         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
188         return true;
189     }
190 
191     /**
192      * @dev Decrease the amount of tokens that an owner allowed to a spender.
193      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * From MonolithDAO Token.sol
197      * Emits an Approval event.
198      * @param spender The address which will spend the funds.
199      * @param subtractedValue The amount of tokens to decrease the allowance by.
200      */
201     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
202         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
203         return true;
204     }
205 
206     /**
207      * @dev Transfer token for a specified addresses
208      * @param from The address to transfer from.
209      * @param to The address to transfer to.
210      * @param value The amount to be transferred.
211      */
212     function _transfer(address from, address to, uint256 value) internal {
213         require(to != address(0));
214 
215         _balances[from] = _balances[from].sub(value);
216         _balances[to] = _balances[to].add(value);
217         emit Transfer(from, to, value);
218     }
219 
220     /**
221      * @dev Internal function that mints an amount of the token and assigns it to
222      * an account. This encapsulates the modification of balances such that the
223      * proper events are emitted.
224      * @param account The account that will receive the created tokens.
225      * @param value The amount that will be created.
226      */
227     function _mint(address account, uint256 value) internal {
228         require(account != address(0));
229 
230         _totalSupply = _totalSupply.add(value);
231         _balances[account] = _balances[account].add(value);
232         emit Transfer(address(0), account, value);
233     }
234 
235     /**
236      * @dev Internal function that burns an amount of the token of a given
237      * account.
238      * @param account The account whose tokens will be burnt.
239      * @param value The amount that will be burnt.
240      */
241     function _burn(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.sub(value);
245         _balances[account] = _balances[account].sub(value);
246         emit Transfer(account, address(0), value);
247     }
248 
249     /**
250      * @dev Approve an address to spend another addresses' tokens.
251      * @param owner The address that owns the tokens.
252      * @param spender The address that will spend the tokens.
253      * @param value The number of tokens that can be spent.
254      */
255     function _approve(address owner, address spender, uint256 value) internal {
256         require(spender != address(0));
257         require(owner != address(0));
258 
259         _allowed[owner][spender] = value;
260         emit Approval(owner, spender, value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _burn(account, value);
273         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
274     }
275 }
276 
277 /**
278  * @title Roles
279  * @dev Library for managing addresses assigned to a Role.
280  */
281 library Roles {
282     struct Role {
283         mapping (address => bool) bearer;
284     }
285 
286     /**
287      * @dev give an account access to this role
288      */
289     function add(Role storage role, address account) internal {
290         require(account != address(0));
291         require(!has(role, account));
292 
293         role.bearer[account] = true;
294     }
295 
296     /**
297      * @dev remove an account's access to this role
298      */
299     function remove(Role storage role, address account) internal {
300         require(account != address(0));
301         require(has(role, account));
302 
303         role.bearer[account] = false;
304     }
305 
306     /**
307      * @dev check if an account has this role
308      * @return bool
309      */
310     function has(Role storage role, address account) internal view returns (bool) {
311         require(account != address(0));
312         return role.bearer[account];
313     }
314 }
315 
316 
317 contract MinterRole {
318     using Roles for Roles.Role;
319 
320     event MinterAdded(address indexed account);
321     event MinterRemoved(address indexed account);
322 
323     Roles.Role private _minters;
324 
325     constructor () internal {
326         _addMinter(msg.sender);
327     }
328 
329     modifier onlyMinter() {
330         require(isMinter(msg.sender));
331         _;
332     }
333 
334     function isMinter(address account) public view returns (bool) {
335         return _minters.has(account);
336     }
337 
338     function addMinter(address account) public onlyMinter {
339         _addMinter(account);
340     }
341 
342     function renounceMinter() public {
343         _removeMinter(msg.sender);
344     }
345 
346     function _addMinter(address account) internal {
347         _minters.add(account);
348         emit MinterAdded(account);
349     }
350 
351     function _removeMinter(address account) internal {
352         _minters.remove(account);
353         emit MinterRemoved(account);
354     }
355 }
356 
357 
358 /**
359  * @title ERC20Mintable
360  * @dev ERC20 minting logic
361  */
362 contract ERC20Mintable is ERC20, MinterRole {
363     /**
364      * @dev Function to mint tokens
365      * @param to The address that will receive the minted tokens.
366      * @param value The amount of tokens to mint.
367      * @return A boolean that indicates if the operation was successful.
368      */
369     function mint(address to, uint256 value) public onlyMinter returns (bool) {
370         _mint(to, value);
371         return true;
372     }
373 }
374 
375 /**
376  * @title Capped token
377  * @dev Mintable token with a token cap.
378  */
379 contract ERC20Capped is ERC20Mintable {
380     uint256 private _cap;
381 
382     constructor (uint256 cap) public {
383         require(cap > 0);
384         _cap = cap;
385     }
386 
387     /**
388      * @return the cap for the token minting.
389      */
390     function cap() public view returns (uint256) {
391         return _cap;
392     }
393 
394     function _mint(address account, uint256 value) internal {
395         require(totalSupply().add(value) <= _cap);
396         super._mint(account, value);
397     }
398 }
399 
400 contract NeoAdam is ERC20Capped(10000000000 ether) {
401    string public name = "NeoAdam";
402    string public symbol = "NADM";
403    uint8 public decimals = 18;
404    address public CFO;
405    address public CEO;
406 
407    constructor () public {
408        CEO = msg.sender;
409        CFO = msg.sender;
410    }
411 
412    function setCEO(address newCEO) external {
413        require(msg.sender == CEO);
414 
415        CEO = newCEO;
416    }
417 
418    function setCFO(address newCFO) external {
419        require(msg.sender == CEO);
420        CFO = newCFO;
421    }
422 
423    function () payable external {
424 
425    }
426 
427    function withdrawEther() external {
428        require(msg.sender == CFO || msg.sender == CEO);
429        msg.sender.transfer(address(this).balance);
430    }
431 
432    function removeMinter(address account) external {
433        require(msg.sender == CFO || msg.sender == CEO);
434        _removeMinter(account);
435    }
436 }