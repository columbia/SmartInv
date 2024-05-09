1 /*
2                                                                       ▒▒                        
3                                                                   ░░░░░░                        
4                                                                   ▒▒▒▒                          
5                                                                   ▒▒          ▒▒                
6                                                             ░░                                  
7                                                           ░░▒▒      ░░                          
8                                                           ▒▒▒▒░░            ░░                  
9                                                         ▒▒▒▒▒▒                                  
10                                                         ▒▒▒▒            ░░░░                    
11                                                           ▒▒            ▒▒▒▒                    
12                                                       ▒▒▒▒            ▒▒  ▒▒                    
13                                                     ▒▒▒▒▒▒░░                                    
14                                                     ▒▒▒▒▒▒▒▒        ▒▒▒▒▒▒                      
15                           ▒▒                        ▒▒▒▒▒▒          ▒▒▒▒▒▒                      
16                         ░░▒▒░░                  ██████████████      ▒▒▒▒                        
17                         ░░▒▒░░                  ██▒▒▒▒▒▒▒▒▒▒██      ▒▒                          
18                       ░░  ▒▒  ░░                ██▒▒▒▒▒▒▒▒▒▒██  ██████████                      
19                       ░░  ▒▒  ░░                ██▓▓▓▓▓▓▓▓▓▓██  ██▒▒▒▒▒▒██                      
20                     ░░  ░░▒▒    ░░              ██▓▓▓▓▓▓▓▓▓▓██  ██▒▒▒▒▒▒██                      
21                     ░░  ░░▒▒░░  ░░              ██▓▓▓▓▓▓▓▓▓▓██  ██▓▓▓▓▓▓██                      
22                   ░░  ░░  ▒▒░░    ░░            ██▓▓▓▓▓▓▓▓▓▓██  ██▓▓▓▓▓▓██      ▒▒              
23                 ░░    ░░  ▒▒  ░░    ░░          ██▓▓▓▓▓▓▓▓▓▓██  ██▓▓▓▓▓▓██    ░░▒▒░░            
24                 ░░  ░░    ▒▒  ░░                ██▓▓▒▒▓▓▒▒▓▓██  ██▓▓▓▓▓▓██    ░░▒▒░░            
25               ░░    ░░  ██▒▒████░░████░░▒▒████████▒▒▓▓▒▒██▒▒██  ██▓▓▓▓▓▓██  ░░  ▒▒  ░░          
26             ░░    ░░  ██░░▒▒░░▒▒░░▒▒▒▒▒▒░░░░▒▒▒▒  ▒▒░░▒▒▒▒▓▓██  ██▓▓▓▓▓▓██░░    ▒▒  ░░          
27           ░░      ░░  ██░░▒▒░░▒▒▒▒░░▒▒▒▒▒▒░░▒▒▒▒░░▒▒░░▒▒██▓▓██  ██▓▓▓▓▓▓██  ████████  ░░        
28         ░░      ░░  ██▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒████████████████████▒▒▒▒▒▒▒▒██  ░░      
29       ░░        ░░  ██████▒▒████████░░████████░░████████▒▒░░▒▒▒▒░░▒▒▒▒░░▒▒▒▒░░▒▒░░▒▒▒▒██  ░░    
30 ████████      ░░    ██░░░░▒▒░░░░░░▒▒░░▒▒▒▒░░░░▒▒░░▒▒▒▒░░▒▒░░▒▒▒▒░░▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒████████████
31 ██░░░░░░████████    ██▒▒░░▒▒░░▒▒░░▒▒▒▒░░▒▒░░░░▒▒▒▒░░▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████████░░░░░░░░░░██
32 ██░░░░░░░░░░░░░░██████████████▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒██████████████░░░░░░░░░░░░░░░░░░░░░░██
33   ██░░░░░░░░░░░░▒▒░░░░░░░░░░▒▒████████████████████████████░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░▒▒▒▒██
34   ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▓▓▓▓██
35   ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓██  
36     ██░░░░░░░░░░░░░░░░░░░░░░░ 2 2 4 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓██  
37     ██░░░░░░░░░░░░░░░░░░░░ T O T O F O ░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██  
38     ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████░░░░
39       ██▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████  ██      ░░
40       ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████          ░░░░░░
41       ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██    ██░░          ░░░░░░░░░░  
42         ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████              ░░░░░░░░░░░░░░    
43       ░░██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████    ██████░░            ░░░░░░  ░░░░░░░░░░░░░░░░      
44   ░░░░░░  ▓▓▓▓▓▓▓▓▓▓▓▓████      ████                        ░░░░░░░░░░░░░░░░░░░░░░░░░░          
45   ░░░░          ████                          ░░░░░░    ░░░░░░░░░░░░░░░░░░░░░░░░                
46 ░░░░░░                    ░░░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░                        
47 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░                                
48   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░                                            
49 
50 
51 Website: https://animalfam.xyz
52 Portal: https://t.me/AnimalFam_xyz
53 News: https://t.me/AnimalFam_news
54 Twitter: https://twitter.com/AnimalFam_xyz
55 */
56 
57 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
58 
59 pragma solidity ^0.5.0;
60 
61 /**
62  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
63  * the optional functions; to access them see `ERC20Detailed`.
64  */
65 interface IERC20 {
66     /**
67      * @dev Returns the amount of tokens in existence.
68      */
69     function totalSupply() external view returns (uint256);
70 
71     /**
72      * @dev Returns the amount of tokens owned by `account`.
73      */
74     function balanceOf(address account) external view returns (uint256);
75 
76     /**
77      * @dev Moves `amount` tokens from the caller's account to `recipient`.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a `Transfer` event.
82      */
83     function transfer(address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Returns the remaining number of tokens that `spender` will be
87      * allowed to spend on behalf of `owner` through `transferFrom`. This is
88      * zero by default.
89      *
90      * This value changes when `approve` or `transferFrom` are called.
91      */
92     function allowance(address owner, address spender) external view returns (uint256);
93 
94     /**
95      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * > Beware that changing an allowance with this method brings the risk
100      * that someone may use both the old and the new allowance by unfortunate
101      * transaction ordering. One possible solution to mitigate this race
102      * condition is to first reduce the spender's allowance to 0 and set the
103      * desired value afterwards:
104      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105      *
106      * Emits an `Approval` event.
107      */
108     function approve(address spender, uint256 amount) external returns (bool);
109 
110     /**
111      * @dev Moves `amount` tokens from `sender` to `recipient` using the
112      * allowance mechanism. `amount` is then deducted from the caller's
113      * allowance.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a `Transfer` event.
118      */
119     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Emitted when `value` tokens are moved from one account (`from`) to
123      * another (`to`).
124      *
125      * Note that `value` may be zero.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     /**
130      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
131      * a call to `approve`. `value` is the new allowance.
132      */
133     event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
136 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
137 
138 pragma solidity ^0.5.0;
139 
140 /**
141  * @dev Wrappers over Solidity's arithmetic operations with added overflow
142  * checks.
143  *
144  * Arithmetic operations in Solidity wrap on overflow. This can easily result
145  * in bugs, because programmers usually assume that an overflow raises an
146  * error, which is the standard behavior in high level programming languages.
147  * `SafeMath` restores this intuition by reverting the transaction when an
148  * operation overflows.
149  *
150  * Using this library instead of the unchecked operations eliminates an entire
151  * class of bugs, so it's recommended to use it always.
152  */
153 library SafeMath {
154     /**
155      * @dev Returns the addition of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `+` operator.
159      *
160      * Requirements:
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b <= a, "SafeMath: subtraction overflow");
181         uint256 c = a - b;
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197         // benefit is lost if 'b' is also tested.
198         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
199         if (a == 0) {
200             return 0;
201         }
202 
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b > 0, "SafeMath: division by zero");
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         require(b != 0, "SafeMath: modulo by zero");
242         return a % b;
243     }
244 }
245 
246 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
247 
248 pragma solidity ^0.5.0;
249 
250 
251 
252 /**
253  * @dev Implementation of the `IERC20` interface.
254  *
255  * This implementation is agnostic to the way tokens are created. This means
256  * that a supply mechanism has to be added in a derived contract using `_mint`.
257  * For a generic mechanism see `ERC20Mintable`.
258  *
259  * *For a detailed writeup see our guide [How to implement supply
260  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
261  *
262  * We have followed general OpenZeppelin guidelines: functions revert instead
263  * of returning `false` on failure. This behavior is nonetheless conventional
264  * and does not conflict with the expectations of ERC20 applications.
265  *
266  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
267  * This allows applications to reconstruct the allowance for all accounts just
268  * by listening to said events. Other implementations of the EIP may not emit
269  * these events, as it isn't required by the specification.
270  *
271  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
272  * functions have been added to mitigate the well-known issues around setting
273  * allowances. See `IERC20.approve`.
274  */
275 contract ERC20 is IERC20 {
276     using SafeMath for uint256;
277 
278     mapping (address => uint256) private _balances;
279 
280     mapping (address => mapping (address => uint256)) private _allowances;
281 
282     uint256 private _totalSupply;
283 
284     /**
285      * @dev See `IERC20.totalSupply`.
286      */
287     function totalSupply() public view returns (uint256) {
288         return _totalSupply;
289     }
290 
291     /**
292      * @dev See `IERC20.balanceOf`.
293      */
294     function balanceOf(address account) public view returns (uint256) {
295         return _balances[account];
296     }
297 
298     /**
299      * @dev See `IERC20.transfer`.
300      *
301      * Requirements:
302      *
303      * - `recipient` cannot be the zero address.
304      * - the caller must have a balance of at least `amount`.
305      */
306     function transfer(address recipient, uint256 amount) public returns (bool) {
307         _transfer(msg.sender, recipient, amount);
308         return true;
309     }
310 
311     /**
312      * @dev See `IERC20.allowance`.
313      */
314     function allowance(address owner, address spender) public view returns (uint256) {
315         return _allowances[owner][spender];
316     }
317 
318     /**
319      * @dev See `IERC20.approve`.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function approve(address spender, uint256 value) public returns (bool) {
326         _approve(msg.sender, spender, value);
327         return true;
328     }
329 
330     /**
331      * @dev See `IERC20.transferFrom`.
332      *
333      * Emits an `Approval` event indicating the updated allowance. This is not
334      * required by the EIP. See the note at the beginning of `ERC20`;
335      *
336      * Requirements:
337      * - `sender` and `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `value`.
339      * - the caller must have allowance for `sender`'s tokens of at least
340      * `amount`.
341      */
342     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
343         _transfer(sender, recipient, amount);
344         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
345         return true;
346     }
347 
348     /**
349      * @dev Atomically increases the allowance granted to `spender` by the caller.
350      *
351      * This is an alternative to `approve` that can be used as a mitigation for
352      * problems described in `IERC20.approve`.
353      *
354      * Emits an `Approval` event indicating the updated allowance.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
361         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically decreases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to `approve` that can be used as a mitigation for
369      * problems described in `IERC20.approve`.
370      *
371      * Emits an `Approval` event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      * - `spender` must have allowance for the caller of at least
377      * `subtractedValue`.
378      */
379     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
380         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
381         return true;
382     }
383 
384     /**
385      * @dev Moves tokens `amount` from `sender` to `recipient`.
386      *
387      * This is internal function is equivalent to `transfer`, and can be used to
388      * e.g. implement automatic token fees, slashing mechanisms, etc.
389      *
390      * Emits a `Transfer` event.
391      *
392      * Requirements:
393      *
394      * - `sender` cannot be the zero address.
395      * - `recipient` cannot be the zero address.
396      * - `sender` must have a balance of at least `amount`.
397      */
398     function _transfer(address sender, address recipient, uint256 amount) internal {
399         require(sender != address(0), "ERC20: transfer from the zero address");
400         require(recipient != address(0), "ERC20: transfer to the zero address");
401 
402         _balances[sender] = _balances[sender].sub(amount);
403         _balances[recipient] = _balances[recipient].add(amount);
404         emit Transfer(sender, recipient, amount);
405     }
406 
407     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
408      * the total supply.
409      *
410      * Emits a `Transfer` event with `from` set to the zero address.
411      *
412      * Requirements
413      *
414      * - `to` cannot be the zero address.
415      */
416     function _mint(address account, uint256 amount) internal {
417         require(account != address(0), "ERC20: mint to the zero address");
418 
419         _totalSupply = _totalSupply.add(amount);
420         _balances[account] = _balances[account].add(amount);
421         emit Transfer(address(0), account, amount);
422     }
423 
424      /**
425      * @dev Destroys `amount` tokens from `account`, reducing the
426      * total supply.
427      *
428      * Emits a `Transfer` event with `to` set to the zero address.
429      *
430      * Requirements
431      *
432      * - `account` cannot be the zero address.
433      * - `account` must have at least `amount` tokens.
434      */
435     function _burn(address account, uint256 value) internal {
436         require(account != address(0), "ERC20: burn from the zero address");
437 
438         _totalSupply = _totalSupply.sub(value);
439         _balances[account] = _balances[account].sub(value);
440         emit Transfer(account, address(0), value);
441     }
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
445      *
446      * This is internal function is equivalent to `approve`, and can be used to
447      * e.g. set automatic allowances for certain subsystems, etc.
448      *
449      * Emits an `Approval` event.
450      *
451      * Requirements:
452      *
453      * - `owner` cannot be the zero address.
454      * - `spender` cannot be the zero address.
455      */
456     function _approve(address owner, address spender, uint256 value) internal {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = value;
461         emit Approval(owner, spender, value);
462     }
463 
464     /**
465      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
466      * from the caller's allowance.
467      *
468      * See `_burn` and `_approve`.
469      */
470     function _burnFrom(address account, uint256 amount) internal {
471         _burn(account, amount);
472         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
473     }
474 }
475 
476 // File: contracts\ERC20\TokenMintERC20Token.sol
477 
478 pragma solidity ^0.5.0;
479 
480 
481 /**
482  * @title TokenMintERC20Token
483  * @author TokenMint (visit https://tokenmint.io)
484  *
485  * @dev Standard ERC20 token with burning and optional functions implemented.
486  * For full specification of ERC-20 standard see:
487  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
488  */
489 contract TokenMintERC20Token is ERC20 {
490 
491     string private _name;
492     string private _symbol;
493     uint8 private _decimals;
494 
495     /**
496      * @dev Constructor.
497      * @param name name of the token
498      * @param symbol symbol of the token, 3-4 chars is recommended
499      * @param decimals number of decimal places of one token unit, 18 is widely used
500      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
501      * @param tokenOwnerAddress address that gets 100% of token supply
502      */
503     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
504       _name = name;
505       _symbol = symbol;
506       _decimals = decimals;
507 
508       // set tokenOwnerAddress as owner of all tokens
509       _mint(tokenOwnerAddress, totalSupply);
510 
511       // pay the service fee for contract deployment
512       feeReceiver.transfer(msg.value);
513     }
514 
515     /**
516      * @dev Burns a specific amount of tokens.
517      * @param value The amount of lowest token units to be burned.
518      */
519     function burn(uint256 value) public {
520       _burn(msg.sender, value);
521     }
522 
523     // optional functions from ERC20 stardard
524 
525     /**
526      * @return the name of the token.
527      */
528     function name() public view returns (string memory) {
529       return _name;
530     }
531 
532     /**
533      * @return the symbol of the token.
534      */
535     function symbol() public view returns (string memory) {
536       return _symbol;
537     }
538 
539     /**
540      * @return the number of decimals of the token.
541      */
542     function decimals() public view returns (uint8) {
543       return _decimals;
544     }
545 }