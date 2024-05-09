1 pragma solidity ^0.5.2;
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
25 /**
26  * @title Roles
27  * @dev Library for managing addresses assigned to a Role.
28  */
29 library Roles {
30     struct Role {
31         mapping (address => bool) bearer;
32     }
33 
34     /**
35      * @dev give an account access to this role
36      */
37     function add(Role storage role, address account) internal {
38         require(account != address(0));
39         require(!has(role, account));
40 
41         role.bearer[account] = true;
42     }
43 
44     /**
45      * @dev remove an account's access to this role
46      */
47     function remove(Role storage role, address account) internal {
48         require(account != address(0));
49         require(has(role, account));
50 
51         role.bearer[account] = false;
52     }
53 
54     /**
55      * @dev check if an account has this role
56      * @return bool
57      */
58     function has(Role storage role, address account) internal view returns (bool) {
59         require(account != address(0));
60         return role.bearer[account];
61     }
62 }
63 
64 contract MinterRole {
65     using Roles for Roles.Role;
66 
67     event MinterAdded(address indexed account);
68     event MinterRemoved(address indexed account);
69 
70     Roles.Role private _minters;
71 
72     constructor () internal {
73         _addMinter(msg.sender);
74     }
75 
76     modifier onlyMinter() {
77         require(isMinter(msg.sender));
78         _;
79     }
80 
81     function isMinter(address account) public view returns (bool) {
82         return _minters.has(account);
83     }
84 
85     function addMinter(address account) public onlyMinter {
86         _addMinter(account);
87     }
88 
89     function renounceMinter() public {
90         _removeMinter(msg.sender);
91     }
92 
93     function _addMinter(address account) internal {
94         _minters.add(account);
95         emit MinterAdded(account);
96     }
97 
98     function _removeMinter(address account) internal {
99         _minters.remove(account);
100         emit MinterRemoved(account);
101     }
102 }
103 
104 /**
105  * @title SafeMath
106  * @dev Unsigned math operations with safety checks that revert on error
107  */
108 library SafeMath {
109     /**
110      * @dev Multiplies two unsigned integers, reverts on overflow.
111      */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b);
122 
123         return c;
124     }
125 
126     /**
127      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         // Solidity only automatically asserts when dividing by 0
131         require(b > 0);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b <= a);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Adds two unsigned integers, reverts on overflow.
150      */
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         require(c >= a);
154 
155         return c;
156     }
157 
158     /**
159      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
160      * reverts when dividing by zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         require(b != 0);
164         return a % b;
165     }
166 }
167 
168 /**
169  * @title ERC20Detailed token
170  * @dev The decimals are only for visualization purposes.
171  * All the operations are done using the smallest and indivisible token unit,
172  * just as on Ethereum all the operations are done in wei.
173  */
174 contract ERC20Detailed is IERC20 {
175     string private _name;
176     string private _symbol;
177     uint8 private _decimals;
178 
179     constructor (string memory name, string memory symbol, uint8 decimals) public {
180         _name = name;
181         _symbol = symbol;
182         _decimals = decimals;
183     }
184 
185     /**
186      * @return the name of the token.
187      */
188     function name() public view returns (string memory) {
189         return _name;
190     }
191 
192     /**
193      * @return the symbol of the token.
194      */
195     function symbol() public view returns (string memory) {
196         return _symbol;
197     }
198 
199     /**
200      * @return the number of decimals of the token.
201      */
202     function decimals() public view returns (uint8) {
203         return _decimals;
204     }
205 }
206 
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
213  * Originally based on code by FirstBlood:
214  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
215  *
216  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
217  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
218  * compliant implementations may not do it.
219  */
220 contract ERC20 is IERC20 {
221     using SafeMath for uint256;
222 
223     mapping (address => uint256) private _balances;
224 
225     mapping (address => mapping (address => uint256)) private _allowed;
226 
227     uint256 private _totalSupply;
228 
229     /**
230      * @dev Total number of tokens in existence
231      */
232     function totalSupply() public view returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev Gets the balance of the specified address.
238      * @param owner The address to query the balance of.
239      * @return An uint256 representing the amount owned by the passed address.
240      */
241     function balanceOf(address owner) public view returns (uint256) {
242         return _balances[owner];
243     }
244 
245     /**
246      * @dev Function to check the amount of tokens that an owner allowed to a spender.
247      * @param owner address The address which owns the funds.
248      * @param spender address The address which will spend the funds.
249      * @return A uint256 specifying the amount of tokens still available for the spender.
250      */
251     function allowance(address owner, address spender) public view returns (uint256) {
252         return _allowed[owner][spender];
253     }
254 
255     /**
256      * @dev Transfer token for a specified address
257      * @param to The address to transfer to.
258      * @param value The amount to be transferred.
259      */
260     function transfer(address to, uint256 value) public returns (bool) {
261         _transfer(msg.sender, to, value);
262         return true;
263     }
264 
265     /**
266      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
267      * Beware that changing an allowance with this method brings the risk that someone may use both the old
268      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
269      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      * @param spender The address which will spend the funds.
272      * @param value The amount of tokens to be spent.
273      */
274     function approve(address spender, uint256 value) public returns (bool) {
275         _approve(msg.sender, spender, value);
276         return true;
277     }
278 
279     /**
280      * @dev Transfer tokens from one address to another.
281      * Note that while this function emits an Approval event, this is not required as per the specification,
282      * and other compliant implementations may not emit the event.
283      * @param from address The address which you want to send tokens from
284      * @param to address The address which you want to transfer to
285      * @param value uint256 the amount of tokens to be transferred
286      */
287     function transferFrom(address from, address to, uint256 value) public returns (bool) {
288         _transfer(from, to, value);
289         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
290         return true;
291     }
292 
293     /**
294      * @dev Increase the amount of tokens that an owner allowed to a spender.
295      * approve should be called when allowed_[_spender] == 0. To increment
296      * allowed value is better to use this function to avoid 2 calls (and wait until
297      * the first transaction is mined)
298      * From MonolithDAO Token.sol
299      * Emits an Approval event.
300      * @param spender The address which will spend the funds.
301      * @param addedValue The amount of tokens to increase the allowance by.
302      */
303     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
304         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
305         return true;
306     }
307 
308     /**
309      * @dev Decrease the amount of tokens that an owner allowed to a spender.
310      * approve should be called when allowed_[_spender] == 0. To decrement
311      * allowed value is better to use this function to avoid 2 calls (and wait until
312      * the first transaction is mined)
313      * From MonolithDAO Token.sol
314      * Emits an Approval event.
315      * @param spender The address which will spend the funds.
316      * @param subtractedValue The amount of tokens to decrease the allowance by.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
319         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
320         return true;
321     }
322 
323     /**
324      * @dev Transfer token for a specified addresses
325      * @param from The address to transfer from.
326      * @param to The address to transfer to.
327      * @param value The amount to be transferred.
328      */
329     function _transfer(address from, address to, uint256 value) internal {
330         require(to != address(0));
331 
332         _balances[from] = _balances[from].sub(value);
333         _balances[to] = _balances[to].add(value);
334         emit Transfer(from, to, value);
335     }
336 
337     /**
338      * @dev Internal function that mints an amount of the token and assigns it to
339      * an account. This encapsulates the modification of balances such that the
340      * proper events are emitted.
341      * @param account The account that will receive the created tokens.
342      * @param value The amount that will be created.
343      */
344     function _mint(address account, uint256 value) internal {
345         require(account != address(0));
346 
347         _totalSupply = _totalSupply.add(value);
348         _balances[account] = _balances[account].add(value);
349         emit Transfer(address(0), account, value);
350     }
351 
352     /**
353      * @dev Internal function that burns an amount of the token of a given
354      * account.
355      * @param account The account whose tokens will be burnt.
356      * @param value The amount that will be burnt.
357      */
358     function _burn(address account, uint256 value) internal {
359         require(account != address(0));
360 
361         _totalSupply = _totalSupply.sub(value);
362         _balances[account] = _balances[account].sub(value);
363         emit Transfer(account, address(0), value);
364     }
365 
366     /**
367      * @dev Approve an address to spend another addresses' tokens.
368      * @param owner The address that owns the tokens.
369      * @param spender The address that will spend the tokens.
370      * @param value The number of tokens that can be spent.
371      */
372     function _approve(address owner, address spender, uint256 value) internal {
373         require(spender != address(0));
374         require(owner != address(0));
375 
376         _allowed[owner][spender] = value;
377         emit Approval(owner, spender, value);
378     }
379 
380     /**
381      * @dev Internal function that burns an amount of the token of a given
382      * account, deducting from the sender's allowance for said account. Uses the
383      * internal burn function.
384      * Emits an Approval event (reflecting the reduced allowance).
385      * @param account The account whose tokens will be burnt.
386      * @param value The amount that will be burnt.
387      */
388     function _burnFrom(address account, uint256 value) internal {
389         _burn(account, value);
390         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
391     }
392 }
393 
394 /**
395  * @title Burnable Token
396  * @dev Token that can be irreversibly burned (destroyed).
397  */
398 contract ERC20Burnable is ERC20 {
399     /**
400      * @dev Burns a specific amount of tokens.
401      * @param value The amount of token to be burned.
402      */
403     function burn(uint256 value) public {
404         _burn(msg.sender, value);
405     }
406 
407     /**
408      * @dev Burns a specific amount of tokens from the target address and decrements allowance
409      * @param from address The account whose tokens will be burned.
410      * @param value uint256 The amount of token to be burned.
411      */
412     function burnFrom(address from, uint256 value) public {
413         _burnFrom(from, value);
414     }
415 }
416 
417 /**
418  * @title ERC20Mintable
419  * @dev ERC20 minting logic
420  */
421 contract ERC20Mintable is ERC20, MinterRole {
422     /**
423      * @dev Function to mint tokens
424      * @param to The address that will receive the minted tokens.
425      * @param value The amount of tokens to mint.
426      * @return A boolean that indicates if the operation was successful.
427      */
428     function mint(address to, uint256 value) public onlyMinter returns (bool) {
429         _mint(to, value);
430         return true;
431     }
432 }
433 
434 
435 /**
436  * @title StableCoin
437  */
438  contract StableCoin is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
439 
440     constructor(
441         string memory name,
442         string memory symbol,
443         uint8 decimals
444     )
445         ERC20Burnable()
446         ERC20Mintable()
447         ERC20Detailed(name, symbol, decimals)
448         ERC20()
449         public
450     {}
451 }