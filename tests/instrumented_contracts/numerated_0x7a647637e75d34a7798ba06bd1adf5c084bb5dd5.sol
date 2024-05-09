1 pragma solidity 0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
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
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * https://eips.ethereum.org/EIPS/eip-20
119  * Originally based on code by FirstBlood:
120  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  *
122  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
123  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
124  * compliant implementations may not do it.
125  */
126 contract ERC20 is IERC20 {
127     using SafeMath for uint256;
128 
129     mapping (address => uint256) private _balances;
130 
131     mapping (address => mapping (address => uint256)) private _allowed;
132 
133     uint256 private _totalSupply;
134 
135     /**
136      * @dev Total number of tokens in existence
137      */
138     function totalSupply() public view returns (uint256) {
139         return _totalSupply;
140     }
141 
142     /**
143      * @dev Gets the balance of the specified address.
144      * @param owner The address to query the balance of.
145      * @return A uint256 representing the amount owned by the passed address.
146      */
147     function balanceOf(address owner) public view returns (uint256) {
148         return _balances[owner];
149     }
150 
151     /**
152      * @dev Function to check the amount of tokens that an owner allowed to a spender.
153      * @param owner address The address which owns the funds.
154      * @param spender address The address which will spend the funds.
155      * @return A uint256 specifying the amount of tokens still available for the spender.
156      */
157     function allowance(address owner, address spender) public view returns (uint256) {
158         return _allowed[owner][spender];
159     }
160 
161     /**
162      * @dev Transfer token to a specified address
163      * @param to The address to transfer to.
164      * @param value The amount to be transferred.
165      */
166     function transfer(address to, uint256 value) public returns (bool) {
167         _transfer(msg.sender, to, value);
168         return true;
169     }
170 
171     /**
172      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173      * Beware that changing an allowance with this method brings the risk that someone may use both the old
174      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      * @param spender The address which will spend the funds.
178      * @param value The amount of tokens to be spent.
179      */
180     function approve(address spender, uint256 value) public returns (bool) {
181         _approve(msg.sender, spender, value);
182         return true;
183     }
184 
185     /**
186      * @dev Transfer tokens from one address to another.
187      * Note that while this function emits an Approval event, this is not required as per the specification,
188      * and other compliant implementations may not emit the event.
189      * @param from address The address which you want to send tokens from
190      * @param to address The address which you want to transfer to
191      * @param value uint256 the amount of tokens to be transferred
192      */
193     function transferFrom(address from, address to, uint256 value) public returns (bool) {
194         _transfer(from, to, value);
195         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
196         return true;
197     }
198 
199     /**
200      * @dev Increase the amount of tokens that an owner allowed to a spender.
201      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param addedValue The amount of tokens to increase the allowance by.
208      */
209     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
210         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
211         return true;
212     }
213 
214     /**
215      * @dev Decrease the amount of tokens that an owner allowed to a spender.
216      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
217      * allowed value is better to use this function to avoid 2 calls (and wait until
218      * the first transaction is mined)
219      * From MonolithDAO Token.sol
220      * Emits an Approval event.
221      * @param spender The address which will spend the funds.
222      * @param subtractedValue The amount of tokens to decrease the allowance by.
223      */
224     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
225         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
226         return true;
227     }
228 
229     /**
230      * @dev Transfer token for a specified addresses
231      * @param from The address to transfer from.
232      * @param to The address to transfer to.
233      * @param value The amount to be transferred.
234      */
235     function _transfer(address from, address to, uint256 value) internal {
236         require(to != address(0));
237 
238         _balances[from] = _balances[from].sub(value);
239         _balances[to] = _balances[to].add(value);
240         emit Transfer(from, to, value);
241     }
242 
243     /**
244      * @dev Internal function that mints an amount of the token and assigns it to
245      * an account. This encapsulates the modification of balances such that the
246      * proper events are emitted.
247      * @param account The account that will receive the created tokens.
248      * @param value The amount that will be created.
249      */
250     function _mint(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.add(value);
254         _balances[account] = _balances[account].add(value);
255         emit Transfer(address(0), account, value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account.
261      * @param account The account whose tokens will be burnt.
262      * @param value The amount that will be burnt.
263      */
264     function _burn(address account, uint256 value) internal {
265         require(account != address(0));
266 
267         _totalSupply = _totalSupply.sub(value);
268         _balances[account] = _balances[account].sub(value);
269         emit Transfer(account, address(0), value);
270     }
271 
272     /**
273      * @dev Approve an address to spend another addresses' tokens.
274      * @param owner The address that owns the tokens.
275      * @param spender The address that will spend the tokens.
276      * @param value The number of tokens that can be spent.
277      */
278     function _approve(address owner, address spender, uint256 value) internal {
279         require(spender != address(0));
280         require(owner != address(0));
281 
282         _allowed[owner][spender] = value;
283         emit Approval(owner, spender, value);
284     }
285 
286     /**
287      * @dev Internal function that burns an amount of the token of a given
288      * account, deducting from the sender's allowance for said account. Uses the
289      * internal burn function.
290      * Emits an Approval event (reflecting the reduced allowance).
291      * @param account The account whose tokens will be burnt.
292      * @param value The amount that will be burnt.
293      */
294     function _burnFrom(address account, uint256 value) internal {
295         _burn(account, value);
296         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
297     }
298 }
299 
300 /**
301  * @title Ownable
302  * @dev The Ownable contract has an owner address, and provides basic authorization control
303  * functions, this simplifies the implementation of "user permissions".
304  */
305 contract Ownable {
306     address private _owner;
307 
308     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
309 
310     /**
311      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
312      * account.
313      */
314     constructor () internal {
315         _owner = msg.sender;
316         emit OwnershipTransferred(address(0), _owner);
317     }
318 
319     /**
320      * @return the address of the owner.
321      */
322     function owner() public view returns (address) {
323         return _owner;
324     }
325 
326     /**
327      * @dev Throws if called by any account other than the owner.
328      */
329     modifier onlyOwner() {
330         require(isOwner());
331         _;
332     }
333 
334     /**
335      * @return true if `msg.sender` is the owner of the contract.
336      */
337     function isOwner() public view returns (bool) {
338         return msg.sender == _owner;
339     }
340 
341     /**
342      * @dev Allows the current owner to relinquish control of the contract.
343      * It will not be possible to call the functions with the `onlyOwner`
344      * modifier anymore.
345      * @notice Renouncing ownership will leave the contract without an owner,
346      * thereby removing any functionality that is only available to the owner.
347      */
348     function renounceOwnership() public onlyOwner {
349         emit OwnershipTransferred(_owner, address(0));
350         _owner = address(0);
351     }
352 
353     /**
354      * @dev Allows the current owner to transfer control of the contract to a newOwner.
355      * @param newOwner The address to transfer ownership to.
356      */
357     function transferOwnership(address newOwner) public onlyOwner {
358         _transferOwnership(newOwner);
359     }
360 
361     /**
362      * @dev Transfers control of the contract to a newOwner.
363      * @param newOwner The address to transfer ownership to.
364      */
365     function _transferOwnership(address newOwner) internal {
366         require(newOwner != address(0));
367         emit OwnershipTransferred(_owner, newOwner);
368         _owner = newOwner;
369     }
370 }
371 
372 /**
373  * @title SafeERC20
374  * @dev Wrappers around ERC20 operations that throw on failure (when the token
375  * contract returns false). Tokens that return no value (and instead revert or
376  * throw on failure) are also supported, non-reverting calls are assumed to be
377  * successful.
378  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
379  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
380  */
381 library SafeERC20 {
382     using SafeMath for uint256;
383     using Address for address;
384 
385     function safeTransfer(IERC20 token, address to, uint256 value) internal {
386         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
387     }
388 
389     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
390         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
391     }
392 
393     function safeApprove(IERC20 token, address spender, uint256 value) internal {
394         // safeApprove should only be called when setting an initial allowance,
395         // or when resetting it to zero. To increase and decrease it, use
396         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
397         require((value == 0) || (token.allowance(address(this), spender) == 0));
398         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
399     }
400 
401     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
402         uint256 newAllowance = token.allowance(address(this), spender).add(value);
403         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
404     }
405 
406     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
407         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
408         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
409     }
410 
411     /**
412      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
413      * on the return value: the return value is optional (but if data is returned, it must equal true).
414      * @param token The token targeted by the call.
415      * @param data The call data (encoded using abi.encode or one of its variants).
416      */
417     function callOptionalReturn(IERC20 token, bytes memory data) private {
418         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
419         // we're implementing it ourselves.
420 
421         // A Solidity high level call has three parts:
422         //  1. The target address is checked to verify it contains contract code
423         //  2. The call itself is made, and success asserted
424         //  3. The return value is decoded, which in turn checks the size of the returned data.
425 
426         require(address(token).isContract());
427 
428         // solhint-disable-next-line avoid-low-level-calls
429         (bool success, bytes memory returndata) = address(token).call(data);
430         require(success);
431 
432         if (returndata.length > 0) { // Return data is optional
433             require(abi.decode(returndata, (bool)));
434         }
435     }
436 }
437 
438 contract TokenRecoverable is Ownable {
439     using SafeERC20 for IERC20;
440 
441     function recoverTokens(IERC20 token, address to, uint256 amount) public onlyOwner {
442         uint256 balance = token.balanceOf(address(this));
443         require(balance >= amount, "Given amount is larger than current balance");
444         token.safeTransfer(to, amount);
445     }
446 }
447 
448 interface ITokenReceiver {
449     function tokensReceived(
450         address from,
451         address to,
452         uint256 amount
453     ) external;
454 }
455 
456 contract BSYToken is TokenRecoverable, ERC20 {
457     using SafeMath for uint256;
458     using Address for address;
459 
460     string public constant name = "BSYToken";
461     string public constant symbol = "BSY";
462     uint8 public constant decimals = uint8(18); 
463     uint256 public tokensToMint = 1000000000e18; // 1 000 000 000 tokens
464     
465     address public burnAddress;
466     mapping(address => bool) public notify;
467     
468     function register() public {
469         notify[msg.sender] = true;
470     }
471 
472     function unregister() public {
473         notify[msg.sender] = false;
474     }
475 
476     /**
477      * @dev Transfer token to a specified address
478      * @param to The address to transfer to.
479      * @param value The amount to be transferred.
480      */
481     function transfer(address to, uint256 value) public returns (bool) {
482         bool success = super.transfer(to, value);
483         if (success) {
484             _postTransfer(msg.sender, to, value);
485         }
486         return success;
487     }
488 
489     /**
490      * @dev Transfer tokens from one address to another.
491      * Note that while this function emits an Approval event, this is not required as per the specification,
492      * and other compliant implementations may not emit the event.
493      * @param from address The address which you want to send tokens from
494      * @param to address The address which you want to transfer to
495      * @param value uint256 the amount of tokens to be transferred
496      */
497     function transferFrom(address from, address to, uint256 value) public returns (bool) {
498         bool success = super.transferFrom(from, to, value);
499         if (success) {
500             _postTransfer(from, to, value);
501         }
502         return success;
503     }
504 
505     function _postTransfer(address from, address to, uint256 value) internal {
506         if (to.isContract()) {
507             if (notify[to] == false) return;
508 
509             ITokenReceiver(to).tokensReceived(from, to, value);
510         } else {
511             if (to == burnAddress) {
512                 _burn(burnAddress, value);
513             }
514         }
515     }
516 
517     function _burn(address account, uint256 value) internal {
518         require(tokensToMint == 0, "All tokens must be minted before burning");
519         super._burn(account, value);
520     }
521 
522     /**
523      * @dev Function to mint tokens
524      * @param to The address that will receive the minted tokens.
525      * @param value The amount of tokens to mint.
526      * @return A boolean that indicates if the operation was successful.
527      */
528     function mint(address to, uint256 value) public onlyOwner returns (bool) {
529         require(tokensToMint.sub(value) >= 0, "Not enough tokens left");
530         tokensToMint = tokensToMint.sub(value);
531         _mint(to, value);
532         _postTransfer(address(0), to, value);
533         return true;
534     }
535 
536     /**
537      * @dev Burns a specific amount of tokens.
538      * @param value The amount of token to be burned.
539      */
540     function burn(uint256 value) public {
541         require(msg.sender == burnAddress, "Only burnAddress can burn tokens");
542         _burn(msg.sender, value);
543     }
544 
545     function setBurnAddress(address _burnAddress) external onlyOwner {
546         require(balanceOf(_burnAddress) == 0, "Burn address must have zero balance!");
547 
548         burnAddress = _burnAddress;
549     }
550 }