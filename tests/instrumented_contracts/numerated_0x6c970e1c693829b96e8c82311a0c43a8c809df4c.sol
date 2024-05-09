1 pragma solidity ^0.5.2;
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
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32      * @dev Multiplies two unsigned integers, reverts on overflow.
33      */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50      */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Adds two unsigned integers, reverts on overflow.
72      */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82      * reverts when dividing by zero.
83      */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * https://eips.ethereum.org/EIPS/eip-20
97  * Originally based on code by FirstBlood:
98  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  *
100  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
101  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
102  * compliant implementations may not do it.
103  */
104 contract ERC20 is IERC20 {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) private _balances;
108 
109     mapping (address => mapping (address => uint256)) private _allowed;
110 
111     uint256 private _totalSupply;
112 
113     /**
114      * @dev Total number of tokens in existence
115      */
116     function totalSupply() public view returns (uint256) {
117         return _totalSupply;
118     }
119 
120     /**
121      * @dev Gets the balance of the specified address.
122      * @param owner The address to query the balance of.
123      * @return A uint256 representing the amount owned by the passed address.
124      */
125     function balanceOf(address owner) public view returns (uint256) {
126         return _balances[owner];
127     }
128 
129     /**
130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
131      * @param owner address The address which owns the funds.
132      * @param spender address The address which will spend the funds.
133      * @return A uint256 specifying the amount of tokens still available for the spender.
134      */
135     function allowance(address owner, address spender) public view returns (uint256) {
136         return _allowed[owner][spender];
137     }
138 
139     /**
140      * @dev Transfer token to a specified address
141      * @param to The address to transfer to.
142      * @param value The amount to be transferred.
143      */
144     function transfer(address to, uint256 value) public returns (bool) {
145         _transfer(msg.sender, to, value);
146         return true;
147     }
148 
149     /**
150      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151      * Beware that changing an allowance with this method brings the risk that someone may use both the old
152      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      * @param spender The address which will spend the funds.
156      * @param value The amount of tokens to be spent.
157      */
158     function approve(address spender, uint256 value) public returns (bool) {
159         _approve(msg.sender, spender, value);
160         return true;
161     }
162 
163     /**
164      * @dev Transfer tokens from one address to another.
165      * Note that while this function emits an Approval event, this is not required as per the specification,
166      * and other compliant implementations may not emit the event.
167      * @param from address The address which you want to send tokens from
168      * @param to address The address which you want to transfer to
169      * @param value uint256 the amount of tokens to be transferred
170      */
171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
172         _transfer(from, to, value);
173         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
174         return true;
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param addedValue The amount of tokens to increase the allowance by.
186      */
187     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
188         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
189         return true;
190     }
191 
192     /**
193      * @dev Decrease the amount of tokens that an owner allowed to a spender.
194      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      * Emits an Approval event.
199      * @param spender The address which will spend the funds.
200      * @param subtractedValue The amount of tokens to decrease the allowance by.
201      */
202     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
203         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
204         return true;
205     }
206 
207     /**
208      * @dev Transfer token for a specified addresses
209      * @param from The address to transfer from.
210      * @param to The address to transfer to.
211      * @param value The amount to be transferred.
212      */
213     function _transfer(address from, address to, uint256 value) internal {
214         require(to != address(0));
215 
216         _balances[from] = _balances[from].sub(value);
217         _balances[to] = _balances[to].add(value);
218         emit Transfer(from, to, value);
219     }
220 
221     /**
222      * @dev Internal function that mints an amount of the token and assigns it to
223      * an account. This encapsulates the modification of balances such that the
224      * proper events are emitted.
225      * @param account The account that will receive the created tokens.
226      * @param value The amount that will be created.
227      */
228     function _mint(address account, uint256 value) internal {
229         require(account != address(0));
230 
231         _totalSupply = _totalSupply.add(value);
232         _balances[account] = _balances[account].add(value);
233         emit Transfer(address(0), account, value);
234     }
235 
236     /**
237      * @dev Internal function that burns an amount of the token of a given
238      * account.
239      * @param account The account whose tokens will be burnt.
240      * @param value The amount that will be burnt.
241      */
242     function _burn(address account, uint256 value) internal {
243         require(account != address(0));
244 
245         _totalSupply = _totalSupply.sub(value);
246         _balances[account] = _balances[account].sub(value);
247         emit Transfer(account, address(0), value);
248     }
249 
250     /**
251      * @dev Approve an address to spend another addresses' tokens.
252      * @param owner The address that owns the tokens.
253      * @param spender The address that will spend the tokens.
254      * @param value The number of tokens that can be spent.
255      */
256     function _approve(address owner, address spender, uint256 value) internal {
257         require(spender != address(0));
258         require(owner != address(0));
259 
260         _allowed[owner][spender] = value;
261         emit Approval(owner, spender, value);
262     }
263 
264     /**
265      * @dev Internal function that burns an amount of the token of a given
266      * account, deducting from the sender's allowance for said account. Uses the
267      * internal burn function.
268      * Emits an Approval event (reflecting the reduced allowance).
269      * @param account The account whose tokens will be burnt.
270      * @param value The amount that will be burnt.
271      */
272     function _burnFrom(address account, uint256 value) internal {
273         _burn(account, value);
274         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
275     }
276 }
277 
278 
279 
280 /**
281  * @title ERC20Detailed token
282  * @dev The decimals are only for visualization purposes.
283  * All the operations are done using the smallest and indivisible token unit,
284  * just as on Ethereum all the operations are done in wei.
285  */
286 contract ERC20Detailed is IERC20 {
287     string private _name;
288     string private _symbol;
289     uint8 private _decimals;
290 
291     constructor (string memory name, string memory symbol, uint8 decimals) public {
292         _name = name;
293         _symbol = symbol;
294         _decimals = decimals;
295     }
296 
297     /**
298      * @return the name of the token.
299      */
300     function name() public view returns (string memory) {
301         return _name;
302     }
303 
304     /**
305      * @return the symbol of the token.
306      */
307     function symbol() public view returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @return the number of decimals of the token.
313      */
314     function decimals() public view returns (uint8) {
315         return _decimals;
316     }
317 }
318 
319 
320 /**
321  * @title Roles
322  * @dev Library for managing addresses assigned to a Role.
323  */
324 library Roles {
325     struct Role {
326         mapping (address => bool) bearer;
327     }
328 
329     /**
330      * @dev give an account access to this role
331      */
332     function add(Role storage role, address account) internal {
333         require(account != address(0));
334         require(!has(role, account));
335 
336         role.bearer[account] = true;
337     }
338 
339     /**
340      * @dev remove an account's access to this role
341      */
342     function remove(Role storage role, address account) internal {
343         require(account != address(0));
344         require(has(role, account));
345 
346         role.bearer[account] = false;
347     }
348 
349     /**
350      * @dev check if an account has this role
351      * @return bool
352      */
353     function has(Role storage role, address account) internal view returns (bool) {
354         require(account != address(0));
355         return role.bearer[account];
356     }
357 }
358 
359 
360 
361 contract MinterRole {
362     using Roles for Roles.Role;
363 
364     event MinterAdded(address indexed account);
365     event MinterRemoved(address indexed account);
366 
367     Roles.Role private _minters;
368 
369     constructor () internal {
370         _addMinter(msg.sender);
371     }
372 
373     modifier onlyMinter() {
374         require(isMinter(msg.sender));
375         _;
376     }
377 
378     function isMinter(address account) public view returns (bool) {
379         return _minters.has(account);
380     }
381 
382     function addMinter(address account) public onlyMinter {
383         _addMinter(account);
384     }
385 
386     function renounceMinter() public {
387         _removeMinter(msg.sender);
388     }
389 
390     function _addMinter(address account) internal {
391         _minters.add(account);
392         emit MinterAdded(account);
393     }
394 
395     function _removeMinter(address account) internal {
396         _minters.remove(account);
397         emit MinterRemoved(account);
398     }
399 }
400 
401 
402 
403 
404 /**
405  * @title ERC20Mintable
406  * @dev ERC20 minting logic
407  */
408 contract ERC20Mintable is ERC20, MinterRole {
409     /**
410      * @dev Function to mint tokens
411      * @param to The address that will receive the minted tokens.
412      * @param value The amount of tokens to mint.
413      * @return A boolean that indicates if the operation was successful.
414      */
415     function mint(address to, uint256 value) public onlyMinter returns (bool) {
416         _mint(to, value);
417         return true;
418     }
419 }
420 
421 
422 /**
423  * @title Burnable Token
424  * @dev Token that can be irreversibly burned (destroyed).
425  */
426 contract ERC20Burnable is ERC20 {
427     /**
428      * @dev Burns a specific amount of tokens.
429      * @param value The amount of token to be burned.
430      */
431     function burn(uint256 value) public {
432         _burn(msg.sender, value);
433     }
434 
435     /**
436      * @dev Burns a specific amount of tokens from the target address and decrements allowance
437      * @param from address The account whose tokens will be burned.
438      * @param value uint256 The amount of token to be burned.
439      */
440     function burnFrom(address from, uint256 value) public {
441         _burnFrom(from, value);
442     }
443 }
444 
445 
446 
447 
448 
449 contract CMT is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
450 
451     string public tokenName = "ChainMall Token";
452     string public tokenSymbol = "CMT";
453     uint8 public tokenDecimals = 18;
454     uint256 public tokenTotalSupply = 1000000000;
455 
456     constructor()
457     ERC20Burnable()
458     ERC20Mintable()
459     ERC20Detailed(tokenName, tokenSymbol, tokenDecimals)
460     ERC20()
461     public
462     {
463         _mint(msg.sender, tokenTotalSupply.mul(10 ** uint256(tokenDecimals)));
464     }
465 
466 }