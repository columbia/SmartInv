1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
5 // Subject to the MIT license.
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
38      *
39      * Counterpart to Solidity's `+` operator.
40      *
41      * Requirements:
42      * - Addition cannot overflow.
43      */
44     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, errorMessage);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot underflow.
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return sub(a, b, "SafeMath: subtraction underflow");
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot underflow.
70      */
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b, errorMessage);
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers.
124      * Reverts on division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers.
139      * Reverts with custom message on division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 contract QuickToken {
190     /// @notice EIP-20 token name for this token
191     string public constant name = "Quickswap";
192 
193     /// @notice EIP-20 token symbol for this token
194     string public constant symbol = "QUICK";
195 
196     /// @notice EIP-20 token decimals for this token
197     uint8 public constant decimals = 18;
198 
199     /// @notice Total number of tokens in circulation
200     uint public totalSupply = 1000000000000000000000000; // 1 million QUICK
201 
202     /// @notice Address which may mint new tokens
203     address public minter;
204 
205     /// @notice The timestamp after which minting may occur
206     uint public mintingAllowedAfter;
207 
208     /// @notice Minimum time between mints
209     uint32 public constant minimumTimeBetweenMints = 1 days * 365;
210 
211     /// @notice Cap on the percentage of totalSupply that can be minted at each mint
212     uint8 public constant mintCap = 2;
213 
214     /// @notice Allowance amounts on behalf of others
215     mapping (address => mapping (address => uint96)) internal allowances;
216 
217     /// @notice Official record of token balances for each account
218     mapping (address => uint96) internal balances;
219 
220 
221     /// @notice An event thats emitted when the minter address is changed
222     event MinterChanged(address minter, address newMinter);
223 
224     /// @notice The standard EIP-20 transfer event
225     event Transfer(address indexed from, address indexed to, uint256 amount);
226 
227     /// @notice The standard EIP-20 approval event
228     event Approval(address indexed owner, address indexed spender, uint256 amount);
229 
230     /**
231      * @notice Construct a new Quick token
232      * @param account The initial account to grant all the tokens
233      * @param minter_ The account with minting ability
234      * @param mintingAllowedAfter_ The timestamp after which minting may occur
235      */
236     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
237         require(mintingAllowedAfter_ >= block.timestamp, "Quick::constructor: minting can only begin after deployment");
238 
239         balances[account] = uint96(totalSupply);
240         emit Transfer(address(0), account, totalSupply);
241         minter = minter_;
242         emit MinterChanged(address(0), minter);
243         mintingAllowedAfter = mintingAllowedAfter_;
244     }
245 
246     /**
247      * @notice Change the minter address
248      * @param minter_ The address of the new minter
249      */
250     function setMinter(address minter_) external {
251         require(msg.sender == minter, "Quick::setMinter: only the minter can change the minter address");
252         emit MinterChanged(minter, minter_);
253         minter = minter_;
254     }
255 
256     /**
257      * @notice Mint new tokens
258      * @param dst The address of the destination account
259      * @param rawAmount The number of tokens to be minted
260      */
261     function mint(address dst, uint rawAmount) external {
262         require(msg.sender == minter, "Quick::mint: only the minter can mint");
263         require(block.timestamp >= mintingAllowedAfter, "Quick::mint: minting not allowed yet");
264         require(dst != address(0), "Quick::mint: cannot transfer to the zero address");
265 
266         // record the mint
267         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
268 
269         // mint the amount
270         uint96 amount = safe96(rawAmount, "Quick::mint: amount exceeds 96 bits");
271         require(amount <= SafeMath.div(SafeMath.mul(totalSupply, mintCap), 100), "Quick::mint: exceeded mint cap");
272         totalSupply = safe96(SafeMath.add(totalSupply, amount), "Quick::mint: totalSupply exceeds 96 bits");
273 
274         // transfer the amount to the recipient
275         balances[dst] = add96(balances[dst], amount, "Quick::mint: transfer amount overflows");
276         emit Transfer(address(0), dst, amount);
277 
278     }
279 
280     /**
281      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
282      * @param account The address of the account holding the funds
283      * @param spender The address of the account spending the funds
284      * @return The number of tokens approved
285      */
286     function allowance(address account, address spender) external view returns (uint) {
287         return allowances[account][spender];
288     }
289 
290     /**
291      * @notice Approve `spender` to transfer up to `amount` from `src`
292      * @dev This will overwrite the approval amount for `spender`
293      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
294      * @param spender The address of the account which may transfer tokens
295      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
296      * @return Whether or not the approval succeeded
297      */
298     function approve(address spender, uint rawAmount) external returns (bool) {
299         uint96 amount;
300         if (rawAmount == uint(-1)) {
301             amount = uint96(-1);
302         } else {
303             amount = safe96(rawAmount, "Quick::approve: amount exceeds 96 bits");
304         }
305 
306         allowances[msg.sender][spender] = amount;
307 
308         emit Approval(msg.sender, spender, amount);
309         return true;
310     }
311 
312     /**
313      * @notice Get the number of tokens held by the `account`
314      * @param account The address of the account to get the balance of
315      * @return The number of tokens held
316      */
317     function balanceOf(address account) external view returns (uint) {
318         return balances[account];
319     }
320 
321     /**
322      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
323      * @param dst The address of the destination account
324      * @param rawAmount The number of tokens to transfer
325      * @return Whether or not the transfer succeeded
326      */
327     function transfer(address dst, uint rawAmount) external returns (bool) {
328         uint96 amount = safe96(rawAmount, "Quick::transfer: amount exceeds 96 bits");
329         _transferTokens(msg.sender, dst, amount);
330         return true;
331     }
332 
333     /**
334      * @notice Transfer `amount` tokens from `src` to `dst`
335      * @param src The address of the source account
336      * @param dst The address of the destination account
337      * @param rawAmount The number of tokens to transfer
338      * @return Whether or not the transfer succeeded
339      */
340     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
341         address spender = msg.sender;
342         uint96 spenderAllowance = allowances[src][spender];
343         uint96 amount = safe96(rawAmount, "Quick::approve: amount exceeds 96 bits");
344 
345         if (spender != src && spenderAllowance != uint96(-1)) {
346             uint96 newAllowance = sub96(spenderAllowance, amount, "Quick::transferFrom: transfer amount exceeds spender allowance");
347             allowances[src][spender] = newAllowance;
348 
349             emit Approval(src, spender, newAllowance);
350         }
351 
352         _transferTokens(src, dst, amount);
353         return true;
354     }
355 
356     function _transferTokens(address src, address dst, uint96 amount) internal {
357         require(src != address(0), "Quick::_transferTokens: cannot transfer from the zero address");
358         require(dst != address(0), "Quick::_transferTokens: cannot transfer to the zero address");
359 
360         balances[src] = sub96(balances[src], amount, "Quick::_transferTokens: transfer amount exceeds balance");
361         balances[dst] = add96(balances[dst], amount, "Quick::_transferTokens: transfer amount overflows");
362         emit Transfer(src, dst, amount);
363 
364     }
365 
366     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
367         require(n < 2**32, errorMessage);
368         return uint32(n);
369     }
370 
371     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
372         require(n < 2**96, errorMessage);
373         return uint96(n);
374     }
375 
376     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
377         uint96 c = a + b;
378         require(c >= a, errorMessage);
379         return c;
380     }
381 
382     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
383         require(b <= a, errorMessage);
384         return a - b;
385     }
386 }