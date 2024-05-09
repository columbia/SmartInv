1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         assert(c>=a && c>=b);
98         return c;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         assert(b <= a);
113         return a - b;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      *
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a * b;
128         assert(a == 0 || c / a == b);
129         return c;
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers, reverting on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator.
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function div(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b > 0, "SafeMath: division by zero");
144         uint256 c = a / b;
145         assert(a == b * c + a % b);
146         return c;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * reverting when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b != 0, "SafeMath: modulo by zero");
163         return a % b;
164     }
165     
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * CAUTION: This function is deprecated because it requires allocating memory for the error
172      * message unnecessarily. For custom revert reasons use {trySub}.
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         unchecked {
186             require(b <= a, errorMessage);
187             return a - b;
188         }
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(
204         uint256 a,
205         uint256 b,
206         string memory errorMessage
207     ) internal pure returns (uint256) {
208         unchecked {
209             require(b > 0, errorMessage);
210             return a / b;
211         }
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * reverting with custom message when dividing by zero.
217      *
218      * CAUTION: This function is deprecated because it requires allocating memory for the error
219      * message unnecessarily. For custom revert reasons use {tryMod}.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(
230         uint256 a,
231         uint256 b,
232         string memory errorMessage
233     ) internal pure returns (uint256) {
234         unchecked {
235             require(b > 0, errorMessage);
236             return a % b;
237         }
238     }
239 }
240 
241 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
242 
243 
244 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Interface of the ERC20 standard as defined in the EIP.
250  */
251 interface IERC20 {
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to {approve}. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 
266     /**
267      * @dev Returns the amount of tokens in existence.
268      */
269     function totalSupply() external view returns (uint256);
270 
271     /**
272      * @dev Returns the amount of tokens owned by `account`.
273      */
274     function balanceOf(address account) external view returns (uint256);
275 
276     /**
277      * @dev Moves `amount` tokens from the caller's account to `to`.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transfer(address to, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Returns the remaining number of tokens that `spender` will be
287      * allowed to spend on behalf of `owner` through {transferFrom}. This is
288      * zero by default.
289      *
290      * This value changes when {approve} or {transferFrom} are called.
291      */
292     function allowance(address owner, address spender) external view returns (uint256);
293 
294     /**
295      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * IMPORTANT: Beware that changing an allowance with this method brings the risk
300      * that someone may use both the old and the new allowance by unfortunate
301      * transaction ordering. One possible solution to mitigate this race
302      * condition is to first reduce the spender's allowance to 0 and set the
303      * desired value afterwards:
304      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305      *
306      * Emits an {Approval} event.
307      */
308     function approve(address spender, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Moves `amount` tokens from `from` to `to` using the
312      * allowance mechanism. `amount` is then deducted from the caller's
313      * allowance.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * Emits a {Transfer} event.
318      */
319     function transferFrom( address from, address to, uint256 amount) external returns (bool);
320 }
321 
322 // File: @openzeppelin/contracts/utils/Context.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Provides information about the current execution context, including the
331  * sender of the transaction and its data. While these are generally available
332  * via msg.sender and msg.data, they should not be accessed in such a direct
333  * manner, since when dealing with meta-transactions the account sending and
334  * paying for execution may not be the actual sender (as far as an application
335  * is concerned).
336  *
337  * This contract is only required for intermediate, library-like contracts.
338  */
339 abstract contract Context {
340     function _msgSender() internal view virtual returns (address) {
341         return msg.sender;
342     }
343 
344     function _msgData() internal view virtual returns (bytes calldata) {
345         return msg.data;
346     }
347 }
348 
349 // File: @openzeppelin/contracts/access/Ownable.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Contract module which provides a basic access control mechanism, where
359  * there is an account (an owner) that can be granted exclusive access to
360  * specific functions.
361  *
362  * By default, the owner account will be the one that deploys the contract. This
363  * can later be changed with {transferOwnership}.
364  *
365  * This module is used through inheritance. It will make available the modifier
366  * `onlyOwner`, which can be applied to your functions to restrict their use to
367  * the owner.
368  */
369 abstract contract Ownable is Context {
370     address private _owner;
371 
372     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
373 
374     /**
375      * @dev Initializes the contract setting the deployer as the initial owner.
376      */
377     constructor() {
378         _transferOwnership(_msgSender());
379     }
380 
381     /**
382      * @dev Returns the address of the current owner.
383      */
384     function owner() public view virtual returns (address) {
385         return _owner;
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         require(owner() == _msgSender(), "Ownable: caller is not the owner");
393         _;
394     }
395 
396     /**
397      * @dev Leaves the contract without owner. It will not be possible to call
398      * `onlyOwner` functions anymore. Can only be called by the current owner.
399      *
400      * NOTE: Renouncing ownership will leave the contract without an owner,
401      * thereby removing any functionality that is only available to the owner.
402      */
403     function renounceOwnership() public virtual onlyOwner {
404         _transferOwnership(address(0));
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Can only be called by the current owner.
410      */
411     function transferOwnership(address newOwner) public virtual onlyOwner {
412         require(newOwner != address(0), "Ownable: new owner is the zero address");
413         _transferOwnership(newOwner);
414     }
415 
416     /**
417      * @dev Transfers ownership of the contract to a new account (`newOwner`).
418      * Internal function without access restriction.
419      */
420     function _transferOwnership(address newOwner) internal virtual {
421         address oldOwner = _owner;
422         _owner = newOwner;
423         emit OwnershipTransferred(oldOwner, newOwner);
424     }
425 }
426 
427 // File: contract/HZMCOIN.sol
428 
429 
430 
431 pragma solidity ^0.8.7;
432 
433 
434 
435 
436 contract HZMCOIN is Ownable,IERC20 {
437 
438     using SafeMath for uint256;
439 
440     uint256 public decimals = 8;   //How many decimals to show.
441     uint256 private totalSupply_ = 4450000000 * 10**8;  // 4.45 billion tokens, 8 decimal places
442     string constant public name = "HZMCOIN"; //fancy name: eg HZM COIN
443     string constant public symbol = "HZM"; //An identifier: eg HZM
444     string constant public version = "v2";  //Version 2 standard. Just an arbitrary versioning scheme
445 
446     mapping (address => uint256) balances;
447     mapping (address => mapping (address => uint256)) allowed;
448     mapping (address => bool) public frozenAccount;
449 
450     event FrozenFunds(address target, bool frozen);
451 
452     constructor()  {
453         balances[_msgSender()] = totalSupply_;  // Give the creator all initial tokens
454         emit Transfer(address(0), _msgSender(), totalSupply_);
455     }
456 
457     function mint(uint256 _amount) public onlyOwner returns(bool) {                                                                                                                                                                                         
458         require(_amount > 0, "Amount must be greater than zero");  // Don't Mint 0 Amount 
459         
460         totalSupply_ = totalSupply_.add(_amount);
461         balances[ _msgSender()] = balances[ _msgSender()].add(_amount);
462 
463         emit Transfer(address(0),  _msgSender(), _amount);
464         return true;
465     }
466 
467     // Only owner can freeze and unfreeze of account
468     function freezeAccount(address target, bool freeze) public onlyOwner {
469         frozenAccount[target] = freeze;
470 
471         emit FrozenFunds(target, freeze);
472     }
473 
474     function balanceOf(address _owner) public view override returns (uint256 balance) {
475         return balances[_owner];
476     }
477 
478     function totalSupply() public view override returns (uint256){
479         return totalSupply_;
480     }
481 
482     function approve(address spender, uint256 amount) public override returns (bool success) {
483         require(balances[_msgSender()]>= amount && amount > 0,"Balances is not enough"); // Check if the sender has enough
484         _approve(_msgSender(), spender, amount);
485         return true;
486     }
487 
488     function transfer(address _to, uint256 _amount) public override returns (bool success) {
489         require(!frozenAccount[_msgSender()] ,"Your account is frozen account"); // Check for frozen account
490         require(balances[_msgSender()]>= _amount && _amount > 0 ,"Amount is not enough");  // Check if the sender has enough
491            
492         _transfer(_msgSender(), _to, _amount);
493 
494         return true;
495     }
496 
497     function transferFrom(address _spenderOwner, address _recipient, uint256 _amount) public override returns (bool) {
498         require(!frozenAccount[_msgSender()],"Your account is frozen account"); // Check for frozen account
499         require(!frozenAccount[_spenderOwner] ,"Spender owner's account is frozen account"); // Check for frozen account
500         require(allowed[_spenderOwner][_msgSender()] >= _amount,"Amount is more then approve amount"); // Check allowance amount
501         require(_amount > 0, "Transfer amount must be greater than zero");  // Don't allow 0Amount transfer
502        
503         _transfer(_spenderOwner,_recipient,_amount);
504         _approve(_spenderOwner,_msgSender(),allowed[_spenderOwner][_msgSender()].sub(_amount,"ERC20: transfer amount exceeds allowance"));
505 
506         return true;
507     }
508 
509     function _transfer(address from,address to, uint256 amount ) private {
510         require(from != address(0),"ERC20: transfer from the zero address"); // check address
511         require(to != address(0), "ERC20: transfer to the zero address");   // check address
512     
513         balances[to] = balances[to].add(amount);
514         balances[from] = balances[from].sub(amount);
515         emit Transfer(from, to, amount);
516     }
517     
518     function _approve(address owner, address spender ,uint256 amount) private {
519         require(owner != address(0), "ERC20: approve from the zero address"); // check address
520         require(spender != address(0), "ERC20: approve to the zero address"); // check address
521     
522         allowed[owner][spender ] = amount;
523 
524         // Notify anyone listening that this approval done
525         emit Approval(owner, spender, amount);
526     }
527 
528     function allowance(address _owner, address _spender)  public override view returns (uint256 ) {
529         return allowed[_owner][_spender];
530     }
531 
532     /* Approves and then calls the receiving contract */
533     function approveAndCall(address _spender, uint256 _amount, bytes memory _extraData) public returns (bool) {
534         allowed[msg.sender][_spender] = _amount;
535         emit Approval(msg.sender, _spender, _amount);
536    
537         (bool success, bytes memory data)  = (_spender).call(abi.encode( bytes4(bytes32(keccak256(abi.encodePacked("receiveApproval(address,uint256,address,bytes)")))), msg.sender, _amount, this, _extraData));
538         require(success);
539         
540         return true;
541     }
542 
543 }