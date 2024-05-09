1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
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
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0); // Solidity only automatically asserts when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two numbers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60     * reverts when dividing by zero.
61     */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 /**
69  * @title Roles
70  * @dev Library for managing addresses assigned to a Role.
71  */
72 library Roles {
73     struct Role {
74         mapping (address => bool) bearer;
75     }
76 
77     /**
78      * @dev give an account access to this role
79      */
80     function add(Role storage role, address account) internal {
81         require(account != address(0));
82         require(!has(role, account));
83 
84         role.bearer[account] = true;
85     }
86 
87     /**
88      * @dev remove an account's access to this role
89      */
90     function remove(Role storage role, address account) internal {
91         require(account != address(0));
92         require(has(role, account));
93 
94         role.bearer[account] = false;
95     }
96 
97     /**
98      * @dev check if an account has this role
99      * @return bool
100      */
101     function has(Role storage role, address account)
102     internal
103     view
104     returns (bool)
105     {
106         require(account != address(0));
107         return role.bearer[account];
108     }
109 }
110 
111 contract MinterRole {
112     using Roles for Roles.Role;
113 
114     event MinterAdded(address indexed account);
115     event MinterRemoved(address indexed account);
116 
117     Roles.Role private minters;
118 
119     constructor() internal {
120         _addMinter(msg.sender);
121     }
122 
123     modifier onlyMinter() {
124         require(isMinter(msg.sender));
125         _;
126     }
127 
128     function isMinter(address account) public view returns (bool) {
129         return minters.has(account);
130     }
131 
132     function addMinter(address account) public onlyMinter {
133         _addMinter(account);
134     }
135 
136     function renounceMinter() public {
137         _removeMinter(msg.sender);
138     }
139 
140     function _addMinter(address account) internal {
141         minters.add(account);
142         emit MinterAdded(account);
143     }
144 
145     function _removeMinter(address account) internal {
146         minters.remove(account);
147         emit MinterRemoved(account);
148     }
149 }
150 
151 interface IERC20 {
152     function totalSupply() external view returns (uint256);
153 
154     function balanceOf(address who) external view returns (uint256);
155 
156     function allowance(address owner, address spender)
157     external view returns (uint256);
158 
159     function transfer(address to, uint256 value) external returns (bool);
160 
161     function approve(address spender, uint256 value)
162     external returns (bool);
163 
164     function transferFrom(address from, address to, uint256 value)
165     external returns (bool);
166 
167     event Transfer(
168         address indexed from,
169         address indexed to,
170         uint256 value
171     );
172 
173     event Approval(
174         address indexed owner,
175         address indexed spender,
176         uint256 value
177     );
178 }
179 
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
186  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 
189 contract ERC20Frozen is IERC20, MinterRole {
190     using SafeMath for uint256;
191 
192     mapping (address => uint256) private _balances;
193 
194     mapping (address => mapping (address => uint256)) private _allowed;
195 
196     mapping (address => uint) private _frozenTimes;
197 
198     uint256 private _totalSupply;
199 
200     /**
201     * @dev Total number of tokens in existence
202     */
203     function totalSupply() public view returns (uint256) {
204         return _totalSupply;
205     }
206 
207     /**
208     * @dev Gets the balance of the specified address.
209     * @param owner The address to query the balance of.
210     * @return An uint256 representing the amount owned by the passed address.
211     */
212     function balanceOf(address owner) public view returns (uint256) {
213         return _balances[owner];
214     }
215 
216     function frozenTime(address owner) public view returns (uint) {
217         return _frozenTimes[owner];
218     }
219 
220     function setFrozenTime(address owner, uint newtime) public onlyMinter {
221         _frozenTimes[owner] = newtime;
222     }
223 
224     /**
225      * @dev Function to check the amount of tokens that an owner allowed to a spender.
226      * @param owner address The address which owns the funds.
227      * @param spender address The address which will spend the funds.
228      * @return A uint256 specifying the amount of tokens still available for the spender.
229      */
230     function allowance(
231         address owner,
232         address spender
233     )
234     public
235     view
236     returns (uint256)
237     {
238         return _allowed[owner][spender];
239     }
240 
241     /**
242     * @dev Transfer token for a specified address
243     * @param to The address to transfer to.
244     * @param value The amount to be transferred.
245     */
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
261         require(spender != address(0));
262 
263         _allowed[msg.sender][spender] = value;
264         emit Approval(msg.sender, spender, value);
265         return true;
266     }
267 
268     /**
269      * @dev Transfer tokens from one address to another
270      * @param from address The address which you want to send tokens from
271      * @param to address The address which you want to transfer to
272      * @param value uint256 the amount of tokens to be transferred
273      */
274     function transferFrom(
275         address from,
276         address to,
277         uint256 value
278     )
279     public
280     returns (bool)
281     {
282         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
283         _transfer(from, to, value);
284         return true;
285     }
286 
287     /**
288      * @dev Increase the amount of tokens that an owner allowed to a spender.
289      * approve should be called when allowed_[_spender] == 0. To increment
290      * allowed value is better to use this function to avoid 2 calls (and wait until
291      * the first transaction is mined)
292      * From MonolithDAO Token.sol
293      * @param spender The address which will spend the funds.
294      * @param addedValue The amount of tokens to increase the allowance by.
295      */
296     function increaseAllowance(
297         address spender,
298         uint256 addedValue
299     )
300     public
301     returns (bool)
302     {
303         require(spender != address(0));
304 
305         _allowed[msg.sender][spender] = (
306         _allowed[msg.sender][spender].add(addedValue));
307         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
308         return true;
309     }
310 
311     /**
312      * @dev Decrease the amount of tokens that an owner allowed to a spender.
313      * approve should be called when allowed_[_spender] == 0. To decrement
314      * allowed value is better to use this function to avoid 2 calls (and wait until
315      * the first transaction is mined)
316      * From MonolithDAO Token.sol
317      * @param spender The address which will spend the funds.
318      * @param subtractedValue The amount of tokens to decrease the allowance by.
319      */
320     function decreaseAllowance(
321         address spender,
322         uint256 subtractedValue
323     )
324     public
325     returns (bool)
326     {
327         require(spender != address(0));
328 
329         _allowed[msg.sender][spender] = (
330         _allowed[msg.sender][spender].sub(subtractedValue));
331         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
332         return true;
333     }
334 
335     /**
336     * @dev Transfer token for a specified addresses
337     * @param from The address to transfer from.
338     * @param to The address to transfer to.
339     * @param value The amount to be transferred.
340     */
341     function _transfer(address from, address to, uint256 value) internal {
342         require(to != address(0));
343         require(_frozenTimes[from] == 0x0 || _frozenTimes[from] < now || isMinter(from));
344         _balances[from] = _balances[from].sub(value);
345         _balances[to] = _balances[to].add(value);
346         emit Transfer(from, to, value);
347     }
348 
349     /**
350      * @dev Internal function that mints an amount of the token and assigns it to
351      * an account. This encapsulates the modification of balances such that the
352      * proper events are emitted.
353      * @param account The account that will receive the created tokens.
354      * @param value The amount that will be created.
355      */
356     function _mint(address account, uint256 value) internal {
357         require(account != address(0));
358         _frozenTimes[account] = now + 15768000; // 6 month
359         _totalSupply = _totalSupply.add(value);
360         _balances[account] = _balances[account].add(value);
361         emit Transfer(address(0), account, value);
362     }
363 
364     /**
365      * @dev Internal function that burns an amount of the token of a given
366      * account.
367      * @param account The account whose tokens will be burnt.
368      * @param value The amount that will be burnt.
369      */
370     function _burn(address account, uint256 value) internal {
371         require(account != address(0));
372 
373         _totalSupply = _totalSupply.sub(value);
374         _balances[account] = _balances[account].sub(value);
375         emit Transfer(account, address(0), value);
376     }
377 
378     /**
379      * @dev Internal function that burns an amount of the token of a given
380      * account, deducting from the sender's allowance for said account. Uses the
381      * internal burn function.
382      * @param account The account whose tokens will be burnt.
383      * @param value The amount that will be burnt.
384      */
385     function _burnFrom(address account, uint256 value) internal {
386         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
387         // this function needs to emit an event with the updated approval.
388         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
389             value);
390         _burn(account, value);
391     }
392 }
393 
394 
395 
396 /**
397  * @title ERC20Mintable
398  * @dev ERC20 minting logic
399  */
400 contract ERC20Mintable is ERC20Frozen{
401     /**
402      * @dev Function to mint tokens
403      * @param to The address that will receive the minted tokens.
404      * @param value The amount of tokens to mint.
405      * @return A boolean that indicates if the operation was successful.
406      */
407     function mint(
408         address to,
409         uint256 value
410     )
411     public
412     onlyMinter
413     returns (bool)
414     {
415         _mint(to, value);
416         return true;
417     }
418 }
419 
420 contract ERC20Burnable is ERC20Frozen {
421 
422     /**
423      * @dev Burns a specific amount of tokens.
424      * @param value The amount of token to be burned.
425      */
426     function burn(uint256 value) public {
427         _burn(msg.sender, value);
428     }
429 
430     /**
431      * @dev Burns a specific amount of tokens from the target address and decrements allowance
432      * @param from address The address which you want to send tokens from
433      * @param value uint256 The amount of token to be burned
434      */
435     function burnFrom(address from, uint256 value) public {
436         _burnFrom(from, value);
437     }
438 }
439 
440 /**
441  * @title ERC20Detailed token
442  * @dev The decimals are only for visualization purposes.
443  * All the operations are done using the smallest and indivisible token unit,
444  * just as on Ethereum all the operations are done in wei.
445  */
446 contract ERC20Detailed is IERC20 {
447     string private _name;
448     string private _symbol;
449     uint8 private _decimals;
450 
451     constructor(string name, string symbol, uint8 decimals) public {
452         _name = name;
453         _symbol = symbol;
454         _decimals = decimals;
455     }
456 
457     /**
458      * @return the name of the token.
459      */
460     function name() public view returns(string) {
461         return _name;
462     }
463 
464     /**
465      * @return the symbol of the token.
466      */
467     function symbol() public view returns(string) {
468         return _symbol;
469     }
470 
471     /**
472      * @return the number of decimals of the token.
473      */
474     function decimals() public view returns(uint8) {
475         return _decimals;
476     }
477 }
478 
479 
480 contract IQRToken is ERC20Frozen, ERC20Mintable, ERC20Burnable, ERC20Detailed {
481 
482     constructor() public ERC20Detailed("IQ RISES SYSTEM", "IQR", 18) {
483 
484     }
485 
486 }