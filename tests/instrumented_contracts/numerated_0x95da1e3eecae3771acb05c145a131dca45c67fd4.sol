1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.4.22 <0.8.0;
3 
4 // File: @openzeppelin/contracts/math/SafeMath.sol
5 
6 
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      *
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/GSN/Context.sol
165 
166 
167 
168 /*
169  * @dev Provides information about the current execution context, including the
170  * sender of the transaction and its data. While these are generally available
171  * via msg.sender and msg.data, they should not be accessed in such a direct
172  * manner, since when dealing with GSN meta-transactions the account sending and
173  * paying for execution may not be the actual sender (as far as an application
174  * is concerned).
175  *
176  * This contract is only required for intermediate, library-like contracts.
177  */
178 abstract contract Context {
179     function _msgSender() internal view virtual returns (address payable) {
180         return msg.sender;
181     }
182 
183     function _msgData() internal view virtual returns (bytes memory) {
184         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
185         return msg.data;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/access/Ownable.sol
190 
191 
192 
193 /**
194  * @dev Contract module which provides a basic access control mechanism, where
195  * there is an account (an owner) that can be granted exclusive access to
196  * specific functions.
197  *
198  * By default, the owner account will be the one that deploys the contract. This
199  * can later be changed with {transferOwnership}.
200  *
201  * This module is used through inheritance. It will make available the modifier
202  * `onlyOwner`, which can be applied to your functions to restrict their use to
203  * the owner.
204  */
205 contract Ownable is Context {
206     address private _owner;
207 
208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210     /**
211      * @dev Initializes the contract setting the deployer as the initial owner.
212      */
213     constructor () internal {
214         address msgSender = _msgSender();
215         _owner = msgSender;
216         emit OwnershipTransferred(address(0), msgSender);
217     }
218 
219     /**
220      * @dev Returns the address of the current owner.
221      */
222     function owner() public view returns (address) {
223         return _owner;
224     }
225 
226     /**
227      * @dev Throws if called by any account other than the owner.
228      */
229     modifier onlyOwner() {
230         require(_owner == _msgSender(), "Ownable: caller is not the owner");
231         _;
232     }
233 
234     /**
235      * @dev Leaves the contract without owner. It will not be possible to call
236      * `onlyOwner` functions anymore. Can only be called by the current owner.
237      *
238      * NOTE: Renouncing ownership will leave the contract without an owner,
239      * thereby removing any functionality that is only available to the owner.
240      */
241     function renounceOwnership() public virtual onlyOwner {
242         emit OwnershipTransferred(_owner, address(0));
243         _owner = address(0);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Can only be called by the current owner.
249      */
250     function transferOwnership(address newOwner) public virtual onlyOwner {
251         require(newOwner != address(0), "Ownable: new owner is the zero address");
252         emit OwnershipTransferred(_owner, newOwner);
253         _owner = newOwner;
254     }
255 }
256 
257 // File: src/Token.sol
258 
259 
260 
261 
262 contract Token is Ownable {
263     using SafeMath for uint256;
264 
265     string private _name;
266     string private _symbol;
267     uint8 private _decimals;
268 
269     address private _rebaseInvoker;
270     uint256 private _perShareAmount;
271     uint256 private _totalShares;
272 
273     mapping(address => uint256) private _shares;
274     mapping(address => mapping(address => uint256)) private _allowedShares;
275 
276     modifier onlyRebaseInvoker() {
277         require(
278             msg.sender == _rebaseInvoker,
279             "Rebase: caller is not the rebase invoker"
280         );
281         _;
282     }
283 
284     constructor() public {
285         _perShareAmount = 10**9;
286         _totalShares = 10000000 * 10**9;
287         _name = "Elastic";
288         _symbol = "ESC";
289         _decimals = 18;
290 
291         address msgSender = _msgSender();
292         _shares[msgSender] = _totalShares;
293         emit Transfer(address(0), msgSender, _totalShares.mul(_perShareAmount));
294     }
295 
296     function name() public view returns (string memory) {
297         return _name;
298     }
299 
300     function symbol() public view returns (string memory) {
301         return _symbol;
302     }
303 
304     function decimals() public view returns (uint8) {
305         return _decimals;
306     }
307 
308     function totalSupply() external view returns (uint256) {
309         return _totalShares.mul(_perShareAmount);
310     }
311 
312     function balanceOf(address account) external view returns (uint256) {
313         return _shares[account].mul(_perShareAmount);
314     }
315 
316     function transfer(address recipient, uint256 amount)
317         external
318         returns (bool)
319     {
320         uint256 share = amount.div(_perShareAmount);
321         _shares[msg.sender] = _shares[msg.sender].sub(share);
322         _shares[recipient] = _shares[recipient].add(share);
323         emit Transfer(msg.sender, recipient, amount);
324         return true;
325     }
326 
327     function allowance(address owner, address spender)
328         external
329         view
330         returns (uint256)
331     {
332         return _allowedShares[owner][spender].mul(_perShareAmount);
333     }
334 
335     function approve(address spender, uint256 amount) external returns (bool) {
336         _allowedShares[msg.sender][spender] = amount.div(_perShareAmount);
337         emit Approval(msg.sender, spender, amount);
338         return true;
339     }
340 
341     function transferFrom(
342         address sender,
343         address recipient,
344         uint256 amount
345     ) external returns (bool) {
346         uint256 share = amount.div(_perShareAmount);
347         _allowedShares[sender][msg.sender] = _allowedShares[sender][msg.sender]
348             .sub(share);
349         _shares[sender] = _shares[sender].sub(share);
350         _shares[recipient] = _shares[recipient].add(share);
351         emit Transfer(sender, recipient, amount);
352         return true;
353     }
354 
355     function rebaseInvoker() public view returns (address) {
356         return _rebaseInvoker;
357     }
358 
359     function perShareAmount() public view returns (uint256) {
360         return _perShareAmount;
361     }
362 
363     function totalShares() public view returns (uint256) {
364         return _totalShares;
365     }
366 
367     function changeRebaseInvoker(address newInvoker) public onlyOwner {
368         require(
369             newInvoker != address(0),
370             "Rebase: new invoker is the zero address"
371         );
372         emit RebaseInvokerChanged(_rebaseInvoker, newInvoker);
373         _rebaseInvoker = newInvoker;
374     }
375 
376     function rebase(
377         uint256 epoch,
378         uint256 numerator,
379         uint256 denominator
380     ) external onlyRebaseInvoker returns (uint256) {
381         uint256 newPerShareAmount = _perShareAmount.mul(numerator).div(
382             denominator
383         );
384         emit Rebase(epoch, _perShareAmount, newPerShareAmount);
385         _perShareAmount = newPerShareAmount;
386         return _perShareAmount;
387     }
388 
389     event Transfer(address indexed from, address indexed to, uint256 amount);
390     event Approval(
391         address indexed owner,
392         address indexed spender,
393         uint256 amount
394     );
395 
396     event Rebase(
397         uint256 indexed epoch,
398         uint256 oldPerShareAmount,
399         uint256 newPerShareAmount
400     );
401 
402     event RebaseInvokerChanged(
403         address indexed previousOwner,
404         address indexed newOwner
405     );
406 }