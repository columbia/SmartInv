1 /*
2 ███████╗██╗░░░██╗███╗░░░██╗░██████╗░░░░██████╗░░██████╗░██╗░░░░██╗███████╗██████╗░███████╗██████╗░
3 ██╔════╝╚██╗░██╔╝████╗░░██║██╔════╝░░░░██╔══██╗██╔═══██╗██║░░░░██║██╔════╝██╔══██╗██╔════╝██╔══██╗
4 ███████╗░╚████╔╝░██╔██╗░██║██║░░░░░░░░░██████╔╝██║░░░██║██║░█╗░██║█████╗░░██████╔╝█████╗░░██║░░██║
5 ╚════██║░░╚██╔╝░░██║╚██╗██║██║░░░░░░░░░██╔═══╝░██║░░░██║██║███╗██║██╔══╝░░██╔══██╗██╔══╝░░██║░░██║
6 ███████║░░░██║░░░██║░╚████║╚██████╗░░░░██║░░░░░╚██████╔╝╚███╔███╔╝███████╗██║░░██║███████╗██████╔╝
7 ╚══════╝░░░╚═╝░░░╚═╝░░╚═══╝░╚═════╝░░░░╚═╝░░░░░░╚═════╝░░╚══╝╚══╝░╚══════╝╚═╝░░╚═╝╚══════╝╚═════╝░
8 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
9 ░██████╗██████╗░██╗░░░██╗██████╗░████████╗░██████╗░██████╗░░██████╗░███╗░░░██╗██████╗░███████╗░░░░
10 ██╔════╝██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗████╗░░██║██╔══██╗██╔════╝░░░░
11 ██║░░░░░██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░░██║██████╔╝██║░░░██║██╔██╗░██║██║░░██║███████╗░░░░
12 ██║░░░░░██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░░██║██╔══██╗██║░░░██║██║╚██╗██║██║░░██║╚════██║░░░░
13 ╚██████╗██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚██████╔╝██████╔╝╚██████╔╝██║░╚████║██████╔╝███████║░░░░
14 ░╚═════╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚═════╝░╚═════╝░░╚═════╝░╚═╝░░╚═══╝╚═════╝░╚══════╝░░░░
15 */
16 
17 pragma solidity ^0.6.0;
18 
19 
20 interface ApproveAndCallFallBack {
21     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
22 }
23 
24 
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 
102 
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 
261 
262 
263 
264 
265 
266 
267 
268 /*
269  * @dev Provides information about the current execution context, including the
270  * sender of the transaction and its data. While these are generally available
271  * via msg.sender and msg.data, they should not be accessed in such a direct
272  * manner, since when dealing with GSN meta-transactions the account sending and
273  * paying for execution may not be the actual sender (as far as an application
274  * is concerned).
275  *
276  * This contract is only required for intermediate, library-like contracts.
277  */
278 abstract contract Context {
279     function _msgSender() internal view virtual returns (address payable) {
280         return msg.sender;
281     }
282 
283     function _msgData() internal view virtual returns (bytes memory) {
284         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
285         return msg.data;
286     }
287 }
288 
289 /**
290  * @dev Contract module which provides a basic access control mechanism, where
291  * there is an account (an owner) that can be granted exclusive access to
292  * specific functions.
293  *
294  * By default, the owner account will be the one that deploys the contract. This
295  * can later be changed with {transferOwnership}.
296  *
297  * This module is used through inheritance. It will make available the modifier
298  * `onlyOwner`, which can be applied to your functions to restrict their use to
299  * the owner.
300  */
301 contract Ownable is Context {
302     address private _owner;
303 
304     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305 
306     /**
307      * @dev Initializes the contract setting the deployer as the initial owner.
308      */
309     constructor () internal {
310         address msgSender = _msgSender();
311         _owner = msgSender;
312         emit OwnershipTransferred(address(0), msgSender);
313     }
314 
315     /**
316      * @dev Returns the address of the current owner.
317      */
318     function owner() public view returns (address) {
319         return _owner;
320     }
321 
322     /**
323      * @dev Throws if called by any account other than the owner.
324      */
325     modifier onlyOwner() {
326         require(_owner == _msgSender(), "Ownable: caller is not the owner");
327         _;
328     }
329 
330     /**
331      * @dev Leaves the contract without owner. It will not be possible to call
332      * `onlyOwner` functions anymore. Can only be called by the current owner.
333      *
334      * NOTE: Renouncing ownership will leave the contract without an owner,
335      * thereby removing any functionality that is only available to the owner.
336      */
337     function renounceOwnership() public virtual onlyOwner {
338         emit OwnershipTransferred(_owner, address(0));
339         _owner = address(0);
340     }
341 
342     /**
343      * @dev Transfers ownership of the contract to a new account (`newOwner`).
344      * Can only be called by the current owner.
345      */
346     function transferOwnership(address newOwner) public virtual onlyOwner {
347         require(newOwner != address(0), "Ownable: new owner is the zero address");
348         emit OwnershipTransferred(_owner, newOwner);
349         _owner = newOwner;
350     }
351 }
352 
353 
354 
355 contract Sync is IERC20, Ownable {
356   using SafeMath for uint256;
357 
358   mapping (address => uint256) private balances;
359   mapping (address => mapping (address => uint256)) private allowed;
360   string public constant name  = "SYNC";
361   string public constant symbol = "SYNC";
362   uint8 public constant decimals = 18;
363   uint256 _totalSupply = 16000000 * (10 ** 18); // 16 million supply
364 
365   mapping (address => bool) public mintContracts;
366 
367   modifier isMintContract() {
368     require(mintContracts[msg.sender],"calling address is not allowed to mint");
369     _;
370   }
371 
372   constructor() public Ownable(){
373     balances[msg.sender] = _totalSupply;
374     emit Transfer(address(0), msg.sender, _totalSupply);
375   }
376 
377   function setMintAccess(address account, bool canMint) public onlyOwner {
378     mintContracts[account]=canMint;
379   }
380 
381   function _mint(address account, uint256 amount) public isMintContract {
382     require(account != address(0), "ERC20: mint to the zero address");
383     _totalSupply = _totalSupply.add(amount);
384     balances[account] = balances[account].add(amount);
385     emit Transfer(address(0), account, amount);
386   }
387 
388   function totalSupply() public view override returns (uint256) {
389     return _totalSupply;
390   }
391 
392   function balanceOf(address user) public view override returns (uint256) {
393     return balances[user];
394   }
395 
396   function allowance(address user, address spender) public view override returns (uint256) {
397     return allowed[user][spender];
398   }
399 
400   function transfer(address to, uint256 value) public override returns (bool) {
401     require(value <= balances[msg.sender],"insufficient balance");
402     require(to != address(0),"cannot send to zero address");
403 
404     balances[msg.sender] = balances[msg.sender].sub(value);
405     balances[to] = balances[to].add(value);
406 
407     emit Transfer(msg.sender, to, value);
408     return true;
409   }
410 
411   function approve(address spender, uint256 value) public override returns (bool) {
412     require(spender != address(0),"cannot approve the zero address");
413     allowed[msg.sender][spender] = value;
414     emit Approval(msg.sender, spender, value);
415     return true;
416   }
417 
418   function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
419         allowed[msg.sender][spender] = tokens;
420         emit Approval(msg.sender, spender, tokens);
421         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
422         return true;
423     }
424 
425   function transferFrom(address from, address to, uint256 value) public override returns (bool) {
426     require(value <= balances[from],"insufficient balance");
427     require(value <= allowed[from][msg.sender],"insufficient allowance");
428     require(to != address(0),"cannot send to the zero address");
429 
430     balances[from] = balances[from].sub(value);
431     balances[to] = balances[to].add(value);
432 
433     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
434 
435     emit Transfer(from, to, value);
436     return true;
437   }
438 
439   function burn(uint256 amount) external {
440     require(amount != 0,"must burn more than zero");
441     require(amount <= balances[msg.sender],"insufficient balance");
442     _totalSupply = _totalSupply.sub(amount);
443     balances[msg.sender] = balances[msg.sender].sub(amount);
444     emit Transfer(msg.sender, address(0), amount);
445   }
446 
447 }