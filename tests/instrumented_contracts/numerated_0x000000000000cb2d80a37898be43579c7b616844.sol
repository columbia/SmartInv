1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
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
81 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
82 
83 
84 
85 pragma solidity >=0.6.0 <0.8.0;
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
243 // File: original_contracts/IReduxToken.sol
244 
245 pragma solidity 0.7.5;
246 
247 interface IReduxToken {
248 
249     function freeUpTo(uint256 value) external returns (uint256 freed);
250 
251     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
252 
253     function mint(uint256 value) external;
254 }
255 
256 // File: original_contracts/lib/ReduxToken.sol
257 
258 pragma solidity 0.7.5;
259 
260 
261 
262 
263 
264 contract ReduxToken is IERC20, IReduxToken {
265     using SafeMath for uint256;
266 
267     string constant public name = "REDUX";
268     string constant public symbol = "REDUX";
269     uint8 constant public decimals = 0;
270 
271     mapping(address => uint256) private s_balances;
272     mapping(address => mapping(address => uint256)) private s_allowances;
273 
274     uint256 public totalReduxMinted;
275     uint256 public totalReduxBurned;
276 
277     //The EIP-712 typehash for the contract's domain
278     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
279 
280     //The EIP-712 typehash for the permit struct used by the contract
281     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
282 
283     //A record of states for signing / validating signatures
284     mapping (address => uint) public nonces;
285 
286     function totalSupply() external view override returns(uint256) {
287         return totalReduxMinted.sub(totalReduxBurned);
288     }
289 
290     function mint(uint256 value) external override {
291         uint256 offset = totalReduxMinted;
292 
293         assembly {
294 
295             // EVM assembler of runtime portion of child contract:
296             //     ;; Pseudocode: if (msg.sender != 0x000000000000cb2d80a37898be43579c7b616844) { throw; }
297             //     ;;             suicide(msg.sender)
298             //     PUSH14 0xcb2d80a37898be43579c7b616856 ;; hardcoded address of this contract
299             //     CALLER
300             //     XOR
301             //     JUMP
302             //     JUMPDEST
303             //     CALLER
304             //     SELFDESTRUCT
305             // Or in binary: 6dcb2d80a37898be43579c7b6168563318565b33ff
306             // Since the binary is so short (21 bytes), we can get away
307             // with a very simple initcode:
308             //     PUSH21 0x6dcb2d80a37898be43579c7b6168573318565b33ff
309             //     PUSH1 0
310             //     MSTORE ;; at this point, memory locations mem[10] through
311             //            ;; mem[30] contain the runtime portion of the child
312             //            ;; contract. all that's left to do is to RETURN this
313             //            ;; chunk of memory.
314             //     PUSH1 21 ;; length
315             //     PUSH1 11 ;; offset
316             //     RETURN
317             // Or in binary: 746dcb2d80a37898be43579c7b6168563318565b33ff6000526015600bf30000
318             // Almost done! All we have to do is put this short (30 bytes) blob into
319             // memory and call CREATE with the appropriate offsets.
320 
321             let end := add(offset, value)
322             mstore(callvalue(), 0x746dcb2d80a37898be43579c7b6168563318565b33ff6000526015600bf30000)
323 
324             for {let i := div(value, 32)} i {i := sub(i, 1)} {
325                 pop(create2(callvalue(), callvalue(), 30, add(offset, 0))) pop(create2(callvalue(), callvalue(), 30, add(offset, 1)))
326                 pop(create2(callvalue(), callvalue(), 30, add(offset, 2))) pop(create2(callvalue(), callvalue(), 30, add(offset, 3)))
327                 pop(create2(callvalue(), callvalue(), 30, add(offset, 4))) pop(create2(callvalue(), callvalue(), 30, add(offset, 5)))
328                 pop(create2(callvalue(), callvalue(), 30, add(offset, 6))) pop(create2(callvalue(), callvalue(), 30, add(offset, 7)))
329                 pop(create2(callvalue(), callvalue(), 30, add(offset, 8))) pop(create2(callvalue(), callvalue(), 30, add(offset, 9)))
330                 pop(create2(callvalue(), callvalue(), 30, add(offset, 10))) pop(create2(callvalue(), callvalue(), 30, add(offset, 11)))
331                 pop(create2(callvalue(), callvalue(), 30, add(offset, 12))) pop(create2(callvalue(), callvalue(), 30, add(offset, 13)))
332                 pop(create2(callvalue(), callvalue(), 30, add(offset, 14))) pop(create2(callvalue(), callvalue(), 30, add(offset, 15)))
333                 pop(create2(callvalue(), callvalue(), 30, add(offset, 16))) pop(create2(callvalue(), callvalue(), 30, add(offset, 17)))
334                 pop(create2(callvalue(), callvalue(), 30, add(offset, 18))) pop(create2(callvalue(), callvalue(), 30, add(offset, 19)))
335                 pop(create2(callvalue(), callvalue(), 30, add(offset, 20))) pop(create2(callvalue(), callvalue(), 30, add(offset, 21)))
336                 pop(create2(callvalue(), callvalue(), 30, add(offset, 22))) pop(create2(callvalue(), callvalue(), 30, add(offset, 23)))
337                 pop(create2(callvalue(), callvalue(), 30, add(offset, 24))) pop(create2(callvalue(), callvalue(), 30, add(offset, 25)))
338                 pop(create2(callvalue(), callvalue(), 30, add(offset, 26))) pop(create2(callvalue(), callvalue(), 30, add(offset, 27)))
339                 pop(create2(callvalue(), callvalue(), 30, add(offset, 28))) pop(create2(callvalue(), callvalue(), 30, add(offset, 29)))
340                 pop(create2(callvalue(), callvalue(), 30, add(offset, 30))) pop(create2(callvalue(), callvalue(), 30, add(offset, 31)))
341                 offset := add(offset, 32)
342             }
343 
344             for { } lt(offset, end) { offset := add(offset, 1) } {
345                 pop(create2(callvalue(), callvalue(), 30, offset))
346             }
347         }
348 
349         _mint(msg.sender, value);
350         totalReduxMinted = offset;
351     }
352 
353     function free(uint256 value) external {
354         _burn(msg.sender, value);
355         _destroyChildren(value);
356     }
357 
358     function freeUpTo(uint256 value) external override returns (uint256) {
359         uint256 fromBalance = s_balances[msg.sender];
360         if (value > fromBalance) {
361             value = fromBalance;
362         }
363         _burn(msg.sender, value);
364         _destroyChildren(value);
365 
366         return value;
367     }
368 
369     function freeFromUpTo(address from, uint256 value) external override returns (uint256) {
370         uint256 fromBalance = s_balances[from];
371         if (value > fromBalance) {
372             value = fromBalance;
373         }
374 
375         uint256 userAllowance = s_allowances[from][msg.sender];
376         if (value > userAllowance) {
377             value = userAllowance;
378         }
379         _burnFrom(from, value);
380         _destroyChildren(value);
381 
382         return value;
383     }
384 
385     function freeFrom(address from, uint256 value) external {
386         _burnFrom(from, value);
387         _destroyChildren(value);
388     }
389 
390     function allowance(address owner, address spender) external view override returns (uint256) {
391         return s_allowances[owner][spender];
392     }
393 
394     function transfer(address recipient, uint256 amount) external override returns (bool) {
395         _transfer(msg.sender, recipient, amount);
396         return true;
397     }
398 
399     function approve(address spender, uint256 amount) external override returns (bool) {
400         _approve(msg.sender, spender, amount);
401         return true;
402     }
403 
404     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
405         _transfer(sender, recipient, amount);
406         _approve(sender, msg.sender, s_allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
407         return true;
408     }
409 
410     /**
411      * @notice Triggers an approval from owner to spends
412      * @param owner The address to approve from
413      * @param spender The address to be approved
414      * @param amount The number of tokens that are approved
415      * @param deadline The time at which to expire the signature
416      * @param v The recovery byte of the signature
417      * @param r Half of the ECDSA signature pair
418      * @param s Half of the ECDSA signature pair
419      */
420     function permit(
421         address owner,
422         address spender,
423         uint256 amount,
424         uint deadline,
425         uint8 v,
426         bytes32 r,
427         bytes32 s
428     )
429         external
430     {
431 
432         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
433         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
434         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
435         address signatory = ecrecover(digest, v, r, s);
436         require(signatory != address(0), "permit: invalid signature");
437         require(signatory == owner, "permit: unauthorized");
438         require(block.timestamp <= deadline, "permit: signature expired");
439 
440         _approve(owner, spender, amount);
441     }
442 
443     function balanceOf(address account) public view override returns (uint256) {
444         return s_balances[account];
445     }
446 
447     function _transfer(address sender, address recipient, uint256 amount) private {
448         s_balances[sender] = s_balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
449         s_balances[recipient] = s_balances[recipient].add(amount);
450         emit Transfer(sender, recipient, amount);
451     }
452 
453     function _approve(address owner, address spender, uint256 amount) private {
454         s_allowances[owner][spender] = amount;
455         emit Approval(owner, spender, amount);
456     }
457 
458     function _mint(address account, uint256 amount) private {
459         s_balances[account] = s_balances[account].add(amount);
460         emit Transfer(address(0), account, amount);
461     }
462 
463     function _burn(address account, uint256 amount) private {
464         s_balances[account] = s_balances[account].sub(amount, "ERC20: burn amount exceeds balance");
465         emit Transfer(account, address(0), amount);
466     }
467 
468     function _burnFrom(address account, uint256 amount) private {
469         _burn(account, amount);
470         _approve(account, msg.sender, s_allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
471     }
472 
473     function computeAddress2(uint256 salt) public pure returns (address child) {
474         assembly {
475             let data := mload(0x40)
476             mstore(data, 0xff000000000000cb2d80a37898be43579c7b6168440000000000000000000000)
477             mstore(add(data, 21), salt)
478             mstore(add(data, 53), 0xe4135d085e66541f164ddfd4dd9d622a50176c98e7bcdbbc6634d80cd31e9421)
479             child := and(keccak256(data, 85), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
480         }
481     }
482 
483     function _destroyChildren(uint256 value) internal {
484         assembly {
485             let i := sload(totalReduxBurned.slot)
486             let end := add(i, value)
487             sstore(totalReduxBurned.slot, end)
488 
489             let data := mload(0x40)
490             mstore(data, 0xff000000000000cb2d80a37898be43579c7b6168440000000000000000000000)
491             mstore(add(data, 53), 0xe4135d085e66541f164ddfd4dd9d622a50176c98e7bcdbbc6634d80cd31e9421)
492             let ptr := add(data, 21)
493             for { } lt(i, end) { i := add(i, 1) } {
494                 mstore(ptr, i)
495                 pop(call(gas(), keccak256(data, 85), callvalue(), callvalue(), callvalue(), callvalue(), callvalue()))
496             }
497         }
498     }
499 
500     function getChainId() internal pure returns (uint) {
501         uint256 chainId;
502         assembly { chainId := chainid() }
503         return chainId;
504     }
505 }