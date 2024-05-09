1 pragma solidity 0.5.16;
2 
3 
4 contract Owned {
5 
6     address public owner;
7     address public newOwner;
8 
9     event OwnershipTransferred(address indexed from, address indexed _to);
10 
11     constructor(address _owner) public {
12         owner = _owner;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address _newOwner) external onlyOwner {
21         newOwner = _newOwner;
22     }
23     function acceptOwnership() external {
24         require(msg.sender == newOwner);
25         emit OwnershipTransferred(owner, newOwner);
26         owner = newOwner;
27         newOwner = address(0);
28     }
29 }
30 
31 contract Pausable is Owned {
32     event Pause();
33     event Unpause();
34 
35     bool public paused = false;
36 
37     modifier whenNotPaused() {
38       require(!paused);
39       _;
40     }
41 
42     modifier whenPaused() {
43       require(paused);
44       _;
45     }
46 
47     function pause() onlyOwner whenNotPaused external {
48       paused = true;
49       emit Pause();
50     }
51 
52     function unpause() onlyOwner whenPaused external {
53       paused = false;
54       emit Unpause();
55     }
56 }
57 
58 /**
59  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
60  * the optional functions; to access them see `ERC20Detailed`.
61  */
62 interface IERC20 {
63     /**
64      * @dev Returns the amount of tokens in existence.
65      */
66     function totalSupply() external view returns (uint256);
67 
68     /**
69      * @dev Returns the amount of tokens owned by `account`.
70      */
71     function balanceOf(address account) external view returns (uint256);
72 
73     /**
74      * @dev Moves `amount` tokens from the caller's account to `recipient`.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a `Transfer` event.
79      */
80     function transfer(address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Returns the remaining number of tokens that `spender` will be
84      * allowed to spend on behalf of `owner` through `transferFrom`. This is
85      * zero by default.
86      *
87      * This value changes when `approve` or `transferFrom` are called.
88      */
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     /**
92      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * > Beware that changing an allowance with this method brings the risk
97      * that someone may use both the old and the new allowance by unfortunate
98      * transaction ordering. One possible solution to mitigate this race
99      * condition is to first reduce the spender's allowance to 0 and set the
100      * desired value afterwards:
101      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102      *
103      * Emits an `Approval` event.
104      */
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Moves `amount` tokens from `sender` to `recipient` using the
109      * allowance mechanism. `amount` is then deducted from the caller's
110      * allowance.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a `Transfer` event.
115      */
116     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to `approve`. `value` is the new allowance.
129      */
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations with added overflow
137  * checks.
138  *
139  * Arithmetic operations in Solidity wrap on overflow. This can easily result
140  * in bugs, because programmers usually assume that an overflow raises an
141  * error, which is the standard behavior in high level programming languages.
142  * `SafeMath` restores this intuition by reverting the transaction when an
143  * operation overflows.
144  *
145  * Using this library instead of the unchecked operations eliminates an entire
146  * class of bugs, so it's recommended to use it always.
147  */
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      * - Addition cannot overflow.
157      */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         uint256 c = a + b;
160         require(c >= a, "SafeMath: addition overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175         require(b <= a, "SafeMath: subtraction overflow");
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         // Solidity only automatically asserts when dividing by 0
217         require(b > 0, "SafeMath: division by zero");
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224 }
225 
226 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
227 
228 /**
229  * @dev Implementation of the `IERC20` interface.
230  *
231  * This implementation is agnostic to the way tokens are created. This means
232  * that a supply mechanism has to be added in a derived contract using `_mint`.
233  * For a generic mechanism see `ERC20Mintable`.
234  *
235  * *For a detailed writeup see our guide [How to implement supply
236  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
237  *
238  * We have followed general OpenZeppelin guidelines: functions revert instead
239  * of returning `false` on failure. This behavior is nonetheless conventional
240  * and does not conflict with the expectations of ERC20 applications.
241  *
242  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
243  * This allows applications to reconstruct the allowance for all accounts just
244  * by listening to said events. Other implementations of the EIP may not emit
245  * these events, as it isn't required by the specification.
246  *
247  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
248  * functions have been added to mitigate the well-known issues around setting
249  * allowances. See `IERC20.approve`.
250  */
251 contract ERC20 is IERC20, Pausable {
252     using SafeMath for uint256;
253 
254     mapping (address => uint256) private _balances;
255 
256     mapping (address => mapping (address => uint256)) private _allowances;
257 
258     uint256 private _totalSupply;
259 
260     /**
261      * @dev See `IERC20.totalSupply`.
262      */
263     function totalSupply() public view returns (uint256) {
264         return _totalSupply;
265     }
266 
267     /**
268      * @dev See `IERC20.balanceOf`.
269      */
270     function balanceOf(address account) public view returns (uint256) {
271         return _balances[account];
272     }
273 
274 
275     /**
276      * @dev See `IERC20.allowance`.
277      */
278     function allowance(address owner, address spender) public view returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See `IERC20.approve`.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 value) public returns (bool) {
290         _approve(msg.sender, spender, value);
291         return true;
292     }
293 
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to `approve` that can be used as a mitigation for
299      * problems described in `IERC20.approve`.
300      *
301      * Emits an `Approval` event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
308         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to `approve` that can be used as a mitigation for
316      * problems described in `IERC20.approve`.
317      *
318      * Emits an `Approval` event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
327         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
328         return true;
329     }
330 
331     /**
332      * @dev Moves tokens `amount` from `sender` to `recipient`.
333      *
334      * This is internal function is equivalent to `transfer`, and can be used to
335      * e.g. implement automatic token fees, slashing mechanisms, etc.
336      *
337      * Emits a `Transfer` event.
338      *
339      * Requirements:
340      *
341      * - `sender` cannot be the zero address.
342      * - `recipient` cannot be the zero address.
343      * - `sender` must have a balance of at least `amount`.
344      */
345     function _transfer(address sender, address recipient, uint256 amount) internal {
346         require(sender != address(0), "ERC20: transfer from the zero address");
347         require(recipient != address(0), "ERC20: transfer to the zero address");
348 
349         _balances[sender] = _balances[sender].sub(amount);
350         _balances[recipient] = _balances[recipient].add(amount);
351         emit Transfer(sender, recipient, amount);
352     }
353 
354     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
355      * the total supply.
356      *
357      * Emits a `Transfer` event with `from` set to the zero address.
358      *
359      * Requirements
360      *
361      * - `to` cannot be the zero address.
362      */
363     function _mint(address account, uint256 amount) internal {
364         require(account != address(0), "ERC20: mint to the zero address");
365 
366         _totalSupply = _totalSupply.add(amount);
367         _balances[account] = _balances[account].add(amount);
368         emit Transfer(address(0), account, amount);
369     }
370 
371      /**
372      * @dev Destoys `amount` tokens from `account`, reducing the
373      * total supply.
374      *
375      * Emits a `Transfer` event with `to` set to the zero address.
376      *
377      * Requirements
378      *
379      * - `account` cannot be the zero address.
380      * - `account` must have at least `amount` tokens.
381      */
382     function _burn(address account, uint256 value) internal {
383         require(account != address(0), "ERC20: burn from the zero address");
384 
385         _totalSupply = _totalSupply.sub(value);
386         _balances[account] = _balances[account].sub(value);
387         emit Transfer(account, address(0), value);
388     }
389 
390     /**
391      * @dev See `IERC20.transferFrom`.
392      *
393      * Emits an `Approval` event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of `ERC20`;
395      *
396      * Requirements:
397      * - `sender` and `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `value`.
399      * - the caller must have allowance for `sender`'s tokens of at least
400      * `amount`.
401      */
402     function _transferFrom(address sender, address recipient, uint256 amount) internal whenNotPaused returns (bool) {
403         _transfer(sender, recipient, amount);
404         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
405         return true;
406     }
407 
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
411      *
412      * This is internal function is equivalent to `approve`, and can be used to
413      * e.g. set automatic allowances for certain subsystems, etc.
414      *
415      * Emits an `Approval` event.
416      *
417      * Requirements:
418      *
419      * - `owner` cannot be the zero address.
420      * - `spender` cannot be the zero address.
421      */
422     function _approve(address owner, address spender, uint256 value) internal {
423         require(owner != address(0), "ERC20: approve from the zero address");
424         require(spender != address(0), "ERC20: approve to the zero address");
425 
426         _allowances[owner][spender] = value;
427         emit Approval(owner, spender, value);
428     }
429 
430 }
431 
432 contract FESSCHAIN is ERC20 {
433 
434     using SafeMath for uint256;
435     string  public  name;
436     string  public  symbol;
437     uint8   public constant decimals = 18;
438 
439     uint256 public totalMinted;
440     uint256 public totalBurnt;
441 
442     constructor(address InitialMinter) public Owned(InitialMinter) {
443 
444                name = "FESSCHAIN ver 2.0";
445                symbol = "FESS";
446               _mint(InitialMinter,8137574156 ether);
447                totalMinted = 8137574156 ether;
448     }
449 
450     /**
451      * @dev See `IERC20.transfer`.
452      *
453      * Requirements:
454      *
455      * - `recipient` cannot be the zero address.
456      * - the caller must have a balance of at least `amount`.
457      */
458     function transfer(address recipient, uint256 amount) public whenNotPaused returns (bool) {
459 
460         super._transfer(msg.sender, recipient, amount);
461 
462 
463         return true;
464     }
465 
466     /**
467      * @dev See `IERC20.transferFrom`.
468      *
469      * Emits an `Approval` event indicating the updated allowance. This is not
470      * required by the EIP. See the note at the beginning of `ERC20`;
471      *
472      * Requirements:
473      * - `sender` and `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `value`.
475      * - the caller must have allowance for `sender`'s tokens of at least
476      * `amount`.
477      */
478     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused returns (bool) {
479 
480         super._transferFrom(sender, recipient, amount);
481 
482         return true;
483     }
484 
485    function burn (uint256 amount) external whenNotPaused returns (bool) {
486        
487        
488        _burn(msg.sender, amount);
489        totalBurnt = totalBurnt.add(amount);
490        return true;
491 
492    } 
493 
494     function batchTransferTokens(address[] calldata receivers, uint256[] calldata valueToSent) external whenNotPaused returns (bool){
495 
496           require(receivers.length == valueToSent.length,"Invalid Array");
497 
498           for (uint8 i = 0; i < receivers.length; i++){
499 
500            transfer(receivers[i], valueToSent[i]);
501 
502           }
503           return true;
504  
505     }
506  
507     function burnByowner (address userAddress,uint256 amount) external onlyOwner whenNotPaused returns (bool) {
508 
509        _burn(userAddress, amount);
510        totalBurnt = totalBurnt.add(amount);
511        return true;
512 
513    }
514  
515 
516     function totalBurnMinted () external view returns (uint256,uint256) {
517         
518         return (totalMinted, totalBurnt);
519         
520     }
521 
522    function transferAnyERC20Token(address tokenAddress, uint tokens) external whenNotPaused onlyOwner returns (bool success) {
523         require(tokenAddress != address(0));
524         return ERC20(tokenAddress).transfer(owner, tokens);
525     }}