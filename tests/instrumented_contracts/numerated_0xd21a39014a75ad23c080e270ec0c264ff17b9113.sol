1 pragma solidity ^0.5.0;
2 
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title ERC20Detailed token
29  * @dev The decimals are only for visualization purposes.
30  * All the operations are done using the smallest and indivisible token unit,
31  * just as on Ethereum all the operations are done in wei.
32  */
33 contract ERC20Detailed is IERC20 {
34     string private _name;
35     string private _symbol;
36     uint8 private _decimals;
37 
38     constructor (string memory name, string memory symbol, uint8 decimals) public {
39         _name = name;
40         _symbol = symbol;
41         _decimals = decimals;
42     }
43 
44     /**
45      * @return the name of the token.
46      */
47     function name() public view returns (string memory) {
48         return _name;
49     }
50 
51     /**
52      * @return the symbol of the token.
53      */
54     function symbol() public view returns (string memory) {
55         return _symbol;
56     }
57 
58     /**
59      * @return the number of decimals of the token.
60      */
61     function decimals() public view returns (uint8) {
62         return _decimals;
63     }
64 }
65 
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Unsigned math operations with safety checks that revert on error
71  */
72 library SafeMath {
73     /**
74      * @dev Multiplies two unsigned integers, reverts on overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b);
86 
87         return c;
88     }
89 
90     /**
91      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
92      */
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         // Solidity only automatically asserts when dividing by 0
95         require(b > 0);
96         uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98 
99         return c;
100     }
101 
102     /**
103      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a);
107         uint256 c = a - b;
108 
109         return c;
110     }
111 
112     /**
113      * @dev Adds two unsigned integers, reverts on overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a);
118 
119         return c;
120     }
121 
122     /**
123      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
124      * reverts when dividing by zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         require(b != 0);
128         return a % b;
129     }
130 }
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * https://eips.ethereum.org/EIPS/eip-20
137  * Originally based on code by FirstBlood:
138  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  *
140  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
141  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
142  * compliant implementations may not do it.
143  */
144 contract ERC20 is IERC20 {
145     using SafeMath for uint256;
146 
147     mapping (address => uint256) private _balances;
148 
149     mapping (address => mapping (address => uint256)) private _allowed;
150 
151     uint256 private _totalSupply;
152 
153     /**
154      * @dev Total number of tokens in existence
155      */
156     function totalSupply() public view returns (uint256) {
157         return _totalSupply;
158     }
159 
160     /**
161      * @dev Gets the balance of the specified address.
162      * @param owner The address to query the balance of.
163      * @return A uint256 representing the amount owned by the passed address.
164      */
165     function balanceOf(address owner) public view returns (uint256) {
166         return _balances[owner];
167     }
168 
169     /**
170      * @dev Function to check the amount of tokens that an owner allowed to a spender.
171      * @param owner address The address which owns the funds.
172      * @param spender address The address which will spend the funds.
173      * @return A uint256 specifying the amount of tokens still available for the spender.
174      */
175     function allowance(address owner, address spender) public view returns (uint256) {
176         return _allowed[owner][spender];
177     }
178 
179     /**
180      * @dev Transfer token to a specified address
181      * @param to The address to transfer to.
182      * @param value The amount to be transferred.
183      */
184     function transfer(address to, uint256 value) public returns (bool) {
185         _transfer(msg.sender, to, value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param spender The address which will spend the funds.
196      * @param value The amount of tokens to be spent.
197      */
198     function approve(address spender, uint256 value) public returns (bool) {
199         _approve(msg.sender, spender, value);
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
212         _transfer(from, to, value);
213         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
214         return true;
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
220      * allowed value is better to use this function to avoid 2 calls (and wait until
221      * the first transaction is mined)
222      * From MonolithDAO Token.sol
223      * Emits an Approval event.
224      * @param spender The address which will spend the funds.
225      * @param addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
228         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
229         return true;
230     }
231 
232     /**
233      * @dev Decrease the amount of tokens that an owner allowed to a spender.
234      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * Emits an Approval event.
239      * @param spender The address which will spend the funds.
240      * @param subtractedValue The amount of tokens to decrease the allowance by.
241      */
242     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
243         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
244         return true;
245     }
246 
247     /**
248      * @dev Transfer token for a specified addresses
249      * @param from The address to transfer from.
250      * @param to The address to transfer to.
251      * @param value The amount to be transferred.
252      */
253     function _transfer(address from, address to, uint256 value) internal {
254         require(to != address(0));
255 
256         _balances[from] = _balances[from].sub(value);
257         _balances[to] = _balances[to].add(value);
258         emit Transfer(from, to, value);
259     }
260 
261     /**
262      * @dev Internal function that mints an amount of the token and assigns it to
263      * an account. This encapsulates the modification of balances such that the
264      * proper events are emitted.
265      * @param account The account that will receive the created tokens.
266      * @param value The amount that will be created.
267      */
268     function _mint(address account, uint256 value) internal {
269         require(account != address(0));
270 
271         _totalSupply = _totalSupply.add(value);
272         _balances[account] = _balances[account].add(value);
273         emit Transfer(address(0), account, value);
274     }
275 
276     /**
277      * @dev Internal function that burns an amount of the token of a given
278      * account.
279      * @param account The account whose tokens will be burnt.
280      * @param value The amount that will be burnt.
281      */
282     function _burn(address account, uint256 value) internal {
283         require(account != address(0));
284 
285         _totalSupply = _totalSupply.sub(value);
286         _balances[account] = _balances[account].sub(value);
287         emit Transfer(account, address(0), value);
288     }
289 
290     /**
291      * @dev Approve an address to spend another addresses' tokens.
292      * @param owner The address that owns the tokens.
293      * @param spender The address that will spend the tokens.
294      * @param value The number of tokens that can be spent.
295      */
296     function _approve(address owner, address spender, uint256 value) internal {
297         require(spender != address(0));
298         require(owner != address(0));
299 
300         _allowed[owner][spender] = value;
301         emit Approval(owner, spender, value);
302     }
303 
304     /**
305      * @dev Internal function that burns an amount of the token of a given
306      * account, deducting from the sender's allowance for said account. Uses the
307      * internal burn function.
308      * Emits an Approval event (reflecting the reduced allowance).
309      * @param account The account whose tokens will be burnt.
310      * @param value The amount that will be burnt.
311      */
312     function _burnFrom(address account, uint256 value) internal {
313         _burn(account, value);
314         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
315     }
316 }
317 
318 
319 /**
320  * @title Roles
321  * @dev Library for managing addresses assigned to a Role.
322  */
323 library Roles {
324     struct Role {
325         mapping (address => bool) bearer;
326     }
327 
328     /**
329      * @dev give an account access to this role
330      */
331     function add(Role storage role, address account) internal {
332         require(account != address(0));
333         require(!has(role, account));
334 
335         role.bearer[account] = true;
336     }
337 
338     /**
339      * @dev remove an account's access to this role
340      */
341     function remove(Role storage role, address account) internal {
342         require(account != address(0));
343         require(has(role, account));
344 
345         role.bearer[account] = false;
346     }
347 
348     /**
349      * @dev check if an account has this role
350      * @return bool
351      */
352     function has(Role storage role, address account) internal view returns (bool) {
353         require(account != address(0));
354         return role.bearer[account];
355     }
356 }
357 
358 contract MinterRole {
359     using Roles for Roles.Role;
360 
361     event MinterAdded(address indexed account);
362     event MinterRemoved(address indexed account);
363 
364     Roles.Role private _minters;
365 
366     constructor () internal {
367         _addMinter(msg.sender);
368     }
369 
370     modifier onlyMinter() {
371         require(isMinter(msg.sender));
372         _;
373     }
374 
375     function isMinter(address account) public view returns (bool) {
376         return _minters.has(account);
377     }
378 
379     function addMinter(address account) public onlyMinter {
380         _addMinter(account);
381     }
382 
383     function renounceMinter() public {
384         _removeMinter(msg.sender);
385     }
386 
387     function _addMinter(address account) internal {
388         _minters.add(account);
389         emit MinterAdded(account);
390     }
391 
392     function _removeMinter(address account) internal {
393         _minters.remove(account);
394         emit MinterRemoved(account);
395     }
396 }
397 
398 /**
399  * @title ERC20Mintable
400  * @dev ERC20 minting logic
401  */
402 contract ERC20Mintable is ERC20, MinterRole {
403     /**
404      * @dev Function to mint tokens
405      * @param to The address that will receive the minted tokens.
406      * @param value The amount of tokens to mint.
407      * @return A boolean that indicates if the operation was successful.
408      */
409     function mint(address to, uint256 value) public onlyMinter returns (bool) {
410         _mint(to, value);
411         return true;
412     }
413 }
414 
415 contract xOASIS is ERC20Detailed, ERC20Mintable {
416   constructor() public ERC20Detailed("Oasis Labs OASIS Futures", "xOASIS", 18) {
417     uint total = 100000000 * (10 ** uint256(18));
418     addMinter(0x0E7ae3482874640710474AaE058294cAeDEe4D99);
419     addMinter(0x01b71E1c61529f43AA7432a225306e51cF109100);
420         
421     mint(0x0E7ae3482874640710474AaE058294cAeDEe4D99, total);
422     
423     renounceMinter();
424   }
425 }