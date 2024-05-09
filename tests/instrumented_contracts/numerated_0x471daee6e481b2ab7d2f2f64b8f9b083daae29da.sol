1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol
45 
46 contract MinterRole {
47     using Roles for Roles.Role;
48 
49     event MinterAdded(address indexed account);
50     event MinterRemoved(address indexed account);
51 
52     Roles.Role private _minters;
53 
54     constructor () internal {
55         _addMinter(msg.sender);
56     }
57 
58     modifier onlyMinter() {
59         require(isMinter(msg.sender));
60         _;
61     }
62 
63     function isMinter(address account) public view returns (bool) {
64         return _minters.has(account);
65     }
66 
67     function addMinter(address account) public onlyMinter {
68         _addMinter(account);
69     }
70 
71     function renounceMinter() public {
72         _removeMinter(msg.sender);
73     }
74 
75     function _addMinter(address account) internal {
76         _minters.add(account);
77         emit MinterAdded(account);
78     }
79 
80     function _removeMinter(address account) internal {
81         _minters.remove(account);
82         emit MinterRemoved(account);
83     }
84 }
85 
86 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
87 
88 /**
89  * @title SafeMath
90  * @dev Unsigned math operations with safety checks that revert on error
91  */
92 library SafeMath {
93     /**
94     * @dev Multiplies two unsigned integers, reverts on overflow.
95     */
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint256 c = a * b;
105         require(c / a == b);
106 
107         return c;
108     }
109 
110     /**
111     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
112     */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
124     */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b <= a);
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133     * @dev Adds two unsigned integers, reverts on overflow.
134     */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a);
138 
139         return c;
140     }
141 
142     /**
143     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
144     * reverts when dividing by zero.
145     */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         require(b != 0);
148         return a % b;
149     }
150 }
151 
152 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 interface IERC20 {
159     function transfer(address to, uint256 value) external returns (bool);
160 
161     function approve(address spender, uint256 value) external returns (bool);
162 
163     function transferFrom(address from, address to, uint256 value) external returns (bool);
164 
165     function totalSupply() external view returns (uint256);
166 
167     function balanceOf(address who) external view returns (uint256);
168 
169     function allowance(address owner, address spender) external view returns (uint256);
170 
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
183  * Originally based on code by FirstBlood:
184  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  *
186  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
187  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
188  * compliant implementations may not do it.
189  */
190 contract ERC20 is IERC20 {
191     using SafeMath for uint256;
192 
193     mapping (address => uint256) private _balances;
194 
195     mapping (address => mapping (address => uint256)) private _allowed;
196 
197     uint256 private _totalSupply;
198 
199     /**
200     * @dev Total number of tokens in existence
201     */
202     function totalSupply() public view returns (uint256) {
203         return _totalSupply;
204     }
205 
206     /**
207     * @dev Gets the balance of the specified address.
208     * @param owner The address to query the balance of.
209     * @return An uint256 representing the amount owned by the passed address.
210     */
211     function balanceOf(address owner) public view returns (uint256) {
212         return _balances[owner];
213     }
214 
215     /**
216      * @dev Function to check the amount of tokens that an owner allowed to a spender.
217      * @param owner address The address which owns the funds.
218      * @param spender address The address which will spend the funds.
219      * @return A uint256 specifying the amount of tokens still available for the spender.
220      */
221     function allowance(address owner, address spender) public view returns (uint256) {
222         return _allowed[owner][spender];
223     }
224 
225     /**
226     * @dev Transfer token for a specified address
227     * @param to The address to transfer to.
228     * @param value The amount to be transferred.
229     */
230     function transfer(address to, uint256 value) public returns (bool) {
231         _transfer(msg.sender, to, value);
232         return true;
233     }
234 
235     /**
236      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237      * Beware that changing an allowance with this method brings the risk that someone may use both the old
238      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      * @param spender The address which will spend the funds.
242      * @param value The amount of tokens to be spent.
243      */
244     function approve(address spender, uint256 value) public returns (bool) {
245         require(spender != address(0));
246 
247         _allowed[msg.sender][spender] = value;
248         emit Approval(msg.sender, spender, value);
249         return true;
250     }
251 
252     /**
253      * @dev Transfer tokens from one address to another.
254      * Note that while this function emits an Approval event, this is not required as per the specification,
255      * and other compliant implementations may not emit the event.
256      * @param from address The address which you want to send tokens from
257      * @param to address The address which you want to transfer to
258      * @param value uint256 the amount of tokens to be transferred
259      */
260     function transferFrom(address from, address to, uint256 value) public returns (bool) {
261         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
262         _transfer(from, to, value);
263         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
264         return true;
265     }
266 
267     /**
268      * @dev Increase the amount of tokens that an owner allowed to a spender.
269      * approve should be called when allowed_[_spender] == 0. To increment
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * Emits an Approval event.
274      * @param spender The address which will spend the funds.
275      * @param addedValue The amount of tokens to increase the allowance by.
276      */
277     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
278         require(spender != address(0));
279 
280         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
281         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282         return true;
283     }
284 
285     /**
286      * @dev Decrease the amount of tokens that an owner allowed to a spender.
287      * approve should be called when allowed_[_spender] == 0. To decrement
288      * allowed value is better to use this function to avoid 2 calls (and wait until
289      * the first transaction is mined)
290      * From MonolithDAO Token.sol
291      * Emits an Approval event.
292      * @param spender The address which will spend the funds.
293      * @param subtractedValue The amount of tokens to decrease the allowance by.
294      */
295     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
296         require(spender != address(0));
297 
298         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
299         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300         return true;
301     }
302 
303     /**
304     * @dev Transfer token for a specified addresses
305     * @param from The address to transfer from.
306     * @param to The address to transfer to.
307     * @param value The amount to be transferred.
308     */
309     function _transfer(address from, address to, uint256 value) internal {
310         require(to != address(0));
311 
312         _balances[from] = _balances[from].sub(value);
313         _balances[to] = _balances[to].add(value);
314         emit Transfer(from, to, value);
315     }
316 
317     /**
318      * @dev Internal function that mints an amount of the token and assigns it to
319      * an account. This encapsulates the modification of balances such that the
320      * proper events are emitted.
321      * @param account The account that will receive the created tokens.
322      * @param value The amount that will be created.
323      */
324     function _mint(address account, uint256 value) internal {
325         require(account != address(0));
326 
327         _totalSupply = _totalSupply.add(value);
328         _balances[account] = _balances[account].add(value);
329         emit Transfer(address(0), account, value);
330     }
331 
332     /**
333      * @dev Internal function that burns an amount of the token of a given
334      * account.
335      * @param account The account whose tokens will be burnt.
336      * @param value The amount that will be burnt.
337      */
338     function _burn(address account, uint256 value) internal {
339         require(account != address(0));
340 
341         _totalSupply = _totalSupply.sub(value);
342         _balances[account] = _balances[account].sub(value);
343         emit Transfer(account, address(0), value);
344     }
345 
346     /**
347      * @dev Internal function that burns an amount of the token of a given
348      * account, deducting from the sender's allowance for said account. Uses the
349      * internal burn function.
350      * Emits an Approval event (reflecting the reduced allowance).
351      * @param account The account whose tokens will be burnt.
352      * @param value The amount that will be burnt.
353      */
354     function _burnFrom(address account, uint256 value) internal {
355         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
356         _burn(account, value);
357         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
358     }
359 }
360 
361 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
362 
363 /**
364  * @title Burnable Token
365  * @dev Token that can be irreversibly burned (destroyed).
366  */
367 contract ERC20Burnable is ERC20 {
368     /**
369      * @dev Burns a specific amount of tokens.
370      * @param value The amount of token to be burned.
371      */
372     function burn(uint256 value) public {
373         _burn(msg.sender, value);
374     }
375 
376     /**
377      * @dev Burns a specific amount of tokens from the target address and decrements allowance
378      * @param from address The address which you want to send tokens from
379      * @param value uint256 The amount of token to be burned
380      */
381     function burnFrom(address from, uint256 value) public {
382         _burnFrom(from, value);
383     }
384 }
385 
386 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
387 
388 /**
389  * @title ERC20Detailed token
390  * @dev The decimals are only for visualization purposes.
391  * All the operations are done using the smallest and indivisible token unit,
392  * just as on Ethereum all the operations are done in wei.
393  */
394 contract ERC20Detailed is IERC20 {
395     string private _name;
396     string private _symbol;
397     uint8 private _decimals;
398 
399     constructor (string memory name, string memory symbol, uint8 decimals) public {
400         _name = name;
401         _symbol = symbol;
402         _decimals = decimals;
403     }
404 
405     /**
406      * @return the name of the token.
407      */
408     function name() public view returns (string memory) {
409         return _name;
410     }
411 
412     /**
413      * @return the symbol of the token.
414      */
415     function symbol() public view returns (string memory) {
416         return _symbol;
417     }
418 
419     /**
420      * @return the number of decimals of the token.
421      */
422     function decimals() public view returns (uint8) {
423         return _decimals;
424     }
425 }
426 
427 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
428 
429 /**
430  * @title ERC20Mintable
431  * @dev ERC20 minting logic
432  */
433 contract ERC20Mintable is ERC20, MinterRole {
434     /**
435      * @dev Function to mint tokens
436      * @param to The address that will receive the minted tokens.
437      * @param value The amount of tokens to mint.
438      * @return A boolean that indicates if the operation was successful.
439      */
440     function mint(address to, uint256 value) public onlyMinter returns (bool) {
441         _mint(to, value);
442         return true;
443     }
444 }
445 
446 // File: contracts/Hops.sol
447 
448 contract MinterRoleMock is MinterRole {
449   function removeMinter(address account) public {
450     _removeMinter(account);
451   }
452 
453   function onlyMinterMock() public view onlyMinter {
454   }
455 
456   // Causes a compilation error if super._removeMinter is not internal
457   function _removeMinter(address account) internal {
458     super._removeMinter(account);
459   }
460 }
461 contract HopsToken is ERC20Mintable, MinterRoleMock, ERC20Burnable, ERC20Detailed {
462   constructor (string name, string symbol, uint8 decimals)
463   ERC20Detailed(name, symbol, decimals) public {}
464 }