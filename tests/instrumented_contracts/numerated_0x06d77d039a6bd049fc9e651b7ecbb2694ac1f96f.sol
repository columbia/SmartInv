1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123     * @dev Total number of tokens in existence
124     */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param owner The address to query the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     * @param to The address to transfer to.
151     * @param value The amount to be transferred.
152     */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         require(spender != address(0));
220 
221         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified addresses
228     * @param from The address to transfer from.
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.add(value);
251         _balances[account] = _balances[account].add(value);
252         emit Transfer(address(0), account, value);
253     }
254 
255     /**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burn(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.sub(value);
265         _balances[account] = _balances[account].sub(value);
266         emit Transfer(account, address(0), value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
285 
286 pragma solidity ^0.5.0;
287 
288 
289 /**
290  * @title Burnable Token
291  * @dev Token that can be irreversibly burned (destroyed).
292  */
293 contract ERC20Burnable is ERC20 {
294     /**
295      * @dev Burns a specific amount of tokens.
296      * @param value The amount of token to be burned.
297      */
298     function burn(uint256 value) public {
299         _burn(msg.sender, value);
300     }
301 
302     /**
303      * @dev Burns a specific amount of tokens from the target address and decrements allowance
304      * @param from address The address which you want to send tokens from
305      * @param value uint256 The amount of token to be burned
306      */
307     function burnFrom(address from, uint256 value) public {
308         _burnFrom(from, value);
309     }
310 }
311 
312 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
313 
314 pragma solidity ^0.5.0;
315 
316 
317 
318 /**
319  * @title SafeERC20
320  * @dev Wrappers around ERC20 operations that throw on failure.
321  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
322  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
323  */
324 library SafeERC20 {
325     using SafeMath for uint256;
326 
327     function safeTransfer(IERC20 token, address to, uint256 value) internal {
328         require(token.transfer(to, value));
329     }
330 
331     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
332         require(token.transferFrom(from, to, value));
333     }
334 
335     function safeApprove(IERC20 token, address spender, uint256 value) internal {
336         // safeApprove should only be called when setting an initial allowance,
337         // or when resetting it to zero. To increase and decrease it, use
338         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
339         require((value == 0) || (token.allowance(address(this), spender) == 0));
340         require(token.approve(spender, value));
341     }
342 
343     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
344         uint256 newAllowance = token.allowance(address(this), spender).add(value);
345         require(token.approve(spender, newAllowance));
346     }
347 
348     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
349         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
350         require(token.approve(spender, newAllowance));
351     }
352 }
353 
354 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
355 
356 pragma solidity ^0.5.0;
357 
358 /**
359  * @title Ownable
360  * @dev The Ownable contract has an owner address, and provides basic authorization control
361  * functions, this simplifies the implementation of "user permissions".
362  */
363 contract Ownable {
364     address private _owner;
365 
366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
367 
368     /**
369      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
370      * account.
371      */
372     constructor () internal {
373         _owner = msg.sender;
374         emit OwnershipTransferred(address(0), _owner);
375     }
376 
377     /**
378      * @return the address of the owner.
379      */
380     function owner() public view returns (address) {
381         return _owner;
382     }
383 
384     /**
385      * @dev Throws if called by any account other than the owner.
386      */
387     modifier onlyOwner() {
388         require(isOwner());
389         _;
390     }
391 
392     /**
393      * @return true if `msg.sender` is the owner of the contract.
394      */
395     function isOwner() public view returns (bool) {
396         return msg.sender == _owner;
397     }
398 
399     /**
400      * @dev Allows the current owner to relinquish control of the contract.
401      * @notice Renouncing to ownership will leave the contract without an owner.
402      * It will not be possible to call the functions with the `onlyOwner`
403      * modifier anymore.
404      */
405     function renounceOwnership() public onlyOwner {
406         emit OwnershipTransferred(_owner, address(0));
407         _owner = address(0);
408     }
409 
410     /**
411      * @dev Allows the current owner to transfer control of the contract to a newOwner.
412      * @param newOwner The address to transfer ownership to.
413      */
414     function transferOwnership(address newOwner) public onlyOwner {
415         _transferOwnership(newOwner);
416     }
417 
418     /**
419      * @dev Transfers control of the contract to a newOwner.
420      * @param newOwner The address to transfer ownership to.
421      */
422     function _transferOwnership(address newOwner) internal {
423         require(newOwner != address(0));
424         emit OwnershipTransferred(_owner, newOwner);
425         _owner = newOwner;
426     }
427 }
428 
429 // File: contracts/misc/AbstractAmbix.sol
430 
431 pragma solidity ^0.5.0;
432 
433 
434 
435 
436 /**
437   @dev Ambix contract is used for morph Token set to another
438   Token's by rule (recipe). In distillation process given
439   Token's are burned and result generated by emission.
440   
441   The recipe presented as equation in form:
442   (N1 * A1 & N'1 * A'1 & N''1 * A''1 ...)
443   | (N2 * A2 & N'2 * A'2 & N''2 * A''2 ...) ...
444   | (Nn * An & N'n * A'n & N''n * A''n ...)
445   = M1 * B1 & M2 * B2 ... & Mm * Bm 
446     where A, B - input and output tokens
447           N, M - token value coeficients
448           n, m - input / output dimetion size 
449           | - is alternative operator (logical OR)
450           & - is associative operator (logical AND)
451   This says that `Ambix` should receive (approve) left
452   part of equation and send (transfer) right part.
453 */
454 contract AbstractAmbix is Ownable {
455     using SafeERC20 for ERC20Burnable;
456     using SafeERC20 for ERC20;
457 
458     address[][] public A;
459     uint256[][] public N;
460     address[] public B;
461     uint256[] public M;
462 
463     /**
464      * @dev Append token recipe source alternative
465      * @param _a Token recipe source token addresses
466      * @param _n Token recipe source token counts
467      **/
468     function appendSource(
469         address[] calldata _a,
470         uint256[] calldata _n
471     ) external onlyOwner {
472         uint256 i;
473 
474         require(_a.length == _n.length && _a.length > 0);
475 
476         for (i = 0; i < _a.length; ++i)
477             require(_a[i] != address(0));
478 
479         if (_n.length == 1 && _n[0] == 0) {
480             require(B.length == 1);
481         } else {
482             for (i = 0; i < _n.length; ++i)
483                 require(_n[i] > 0);
484         }
485 
486         A.push(_a);
487         N.push(_n);
488     }
489 
490     /**
491      * @dev Set sink of token recipe
492      * @param _b Token recipe sink token list
493      * @param _m Token recipe sink token counts
494      */
495     function setSink(
496         address[] calldata _b,
497         uint256[] calldata _m
498     ) external onlyOwner{
499         require(_b.length == _m.length);
500 
501         for (uint256 i = 0; i < _b.length; ++i)
502             require(_b[i] != address(0));
503 
504         B = _b;
505         M = _m;
506     }
507 
508     function _run(uint256 _ix) internal {
509         require(_ix < A.length);
510         uint256 i;
511 
512         if (N[_ix][0] > 0) {
513             // Static conversion
514 
515             // Token count multiplier
516             uint256 mux = ERC20(A[_ix][0]).allowance(msg.sender, address(this)) / N[_ix][0];
517             require(mux > 0);
518 
519             // Burning run
520             for (i = 0; i < A[_ix].length; ++i)
521                 ERC20Burnable(A[_ix][i]).burnFrom(msg.sender, mux * N[_ix][i]);
522 
523             // Transfer up
524             for (i = 0; i < B.length; ++i)
525                 ERC20(B[i]).safeTransfer(msg.sender, M[i] * mux);
526 
527         } else {
528             // Dynamic conversion
529             //   Let source token total supply is finite and decrease on each conversion,
530             //   just convert finite supply of source to tokens on balance of ambix.
531             //         dynamicRate = balance(sink) / total(source)
532 
533             // Is available for single source and single sink only
534             require(A[_ix].length == 1 && B.length == 1);
535 
536             ERC20Burnable source = ERC20Burnable(A[_ix][0]);
537             ERC20 sink = ERC20(B[0]);
538 
539             uint256 scale = 10 ** 18 * sink.balanceOf(address(this)) / source.totalSupply();
540 
541             uint256 allowance = source.allowance(msg.sender, address(this));
542             require(allowance > 0);
543             source.burnFrom(msg.sender, allowance);
544 
545             uint256 reward = scale * allowance / 10 ** 18;
546             require(reward > 0);
547             sink.safeTransfer(msg.sender, reward);
548         }
549     }
550 }
551 
552 // File: contracts/misc/PublicAmbix.sol
553 
554 pragma solidity ^0.5.0;
555 
556 
557 contract PublicAmbix is AbstractAmbix {
558     /**
559      * @dev Run distillation process
560      * @param _ix Source alternative index
561      */
562     function run(uint256 _ix) external {
563         _run(_ix);
564     }
565 }