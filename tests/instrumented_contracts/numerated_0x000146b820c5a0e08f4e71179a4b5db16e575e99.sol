1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
111  * the optional functions; to access them see {ERC20Detailed}.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 contract ERC20 is IERC20 {
185     using SafeMath for uint256;
186 
187     mapping (address => uint256) _balances;
188 
189     mapping (address => mapping (address => uint256)) private _allowances;
190 
191     uint256 _totalSupply;
192 
193     /**
194      * @dev See {IERC20-totalSupply}.
195      */
196     function totalSupply() public view returns (uint256) {
197         return _totalSupply;
198     }
199 
200     /**
201      * @dev See {IERC20-balanceOf}.
202      */
203     function balanceOf(address account) public view returns (uint256) {
204         return _balances[account];
205     }
206 
207     /**
208      * @dev See {IERC20-transfer}.
209      *
210      * Requirements:
211      *
212      * - `recipient` cannot be the zero address.
213      * - the caller must have a balance of at least `amount`.
214      */
215     function transfer(address recipient, uint256 amount) public returns (bool) {
216         _transfer(msg.sender, recipient, amount);
217         return true;
218     }
219 
220     /**
221      * @dev See {IERC20-allowance}.
222      */
223     function allowance(address owner, address spender) public view returns (uint256) {
224         return _allowances[owner][spender];
225     }
226 
227     /**
228      * @dev See {IERC20-approve}.
229      *
230      * Requirements:
231      *
232      * - `spender` cannot be the zero address.
233      */
234     function approve(address spender, uint256 value) public returns (bool) {
235         _approve(msg.sender, spender, value);
236         return true;
237     }
238 
239     /**
240      * @dev See {IERC20-transferFrom}.
241      *
242      * Emits an {Approval} event indicating the updated allowance. This is not
243      * required by the EIP. See the note at the beginning of {ERC20};
244      *
245      * Requirements:
246      * - `sender` and `recipient` cannot be the zero address.
247      * - `sender` must have a balance of at least `value`.
248      * - the caller must have allowance for `sender`'s tokens of at least
249      * `amount`.
250      */
251     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
252         _transfer(sender, recipient, amount);
253         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
254         return true;
255     }
256 
257     /**
258      * @dev Atomically increases the allowance granted to `spender` by the caller.
259      *
260      * This is an alternative to {approve} that can be used as a mitigation for
261      * problems described in {IERC20-approve}.
262      *
263      * Emits an {Approval} event indicating the updated allowance.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
270         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
271         return true;
272     }
273 
274     /**
275      * @dev Atomically decreases the allowance granted to `spender` by the caller.
276      *
277      * This is an alternative to {approve} that can be used as a mitigation for
278      * problems described in {IERC20-approve}.
279      *
280      * Emits an {Approval} event indicating the updated allowance.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      * - `spender` must have allowance for the caller of at least
286      * `subtractedValue`.
287      */
288     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
289         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
290         return true;
291     }
292 
293     /**
294      * @dev Moves tokens `amount` from `sender` to `recipient`.
295      *
296      * This is internal function is equivalent to {transfer}, and can be used to
297      * e.g. implement automatic token fees, slashing mechanisms, etc.
298      *
299      * Emits a {Transfer} event.
300      *
301      * Requirements:
302      *
303      * - `sender` cannot be the zero address.
304      * - `recipient` cannot be the zero address.
305      * - `sender` must have a balance of at least `amount`.
306      */
307     function _transfer(address sender, address recipient, uint256 amount) internal {
308         require(sender != address(0), "ERC20: transfer from the zero address");
309         require(recipient != address(0), "ERC20: transfer to the zero address");
310 
311         _balances[sender] = _balances[sender].sub(amount);
312         _balances[recipient] = _balances[recipient].add(amount);
313         emit Transfer(sender, recipient, amount);
314     }
315 
316      /**
317      * @dev Destroys `amount` tokens from `account`, reducing the
318      * total supply.
319      *
320      * Emits a {Transfer} event with `to` set to the zero address.
321      *
322      * Requirements
323      *
324      * - `account` cannot be the zero address.
325      * - `account` must have at least `amount` tokens.
326      */
327     function _burn(address account, uint256 value) internal {
328         require(account != address(0), "ERC20: burn from the zero address");
329 
330         _totalSupply = _totalSupply.sub(value);
331         _balances[account] = _balances[account].sub(value);
332         emit Transfer(account, address(0), value);
333     }
334 
335     /**
336      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
337      *
338      * This is internal function is equivalent to `approve`, and can be used to
339      * e.g. set automatic allowances for certain subsystems, etc.
340      *
341      * Emits an {Approval} event.
342      *
343      * Requirements:
344      *
345      * - `owner` cannot be the zero address.
346      * - `spender` cannot be the zero address.
347      */
348     function _approve(address owner, address spender, uint256 value) internal {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351 
352         _allowances[owner][spender] = value;
353         emit Approval(owner, spender, value);
354     }
355 }
356 
357 
358 contract Ownable {
359   address public owner;
360 
361 
362   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
363 
364 
365   /**
366    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
367    * account.
368    */
369   constructor() public {
370     owner = msg.sender;
371   }
372 
373 
374   /**
375    * @dev Throws if called by any account other than the owner.
376    */
377   modifier onlyOwner() {
378     require(msg.sender == owner);
379     _;
380   }
381 
382 
383   /**
384    * @dev Allows the current owner to transfer control of the contract to a newOwner.
385    * @param newOwner The address to transfer ownership to.
386    */
387   function transferOwnership(address newOwner) public onlyOwner {
388     require(newOwner != address(0));
389     emit OwnershipTransferred(owner, newOwner);
390     owner = newOwner;
391   }
392 
393 }
394 
395 contract Pausable is Ownable {
396   event Pause();
397   event Unpause();
398 
399   bool public paused = false;
400 
401 
402   /**
403    * @dev Modifier to make a function callable only when the contract is not paused.
404    */
405   modifier whenNotPaused() {
406     require(!paused);
407     _;
408   }
409 
410   /**
411    * @dev Modifier to make a function callable only when the contract is paused.
412    */
413   modifier whenPaused() {
414     require(paused);
415     _;
416   }
417 
418   /**
419    * @dev called by the owner to pause, triggers stopped state
420    */
421   function pause() onlyOwner whenNotPaused public {
422     paused = true;
423     emit Pause();
424   }
425 
426   /**
427    * @dev called by the owner to unpause, returns to normal state
428    */
429   function unpause() onlyOwner whenPaused public {
430     paused = false;
431     emit Unpause(); 
432   }
433 }
434 
435 contract PausableToken is ERC20, Pausable {
436   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
437     return super.transfer(_to, _value);
438   }
439 
440   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
441     return super.transferFrom(_from, _to, _value);
442   }
443 
444   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
445     return super.approve(_spender, _value);
446   }
447 
448   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
449     return super.increaseApproval(_spender, _addedValue);
450   }
451 
452   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
453     return super.decreaseApproval(_spender, _subtractedValue);
454   }
455 
456   function burn(uint256 amount) onlyOwner public {
457       _burn(msg.sender, amount);
458   }
459 }
460 
461 contract FairyLandToken is PausableToken {
462   string public constant name = "FairyLand token";
463   string public constant symbol = "FLDT";
464   string public constant version = '1.0';
465   uint256 public constant decimals = 6;
466 
467   constructor() public {
468       _totalSupply = 10000000000 * (10 ** decimals);
469       _balances[msg.sender] = _totalSupply;
470   }
471 }