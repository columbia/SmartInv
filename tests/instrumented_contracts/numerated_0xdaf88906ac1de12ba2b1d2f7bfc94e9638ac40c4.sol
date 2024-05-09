1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Calculates the average of two numbers. Since these are integers,
24      * averages of an even and odd number cannot be represented, and will be
25      * rounded down.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 /**
34  * @title SafeMath
35  * @dev Unsigned math operations with safety checks that revert on error.
36  */
37 library SafeMath {
38     /**
39      * @dev Multiplies two unsigned integers, reverts on overflow.
40      */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51 
52         return c;
53     }
54 
55     /**
56      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57      */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0, "SafeMath: division by zero");
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a, "SafeMath: subtraction overflow");
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Adds two unsigned integers, reverts on overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
89      * reverts when dividing by zero.
90      */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0, "SafeMath: modulo by zero");
93         return a % b;
94     }
95 }
96 
97 /**
98  * @title Roles
99  * @dev Library for managing addresses assigned to a Role.
100  */
101 library Roles {
102     struct Role {
103         mapping (address => bool) bearer;
104     }
105 
106     /**
107      * @dev Give an account access to this role.
108      */
109     function add(Role storage role, address account) internal {
110         require(!has(role, account), "Roles: account already has role");
111         role.bearer[account] = true;
112     }
113 
114     /**
115      * @dev Remove an account's access to this role.
116      */
117     function remove(Role storage role, address account) internal {
118         require(has(role, account), "Roles: account does not have role");
119         role.bearer[account] = false;
120     }
121 
122     /**
123      * @dev Check if an account has this role.
124      * @return bool
125      */
126     function has(Role storage role, address account) internal view returns (bool) {
127         require(account != address(0), "Roles: account is the zero address");
128         return role.bearer[account];
129     }
130 }
131 
132 contract MinterRole {
133     using Roles for Roles.Role;
134 
135     event MinterAdded(address indexed account);
136     event MinterRemoved(address indexed account);
137 
138     Roles.Role private _minters;
139 
140     constructor () internal {
141         _addMinter(msg.sender);
142     }
143 
144     modifier onlyMinter() {
145         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
146         _;
147     }
148 
149     function isMinter(address account) public view returns (bool) {
150         return _minters.has(account);
151     }
152 
153     function addMinter(address account) public onlyMinter {
154         _addMinter(account);
155     }
156 
157     function renounceMinter() public {
158         _removeMinter(msg.sender);
159     }
160 
161     function _addMinter(address account) internal {
162         _minters.add(account);
163         emit MinterAdded(account);
164     }
165 
166     function _removeMinter(address account) internal {
167         _minters.remove(account);
168         emit MinterRemoved(account);
169     }
170 }
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://eips.ethereum.org/EIPS/eip-20
175  */
176 interface IERC20 {
177     function transfer(address to, uint256 value) external returns (bool);
178 
179     function approve(address spender, uint256 value) external returns (bool);
180 
181     function transferFrom(address from, address to, uint256 value) external returns (bool);
182 
183     function totalSupply() external view returns (uint256);
184 
185     function balanceOf(address who) external view returns (uint256);
186 
187     function allowance(address owner, address spender) external view returns (uint256);
188 
189     event Transfer(address indexed from, address indexed to, uint256 value);
190 
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 /**
195  * @title Standard ERC20 token
196  *
197  * @dev Implementation of the basic standard token.
198  * https://eips.ethereum.org/EIPS/eip-20
199  * Originally based on code by FirstBlood:
200  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  *
202  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
203  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
204  * compliant implementations may not do it.
205  */
206 contract ERC20 is IERC20 {
207     using SafeMath for uint256;
208 
209     mapping (address => uint256) private _balances;
210 
211     mapping (address => mapping (address => uint256)) private _allowances;
212 
213     uint256 private _totalSupply;
214 
215     /**
216      * @dev Total number of tokens in existence.
217      */
218     function totalSupply() public view returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223      * @dev Gets the balance of the specified address.
224      * @param owner The address to query the balance of.
225      * @return A uint256 representing the amount owned by the passed address.
226      */
227     function balanceOf(address owner) public view returns (uint256) {
228         return _balances[owner];
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param owner address The address which owns the funds.
234      * @param spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(address owner, address spender) public view returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     /**
242      * @dev Transfer token to a specified address.
243      * @param to The address to transfer to.
244      * @param value The amount to be transferred.
245      */
246     function transfer(address to, uint256 value) public returns (bool) {
247         _transfer(msg.sender, to, value);
248         return true;
249     }
250 
251     /**
252      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253      * Beware that changing an allowance with this method brings the risk that someone may use both the old
254      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      * @param spender The address which will spend the funds.
258      * @param value The amount of tokens to be spent.
259      */
260     function approve(address spender, uint256 value) public returns (bool) {
261         _approve(msg.sender, spender, value);
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
274         _transfer(from, to, value);
275         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
276         return true;
277     }
278 
279     /**
280      * @dev Increase the amount of tokens that an owner allowed to a spender.
281      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
282      * allowed value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      * From MonolithDAO Token.sol
285      * Emits an Approval event.
286      * @param spender The address which will spend the funds.
287      * @param addedValue The amount of tokens to increase the allowance by.
288      */
289     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
290         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
291         return true;
292     }
293 
294     /**
295      * @dev Decrease the amount of tokens that an owner allowed to a spender.
296      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
297      * allowed value is better to use this function to avoid 2 calls (and wait until
298      * the first transaction is mined)
299      * From MonolithDAO Token.sol
300      * Emits an Approval event.
301      * @param spender The address which will spend the funds.
302      * @param subtractedValue The amount of tokens to decrease the allowance by.
303      */
304     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Transfer token for a specified addresses.
311      * @param from The address to transfer from.
312      * @param to The address to transfer to.
313      * @param value The amount to be transferred.
314      */
315     function _transfer(address from, address to, uint256 value) internal {
316         require(to != address(0), "ERC20: transfer to the zero address");
317 
318         _balances[from] = _balances[from].sub(value);
319         _balances[to] = _balances[to].add(value);
320         emit Transfer(from, to, value);
321     }
322 
323     /**
324      * @dev Internal function that mints an amount of the token and assigns it to
325      * an account. This encapsulates the modification of balances such that the
326      * proper events are emitted.
327      * @param account The account that will receive the created tokens.
328      * @param value The amount that will be created.
329      */
330     function _mint(address account, uint256 value) internal {
331         require(account != address(0), "ERC20: mint to the zero address");
332 
333         _totalSupply = _totalSupply.add(value);
334         _balances[account] = _balances[account].add(value);
335         emit Transfer(address(0), account, value);
336     }
337 
338     /**
339      * @dev Internal function that burns an amount of the token of a given
340      * account.
341      * @param account The account whose tokens will be burnt.
342      * @param value The amount that will be burnt.
343      */
344     function _burn(address account, uint256 value) internal {
345         require(account != address(0), "ERC20: burn from the zero address");
346 
347         _totalSupply = _totalSupply.sub(value);
348         _balances[account] = _balances[account].sub(value);
349         emit Transfer(account, address(0), value);
350     }
351 
352     /**
353      * @dev Approve an address to spend another addresses' tokens.
354      * @param owner The address that owns the tokens.
355      * @param spender The address that will spend the tokens.
356      * @param value The number of tokens that can be spent.
357      */
358     function _approve(address owner, address spender, uint256 value) internal {
359         require(owner != address(0), "ERC20: approve from the zero address");
360         require(spender != address(0), "ERC20: approve to the zero address");
361 
362         _allowances[owner][spender] = value;
363         emit Approval(owner, spender, value);
364     }
365 
366     /**
367      * @dev Internal function that burns an amount of the token of a given
368      * account, deducting from the sender's allowance for said account. Uses the
369      * internal burn function.
370      * Emits an Approval event (reflecting the reduced allowance).
371      * @param account The account whose tokens will be burnt.
372      * @param value The amount that will be burnt.
373      */
374     function _burnFrom(address account, uint256 value) internal {
375         _burn(account, value);
376         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
377     }
378 }
379 
380 /**
381  * @title ERC20Mintable
382  * @dev ERC20 minting logic.
383  */
384 contract ERC20Mintable is ERC20, MinterRole {
385     /**
386      * @dev Function to mint tokens
387      * @param to The address that will receive the minted tokens.
388      * @param value The amount of tokens to mint.
389      * @return A boolean that indicates if the operation was successful.
390      */
391     function mint(address to, uint256 value) public onlyMinter returns (bool) {
392         _mint(to, value);
393         return true;
394     }
395 }
396 
397 /**
398  * @title ERC20Detailed token
399  * @dev The decimals are only for visualization purposes.
400  * All the operations are done using the smallest and indivisible token unit,
401  * just as on Ethereum all the operations are done in wei.
402  */
403 contract ERC20Detailed is IERC20 {
404     string private _name;
405     string private _symbol;
406     uint8 private _decimals;
407 
408     constructor (string memory name, string memory symbol, uint8 decimals) public {
409         _name = name;
410         _symbol = symbol;
411         _decimals = decimals;
412     }
413 
414     /**
415      * @return the name of the token.
416      */
417     function name() public view returns (string memory) {
418         return _name;
419     }
420 
421     /**
422      * @return the symbol of the token.
423      */
424     function symbol() public view returns (string memory) {
425         return _symbol;
426     }
427 
428     /**
429      * @return the number of decimals of the token.
430      */
431     function decimals() public view returns (uint8) {
432         return _decimals;
433     }
434 }
435 
436 /**
437  * @title Capped token
438  * @dev Mintable token with a token cap.
439  */
440 contract ERC20Capped is ERC20Mintable {
441     uint256 private _cap;
442 
443     constructor (uint256 cap) public {
444         require(cap > 0, "ERC20Capped: cap is 0");
445         _cap = cap;
446     }
447 
448     /**
449      * @return the cap for the token minting.
450      */
451     function cap() public view returns (uint256) {
452         return _cap;
453     }
454 
455     function _mint(address account, uint256 value) internal {
456         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
457         super._mint(account, value);
458     }
459 }
460 
461 contract EPK is ERC20Capped, ERC20Detailed {
462 
463     constructor(uint256 cap, string memory name, string memory symbol, uint8 decimals)
464     ERC20Capped(cap) ERC20Detailed(name, symbol, decimals) public {}
465 
466 }