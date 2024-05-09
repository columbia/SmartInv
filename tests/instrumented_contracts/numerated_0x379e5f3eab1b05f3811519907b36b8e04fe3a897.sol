1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
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
25 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
26 
27 pragma solidity ^0.5.0;
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
94 
95 pragma solidity ^0.5.0;
96 
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
104  * Originally based on code by FirstBlood:
105  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  *
107  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
108  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
109  * compliant implementations may not do it.
110  */
111 contract ERC20 is IERC20 {
112     using SafeMath for uint256;
113 
114     mapping (address => uint256) private _balances;
115 
116     mapping (address => mapping (address => uint256)) private _allowed;
117 
118     uint256 private _totalSupply;
119 
120     /**
121      * @dev Total number of tokens in existence
122      */
123     function totalSupply() public view returns (uint256) {
124         return _totalSupply;
125     }
126 
127     /**
128      * @dev Gets the balance of the specified address.
129      * @param owner The address to query the balance of.
130      * @return An uint256 representing the amount owned by the passed address.
131      */
132     function balanceOf(address owner) public view returns (uint256) {
133         return _balances[owner];
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      * @param owner address The address which owns the funds.
139      * @param spender address The address which will spend the funds.
140      * @return A uint256 specifying the amount of tokens still available for the spender.
141      */
142     function allowance(address owner, address spender) public view returns (uint256) {
143         return _allowed[owner][spender];
144     }
145 
146     /**
147      * @dev Transfer token for a specified address
148      * @param to The address to transfer to.
149      * @param value The amount to be transferred.
150      */
151     function transfer(address to, uint256 value) public returns (bool) {
152         _transfer(msg.sender, to, value);
153         return true;
154     }
155 
156     /**
157      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param spender The address which will spend the funds.
163      * @param value The amount of tokens to be spent.
164      */
165     function approve(address spender, uint256 value) public returns (bool) {
166         _approve(msg.sender, spender, value);
167         return true;
168     }
169 
170     /**
171      * @dev Transfer tokens from one address to another.
172      * Note that while this function emits an Approval event, this is not required as per the specification,
173      * and other compliant implementations may not emit the event.
174      * @param from address The address which you want to send tokens from
175      * @param to address The address which you want to transfer to
176      * @param value uint256 the amount of tokens to be transferred
177      */
178     function transferFrom(address from, address to, uint256 value) public returns (bool) {
179         _transfer(from, to, value);
180         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
196         return true;
197     }
198 
199     /**
200      * @dev Decrease the amount of tokens that an owner allowed to a spender.
201      * approve should be called when allowed_[_spender] == 0. To decrement
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param subtractedValue The amount of tokens to decrease the allowance by.
208      */
209     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
210         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
211         return true;
212     }
213 
214     /**
215      * @dev Transfer token for a specified addresses
216      * @param from The address to transfer from.
217      * @param to The address to transfer to.
218      * @param value The amount to be transferred.
219      */
220     function _transfer(address from, address to, uint256 value) internal {
221         require(to != address(0));
222 
223         _balances[from] = _balances[from].sub(value);
224         _balances[to] = _balances[to].add(value);
225         emit Transfer(from, to, value);
226     }
227 
228     /**
229      * @dev Internal function that mints an amount of the token and assigns it to
230      * an account. This encapsulates the modification of balances such that the
231      * proper events are emitted.
232      * @param account The account that will receive the created tokens.
233      * @param value The amount that will be created.
234      */
235     function _mint(address account, uint256 value) internal {
236         require(account != address(0));
237 
238         _totalSupply = _totalSupply.add(value);
239         _balances[account] = _balances[account].add(value);
240         emit Transfer(address(0), account, value);
241     }
242 
243     /**
244      * @dev Internal function that burns an amount of the token of a given
245      * account.
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burn(address account, uint256 value) internal {
250         require(account != address(0));
251 
252         _totalSupply = _totalSupply.sub(value);
253         _balances[account] = _balances[account].sub(value);
254         emit Transfer(account, address(0), value);
255     }
256 
257     /**
258      * @dev Approve an address to spend another addresses' tokens.
259      * @param owner The address that owns the tokens.
260      * @param spender The address that will spend the tokens.
261      * @param value The number of tokens that can be spent.
262      */
263     function _approve(address owner, address spender, uint256 value) internal {
264         require(spender != address(0));
265         require(owner != address(0));
266 
267         _allowed[owner][spender] = value;
268         emit Approval(owner, spender, value);
269     }
270 
271     /**
272      * @dev Internal function that burns an amount of the token of a given
273      * account, deducting from the sender's allowance for said account. Uses the
274      * internal burn function.
275      * Emits an Approval event (reflecting the reduced allowance).
276      * @param account The account whose tokens will be burnt.
277      * @param value The amount that will be burnt.
278      */
279     function _burnFrom(address account, uint256 value) internal {
280         _burn(account, value);
281         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
282     }
283 }
284 
285 // File: contracts\open-zeppelin-contracts\access\Roles.sol
286 
287 pragma solidity ^0.5.0;
288 
289 /**
290  * @title Roles
291  * @dev Library for managing addresses assigned to a Role.
292  */
293 library Roles {
294     struct Role {
295         mapping (address => bool) bearer;
296     }
297 
298     /**
299      * @dev give an account access to this role
300      */
301     function add(Role storage role, address account) internal {
302         require(account != address(0));
303         require(!has(role, account));
304 
305         role.bearer[account] = true;
306     }
307 
308     /**
309      * @dev remove an account's access to this role
310      */
311     function remove(Role storage role, address account) internal {
312         require(account != address(0));
313         require(has(role, account));
314 
315         role.bearer[account] = false;
316     }
317 
318     /**
319      * @dev check if an account has this role
320      * @return bool
321      */
322     function has(Role storage role, address account) internal view returns (bool) {
323         require(account != address(0));
324         return role.bearer[account];
325     }
326 }
327 
328 // File: contracts\open-zeppelin-contracts\access\roles\MinterRole.sol
329 
330 pragma solidity ^0.5.0;
331 
332 
333 contract MinterRole {
334     using Roles for Roles.Role;
335 
336     event MinterAdded(address indexed account);
337     event MinterRemoved(address indexed account);
338 
339     Roles.Role private _minters;
340 
341     constructor () internal {
342         _addMinter(msg.sender);
343     }
344 
345     modifier onlyMinter() {
346         require(isMinter(msg.sender));
347         _;
348     }
349 
350     function isMinter(address account) public view returns (bool) {
351         return _minters.has(account);
352     }
353 
354     function addMinter(address account) public onlyMinter {
355         _addMinter(account);
356     }
357 
358     function renounceMinter() public {
359         _removeMinter(msg.sender);
360     }
361 
362     function _addMinter(address account) internal {
363         _minters.add(account);
364         emit MinterAdded(account);
365     }
366 
367     function _removeMinter(address account) internal {
368         _minters.remove(account);
369         emit MinterRemoved(account);
370     }
371 }
372 
373 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20Mintable.sol
374 
375 pragma solidity ^0.5.0;
376 
377 
378 
379 /**
380  * @title ERC20Mintable
381  * @dev ERC20 minting logic
382  */
383 contract ERC20Mintable is ERC20, MinterRole {
384     /**
385      * @dev Function to mint tokens
386      * @param to The address that will receive the minted tokens.
387      * @param value The amount of tokens to mint.
388      * @return A boolean that indicates if the operation was successful.
389      */
390     function mint(address to, uint256 value) public onlyMinter returns (bool) {
391         _mint(to, value);
392         return true;
393     }
394 }
395 
396 // File: contracts\ERC20\TokenMintERC20MintableToken.sol
397 
398 pragma solidity ^0.5.0;
399 
400 
401 /**
402  * @title TokenMintERC20MintableToken
403  * @author TokenMint (visit https://tokenmint.io)
404  *
405  * @dev Mintable ERC20 token with optional functions implemented.
406  * Any address with minter role can mint new tokens.
407  * For full specification of ERC-20 standard see:
408  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
409  */
410 contract TokenMintERC20MintableToken is ERC20Mintable {
411 
412     string private _name;
413     string private _symbol;
414     uint8 private _decimals;
415 
416     constructor(string memory name, string memory symbol, uint8 decimals, uint256 initialSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
417       _name = name;
418       _symbol = symbol;
419       _decimals = decimals;
420 
421       // set tokenOwnerAddress as owner of initial supply, more tokens can be minted later
422       _mint(tokenOwnerAddress, initialSupply);
423 
424       // pay the service fee for contract deployment
425       feeReceiver.transfer(msg.value);
426     }
427 
428     /**
429      * @dev transfers minter role from msg.sender to newMinter
430      */
431     function transferMinterRole(address newMinter) public {
432       addMinter(newMinter);
433       renounceMinter();
434     }
435 
436     // optional functions from ERC20 stardard
437 
438     /**
439      * @return the name of the token.
440      */
441     function name() public view returns (string memory) {
442       return _name;
443     }
444 
445     /**
446      * @return the symbol of the token.
447      */
448     function symbol() public view returns (string memory) {
449       return _symbol;
450     }
451 
452     /**
453      * @return the number of decimals of the token.
454      */
455     function decimals() public view returns (uint8) {
456       return _decimals;
457     }
458 }