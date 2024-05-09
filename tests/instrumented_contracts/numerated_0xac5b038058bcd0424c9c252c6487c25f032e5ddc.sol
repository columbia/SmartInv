1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-27
3  */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @title Math
9  * @dev Assorted math operations.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Calculates the average of two numbers. Since these are integers,
28      * averages of an even and odd number cannot be represented, and will be
29      * rounded down.
30      */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
34     }
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Unsigned math operations with safety checks that revert on error.
40  */
41 library SafeMath {
42     /**
43      * @dev Multiplies two unsigned integers, reverts on overflow.
44      */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
61      */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0, "SafeMath: division by zero");
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a, "SafeMath: subtraction overflow");
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Adds two unsigned integers, reverts on overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
93      * reverts when dividing by zero.
94      */
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0, "SafeMath: modulo by zero");
97         return a % b;
98     }
99 }
100 
101 /**
102  * @title Roles
103  * @dev Library for managing addresses assigned to a Role.
104  */
105 library Roles {
106     struct Role {
107         mapping(address => bool) bearer;
108     }
109 
110     /**
111      * @dev Give an account access to this role.
112      */
113     function add(Role storage role, address account) internal {
114         require(!has(role, account), "Roles: account already has role");
115         role.bearer[account] = true;
116     }
117 
118     /**
119      * @dev Remove an account's access to this role.
120      */
121     function remove(Role storage role, address account) internal {
122         require(has(role, account), "Roles: account does not have role");
123         role.bearer[account] = false;
124     }
125 
126     /**
127      * @dev Check if an account has this role.
128      * @return bool
129      */
130     function has(
131         Role storage role,
132         address account
133     ) internal view returns (bool) {
134         require(account != address(0), "Roles: account is the zero address");
135         return role.bearer[account];
136     }
137 }
138 
139 contract MinterRole {
140     using Roles for Roles.Role;
141 
142     event MinterAdded(address indexed account);
143     event MinterRemoved(address indexed account);
144 
145     Roles.Role private _minters;
146 
147     constructor() internal {
148         _addMinter(msg.sender);
149     }
150 
151     modifier onlyMinter() {
152         require(
153             isMinter(msg.sender),
154             "MinterRole: caller does not have the Minter role"
155         );
156         _;
157     }
158 
159     function isMinter(address account) public view returns (bool) {
160         return _minters.has(account);
161     }
162 
163     function addMinter(address account) public onlyMinter {
164         _addMinter(account);
165     }
166 
167     function renounceMinter() public {
168         _removeMinter(msg.sender);
169     }
170 
171     function _addMinter(address account) internal {
172         _minters.add(account);
173         emit MinterAdded(account);
174     }
175 
176     function _removeMinter(address account) internal {
177         _minters.remove(account);
178         emit MinterRemoved(account);
179     }
180 }
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://eips.ethereum.org/EIPS/eip-20
185  */
186 interface IERC20 {
187     function transfer(address to, uint256 value) external returns (bool);
188 
189     function approve(address spender, uint256 value) external returns (bool);
190 
191     function transferFrom(
192         address from,
193         address to,
194         uint256 value
195     ) external returns (bool);
196 
197     function totalSupply() external view returns (uint256);
198 
199     function balanceOf(address who) external view returns (uint256);
200 
201     function allowance(
202         address owner,
203         address spender
204     ) external view returns (uint256);
205 
206     event Transfer(address indexed from, address indexed to, uint256 value);
207 
208     event Approval(
209         address indexed owner,
210         address indexed spender,
211         uint256 value
212     );
213 }
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * https://eips.ethereum.org/EIPS/eip-20
220  * Originally based on code by FirstBlood:
221  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  *
223  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
224  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
225  * compliant implementations may not do it.
226  */
227 contract ERC20 is IERC20 {
228     using SafeMath for uint256;
229 
230     mapping(address => uint256) private _balances;
231 
232     mapping(address => mapping(address => uint256)) private _allowances;
233 
234     uint256 private _totalSupply;
235 
236     /**
237      * @dev Total number of tokens in existence.
238      */
239     function totalSupply() public view returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev Gets the balance of the specified address.
245      * @param owner The address to query the balance of.
246      * @return A uint256 representing the amount owned by the passed address.
247      */
248     function balanceOf(address owner) public view returns (uint256) {
249         return _balances[owner];
250     }
251 
252     /**
253      * @dev Function to check the amount of tokens that an owner allowed to a spender.
254      * @param owner address The address which owns the funds.
255      * @param spender address The address which will spend the funds.
256      * @return A uint256 specifying the amount of tokens still available for the spender.
257      */
258     function allowance(
259         address owner,
260         address spender
261     ) public view returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev Transfer token to a specified address.
267      * @param to The address to transfer to.
268      * @param value The amount to be transferred.
269      */
270     function transfer(address to, uint256 value) public returns (bool) {
271         _transfer(msg.sender, to, value);
272         return true;
273     }
274 
275     /**
276      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
277      * Beware that changing an allowance with this method brings the risk that someone may use both the old
278      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
279      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
280      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281      * @param spender The address which will spend the funds.
282      * @param value The amount of tokens to be spent.
283      */
284     function approve(address spender, uint256 value) public returns (bool) {
285         _approve(msg.sender, spender, value);
286         return true;
287     }
288 
289     /**
290      * @dev Transfer tokens from one address to another.
291      * Note that while this function emits an Approval event, this is not required as per the specification,
292      * and other compliant implementations may not emit the event.
293      * @param from address The address which you want to send tokens from
294      * @param to address The address which you want to transfer to
295      * @param value uint256 the amount of tokens to be transferred
296      */
297     function transferFrom(
298         address from,
299         address to,
300         uint256 value
301     ) public returns (bool) {
302         _transfer(from, to, value);
303         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
304         return true;
305     }
306 
307     /**
308      * @dev Increase the amount of tokens that an owner allowed to a spender.
309      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
310      * allowed value is better to use this function to avoid 2 calls (and wait until
311      * the first transaction is mined)
312      * From MonolithDAO Token.sol
313      * Emits an Approval event.
314      * @param spender The address which will spend the funds.
315      * @param addedValue The amount of tokens to increase the allowance by.
316      */
317     function increaseAllowance(
318         address spender,
319         uint256 addedValue
320     ) public returns (bool) {
321         _approve(
322             msg.sender,
323             spender,
324             _allowances[msg.sender][spender].add(addedValue)
325         );
326         return true;
327     }
328 
329     /**
330      * @dev Decrease the amount of tokens that an owner allowed to a spender.
331      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
332      * allowed value is better to use this function to avoid 2 calls (and wait until
333      * the first transaction is mined)
334      * From MonolithDAO Token.sol
335      * Emits an Approval event.
336      * @param spender The address which will spend the funds.
337      * @param subtractedValue The amount of tokens to decrease the allowance by.
338      */
339     function decreaseAllowance(
340         address spender,
341         uint256 subtractedValue
342     ) public returns (bool) {
343         _approve(
344             msg.sender,
345             spender,
346             _allowances[msg.sender][spender].sub(subtractedValue)
347         );
348         return true;
349     }
350 
351     /**
352      * @dev Transfer token for a specified addresses.
353      * @param from The address to transfer from.
354      * @param to The address to transfer to.
355      * @param value The amount to be transferred.
356      */
357     function _transfer(address from, address to, uint256 value) internal {
358         require(to != address(0), "ERC20: transfer to the zero address");
359 
360         _balances[from] = _balances[from].sub(value);
361         _balances[to] = _balances[to].add(value);
362         emit Transfer(from, to, value);
363     }
364 
365     /**
366      * @dev Internal function that mints an amount of the token and assigns it to
367      * an account. This encapsulates the modification of balances such that the
368      * proper events are emitted.
369      * @param account The account that will receive the created tokens.
370      * @param value The amount that will be created.
371      */
372     function _mint(address account, uint256 value) internal {
373         require(account != address(0), "ERC20: mint to the zero address");
374 
375         _totalSupply = _totalSupply.add(value);
376         _balances[account] = _balances[account].add(value);
377         emit Transfer(address(0), account, value);
378     }
379 
380     /**
381      * @dev Internal function that burns an amount of the token of a given
382      * account.
383      * @param account The account whose tokens will be burnt.
384      * @param value The amount that will be burnt.
385      */
386     function _burn(address account, uint256 value) internal {
387         require(account != address(0), "ERC20: burn from the zero address");
388 
389         _totalSupply = _totalSupply.sub(value);
390         _balances[account] = _balances[account].sub(value);
391         emit Transfer(account, address(0), value);
392     }
393 
394     /**
395      * @dev Approve an address to spend another addresses' tokens.
396      * @param owner The address that owns the tokens.
397      * @param spender The address that will spend the tokens.
398      * @param value The number of tokens that can be spent.
399      */
400     function _approve(address owner, address spender, uint256 value) internal {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = value;
405         emit Approval(owner, spender, value);
406     }
407 
408     /**
409      * @dev Internal function that burns an amount of the token of a given
410      * account, deducting from the sender's allowance for said account. Uses the
411      * internal burn function.
412      * Emits an Approval event (reflecting the reduced allowance).
413      * @param account The account whose tokens will be burnt.
414      * @param value The amount that will be burnt.
415      */
416     function _burnFrom(address account, uint256 value) internal {
417         _burn(account, value);
418         _approve(
419             account,
420             msg.sender,
421             _allowances[account][msg.sender].sub(value)
422         );
423     }
424 }
425 
426 /**
427  * @title ERC20Mintable
428  * @dev ERC20 minting logic.
429  */
430 contract ERC20Mintable is ERC20, MinterRole {
431     /**
432      * @dev Function to mint tokens
433      * @param to The address that will receive the minted tokens.
434      * @param value The amount of tokens to mint.
435      * @return A boolean that indicates if the operation was successful.
436      */
437     function mint(address to, uint256 value) public onlyMinter returns (bool) {
438         _mint(to, value);
439         return true;
440     }
441 }
442 
443 /**
444  * @title ERC20Detailed token
445  * @dev The decimals are only for visualization purposes.
446  * All the operations are done using the smallest and indivisible token unit,
447  * just as on Ethereum all the operations are done in wei.
448  */
449 contract ERC20Detailed is IERC20 {
450     string private _name;
451     string private _symbol;
452     uint8 private _decimals;
453 
454     constructor(
455         string memory name,
456         string memory symbol,
457         uint8 decimals
458     ) public {
459         _name = name;
460         _symbol = symbol;
461         _decimals = decimals;
462     }
463 
464     /**
465      * @return the name of the token.
466      */
467     function name() public view returns (string memory) {
468         return _name;
469     }
470 
471     /**
472      * @return the symbol of the token.
473      */
474     function symbol() public view returns (string memory) {
475         return _symbol;
476     }
477 
478     /**
479      * @return the number of decimals of the token.
480      */
481     function decimals() public view returns (uint8) {
482         return _decimals;
483     }
484 }
485 
486 /**
487  * @title Capped token
488  * @dev Mintable token with a token cap.
489  */
490 contract ERC20Capped is ERC20Mintable {
491     uint256 private _cap;
492 
493     constructor(uint256 cap) public {
494         require(cap > 0, "ERC20Capped: cap is 0");
495         _cap = cap;
496     }
497 
498     /**
499      * @return the cap for the token minting.
500      */
501     function cap() public view returns (uint256) {
502         return _cap;
503     }
504 
505     function _mint(address account, uint256 value) internal {
506         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
507         super._mint(account, value);
508     }
509 }
510 
511 contract EPK is ERC20Capped, ERC20Detailed {
512     constructor(
513         uint256 cap,
514         string memory name,
515         string memory symbol,
516         uint8 decimals
517     ) public ERC20Capped(cap) ERC20Detailed(name, symbol, decimals) {}
518 }