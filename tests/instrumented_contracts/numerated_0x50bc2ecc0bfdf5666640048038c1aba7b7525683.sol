1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * // importANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
83 
84 
85 // pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 
244 // Root file: contracts/cVToken.sol
245 
246 pragma solidity 0.6.12;
247 
248 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
249 // import "@openzeppelin/contracts/math/SafeMath.sol";
250 
251 
252 contract cVToken is IERC20 {
253     using SafeMath for uint256;
254 
255     uint256 constant private MAX_UINT256 = ~uint256(0);
256 
257     mapping (address => uint256) private _balances;
258 
259     mapping (address => mapping (address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name = "cVToken";
264     string private _symbol = "cV";
265     uint8 private _decimals = 18;
266 
267     bytes32 public DOMAIN_SEPARATOR;
268     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
269     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
270     mapping(address => uint256) public nonces;
271 
272     constructor () public {
273         _totalSupply = 9931143978000000000000000000; // https://etherscan.io/address/0xda6cb58a0d0c01610a29c5a65c303e13e885887c
274         _balances[msg.sender] = _totalSupply;
275         emit Transfer(address(0), msg.sender, _totalSupply);
276 
277         uint256 chainId;
278         assembly {
279             chainId := chainid()
280         }
281 
282         DOMAIN_SEPARATOR = keccak256(
283             abi.encode(
284                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
285                 keccak256(bytes(_name)),
286                 keccak256(bytes('1')),
287                 chainId,
288                 address(this)
289             )
290         );    
291     }
292 
293     /**
294      * @dev Returns the name of the token.
295      */
296     function name() public view returns (string memory) {
297         return _name;
298     }
299 
300     /**
301      * @dev Returns the symbol of the token, usually a shorter version of the
302      * name.
303      */
304     function symbol() public view returns (string memory) {
305         return _symbol;
306     }
307 
308     /**
309      * @dev Returns the number of decimals used to get its user representation.
310      * For example, if `decimals` equals `2`, a balance of `505` tokens should
311      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
312      *
313      * Tokens usually opt for a value of 18, imitating the relationship between
314      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
315      * called.
316      *
317      * NOTE: This information is only used for _display_ purposes: it in
318      * no way affects any of the arithmetic of the contract, including
319      * {IERC20-balanceOf} and {IERC20-transfer}.
320      */
321     function decimals() public view returns (uint8) {
322         return _decimals;
323     }
324 
325     /**
326      * @dev See {IERC20-totalSupply}.
327      */
328     function totalSupply() public view override returns (uint256) {
329         return _totalSupply;
330     }
331 
332     /**
333      * @dev See {IERC20-balanceOf}.
334      */
335     function balanceOf(address account) public view override returns (uint256) {
336         return _balances[account];
337     }
338 
339     /**
340      * @dev See {IERC20-transfer}.
341      *
342      * Requirements:
343      *
344      * - `recipient` cannot be the zero address.
345      * - the caller must have a balance of at least `amount`.
346      */
347     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
348         _transfer(msg.sender, recipient, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See {IERC20-allowance}.
354      */
355     function allowance(address owner, address spender) public view virtual override returns (uint256) {
356         return _allowances[owner][spender];
357     }
358 
359     /**
360      * @dev See {IERC20-approve}.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function approve(address spender, uint256 amount) public virtual override returns (bool) {
367         _approve(msg.sender, spender, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-transferFrom}.
373      *
374      * Emits an {Approval} event indicating the updated allowance. This is not
375      * required by the EIP. See the note at the beginning of {ERC20};
376      *
377      * Requirements:
378      * - `sender` and `recipient` cannot be the zero address.
379      * - `sender` must have a balance of at least `amount`.
380      * - the caller must have allowance for ``sender``'s tokens of at least
381      * `amount`.
382      */
383     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
384         _transfer(sender, recipient, amount);
385         if (_allowances[sender][msg.sender] < MAX_UINT256) { // treat MAX_UINT256 approve as infinite approval
386             _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
387         }
388         return true;
389     }
390 
391     /**
392      * @dev Atomically increases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
404         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
405         return true;
406     }
407 
408     /**
409      * @dev Atomically decreases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      * - `spender` must have allowance for the caller of at least
420      * `subtractedValue`.
421      */
422     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
423         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
424         return true;
425     }
426 
427     /**
428      * @dev Moves tokens `amount` from `sender` to `recipient`.
429      *
430      * This is internal function is equivalent to {transfer}, and can be used to
431      * e.g. implement automatic token fees, slashing mechanisms, etc.
432      *
433      * Emits a {Transfer} event.
434      *
435      * Requirements:
436      *
437      * - `sender` cannot be the zero address.
438      * - `recipient` cannot be the zero address.
439      * - `sender` must have a balance of at least `amount`.
440      */
441     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
442         require(sender != address(0), "ERC20: transfer from the zero address");
443         require(recipient != address(0), "ERC20: transfer to the zero address");
444 
445         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
446         _balances[recipient] = _balances[recipient].add(amount);
447         emit Transfer(sender, recipient, amount);
448     }
449 
450     /**
451      * @dev Destroys `amount` tokens from `account`, reducing the
452      * total supply.
453      *
454      * Emits a {Transfer} event with `to` set to the zero address.
455      *
456      * Requirements
457      *
458      * - `account` cannot be the zero address.
459      * - `account` must have at least `amount` tokens.
460      */
461     function _burn(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: burn from the zero address");
463 
464         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
465         _totalSupply = _totalSupply.sub(amount);
466         emit Transfer(account, address(0), amount);
467     }
468 
469     /**
470      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
471      *
472      * This internal function is equivalent to `approve`, and can be used to
473      * e.g. set automatic allowances for certain subsystems, etc.
474      *
475      * Emits an {Approval} event.
476      *
477      * Requirements:
478      *
479      * - `owner` cannot be the zero address.
480      * - `spender` cannot be the zero address.
481      */
482     function _approve(address owner, address spender, uint256 amount) internal virtual {
483         require(owner != address(0), "ERC20: approve from the zero address");
484         require(spender != address(0), "ERC20: approve to the zero address");
485 
486         _allowances[owner][spender] = amount;
487         emit Approval(owner, spender, amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from the caller.
492      *
493      * See {ERC20-_burn}.
494      */
495     function burn(uint256 amount) public virtual {
496         _burn(msg.sender, amount);
497     }
498 
499     function transferMany(address[] calldata recipients, uint256[] calldata amounts) external {
500         require(recipients.length == amounts.length, "cVToken: Wrong array length");
501 
502         uint256 total = 0;
503         for (uint256 i = 0; i < amounts.length; i++) {
504             total = total.add(amounts[i]);
505         }
506 
507         _balances[msg.sender] = _balances[msg.sender].sub(total, "ERC20: transfer amount exceeds balance");
508 
509         for (uint256 i = 0; i < recipients.length; i++) {
510             address recipient = recipients[i];
511             uint256 amount = amounts[i];
512             require(recipient != address(0), "ERC20: transfer to the zero address");
513 
514             _balances[recipient] = _balances[recipient].add(amount);
515             emit Transfer(msg.sender, recipient, amount);
516         }
517     }
518 
519     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
520         require(deadline >= block.timestamp, 'cVToken: EXPIRED');
521         bytes32 digest = keccak256(
522             abi.encodePacked(
523                 '\x19\x01',
524                 DOMAIN_SEPARATOR,
525                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
526             )
527         );
528 
529         address recoveredAddress = ecrecover(digest, v, r, s);
530 
531         require(recoveredAddress != address(0) && recoveredAddress == owner, 'cVToken: INVALID_SIGNATURE');
532         _approve(owner, spender, value);
533     }
534 }