1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-16
3 */
4 
5 pragma solidity ^0.5;
6 
7 library SafeMath {
8     /**
9      * @dev Returns the addition of two unsigned integers, reverting on
10      * overflow.
11      *
12      * Counterpart to Solidity's `+` operator.
13      *
14      * Requirements:
15      * - Addition cannot overflow.
16      */
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23 
24     /**
25      * @dev Returns the subtraction of two unsigned integers, reverting on
26      * overflow (when the result is negative).
27      *
28      * Counterpart to Solidity's `-` operator.
29      *
30      * Requirements:
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b <= a, "SafeMath: subtraction overflow");
35         uint256 c = a - b;
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `*` operator.
45      *
46      * Requirements:
47      * - Multiplication cannot overflow.
48      */
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the integer division of two unsigned integers. Reverts on
65      * division by zero. The result is rounded towards zero.
66      *
67      * Counterpart to Solidity's `/` operator. Note: this function uses a
68      * `revert` opcode (which leaves remaining gas untouched) while Solidity
69      * uses an invalid opcode to revert (consuming all remaining gas).
70      *
71      * Requirements:
72      * - The divisor cannot be zero.
73      */
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Solidity only automatically asserts when dividing by 0
76         require(b > 0, "SafeMath: division by zero");
77         uint256 c = a / b;
78         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79 
80         return c;
81     }
82 
83     /**
84      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
85      * Reverts when dividing by zero.
86      *
87      * Counterpart to Solidity's `%` operator. This function uses a `revert`
88      * opcode (which leaves remaining gas untouched) while Solidity uses an
89      * invalid opcode to revert (consuming all remaining gas).
90      *
91      * Requirements:
92      * - The divisor cannot be zero.
93      */
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0, "SafeMath: modulo by zero");
96         return a % b;
97     }
98 }
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
102  * the optional functions; to access them see `ERC20Detailed`.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a `Transfer` event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through `transferFrom`. This is
127      * zero by default.
128      *
129      * This value changes when `approve` or `transferFrom` are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * > Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an `Approval` event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a `Transfer` event.
157      */
158     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to `approve`. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 contract ERC20 is IERC20 {
176     using SafeMath for uint256;
177 
178     mapping (address => uint256) private _balances;
179 
180     mapping (address => mapping (address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     /**
185      * @dev See `IERC20.totalSupply`.
186      */
187     function totalSupply() public view returns (uint256) {
188         return _totalSupply;
189     }
190 
191     /**
192      * @dev See `IERC20.balanceOf`.
193      */
194     function balanceOf(address account) public view returns (uint256) {
195         return _balances[account];
196     }
197 
198     /**
199      * @dev See `IERC20.transfer`.
200      *
201      * Requirements:
202      *
203      * - `recipient` cannot be the zero address.
204      * - the caller must have a balance of at least `amount`.
205      */
206     function transfer(address recipient, uint256 amount) public returns (bool) {
207         _transfer(msg.sender, recipient, amount);
208         return true;
209     }
210 
211     /**
212      * @dev See `IERC20.allowance`.
213      */
214     function allowance(address owner, address spender) public view returns (uint256) {
215         return _allowances[owner][spender];
216     }
217 
218     /**
219      * @dev See `IERC20.approve`.
220      *
221      * Requirements:
222      *
223      * - `spender` cannot be the zero address.
224      */
225     function approve(address spender, uint256 value) public returns (bool) {
226         _approve(msg.sender, spender, value);
227         return true;
228     }
229 
230     /**
231      * @dev See `IERC20.transferFrom`.
232      *
233      * Emits an `Approval` event indicating the updated allowance. This is not
234      * required by the EIP. See the note at the beginning of `ERC20`;
235      *
236      * Requirements:
237      * - `sender` and `recipient` cannot be the zero address.
238      * - `sender` must have a balance of at least `value`.
239      * - the caller must have allowance for `sender`'s tokens of at least
240      * `amount`.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
243         _transfer(sender, recipient, amount);
244         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
245         return true;
246     }
247 
248     /**
249      * @dev Atomically increases the allowance granted to `spender` by the caller.
250      *
251      * This is an alternative to `approve` that can be used as a mitigation for
252      * problems described in `IERC20.approve`.
253      *
254      * Emits an `Approval` event indicating the updated allowance.
255      *
256      * Requirements:
257      *
258      * - `spender` cannot be the zero address.
259      */
260     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
261         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
262         return true;
263     }
264 
265     /**
266      * @dev Atomically decreases the allowance granted to `spender` by the caller.
267      *
268      * This is an alternative to `approve` that can be used as a mitigation for
269      * problems described in `IERC20.approve`.
270      *
271      * Emits an `Approval` event indicating the updated allowance.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      * - `spender` must have allowance for the caller of at least
277      * `subtractedValue`.
278      */
279     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
280         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
281         return true;
282     }
283 
284     /**
285      * @dev Moves tokens `amount` from `sender` to `recipient`.
286      *
287      * This is internal function is equivalent to `transfer`, and can be used to
288      * e.g. implement automatic token fees, slashing mechanisms, etc.
289      *
290      * Emits a `Transfer` event.
291      *
292      * Requirements:
293      *
294      * - `sender` cannot be the zero address.
295      * - `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      */
298     function _transfer(address sender, address recipient, uint256 amount) internal {
299         require(sender != address(0), "ERC20: transfer from the zero address");
300         require(recipient != address(0), "ERC20: transfer to the zero address");
301 
302         _balances[sender] = _balances[sender].sub(amount);
303         _balances[recipient] = _balances[recipient].add(amount);
304         emit Transfer(sender, recipient, amount);
305     }
306 
307     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
308      * the total supply.
309      *
310      * Emits a `Transfer` event with `from` set to the zero address.
311      *
312      * Requirements
313      *
314      * - `to` cannot be the zero address.
315      */
316     function _mint(address account, uint256 amount) internal {
317         require(account != address(0), "ERC20: mint to the zero address");
318 
319         _totalSupply = _totalSupply.add(amount);
320         _balances[account] = _balances[account].add(amount);
321         emit Transfer(address(0), account, amount);
322     }
323 
324      /**
325      * @dev Destoys `amount` tokens from `account`, reducing the
326      * total supply.
327      *
328      * Emits a `Transfer` event with `to` set to the zero address.
329      *
330      * Requirements
331      *
332      * - `account` cannot be the zero address.
333      * - `account` must have at least `amount` tokens.
334      */
335     function _burn(address account, uint256 value) internal {
336         require(account != address(0), "ERC20: burn from the zero address");
337 
338         _totalSupply = _totalSupply.sub(value);
339         _balances[account] = _balances[account].sub(value);
340         emit Transfer(account, address(0), value);
341     }
342 
343     /**
344      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
345      *
346      * This is internal function is equivalent to `approve`, and can be used to
347      * e.g. set automatic allowances for certain subsystems, etc.
348      *
349      * Emits an `Approval` event.
350      *
351      * Requirements:
352      *
353      * - `owner` cannot be the zero address.
354      * - `spender` cannot be the zero address.
355      */
356     function _approve(address owner, address spender, uint256 value) internal {
357         require(owner != address(0), "ERC20: approve from the zero address");
358         require(spender != address(0), "ERC20: approve to the zero address");
359 
360         _allowances[owner][spender] = value;
361         emit Approval(owner, spender, value);
362     }
363 
364     /**
365      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
366      * from the caller's allowance.
367      *
368      * See `_burn` and `_approve`.
369      */
370     function _burnFrom(address account, uint256 amount) internal {
371         _burn(account, amount);
372         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
373     }
374 }
375 
376 contract Admin { 
377 
378         address private superAdmin;
379         mapping(address => bool) public admin;
380 
381         constructor() public {
382                 superAdmin = msg.sender;
383                 addAdmin(msg.sender);
384         }
385 
386         modifier onlyAdmin() {
387                 require(admin[msg.sender]);
388                 _;
389         }
390 
391         modifier onlySuperAdmin() {
392                 require(msg.sender == superAdmin);
393                 _;
394         }
395 
396         function addAdmin(address a) public onlySuperAdmin {
397                 require(a != address(0));
398                 admin[a] = true;
399         }
400 
401         function removeAdmin(address a) public onlySuperAdmin {
402                 require(a != address(0));
403                 admin[a] = false;
404         }
405 }
406 
407 contract Constant is ERC20, Admin {
408 
409         // token info
410         string public constant name = "Constant Stablecoin";
411         string public constant symbol = "CONST";
412         uint public constant decimals = 2;
413 
414 
415         // events to track onchain-offchain relationships
416         event __transferByAdmin(bytes32 offchain);
417         event __purchase(bytes32 offchain);
418         event __redeem(bytes32 offchain);
419 
420         /**
421          * @dev function to transfer CONS
422          * @param from the address to transfer from
423          * @param to the address to transfer to
424          * @param value the amount to be transferred
425          */
426         function transferByAdmin(
427                 address from,
428                 address to,
429                 uint value,
430                 bytes32 offchain
431         )
432                 public
433                 onlyAdmin
434         {
435                 _transfer(from, to, value);
436                 emit __transferByAdmin(offchain);
437         }
438 
439 
440         /**
441          * @dev function to purchase new CONST
442          * @param purchaser the address that will receive the newly minted CONST
443          * @param value the amount of CONST to mint
444          */
445         function purchase(
446                 address purchaser,
447                 uint value,
448                 bytes32 offchain
449         )
450                 public
451                 onlyAdmin
452         {
453                 _mint(purchaser, value);
454                 emit __purchase(offchain);
455         }
456 
457 
458         /**
459          * @dev function to burn CONST
460          * @param redeemer the account whose CONST will be burnt
461          * @param value the amount of CONST to be burnt
462          */
463         function redeem(
464                 address redeemer,
465                 uint value,
466                 bytes32 offchain
467         )
468                 public
469                 onlyAdmin
470         {
471                 _burn(redeemer, value);
472                 emit __redeem(offchain);
473         }
474 }