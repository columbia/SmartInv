1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * Utility library of inline functions on addresses
69  */
70 library Address {
71     /**
72      * Returns whether the target address is a contract
73      * @dev This function will return false if invoked during the constructor of a contract,
74      * as the code is not actually created until after the constructor finishes.
75      * @param account address of the account to check
76      * @return whether the target address is a contract
77      */
78     function isContract(address account) internal view returns (bool) {
79         uint256 size;
80         // XXX Currently there is no better way to check if there is a contract in an address
81         // than to check the size of the code at that address.
82         // See https://ethereum.stackexchange.com/a/14016/36603
83         // for more details about how this works.
84         // TODO Check this again before the Serenity release, because all addresses will be
85         // contracts then.
86         // solhint-disable-next-line no-inline-assembly
87         assembly { size := extcodesize(account) }
88         return size > 0;
89     }
90 }
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://eips.ethereum.org/EIPS/eip-20
95  */
96 interface IERC20 {
97     function transfer(address to, uint256 value) external returns (bool);
98 
99     function approve(address spender, uint256 value) external returns (bool);
100 
101     function transferFrom(address from, address to, uint256 value) external returns (bool);
102 
103     function totalSupply() external view returns (uint256);
104 
105     function balanceOf(address who) external view returns (uint256);
106 
107     function allowance(address owner, address spender) external view returns (uint256);
108 
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 // ----------------------------------------------------------------------------
115 // Contract function to receive approval and execute function in one call
116 //
117 // Borrowed from MiniMeToken
118 // ----------------------------------------------------------------------------
119 contract ApproveAndCallFallBack {
120     function receiveApproval(address from, uint256 value, address token, bytes memory data) public;
121 }
122 
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * https://eips.ethereum.org/EIPS/eip-20
130  * Originally based on code by FirstBlood:
131  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  *
133  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
134  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
135  * compliant implementations may not do it.
136  */
137 contract ERC20 is IERC20 {
138     using SafeMath for uint256;
139 
140     mapping (address => uint256) private _balances;
141 
142     mapping (address => mapping (address => uint256)) private _allowed;
143 
144     uint256 private _totalSupply;
145 
146     /**
147      * @dev Total number of tokens in existence.
148      */
149     function totalSupply() public view returns (uint256) {
150         return _totalSupply;
151     }
152 
153     /**
154      * @dev Gets the balance of the specified address.
155      * @param owner The address to query the balance of.
156      * @return A uint256 representing the amount owned by the passed address.
157      */
158     function balanceOf(address owner) public view returns (uint256) {
159         return _balances[owner];
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param owner address The address which owns the funds.
165      * @param spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address owner, address spender) public view returns (uint256) {
169         return _allowed[owner][spender];
170     }
171 
172     /**
173      * @dev Transfer token to a specified address.
174      * @param to The address to transfer to.
175      * @param value The amount to be transferred.
176      */
177     function transfer(address to, uint256 value) public returns (bool) {
178         _transfer(msg.sender, to, value);
179         return true;
180     }
181 
182     /**
183      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184      * Beware that changing an allowance with this method brings the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      * @param spender The address which will spend the funds.
189      * @param value The amount of tokens to be spent.
190      */
191     function approve(address spender, uint256 value) public returns (bool) {
192         _approve(msg.sender, spender, value);
193         return true;
194     }
195 
196     /**
197      * @dev Transfer tokens from one address to another.
198      * Note that while this function emits an Approval event, this is not required as per the specification,
199      * and other compliant implementations may not emit the event.
200      * @param from address The address which you want to send tokens from
201      * @param to address The address which you want to transfer to
202      * @param value uint256 the amount of tokens to be transferred
203      */
204     function transferFrom(address from, address to, uint256 value) public returns (bool) {
205         _transfer(from, to, value);
206         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
207         return true;
208     }
209 
210     /**
211      * @dev Increase the amount of tokens that an owner allowed to a spender.
212      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
213      * allowed value is better to use this function to avoid 2 calls (and wait until
214      * the first transaction is mined)
215      * From MonolithDAO Token.sol
216      * Emits an Approval event.
217      * @param spender The address which will spend the funds.
218      * @param addedValue The amount of tokens to increase the allowance by.
219      */
220     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
221         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
222         return true;
223     }
224 
225     /**
226      * @dev Decrease the amount of tokens that an owner allowed to a spender.
227      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
228      * allowed value is better to use this function to avoid 2 calls (and wait until
229      * the first transaction is mined)
230      * From MonolithDAO Token.sol
231      * Emits an Approval event.
232      * @param spender The address which will spend the funds.
233      * @param subtractedValue The amount of tokens to decrease the allowance by.
234      */
235     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
236         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
237         return true;
238     }
239 
240     /**
241      * @dev Transfer token for a specified addresses.
242      * @param from The address to transfer from.
243      * @param to The address to transfer to.
244      * @param value The amount to be transferred.
245      */
246     function _transfer(address from, address to, uint256 value) internal {
247         require(to != address(0));
248 
249         _balances[from] = _balances[from].sub(value);
250         _balances[to] = _balances[to].add(value);
251         emit Transfer(from, to, value);
252     }
253 
254     /**
255      * @dev Internal function that mints an amount of the token and assigns it to
256      * an account. This encapsulates the modification of balances such that the
257      * proper events are emitted.
258      * @param account The account that will receive the created tokens.
259      * @param value The amount that will be created.
260      */
261     function _mint(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.add(value);
265         _balances[account] = _balances[account].add(value);
266         emit Transfer(address(0), account, value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account.
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burn(address account, uint256 value) internal {
276         require(account != address(0));
277 
278         _totalSupply = _totalSupply.sub(value);
279         _balances[account] = _balances[account].sub(value);
280         emit Transfer(account, address(0), value);
281     }
282 
283     /**
284      * @dev Approve an address to spend another addresses' tokens.
285      * @param owner The address that owns the tokens.
286      * @param spender The address that will spend the tokens.
287      * @param value The number of tokens that can be spent.
288      */
289     function _approve(address owner, address spender, uint256 value) internal {
290         require(spender != address(0));
291         require(owner != address(0));
292 
293         _allowed[owner][spender] = value;
294         emit Approval(owner, spender, value);
295     }
296 
297     /**
298      * @dev Internal function that burns an amount of the token of a given
299      * account, deducting from the sender's allowance for said account. Uses the
300      * internal burn function.
301      * Emits an Approval event (reflecting the reduced allowance).
302      * @param account The account whose tokens will be burnt.
303      * @param value The amount that will be burnt.
304      */
305     function _burnFrom(address account, uint256 value) internal {
306         _burn(account, value);
307         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
308     }
309     
310        // ------------------------------------------------------------------------
311     // Token owner can approve for `spender` to transferFrom(...) `tokens`
312     // from the token owner's account. The `spender` contract function
313     // `receiveApproval(...)` is then executed
314     // ------------------------------------------------------------------------
315     function approveAndCall(address spender, uint value, bytes memory data) public returns (bool success) {
316         _approve(msg.sender, spender, value);
317         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, value, address(this), data);
318         return true;
319     }
320     
321     
322 }
323 
324 /**
325  * @title Burnable Token
326  * @dev Token that can be irreversibly burned (destroyed).
327  */
328 contract ERC20Burnable is ERC20 {
329     /**
330      * @dev Burns a specific amount of tokens.
331      * @param value The amount of token to be burned.
332      */
333     function burn(uint256 value) public {
334         _burn(msg.sender, value);
335     }
336 
337     /**
338      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
339      * @param from address The account whose tokens will be burned.
340      * @param value uint256 The amount of token to be burned.
341      */
342     function burnFrom(address from, uint256 value) public {
343         _burnFrom(from, value);
344     }
345 }
346 
347 /**
348  * @title ERC20Detailed token
349  * @dev The decimals are only for visualization purposes.
350  * All the operations are done using the smallest and indivisible token unit,
351  * just as on Ethereum all the operations are done in wei.
352  */
353 contract ERC20Detailed is IERC20 {
354     string private _name;
355     string private _symbol;
356     uint8 private _decimals;
357 
358     constructor (string memory name, string memory symbol, uint8 decimals) public {
359         _name = name;
360         _symbol = symbol;
361         _decimals = decimals;
362     }
363 
364     /**
365      * @return the name of the token.
366      */
367     function name() public view returns (string memory) {
368         return _name;
369     }
370 
371     /**
372      * @return the symbol of the token.
373      */
374     function symbol() public view returns (string memory) {
375         return _symbol;
376     }
377 
378     /**
379      * @return the number of decimals of the token.
380      */
381     function decimals() public view returns (uint8) {
382         return _decimals;
383     }
384 }
385 /**
386  * @title SafeERC20
387  * @dev Wrappers around ERC20 operations that throw on failure (when the token
388  * contract returns false). Tokens that return no value (and instead revert or
389  * throw on failure) are also supported, non-reverting calls are assumed to be
390  * successful.
391  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
392  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
393  */
394 library SafeERC20 {
395     using SafeMath for uint256;
396     using Address for address;
397 
398     function safeTransfer(IERC20 token, address to, uint256 value) internal {
399         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
400     }
401 
402     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
403         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
404     }
405 
406     function safeApprove(IERC20 token, address spender, uint256 value) internal {
407         // safeApprove should only be called when setting an initial allowance,
408         // or when resetting it to zero. To increase and decrease it, use
409         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
410         require((value == 0) || (token.allowance(address(this), spender) == 0));
411         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
412     }
413 
414     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
415         uint256 newAllowance = token.allowance(address(this), spender).add(value);
416         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
417     }
418 
419     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
420         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
421         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
422     }
423 
424     /**
425      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
426      * on the return value: the return value is optional (but if data is returned, it must not be false).
427      * @param token The token targeted by the call.
428      * @param data The call data (encoded using abi.encode or one of its variants).
429      */
430     function callOptionalReturn(IERC20 token, bytes memory data) private {
431         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
432         // we're implementing it ourselves.
433 
434         // A Solidity high level call has three parts:
435         //  1. The target address is checked to verify it contains contract code
436         //  2. The call itself is made, and success asserted
437         //  3. The return value is decoded, which in turn checks the size of the returned data.
438 
439         require(address(token).isContract());
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = address(token).call(data);
443         require(success);
444 
445         if (returndata.length > 0) { // Return data is optional
446             require(abi.decode(returndata, (bool)));
447         }
448     }
449 }
450 
451 contract VeriSafe is ERC20, ERC20Detailed, ERC20Burnable {
452     using SafeERC20 for ERC20;
453     constructor()
454         ERC20Burnable()
455         ERC20Detailed('VeriSafe', 'VSF', 18)
456         ERC20()
457         public
458     {
459         _mint(msg.sender, 20000000000 * (10 ** uint256(18)));
460     }
461 
462 }