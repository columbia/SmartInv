1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping(address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev remove an account's access to this role
22      */
23     function remove(Role storage role, address account) internal {
24         require(account != address(0));
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev check if an account has this role
30      * @return bool
31      */
32     function has(Role storage role, address account)
33     internal
34     view
35     returns (bool)
36     {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that revert on error
45  */
46 library SafeMath {
47 
48     /**
49     * @dev Multiplies two numbers, reverts on overflow.
50     */
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b);
61 
62         return c;
63     }
64 
65     /**
66     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
67     */
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b > 0);
70         // Solidity only automatically asserts when dividing by 0
71         uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74         return c;
75     }
76 
77     /**
78     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b <= a);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88     * @dev Adds two numbers, reverts on overflow.
89     */
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a);
93 
94         return c;
95     }
96 
97     /**
98     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
99     * reverts when dividing by zero.
100     */
101     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b != 0);
103         return a % b;
104     }
105 }
106 
107 contract MinterRole {
108     using Roles for Roles.Role;
109 
110     event MinterAdded(address indexed account);
111     event MinterRemoved(address indexed account);
112 
113     Roles.Role private minters;
114 
115     constructor() public {
116         minters.add(msg.sender);
117     }
118 
119     modifier onlyMinter() {
120         require(isMinter(msg.sender));
121         _;
122     }
123 
124     function isMinter(address account) public view returns (bool) {
125         return minters.has(account);
126     }
127 
128     function addMinter(address account) public onlyMinter {
129         minters.add(account);
130         emit MinterAdded(account);
131     }
132 
133     function renounceMinter() public {
134         minters.remove(msg.sender);
135     }
136 
137     function _removeMinter(address account) internal {
138         minters.remove(account);
139         emit MinterRemoved(account);
140     }
141 }
142 
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 interface IERC20 {
149     function totalSupply() external view returns (uint256);
150 
151     function balanceOf(address who) external view returns (uint256);
152 
153     function allowance(address owner, address spender)
154     external view returns (uint256);
155 
156     function transfer(address to, uint256 value) external returns (bool);
157 
158     function approve(address spender, uint256 value)
159     external returns (bool);
160 
161     function transferFrom(address from, address to, uint256 value)
162     external returns (bool);
163 
164     event Transfer(
165         address indexed from,
166         address indexed to,
167         uint256 value
168     );
169 
170     event Approval(
171         address indexed owner,
172         address indexed spender,
173         uint256 value
174     );
175 }
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
182  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract ERC20 is IERC20 {
185     using SafeMath for uint256;
186 
187     mapping(address => uint256) private _balances;
188 
189     mapping(address => mapping(address => uint256)) private _allowed;
190 
191     uint256 private _totalSupply;
192 
193     /**
194     * @dev Total number of tokens in existence
195     */
196     function totalSupply() public view returns (uint256) {
197         return _totalSupply;
198     }
199 
200     /**
201     * @dev Gets the balance of the specified address.
202     * @param owner The address to query the balance of.
203     * @return An uint256 representing the amount owned by the passed address.
204     */
205     function balanceOf(address owner) public view returns (uint256) {
206         return _balances[owner];
207     }
208 
209     /**
210      * @dev Function to check the amount of tokens that an owner allowed to a spender.
211      * @param owner address The address which owns the funds.
212      * @param spender address The address which will spend the funds.
213      * @return A uint256 specifying the amount of tokens still available for the spender.
214      */
215     function allowance(
216         address owner,
217         address spender
218     )
219     public
220     view
221     returns (uint256)
222     {
223         return _allowed[owner][spender];
224     }
225 
226     /**
227     * @dev Transfer token for a specified address
228     * @param to The address to transfer to.
229     * @param value The amount to be transferred.
230     */
231     function transfer(address to, uint256 value) public returns (bool) {
232         require(value <= _balances[msg.sender]);
233         require(to != address(0));
234 
235         _balances[msg.sender] = _balances[msg.sender].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(msg.sender, to, value);
238         return true;
239     }
240 
241     /**
242      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243      * Beware that changing an allowance with this method brings the risk that someone may use both the old
244      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247      * @param spender The address which will spend the funds.
248      * @param value The amount of tokens to be spent.
249      */
250     function approve(address spender, uint256 value) public returns (bool) {
251         require(spender != address(0));
252 
253         _allowed[msg.sender][spender] = value;
254         emit Approval(msg.sender, spender, value);
255         return true;
256     }
257 
258     /**
259      * @dev Transfer tokens from one address to another
260      * @param from address The address which you want to send tokens from
261      * @param to address The address which you want to transfer to
262      * @param value uint256 the amount of tokens to be transferred
263      */
264     function transferFrom(
265         address from,
266         address to,
267         uint256 value
268     )
269     public
270     returns (bool)
271     {
272         require(value <= _balances[from]);
273         require(value <= _allowed[from][msg.sender]);
274         require(to != address(0));
275 
276         _balances[from] = _balances[from].sub(value);
277         _balances[to] = _balances[to].add(value);
278         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
279         emit Transfer(from, to, value);
280         return true;
281     }
282 
283     /**
284      * @dev Increase the amount of tokens that an owner allowed to a spender.
285      * approve should be called when allowed_[_spender] == 0. To increment
286      * allowed value is better to use this function to avoid 2 calls (and wait until
287      * the first transaction is mined)
288      * From MonolithDAO Token.sol
289      * @param spender The address which will spend the funds.
290      * @param addedValue The amount of tokens to increase the allowance by.
291      */
292     function increaseAllowance(
293         address spender,
294         uint256 addedValue
295     )
296     public
297     returns (bool)
298     {
299         require(spender != address(0));
300 
301         _allowed[msg.sender][spender] = (
302         _allowed[msg.sender][spender].add(addedValue));
303         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
304         return true;
305     }
306 
307     /**
308      * @dev Decrease the amount of tokens that an owner allowed to a spender.
309      * approve should be called when allowed_[_spender] == 0. To decrement
310      * allowed value is better to use this function to avoid 2 calls (and wait until
311      * the first transaction is mined)
312      * From MonolithDAO Token.sol
313      * @param spender The address which will spend the funds.
314      * @param subtractedValue The amount of tokens to decrease the allowance by.
315      */
316     function decreaseAllowance(
317         address spender,
318         uint256 subtractedValue
319     )
320     public
321     returns (bool)
322     {
323         require(spender != address(0));
324 
325         _allowed[msg.sender][spender] = (
326         _allowed[msg.sender][spender].sub(subtractedValue));
327         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
328         return true;
329     }
330 
331     /**
332      * @dev Internal function that mints an amount of the token and assigns it to
333      * an account. This encapsulates the modification of balances such that the
334      * proper events are emitted.
335      * @param account The account that will receive the created tokens.
336      * @param amount The amount that will be created.
337      */
338     function _mint(address account, uint256 amount) internal {
339         require(account != 0);
340         _totalSupply = _totalSupply.add(amount);
341         _balances[account] = _balances[account].add(amount);
342         emit Transfer(address(0), account, amount);
343     }
344 
345     /**
346      * @dev Internal function that burns an amount of the token of a given
347      * account.
348      * @param account The account whose tokens will be burnt.
349      * @param amount The amount that will be burnt.
350      */
351     function _burn(address account, uint256 amount) internal {
352         require(account != 0);
353         require(amount <= _balances[account]);
354 
355         _totalSupply = _totalSupply.sub(amount);
356         _balances[account] = _balances[account].sub(amount);
357         emit Transfer(account, address(0), amount);
358     }
359 
360     /**
361      * @dev Internal function that burns an amount of the token of a given
362      * account, deducting from the sender's allowance for said account. Uses the
363      * internal burn function.
364      * @param account The account whose tokens will be burnt.
365      * @param amount The amount that will be burnt.
366      */
367     function _burnFrom(address account, uint256 amount) internal {
368         require(amount <= _allowed[account][msg.sender]);
369 
370         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
371         // this function needs to emit an event with the updated approval.
372         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
373             amount);
374         _burn(account, amount);
375     }
376 }
377 /**
378  * @title ERC20Mintable
379  * @dev ERC20 minting logic
380  */
381 contract ERC20Mintable is ERC20, MinterRole {
382     event MintingFinished();
383 
384     bool private _mintingFinished = false;
385 
386     modifier onlyBeforeMintingFinished() {
387         require(!_mintingFinished);
388         _;
389     }
390 
391     /**
392      * @return true if the minting is finished.
393      */
394     function mintingFinished() public view returns (bool) {
395         return _mintingFinished;
396     }
397 
398     /**
399      * @dev Function to mint tokens
400      * @param to The address that will receive the minted tokens.
401      * @param amount The amount of tokens to mint.
402      * @return A boolean that indicates if the operation was successful.
403      */
404     function mint(
405         address to,
406         uint256 amount
407     )
408     public
409     onlyMinter
410     onlyBeforeMintingFinished
411     returns (bool)
412     {
413         _mint(to, amount);
414         return true;
415     }
416 
417     /**
418      * @dev Function to stop minting new tokens.
419      * @return True if the operation was successful.
420      */
421     function finishMinting()
422     public
423     onlyMinter
424     onlyBeforeMintingFinished
425     returns (bool)
426     {
427         _mintingFinished = true;
428         emit MintingFinished();
429         return true;
430     }
431 }
432 
433 
434 /**
435  * @title Burnable Token
436  * @dev Token that can be irreversibly burned (destroyed).
437  */
438 contract ERC20Burnable is ERC20 {
439 
440     /**
441      * @dev Burns a specific amount of tokens.
442      * @param value The amount of token to be burned.
443      */
444     function burn(uint256 value) public {
445         _burn(msg.sender, value);
446     }
447 
448     /**
449      * @dev Burns a specific amount of tokens from the target address and decrements allowance
450      * @param from address The address which you want to send tokens from
451      * @param value uint256 The amount of token to be burned
452      */
453     function burnFrom(address from, uint256 value) public {
454         _burnFrom(from, value);
455     }
456 
457     /**
458      * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
459      * an additional Burn event.
460      */
461     function _burn(address who, uint256 value) internal {
462         super._burn(who, value);
463     }
464 }
465 
466 
467 /**
468  * @title SimpleToken
469  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
470  * Note they can later distribute these tokens as they wish using `transfer` and other
471  * `ERC20` functions.
472  */
473 contract OnePerfectCoin is ERC20Mintable, ERC20Burnable {
474 
475     string public constant name = "One Perfect Coin";
476     string public constant symbol = "OPC";
477     uint8 public constant decimals = 18;
478 
479     uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** uint256(decimals));
480 
481     /**
482      * @dev Constructor that gives msg.sender all of existing tokens.
483      */
484     constructor() public {
485         _mint(msg.sender, INITIAL_SUPPLY);
486     }
487 
488 }