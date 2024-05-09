1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title Roles
6  * @dev Library for managing addresses assigned to a Role.
7  */
8 library Roles {
9     struct Role {
10         mapping (address => bool) bearer;
11     }
12 
13     /**
14      * @dev give an account access to this role
15      */
16     function add(Role storage role, address account) internal {
17         require(account != address(0));
18         require(!has(role, account));
19 
20         role.bearer[account] = true;
21     }
22 
23     /**
24      * @dev remove an account's access to this role
25      */
26     function remove(Role storage role, address account) internal {
27         require(account != address(0));
28         require(has(role, account));
29 
30         role.bearer[account] = false;
31     }
32 
33     /**
34      * @dev check if an account has this role
35      * @return bool
36      */
37     function has(Role storage role, address account)
38     internal
39     view
40     returns (bool)
41     {
42         require(account != address(0));
43         return role.bearer[account];
44     }
45 }
46 
47 
48 contract MinterRole {
49     using Roles for Roles.Role;
50 
51     event MinterAdded(address indexed account);
52     event MinterRemoved(address indexed account);
53 
54     Roles.Role private minters;
55 
56     constructor() internal {
57         _addMinter(msg.sender);
58     }
59 
60     modifier onlyMinter() {
61         require(isMinter(msg.sender));
62         _;
63     }
64 
65     function isMinter(address account) public view returns (bool) {
66         return minters.has(account);
67     }
68 
69     function addMinter(address account) public onlyMinter {
70         _addMinter(account);
71     }
72 
73     function renounceMinter() public {
74         _removeMinter(msg.sender);
75     }
76 
77     function _addMinter(address account) internal {
78         minters.add(account);
79         emit MinterAdded(account);
80     }
81 
82     function _removeMinter(address account) internal {
83         minters.remove(account);
84         emit MinterRemoved(account);
85     }
86 }
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that revert on error
92  */
93 library SafeMath {
94 
95     /**
96     * @dev Multiplies two numbers, reverts on overflow.
97     */
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
100         // benefit is lost if 'b' is also tested.
101         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
102         if (a == 0) {
103             return 0;
104         }
105 
106         uint256 c = a * b;
107         require(c / a == b);
108 
109         return c;
110     }
111 
112     /**
113     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
114     */
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b > 0); // Solidity only automatically asserts when dividing by 0
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119 
120         return c;
121     }
122 
123     /**
124     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
125     */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         require(b <= a);
128         uint256 c = a - b;
129 
130         return c;
131     }
132 
133     /**
134     * @dev Adds two numbers, reverts on overflow.
135     */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a);
139 
140         return c;
141     }
142 
143     /**
144     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
145     * reverts when dividing by zero.
146     */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         require(b != 0);
149         return a % b;
150     }
151 }
152 
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 interface IERC20 {
159     function totalSupply() external view returns (uint256);
160 
161     function balanceOf(address who) external view returns (uint256);
162 
163     function allowance(address owner, address spender)
164     external view returns (uint256);
165 
166     function transfer(address to, uint256 value) external returns (bool);
167 
168     function approve(address spender, uint256 value)
169     external returns (bool);
170 
171     function transferFrom(address from, address to, uint256 value)
172     external returns (bool);
173 
174     event Transfer(
175         address indexed from,
176         address indexed to,
177         uint256 value
178     );
179 
180     event Approval(
181         address indexed owner,
182         address indexed spender,
183         uint256 value
184     );
185 }
186 
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
193  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194  */
195 contract ERC20 is IERC20 {
196     using SafeMath for uint256;
197 
198     mapping (address => uint256) private _balances;
199 
200     mapping (address => mapping (address => uint256)) private _allowed;
201 
202     uint256 private _totalSupply;
203 
204     /**
205     * @dev Total number of tokens in existence
206     */
207     function totalSupply() public view returns (uint256) {
208         return _totalSupply;
209     }
210 
211     /**
212     * @dev Gets the balance of the specified address.
213     * @param owner The address to query the balance of.
214     * @return An uint256 representing the amount owned by the passed address.
215     */
216     function balanceOf(address owner) public view returns (uint256) {
217         return _balances[owner];
218     }
219 
220     /**
221      * @dev Function to check the amount of tokens that an owner allowed to a spender.
222      * @param owner address The address which owns the funds.
223      * @param spender address The address which will spend the funds.
224      * @return A uint256 specifying the amount of tokens still available for the spender.
225      */
226     function allowance(
227         address owner,
228         address spender
229     )
230     public
231     view
232     returns (uint256)
233     {
234         return _allowed[owner][spender];
235     }
236 
237     /**
238     * @dev Transfer token for a specified address
239     * @param to The address to transfer to.
240     * @param value The amount to be transferred.
241     */
242     function transfer(address to, uint256 value) public returns (bool) {
243         _transfer(msg.sender, to, value);
244         return true;
245     }
246 
247     /**
248      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249      * Beware that changing an allowance with this method brings the risk that someone may use both the old
250      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253      * @param spender The address which will spend the funds.
254      * @param value The amount of tokens to be spent.
255      */
256     function approve(address spender, uint256 value) public returns (bool) {
257         require(spender != address(0));
258 
259         _allowed[msg.sender][spender] = value;
260         emit Approval(msg.sender, spender, value);
261         return true;
262     }
263 
264     /**
265      * @dev Transfer tokens from one address to another
266      * @param from address The address which you want to send tokens from
267      * @param to address The address which you want to transfer to
268      * @param value uint256 the amount of tokens to be transferred
269      */
270     function transferFrom(
271         address from,
272         address to,
273         uint256 value
274     )
275     public
276     returns (bool)
277     {
278         require(value <= _allowed[from][msg.sender]);
279 
280         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
281         _transfer(from, to, value);
282         return true;
283     }
284 
285     /**
286      * @dev Increase the amount of tokens that an owner allowed to a spender.
287      * approve should be called when allowed_[_spender] == 0. To increment
288      * allowed value is better to use this function to avoid 2 calls (and wait until
289      * the first transaction is mined)
290      * From MonolithDAO Token.sol
291      * @param spender The address which will spend the funds.
292      * @param addedValue The amount of tokens to increase the allowance by.
293      */
294     function increaseAllowance(
295         address spender,
296         uint256 addedValue
297     )
298     public
299     returns (bool)
300     {
301         require(spender != address(0));
302 
303         _allowed[msg.sender][spender] = (
304         _allowed[msg.sender][spender].add(addedValue));
305         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
306         return true;
307     }
308 
309     /**
310      * @dev Decrease the amount of tokens that an owner allowed to a spender.
311      * approve should be called when allowed_[_spender] == 0. To decrement
312      * allowed value is better to use this function to avoid 2 calls (and wait until
313      * the first transaction is mined)
314      * From MonolithDAO Token.sol
315      * @param spender The address which will spend the funds.
316      * @param subtractedValue The amount of tokens to decrease the allowance by.
317      */
318     function decreaseAllowance(
319         address spender,
320         uint256 subtractedValue
321     )
322     public
323     returns (bool)
324     {
325         require(spender != address(0));
326 
327         _allowed[msg.sender][spender] = (
328         _allowed[msg.sender][spender].sub(subtractedValue));
329         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
330         return true;
331     }
332 
333     /**
334     * @dev Transfer token for a specified addresses
335     * @param from The address to transfer from.
336     * @param to The address to transfer to.
337     * @param value The amount to be transferred.
338     */
339     function _transfer(address from, address to, uint256 value) internal {
340         require(value <= _balances[from]);
341         require(to != address(0));
342 
343         _balances[from] = _balances[from].sub(value);
344         _balances[to] = _balances[to].add(value);
345         emit Transfer(from, to, value);
346     }
347 
348     /**
349      * @dev Internal function that mints an amount of the token and assigns it to
350      * an account. This encapsulates the modification of balances such that the
351      * proper events are emitted.
352      * @param account The account that will receive the created tokens.
353      * @param value The amount that will be created.
354      */
355     function _mint(address account, uint256 value) internal {
356         require(account != 0);
357         _totalSupply = _totalSupply.add(value);
358         _balances[account] = _balances[account].add(value);
359         emit Transfer(address(0), account, value);
360     }
361 
362     /**
363      * @dev Internal function that burns an amount of the token of a given
364      * account.
365      * @param account The account whose tokens will be burnt.
366      * @param value The amount that will be burnt.
367      */
368     function _burn(address account, uint256 value) internal {
369         require(account != 0);
370         require(value <= _balances[account]);
371 
372         _totalSupply = _totalSupply.sub(value);
373         _balances[account] = _balances[account].sub(value);
374         emit Transfer(account, address(0), value);
375     }
376 
377     /**
378      * @dev Internal function that burns an amount of the token of a given
379      * account, deducting from the sender's allowance for said account. Uses the
380      * internal burn function.
381      * @param account The account whose tokens will be burnt.
382      * @param value The amount that will be burnt.
383      */
384     function _burnFrom(address account, uint256 value) internal {
385         require(value <= _allowed[account][msg.sender]);
386 
387         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
388         // this function needs to emit an event with the updated approval.
389         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
390             value);
391         _burn(account, value);
392     }
393 }
394 
395 
396 /**
397  * @title Burnable Token
398  * @dev Token that can be irreversibly burned (destroyed).
399  */
400 contract ERC20Burnable is ERC20 {
401 
402     /**
403      * @dev Burns a specific amount of tokens.
404      * @param value The amount of token to be burned.
405      */
406     function burn(uint256 value) public {
407         _burn(msg.sender, value);
408     }
409 
410     /**
411      * @dev Burns a specific amount of tokens from the target address and decrements allowance
412      * @param from address The address which you want to send tokens from
413      * @param value uint256 The amount of token to be burned
414      */
415     function burnFrom(address from, uint256 value) public {
416         _burnFrom(from, value);
417     }
418 }
419 
420 
421 /**
422  * @title ERC20Mintable
423  * @dev ERC20 minting logic
424  */
425 contract ERC20Mintable is ERC20Burnable, MinterRole {
426     /**
427      * @dev Function to mint tokens
428      * @param to The address that will receive the minted tokens.
429      * @param value The amount of tokens to mint.
430      * @return A boolean that indicates if the operation was successful.
431      */
432     function mint(
433         address to,
434         uint256 value
435     )
436     public
437     onlyMinter
438     returns (bool)
439     {
440         _mint(to, value);
441         return true;
442     }
443 }
444 
445 
446 /**
447  * @title SimpleToken
448  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
449  * Note they can later distribute these tokens as they wish using `transfer` and other
450  * `ERC20` functions.
451  */
452 contract AzulToken is ERC20Mintable {
453 
454     string public constant name = "Azul";
455     string public constant symbol = "AZU";
456     uint8 public constant decimals = 18;
457 
458 }