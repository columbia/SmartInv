1 pragma solidity ^0.5.16;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      *
114      * _Available since v2.4.0._
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 contract Context {
160     // Empty internal constructor, to prevent people from mistakenly deploying
161     // an instance of this contract, which should be used via inheritance.
162     constructor () internal { }
163     // solhint-disable-previous-line no-empty-blocks
164 
165     function _msgSender() internal view returns (address payable) {
166         return msg.sender;
167     }
168 
169     function _msgData() internal view returns (bytes memory) {
170         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
171         return msg.data;
172     }
173 }
174 
175 /**
176  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
177  * the optional functions; to access them see {ERC20Detailed}.
178  */
179 interface IERC20 {
180     /**
181      * @dev Returns the amount of tokens in existence.
182      */
183     function totalSupply() external view returns (uint256);
184 
185     /**
186      * @dev Returns the amount of tokens owned by `account`.
187      */
188     function balanceOf(address account) external view returns (uint256);
189 
190     /**
191      * @dev Moves `amount` tokens from the caller's account to `recipient`.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transfer(address recipient, uint256 amount) external returns (bool);
198 
199 
200     /**
201      * @dev Returns the remaining number of tokens that `spender` will be
202      * allowed to spend on behalf of `owner` through {transferFrom}. This is
203      * zero by default.
204      *
205      * This value changes when {approve} or {transferFrom} are called.
206      */
207     function allowance(address owner, address spender) external view returns (uint256);
208 
209     /**
210      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * IMPORTANT: Beware that changing an allowance with this method brings the risk
215      * that someone may use both the old and the new allowance by unfortunate
216      * transaction ordering. One possible solution to mitigate this race
217      * condition is to first reduce the spender's allowance to 0 and set the
218      * desired value afterwards:
219      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address spender, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Moves `amount` tokens from `sender` to `recipient` using the
227      * allowance mechanism. `amount` is then deducted from the caller's
228      * allowance.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * Emits a {Transfer} event.
233      */
234     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Emitted when `value` tokens are moved from one account (`from`) to
238      * another (`to`).
239      *
240      * Note that `value` may be zero.
241      */
242     event Transfer(address indexed from, address indexed to, uint256 value);
243 
244     /**
245      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
246      * a call to {approve}. `value` is the new allowance.
247      */
248     event Approval(address indexed owner, address indexed spender, uint256 value);
249 }
250 
251 
252 contract ERC20 is Context, IERC20 {
253     using SafeMath for uint;
254 
255     mapping (address => uint) private _balances;
256 
257     mapping (address => mapping (address => uint)) private _allowances;
258 
259     uint private _totalSupply;
260     function totalSupply() public view returns (uint) {
261         return _totalSupply;
262     }
263 
264     function balanceOf(address account) public view returns (uint) {
265         return _balances[account];
266     }
267 
268     function transfer(address recipient, uint amount) public returns (bool) {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272 
273     function allowance(address owner, address spender) public view returns (uint) {
274         return _allowances[owner][spender];
275     }
276 
277     function approve(address spender, uint amount) public returns (bool) {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281 
282     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
283         _transfer(sender, recipient, amount);
284         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
285         return true;
286     }
287 
288     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
289         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
290         return true;
291     }
292 
293     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
294         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
295         return true;
296     }
297 
298     function _transfer(address sender, address recipient, uint amount) internal {
299         require(sender != address(0), "ERC20: transfer from the zero address");
300         require(recipient != address(0), "ERC20: transfer to the zero address");
301 
302         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
303         _balances[recipient] = _balances[recipient].add(amount);
304         emit Transfer(sender, recipient, amount);
305     }
306 
307     function _mint(address account, uint amount) internal {
308         require(account != address(0), "ERC20: mint to the zero address");
309 
310         _totalSupply = _totalSupply.add(amount);
311         _balances[account] = _balances[account].add(amount);
312         emit Transfer(address(0), account, amount);
313     }
314 
315     function _burn(address account, uint amount) internal {
316         require(account != address(0), "ERC20: burn from the zero address");
317 
318         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
319         _totalSupply = _totalSupply.sub(amount);
320         emit Transfer(account, address(0), amount);
321     }
322 
323     function _approve(address owner, address spender, uint amount) internal {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326 
327         _allowances[owner][spender] = amount;
328         emit Approval(owner, spender, amount);
329     }
330 }
331 
332 contract ERC20Detailed is ERC20 {
333     string private _name;
334     string private _symbol;
335     uint8 private _decimals;
336 
337     constructor (string memory name, string memory symbol, uint8 decimals) public {
338         _name = name;
339         _symbol = symbol;
340         _decimals = decimals;
341     }
342     function name() public view returns (string memory) {
343         return _name;
344     }
345     function symbol() public view returns (string memory) {
346         return _symbol;
347     }
348     function decimals() public view returns (uint8) {
349         return _decimals;
350     }
351 }
352 
353 contract CourtToken is ERC20Detailed {
354 
355     uint256 public capital = 40001 * 1e18;
356     address public governance;
357     mapping(address => bool) public minters;
358 
359     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
360     event CapitalChanged(uint256 previousCapital, uint256 newCapital);
361     event MinterAdded(address indexed minter);
362     event MinterRemoved(address indexed minter);
363 
364     constructor () public ERC20Detailed("Court Token", "COURT", 18) {
365         governance = _msgSender();
366 		// minting 1 token with 18 decimals
367         _mint(_msgSender(), 1e18);
368     }
369 
370     function mint(address account, uint256 amount) public {
371         require(minters[_msgSender()] == true, "Caller is not a minter");
372         require(totalSupply().add(amount) <= capital, "Court: capital exceeded");
373 
374         _mint(account, amount);
375     }
376 
377     function transferOwnership(address newOwner) public onlyGovernance {
378         require(newOwner != address(0), "Ownable: new owner is the zero address");
379 
380         emit OwnershipTransferred(governance, newOwner);
381         governance = newOwner;
382     }
383 
384     function changeCapital(uint256 newCapital) public onlyGovernance {
385         require(newCapital > totalSupply(), "total supply exceeded capital");
386 
387         emit CapitalChanged(capital, newCapital);
388         capital = newCapital;
389     }
390 
391     function addMinter(address minter) public onlyGovernance {
392 
393         emit MinterAdded(minter);
394         minters[minter] = true;
395     }
396 
397     function removeMinter(address minter) public onlyGovernance {
398 
399         emit MinterRemoved(minter);
400         minters[minter] = false;
401     }
402 
403     modifier onlyGovernance() {
404         require(governance == _msgSender(), "Ownable: caller is not the governance");
405         _;
406     }
407 
408 }