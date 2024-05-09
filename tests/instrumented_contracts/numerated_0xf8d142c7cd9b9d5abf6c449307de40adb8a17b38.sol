1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error.
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b, "SafeMath: multiplication overflow");
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0, "SafeMath: division by zero");
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a, "SafeMath: subtraction overflow");
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0, "SafeMath: modulo by zero");
64         return a % b;
65     }
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://eips.ethereum.org/EIPS/eip-20
71  */
72 interface IERC20 {
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function approve(address spender, uint256 value) external returns (bool);
76 
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79     function totalSupply() external view returns (uint256);
80 
81     function balanceOf(address who) external view returns (uint256);
82 
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 /**
92  * @title ERC20Detailed token
93  * @dev The decimals are only for visualization purposes.
94  * All the operations are done using the smallest and indivisible token unit,
95  * just as on Ethereum all the operations are done in wei.
96  */
97 contract ERC20Detailed is IERC20 {
98     string private _name;
99     string private _symbol;
100     uint8 private _decimals;
101 
102     constructor (string memory name, string memory symbol, uint8 decimals) public {
103         _name = name;
104         _symbol = symbol;
105         _decimals = decimals;
106     }
107 
108     /**
109      * @return the name of the token.
110      */
111     function name() public view returns (string memory) {
112         return _name;
113     }
114 
115     /**
116      * @return the symbol of the token.
117      */
118     function symbol() public view returns (string memory) {
119         return _symbol;
120     }
121 
122     /**
123      * @return the number of decimals of the token.
124      */
125     function decimals() public view returns (uint8) {
126         return _decimals;
127     }
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * https://eips.ethereum.org/EIPS/eip-20
135  * Originally based on code by FirstBlood:
136  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  *
138  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
139  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
140  * compliant implementations may not do it.
141  */
142 contract ERC20 is IERC20 {
143     using SafeMath for uint256;
144 
145     mapping (address => uint256) private _balances;
146 
147     mapping (address => mapping (address => uint256)) private _allowed;
148 
149     uint256 private _totalSupply;
150 
151     /**
152      * @dev Total number of tokens in existence.
153      */
154     function totalSupply() public view returns (uint256) {
155         return _totalSupply;
156     }
157 
158     /**
159      * @dev Gets the balance of the specified address.
160      * @param owner The address to query the balance of.
161      * @return A uint256 representing the amount owned by the passed address.
162      */
163     function balanceOf(address owner) public view returns (uint256) {
164         return _balances[owner];
165     }
166 
167     /**
168      * @dev Function to check the amount of tokens that an owner allowed to a spender.
169      * @param owner address The address which owns the funds.
170      * @param spender address The address which will spend the funds.
171      * @return A uint256 specifying the amount of tokens still available for the spender.
172      */
173     function allowance(address owner, address spender) public view returns (uint256) {
174         return _allowed[owner][spender];
175     }
176 
177     /**
178      * @dev Transfer token to a specified address.
179      * @param to The address to transfer to.
180      * @param value The amount to be transferred.
181      */
182     function transfer(address to, uint256 value) public returns (bool) {
183         _transfer(msg.sender, to, value);
184         return true;
185     }
186 
187     /**
188      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189      * Beware that changing an allowance with this method brings the risk that someone may use both the old
190      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      * @param spender The address which will spend the funds.
194      * @param value The amount of tokens to be spent.
195      */
196     function approve(address spender, uint256 value) public returns (bool) {
197         _approve(msg.sender, spender, value);
198         return true;
199     }
200 
201     /**
202      * @dev Transfer tokens from one address to another.
203      * Note that while this function emits an Approval event, this is not required as per the specification,
204      * and other compliant implementations may not emit the event.
205      * @param from address The address which you want to send tokens from
206      * @param to address The address which you want to transfer to
207      * @param value uint256 the amount of tokens to be transferred
208      */
209     function transferFrom(address from, address to, uint256 value) public returns (bool) {
210         _transfer(from, to, value);
211         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
212         return true;
213     }
214 
215     /**
216      * @dev Increase the amount of tokens that an owner allowed to a spender.
217      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
218      * allowed value is better to use this function to avoid 2 calls (and wait until
219      * the first transaction is mined)
220      * From MonolithDAO Token.sol
221      * Emits an Approval event.
222      * @param spender The address which will spend the funds.
223      * @param addedValue The amount of tokens to increase the allowance by.
224      */
225     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
226         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
227         return true;
228     }
229 
230     /**
231      * @dev Decrease the amount of tokens that an owner allowed to a spender.
232      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * Emits an Approval event.
237      * @param spender The address which will spend the funds.
238      * @param subtractedValue The amount of tokens to decrease the allowance by.
239      */
240     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
241         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
242         return true;
243     }
244 
245     /**
246      * @dev Transfer token for a specified addresses.
247      * @param from The address to transfer from.
248      * @param to The address to transfer to.
249      * @param value The amount to be transferred.
250      */
251     function _transfer(address from, address to, uint256 value) internal {
252         require(to != address(0), "ERC20: transfer to the zero address");
253 
254         _balances[from] = _balances[from].sub(value);
255         _balances[to] = _balances[to].add(value);
256         emit Transfer(from, to, value);
257     }
258 
259     /**
260      * @dev Internal function that mints an amount of the token and assigns it to
261      * an account. This encapsulates the modification of balances such that the
262      * proper events are emitted.
263      * @param account The account that will receive the created tokens.
264      * @param value The amount that will be created.
265      */
266     function _mint(address account, uint256 value) internal {
267         require(account != address(0), "ERC20: mint to the zero address");
268 
269         _totalSupply = _totalSupply.add(value);
270         _balances[account] = _balances[account].add(value);
271         emit Transfer(address(0), account, value);
272     }
273 
274     /**
275      * @dev Internal function that burns an amount of the token of a given
276      * account.
277      * @param account The account whose tokens will be burnt.
278      * @param value The amount that will be burnt.
279      */
280     function _burn(address account, uint256 value) internal {
281         require(account != address(0), "ERC20: burn from the zero address");
282 
283         _totalSupply = _totalSupply.sub(value);
284         _balances[account] = _balances[account].sub(value);
285         emit Transfer(account, address(0), value);
286     }
287 
288     /**
289      * @dev Approve an address to spend another addresses' tokens.
290      * @param owner The address that owns the tokens.
291      * @param spender The address that will spend the tokens.
292      * @param value The number of tokens that can be spent.
293      */
294     function _approve(address owner, address spender, uint256 value) internal {
295         require(owner != address(0), "ERC20: approve from the zero address");
296         require(spender != address(0), "ERC20: approve to the zero address");
297 
298         _allowed[owner][spender] = value;
299         emit Approval(owner, spender, value);
300     }
301 
302     /**
303      * @dev Internal function that burns an amount of the token of a given
304      * account, deducting from the sender's allowance for said account. Uses the
305      * internal burn function.
306      * Emits an Approval event (reflecting the reduced allowance).
307      * @param account The account whose tokens will be burnt.
308      * @param value The amount that will be burnt.
309      */
310     function _burnFrom(address account, uint256 value) internal {
311         _burn(account, value);
312         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
313     }
314 }
315 
316 /**
317  * @title Burnable Token
318  * @dev Token that can be irreversibly burned (destroyed).
319  */
320 contract ERC20Burnable is ERC20 {
321     /**
322      * @dev Burns a specific amount of tokens.
323      * @param value The amount of token to be burned.
324      */
325     function burn(uint256 value) public {
326         _burn(msg.sender, value);
327     }
328 
329     /**
330      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
331      * @param from address The account whose tokens will be burned.
332      * @param value uint256 The amount of token to be burned.
333      */
334     function burnFrom(address from, uint256 value) public {
335         _burnFrom(from, value);
336     }
337 }
338 
339 /**
340  * @title ERC20Mintable
341  * @dev ERC20 minting logic.
342  */
343 contract ERC20Mintable is ERC20 {
344     
345     address private _minter;
346     
347     modifier onlyMinter() {
348         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
349         _;
350     }
351 
352     function isMinter(address account) public view returns (bool) {
353         return _minter == account;
354     }
355     
356     constructor (address minter) public {
357         _minter = minter;
358     }
359     
360     /**
361      * @dev Function to mint tokens
362      * @param to The address that will receive the minted tokens.
363      * @param value The amount of tokens to mint.
364      * @return A boolean that indicates if the operation was successful.
365      */
366     function mint(address to, uint256 value) public onlyMinter returns (bool) {
367         _mint(to, value);
368         return true;
369     }
370 }
371 
372 /**
373  * @title Capped token
374  * @dev Mintable token with a token cap.
375  */
376 contract ERC20Capped is ERC20Mintable {
377     uint256 private _cap;
378 
379     constructor (uint256 cap) public {
380         require(cap > 0, "ERC20Capped: cap is 0");
381         _cap = cap;
382     }
383 
384     /**
385      * @return the cap for the token minting.
386      */
387     function cap() public view returns (uint256) {
388         return _cap;
389     }
390 
391     function _mint(address account, uint256 value) internal {
392         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
393         super._mint(account, value);
394     }
395 }
396 
397 interface IERC20Freezable {
398     event Freeze(address indexed account);
399     event Unfreeze(address indexed account);
400 }
401 
402 contract ERC20Freezable is ERC20Mintable, IERC20Freezable {
403     
404     mapping (address => bool) private _frozenAddresses;
405     
406     modifier notFrozen() {
407         require(!isFrozen(msg.sender), "ERC20Freezable: address is frozen");
408         _;
409     }
410 
411     function isFrozen(address account) public view returns (bool) {
412         return _frozenAddresses[account];
413     }
414     
415     function freeze(address account) public onlyMinter returns (bool) {
416         _frozenAddresses[account] = true;
417         emit Freeze(account);
418         return true;
419     }
420     
421     function unfreeze(address account) public onlyMinter returns (bool) {
422         require(isFrozen(account), "ERC20Freezable: account is not frozen");
423         _frozenAddresses[account] = false;
424         emit Unfreeze(account);
425         return true;
426     }
427     
428     function transfer(address to, uint256 value) public notFrozen returns (bool) {
429         return super.transfer(to, value);
430     }
431 
432     function approve(address spender, uint256 value) public notFrozen returns (bool) {
433         return super.approve(spender, value);
434     }
435     function transferFrom(address from, address to, uint256 value) public notFrozen returns (bool) {
436         require(!isFrozen(from), "ERC20Freezable: from address is frozen");
437         require(!isFrozen(to), "ERC20Freezable: to address is frozen");
438         
439         return super.transferFrom(from, to, value);
440     }
441 
442     function increaseAllowance(address spender, uint256 addedValue) public notFrozen returns (bool) {
443         return super.increaseAllowance(spender, addedValue);
444     }
445 
446     function decreaseAllowance(address spender, uint256 subtractedValue) public notFrozen returns (bool) {
447         return super.decreaseAllowance(spender, subtractedValue);
448     }
449 }
450 
451 /**
452  * @title L2T token contract
453  */
454 contract L2T is ERC20Mintable, ERC20Detailed, ERC20Capped {
455     uint8 public constant DECIMALS = 18;
456     uint256 public constant TOTAL_CAP = 40000000 * (10 ** uint256(DECIMALS));
457 
458     /**
459      * @dev Constructor
460      */
461     constructor () public
462         ERC20Detailed("L2T", "L2T", DECIMALS)
463         ERC20Mintable(0x037C60d02B9eB55529C2EC1643B77c2Ab3fE4396)
464         ERC20Capped(TOTAL_CAP)
465     {
466         
467     }
468 }