1 pragma solidity ^0.5.0;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
27 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
28 
29 /**
30  * @title ERC20Detailed token
31  * @dev The decimals are only for visualization purposes.
32  * All the operations are done using the smallest and indivisible token unit,
33  * just as on Ethereum all the operations are done in wei.
34  */
35 contract ERC20Detailed is IERC20 {
36     string private _name;
37     string private _symbol;
38     uint8 private _decimals;
39 
40     constructor (string memory name, string memory symbol, uint8 decimals) public {
41         _name = name;
42         _symbol = symbol;
43         _decimals = decimals;
44     }
45 
46     /**
47      * @return the name of the token.
48      */
49     function name() public view returns (string memory) {
50         return _name;
51     }
52 
53     /**
54      * @return the symbol of the token.
55      */
56     function symbol() public view returns (string memory) {
57         return _symbol;
58     }
59 
60     /**
61      * @return the number of decimals of the token.
62      */
63     function decimals() public view returns (uint8) {
64         return _decimals;
65     }
66 }
67 
68 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
69 
70 /**
71  * @title SafeMath
72  * @dev Unsigned math operations with safety checks that revert on error
73  */
74 library SafeMath {
75     /**
76     * @dev Multiplies two unsigned integers, reverts on overflow.
77     */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     /**
93     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
94     */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Solidity only automatically asserts when dividing by 0
97         require(b > 0);
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     /**
105     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
106     */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b <= a);
109         uint256 c = a - b;
110 
111         return c;
112     }
113 
114     /**
115     * @dev Adds two unsigned integers, reverts on overflow.
116     */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a);
120 
121         return c;
122     }
123 
124     /**
125     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
126     * reverts when dividing by zero.
127     */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b != 0);
130         return a % b;
131     }
132 }
133 
134 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
141  * Originally based on code by FirstBlood:
142  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  *
144  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
145  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
146  * compliant implementations may not do it.
147  */
148 contract ERC20 is IERC20 {
149     using SafeMath for uint256;
150 
151     mapping (address => uint256) private _balances;
152 
153     mapping (address => mapping (address => uint256)) private _allowed;
154 
155     uint256 private _totalSupply;
156 
157     /**
158     * @dev Total number of tokens in existence
159     */
160     function totalSupply() public view returns (uint256) {
161         return _totalSupply;
162     }
163 
164     /**
165     * @dev Gets the balance of the specified address.
166     * @param owner The address to query the balance of.
167     * @return An uint256 representing the amount owned by the passed address.
168     */
169     function balanceOf(address owner) public view returns (uint256) {
170         return _balances[owner];
171     }
172 
173     /**
174      * @dev Function to check the amount of tokens that an owner allowed to a spender.
175      * @param owner address The address which owns the funds.
176      * @param spender address The address which will spend the funds.
177      * @return A uint256 specifying the amount of tokens still available for the spender.
178      */
179     function allowance(address owner, address spender) public view returns (uint256) {
180         return _allowed[owner][spender];
181     }
182 
183     /**
184     * @dev Transfer token for a specified address
185     * @param to The address to transfer to.
186     * @param value The amount to be transferred.
187     */
188     function transfer(address to, uint256 value) public returns (bool) {
189         _transfer(msg.sender, to, value);
190         return true;
191     }
192 
193     /**
194      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195      * Beware that changing an allowance with this method brings the risk that someone may use both the old
196      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      * @param spender The address which will spend the funds.
200      * @param value The amount of tokens to be spent.
201      */
202     function approve(address spender, uint256 value) public returns (bool) {
203         require(spender != address(0));
204 
205         _allowed[msg.sender][spender] = value;
206         emit Approval(msg.sender, spender, value);
207         return true;
208     }
209 
210     /**
211      * @dev Transfer tokens from one address to another.
212      * Note that while this function emits an Approval event, this is not required as per the specification,
213      * and other compliant implementations may not emit the event.
214      * @param from address The address which you want to send tokens from
215      * @param to address The address which you want to transfer to
216      * @param value uint256 the amount of tokens to be transferred
217      */
218     function transferFrom(address from, address to, uint256 value) public returns (bool) {
219         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
220         _transfer(from, to, value);
221         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
222         return true;
223     }
224 
225     /**
226      * @dev Increase the amount of tokens that an owner allowed to a spender.
227      * approve should be called when allowed_[_spender] == 0. To increment
228      * allowed value is better to use this function to avoid 2 calls (and wait until
229      * the first transaction is mined)
230      * From MonolithDAO Token.sol
231      * Emits an Approval event.
232      * @param spender The address which will spend the funds.
233      * @param addedValue The amount of tokens to increase the allowance by.
234      */
235     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
236         require(spender != address(0));
237 
238         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
239         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
240         return true;
241     }
242 
243     /**
244      * @dev Decrease the amount of tokens that an owner allowed to a spender.
245      * approve should be called when allowed_[_spender] == 0. To decrement
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * Emits an Approval event.
250      * @param spender The address which will spend the funds.
251      * @param subtractedValue The amount of tokens to decrease the allowance by.
252      */
253     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
254         require(spender != address(0));
255 
256         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
257         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
258         return true;
259     }
260 
261     /**
262     * @dev Transfer token for a specified addresses
263     * @param from The address to transfer from.
264     * @param to The address to transfer to.
265     * @param value The amount to be transferred.
266     */
267     function _transfer(address from, address to, uint256 value) internal {
268         require(to != address(0));
269 
270         _balances[from] = _balances[from].sub(value);
271         _balances[to] = _balances[to].add(value);
272         emit Transfer(from, to, value);
273     }
274 
275     /**
276      * @dev Internal function that mints an amount of the token and assigns it to
277      * an account. This encapsulates the modification of balances such that the
278      * proper events are emitted.
279      * @param account The account that will receive the created tokens.
280      * @param value The amount that will be created.
281      */
282     function _mint(address account, uint256 value) internal {
283         require(account != address(0));
284 
285         _totalSupply = _totalSupply.add(value);
286         _balances[account] = _balances[account].add(value);
287         emit Transfer(address(0), account, value);
288     }
289 
290     /**
291      * @dev Internal function that burns an amount of the token of a given
292      * account.
293      * @param account The account whose tokens will be burnt.
294      * @param value The amount that will be burnt.
295      */
296     function _burn(address account, uint256 value) internal {
297         require(account != address(0));
298 
299         _totalSupply = _totalSupply.sub(value);
300         _balances[account] = _balances[account].sub(value);
301         emit Transfer(account, address(0), value);
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
313         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
314         _burn(account, value);
315         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
316     }
317 }
318 
319 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
320 
321 /**
322  * @title Ownable
323  * @dev The Ownable contract has an owner address, and provides basic authorization control
324  * functions, this simplifies the implementation of "user permissions".
325  */
326 contract Ownable {
327     address private _owner;
328 
329     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
330 
331     /**
332      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
333      * account.
334      */
335     constructor () internal {
336         _owner = msg.sender;
337         emit OwnershipTransferred(address(0), _owner);
338     }
339 
340     /**
341      * @return the address of the owner.
342      */
343     function owner() public view returns (address) {
344         return _owner;
345     }
346 
347     /**
348      * @dev Throws if called by any account other than the owner.
349      */
350     modifier onlyOwner() {
351         require(isOwner());
352         _;
353     }
354 
355     /**
356      * @return true if `msg.sender` is the owner of the contract.
357      */
358     function isOwner() public view returns (bool) {
359         return msg.sender == _owner;
360     }
361 
362     /**
363      * @dev Allows the current owner to relinquish control of the contract.
364      * @notice Renouncing to ownership will leave the contract without an owner.
365      * It will not be possible to call the functions with the `onlyOwner`
366      * modifier anymore.
367      */
368     function renounceOwnership() public onlyOwner {
369         emit OwnershipTransferred(_owner, address(0));
370         _owner = address(0);
371     }
372 
373     /**
374      * @dev Allows the current owner to transfer control of the contract to a newOwner.
375      * @param newOwner The address to transfer ownership to.
376      */
377     function transferOwnership(address newOwner) public onlyOwner {
378         _transferOwnership(newOwner);
379     }
380 
381     /**
382      * @dev Transfers control of the contract to a newOwner.
383      * @param newOwner The address to transfer ownership to.
384      */
385     function _transferOwnership(address newOwner) internal {
386         require(newOwner != address(0));
387         emit OwnershipTransferred(_owner, newOwner);
388         _owner = newOwner;
389     }
390 }
391 
392 // File: contracts/LockedPosition.sol
393 
394 // 锁仓认购期的账户
395 contract LockedPosition is ERC20, Ownable {
396 
397     mapping (address => uint256) private _partners;
398     mapping (address => uint256) private _release;
399 
400     bool public publish = false;
401     uint256 public released = 0;
402 
403     /**
404     * @dev update account to partner list
405     * @return 
406     */
407     function partner(address from, address to, uint256 value) internal {
408         require(from != address(0), "The from address is empty");
409         require(to != address(0), "The to address is empty");
410 
411         if(publish){
412             // 已发行
413             _release[from] = _release[from].add(value);
414         }else{
415             // 未发行
416             if(owner() != from){
417                 _partners[from] = _partners[from].sub(value);
418             }
419             if(owner() != to){
420                 _partners[to] = _partners[to].add(value);
421             }
422         }
423     }
424     /**
425      * @dev check an account position
426      * @return bool
427      */
428     function checkPosition(address account, uint256 value) internal view returns (bool) {
429         require(account != address(0), "The account address is empty");
430         // 发行人，不限制
431         if (isOwner()){
432             return true;
433         } 
434         // 未发行，未锁仓，不限制
435         if (!publish){
436             return true;
437         } 
438         // 放开率100%，不限制
439         if (released >= 100) {
440             return true;
441         }
442         // 锁仓之后的交易地址，不限制
443         if(_partners[account]==0){
444             return true;
445         }
446         // 已经发行，锁定
447         return ((_partners[account]/100) * released) >= _release[account] + value;
448     }
449 
450     /**
451      * @dev locked partners account
452      * @return 
453      */
454     function locked() external onlyOwner {
455         publish = true;
456     }
457     /**
458      * @dev release position
459      * @return 
460      */
461     function release(uint256 percent) external onlyOwner {
462         require(percent <= 100 && percent > 0, "The released must be between 0 and 100");
463         released = percent;
464     }
465      /**
466      * @dev get account position
467      * @return bool
468      */
469     function getPosition() external view returns(uint256) {
470         return _partners[msg.sender];
471     }
472 
473     /**
474      * @dev get account release
475      * @return bool
476      */
477     function getRelease() external view returns(uint256) {
478         return _release[msg.sender];
479     }
480 
481     /**
482      * @dev get account position
483      * @return bool
484      */
485     function positionOf(address account) external onlyOwner view returns(uint256) {
486         require(account != address(0), "The account address is empty");
487         return _partners[account];
488     }
489 
490     /**
491      * @dev get account release
492      * @return bool
493      */
494     function releaseOf(address account) external onlyOwner view returns(uint256) {
495         require(account != address(0), "The account address is empty");
496         return _release[account];
497     }
498     
499     
500     function transfer(address to, uint256 value) public returns (bool) {
501         require(checkPosition(msg.sender, value), "Insufficient positions");
502 
503         partner(msg.sender, to, value);
504 
505         return super.transfer(to, value);
506     }
507 
508     function transferFrom(address from,address to, uint256 value) public returns (bool) {
509         require(checkPosition(from, value), "Insufficient positions");
510 
511         partner(from, to, value);
512 
513         return super.transferFrom(from, to, value);
514     }
515 }
516 
517 // File: contracts/XinTimeToken.sol
518 
519 contract XinTimeToken is ERC20Detailed, LockedPosition {
520     uint256 private constant INITIAL_SUPPLY = 2 * (10**8) * (10**18);
521 
522     constructor () public ERC20Detailed("Xin Time Token", "XTT", 18){
523         _mint(msg.sender, INITIAL_SUPPLY);
524         emit Transfer(address(0), msg.sender, totalSupply());
525     }
526 
527 }