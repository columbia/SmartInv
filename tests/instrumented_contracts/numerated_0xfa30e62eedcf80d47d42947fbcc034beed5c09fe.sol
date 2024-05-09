1 pragma solidity ^0.8.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the token decimals.
11      */
12     function decimals() external view returns (uint8);
13 
14     /**
15      * @dev Returns the token symbol.
16      */
17     function symbol() external view returns (string memory);
18 
19     /**
20     * @dev Returns the token name.
21     */
22     function name() external view returns (string memory);
23 
24     /**
25      * @dev Returns the bep token owner.
26      */
27     function getOwner() external view returns (address);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address _owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /*
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with GSN meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 contract Context {
105     // Empty internal constructor, to prevent people from mistakenly deploying
106     // an instance of this contract, which should be used via inheritance.
107     constructor ()  {}
108 
109     function _msgSender() internal view returns (address payable) {
110         return payable(msg.sender);
111     }
112 
113     function _msgData() internal view returns (bytes memory) {
114         this;
115         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116         return msg.data;
117     }
118 }
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134     /**
135      * @dev Returns the addition of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `+` operator.
139      *
140      * Requirements:
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         // Solidity only automatically asserts when dividing by 0
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * By default, the owner account will be the one that deploys the contract. This
275  * can later be changed with {transferOwnership}.
276  *
277  * This module is used through inheritance. It will make available the modifier
278  * `onlyOwner`, which can be applied to your functions to restrict their use to
279  * the owner.
280  */
281 contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286     /**
287      * @dev Initializes the contract setting the deployer as the initial owner.
288      */
289     constructor ()  {
290         address msgSender = _msgSender();
291         _owner = msgSender;
292         emit OwnershipTransferred(address(0), msgSender);
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(_owner == _msgSender(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public onlyOwner {
318         emit OwnershipTransferred(_owner, address(0));
319         _owner = address(0);
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      * Can only be called by the current owner.
325      */
326     function transferOwnership(address newOwner) public onlyOwner {
327         _transferOwnership(newOwner);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      */
333     function _transferOwnership(address newOwner) internal {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         emit OwnershipTransferred(_owner, newOwner);
336         _owner = newOwner;
337     }
338 }
339 
340 
341 contract LoveEarthToken is Context, IERC20, Ownable {
342     using SafeMath for uint256;
343 
344     mapping(address => uint256) private _balances;
345     mapping(address => mapping(address => uint256)) private _allowances;
346 
347     uint256 private _totalSupply;
348     uint8 private _decimals;
349     string private _symbol;
350     string private _name;
351 
352     mapping(address => bool)private _isExist;
353     uint256 private addressNumber;
354 
355     address public publicWelfareFund = address(0);
356     address public publicWareHouse = address(0);
357     address public uniSwap = address(0);
358   
359     
360 
361     constructor()  {
362         _name = "LOVEEARTH COIN";
363         _symbol = "LEC";
364         _totalSupply = 1000000000 * 10 ** 18;
365         _decimals = 18;
366         _balances[msg.sender] = _totalSupply;
367         _isExist[msg.sender] = true;
368         addressNumber = addressNumber.add(1);
369         
370         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
371          // Create a uniswap pair for this new token
372         // uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
373             // .createPair(address(this), _uniswapV2Router.WETH());
374 
375         // set the rest of the contract variables
376         // uniswapV2Router = _uniswapV2Router;
377         
378         emit Transfer(address(0), msg.sender, _totalSupply);
379     }
380 
381     function setPublicWelfareFund(address _publicWelfareFund) external onlyOwner {
382         require(address(_publicWelfareFund) != address(0),"_publicWelfareFund is zero value!");
383         publicWelfareFund = _publicWelfareFund;
384     }
385 
386     function setPublicWareHouse(address _publicWareHouse) external onlyOwner {
387         require(address(_publicWareHouse) != address(0),"_publicWareHouse is zero value!");
388         publicWareHouse = _publicWareHouse;
389     }
390 
391     function setUniSwap(address _uniSwap) external onlyOwner {
392         require(address(_uniSwap) != address(0),"_uniSwap is zero value!");
393         uniSwap = _uniSwap;
394     }
395 
396     function transferToPublicWelfareFund() external onlyOwner returns (bool){
397         return transfer(publicWelfareFund, _totalSupply.mul(50).div(100));
398     }
399 
400     function transferToPublicWareHouse() external onlyOwner returns (bool){
401         return transfer(publicWareHouse, _totalSupply.mul(10).div(100));
402     }
403 
404     function transferToUniSwap() external onlyOwner returns (bool){
405         return transfer(uniSwap, _totalSupply.mul(40).div(100));
406     }
407 
408     function upDateIsExist(address account, bool isexist) public onlyOwner {
409         if (_isExist[account]) {
410             require(!isexist, "this account is exist!");
411             _isExist[account] = isexist;
412             addressNumber = addressNumber.sub(1);
413         } else {
414             require(isexist, "this account is not exist!");
415             _isExist[account] = isexist;
416             addressNumber = addressNumber.add(1);
417         }
418     }
419 
420     function upDateAddressNumber(uint256 _number) public onlyOwner {
421         addressNumber = _number;
422     }
423 
424     function getAddressNumber() public view returns (uint256){
425         return addressNumber;
426     }
427 
428     function _calaAddressNumber(address account) internal {
429         if (_balances[account] < 1 * 10 ** 18) {
430             if (_isExist[account]) {
431                 _isExist[account] = false;
432                 addressNumber = addressNumber.sub(1);
433             }
434         } else {
435             if (!_isExist[account]) {
436                 _isExist[account] = true;
437                 addressNumber = addressNumber.add(1);
438             }
439         }
440     }
441 
442     /**
443      * @dev Returns the bep token owner.
444      */
445     function getOwner() external override view returns (address) {
446         return owner();
447     }
448 
449     /**
450      * @dev Returns the token decimals.
451      */
452     function decimals() external override view returns (uint8) {
453         return _decimals;
454     }
455 
456     /**
457      * @dev Returns the token symbol.
458      */
459     function symbol() external override view returns (string memory) {
460         return _symbol;
461     }
462 
463     /**
464     * @dev Returns the token name.
465     */
466     function name() external override view returns (string memory) {
467         return _name;
468     }
469 
470     /**
471      * @dev See {IERC20-totalSupply}.
472      */
473     function totalSupply() external override view returns (uint256) {
474         return _totalSupply;
475     }
476 
477     /**
478      * @dev See {IERC20-balanceOf}.
479      */
480     function balanceOf(address account) external override view returns (uint256) {
481         return _balances[account];
482     }
483 
484     /**
485      * @dev See {IERC20-transfer}.
486      *
487      * Requirements:
488      *
489      * - `recipient` cannot be the zero address.
490      * - the caller must have a balance of at least `amount`.
491      */
492     function transfer(address recipient, uint256 amount) public override returns (bool) {
493         _transfer(_msgSender(), recipient, amount);
494         return true;
495     }
496 
497     /**
498      * @dev See {IERC20-allowance}.
499      */
500     function allowance(address owner, address spender) external override view returns (uint256) {
501         return _allowances[owner][spender];
502     }
503 
504     /**
505      * @dev See {IERC20-approve}.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      */
511     function approve(address spender, uint256 amount) external override returns (bool) {
512         _approve(_msgSender(), spender, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-transferFrom}.
518      *
519      * Emits an {Approval} event indicating the updated allowance. This is not
520      * required by the EIP. See the note at the beginning of {IERC20};
521      *
522      * Requirements:
523      * - `sender` and `recipient` cannot be the zero address.
524      * - `sender` must have a balance of at least `amount`.
525      * - the caller must have allowance for `sender`'s tokens of at least
526      * `amount`.
527      */
528     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
529         _transfer(sender, recipient, amount);
530         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "IERC20: transfer amount exceeds allowance"));
531         return true;
532     }
533 
534     /**
535      * @dev Moves tokens `amount` from `sender` to `recipient`.
536      *
537      * This is internal function is equivalent to {transfer}, and can be used to
538      * e.g. implement automatic token fees, slashing mechanisms, etc.
539      *
540      * Emits a {Transfer} event.
541      *
542      * Requirements:
543      *
544      * - `sender` cannot be the zero address.
545      * - `recipient` cannot be the zero address.
546      * - `sender` must have a balance of at least `amount`.
547      */
548     function _transfer(address sender, address recipient, uint256 amount) internal {
549         require(sender != address(0), "IERC20: transfer from the zero address");
550         require(recipient != address(0), "IERC20: transfer to the zero address");
551 
552         _balances[sender] = _balances[sender].sub(amount, "IERC20: transfer amount exceeds balance");
553         _balances[recipient] = _balances[recipient].add(amount);
554 
555         _calaAddressNumber(sender);
556         _calaAddressNumber(recipient);
557 
558         emit Transfer(sender, recipient, amount);
559     }
560 
561     /**
562      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
563      *
564      * This is internal function is equivalent to `approve`, and can be used to
565      * e.g. set automatic allowances for certain subsystems, etc.
566      *
567      * Emits an {Approval} event.
568      *
569      * Requirements:
570      *
571      * - `owner` cannot be the zero address.
572      * - `spender` cannot be the zero address.
573      */
574     //   function addLiquidityETH(uint256 tokenAmount) external payable {
575     //     // approve token transfer to cover all possible scenarios
576     //     _approve(address(this), address(uniswapV2Router), tokenAmount);
577 
578     //     // add the liquidity
579     //     uniswapV2Router.addLiquidityETH{value: msg.value}(
580     //         address(this),
581     //         tokenAmount,
582     //         0, // slippage is unavoidable
583     //         0, // slippage is unavoidable
584     //         msg.sender,
585     //         block.timestamp
586     //     );
587     // }
588      
589      
590     function _approve(address owner, address spender, uint256 amount) internal {
591         require(owner != address(0), "IERC20: approve from the zero address");
592         require(spender != address(0), "IERC20: approve to the zero address");
593 
594         _allowances[owner][spender] = amount;
595         emit Approval(owner, spender, amount);
596     }
597 
598 }