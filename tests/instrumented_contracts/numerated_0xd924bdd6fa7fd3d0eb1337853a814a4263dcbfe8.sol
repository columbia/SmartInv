1 pragma solidity ^0.5.4;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
6  * the optional functions; to access them see `ERC20Detailed`.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a `Transfer` event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through `transferFrom`. This is
31      * zero by default.
32      *
33      * This value changes when `approve` or `transferFrom` are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * > Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an `Approval` event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a `Transfer` event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to `approve`. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a, "SafeMath: subtraction overflow");
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Solidity only automatically asserts when dividing by 0
161         require(b > 0, "SafeMath: division by zero");
162         uint256 c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b != 0, "SafeMath: modulo by zero");
181         return a % b;
182     }
183 }
184 
185 /**
186  * @dev Collection of functions related to the address type,
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * This test is non-exhaustive, and there may be false-negatives: during the
193      * execution of a contract's constructor, its address will be reported as
194      * not containing a contract.
195      *
196      * > It is unsafe to assume that an address for which this function returns
197      * false is an externally-owned account (EOA) and not a contract.
198      */
199     function isContract(address account) internal view returns (bool) {
200         // This method relies in extcodesize, which returns 0 for contracts in
201         // construction, since the code is only stored at the end of the
202         // constructor execution.
203 
204         uint256 size;
205         // solhint-disable-next-line no-inline-assembly
206         assembly { size := extcodesize(account) }
207         return size > 0;
208     }
209 
210     /**
211      * @dev Converts an `address` into `address payable`. Note that this is
212      * simply a type cast: the actual underlying value is not changed.
213      */
214     function toPayable(address account) internal pure returns (address payable) {
215         return address(uint160(account));
216     }
217 }
218 
219 /**
220  * @title SafeERC20
221  * @dev Wrappers around ERC20 operations that throw on failure (when the token
222  * contract returns false). Tokens that return no value (and instead revert or
223  * throw on failure) are also supported, non-reverting calls are assumed to be
224  * successful.
225  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
226  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
227  */
228 library SafeERC20 {
229     using SafeMath for uint256;
230     using Address for address;
231 
232     function safeTransfer(IERC20 token, address to, uint256 value) internal {
233         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
234     }
235 
236     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
237         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
238     }
239 
240     function safeApprove(IERC20 token, address spender, uint256 value) internal {
241         // safeApprove should only be called when setting an initial allowance,
242         // or when resetting it to zero. To increase and decrease it, use
243         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
244         // solhint-disable-next-line max-line-length
245         require((value == 0) || (token.allowance(address(this), spender) == 0),
246             "SafeERC20: approve from non-zero to non-zero allowance"
247         );
248         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
249     }
250 
251     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
252         uint256 newAllowance = token.allowance(address(this), spender).add(value);
253         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
254     }
255 
256     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
257         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
258         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
259     }
260 
261     /**
262      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
263      * on the return value: the return value is optional (but if data is returned, it must not be false).
264      * @param token The token targeted by the call.
265      * @param data The call data (encoded using abi.encode or one of its variants).
266      */
267     function callOptionalReturn(IERC20 token, bytes memory data) private {
268         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
269         // we're implementing it ourselves.
270 
271         // A Solidity high level call has three parts:
272         //  1. The target address is checked to verify it contains contract code
273         //  2. The call itself is made, and success asserted
274         //  3. The return value is decoded, which in turn checks the size of the returned data.
275         // solhint-disable-next-line max-line-length
276         require(address(token).isContract(), "SafeERC20: call to non-contract");
277 
278         // solhint-disable-next-line avoid-low-level-calls
279         (bool success, bytes memory returndata) = address(token).call(data);
280         require(success, "SafeERC20: low-level call failed");
281 
282         if (returndata.length > 0) { // Return data is optional
283             // solhint-disable-next-line max-line-length
284             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
285         }
286     }
287 }
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295     address private _owner;
296 
297     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
298 
299     /**
300      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
301      * account.
302      */
303     constructor () internal {
304         _owner = msg.sender;
305         emit OwnershipTransferred(address(0), _owner);
306     }
307 
308     /**
309      * @return the address of the owner.
310      */
311     function owner() public view returns (address) {
312         return _owner;
313     }
314 
315     /**
316      * @dev Throws if called by any account other than the owner.
317      */
318     modifier onlyOwner() {
319         require(isOwner());
320         _;
321     }
322 
323     /**
324      * @return true if `msg.sender` is the owner of the contract.
325      */
326     function isOwner() public view returns (bool) {
327         return msg.sender == _owner;
328     }
329 
330     /**
331      * @dev Allows the current owner to relinquish control of the contract.
332      * It will not be possible to call the functions with the `onlyOwner`
333      * modifier anymore.
334      * @notice Renouncing ownership will leave the contract without an owner,
335      * thereby removing any functionality that is only available to the owner.
336      */
337     function renounceOwnership() public onlyOwner {
338         emit OwnershipTransferred(_owner, address(0));
339         _owner = address(0);
340     }
341 
342     /**
343      * @dev Allows the current owner to transfer control of the contract to a newOwner.
344      * @param newOwner The address to transfer ownership to.
345      */
346     function transferOwnership(address newOwner) public onlyOwner {
347         _transferOwnership(newOwner);
348     }
349 
350     /**
351      * @dev Transfers control of the contract to a newOwner.
352      * @param newOwner The address to transfer ownership to.
353      */
354     function _transferOwnership(address newOwner) internal {
355         require(newOwner != address(0));
356         emit OwnershipTransferred(_owner, newOwner);
357         _owner = newOwner;
358     }
359 }
360 
361 
362 contract TrustlessOTC is Ownable {
363     using SafeMath for uint256;
364     using SafeERC20 for IERC20;
365 
366     mapping(address => uint256) public balanceTracker;
367     mapping(address => uint256) public feeTracker;
368     mapping(address => uint[]) public tradeTracker;
369 
370     event OfferCreated(uint indexed tradeID);
371     event OfferCancelled(uint indexed tradeID);
372     event OfferTaken(uint indexed tradeID);
373 
374     uint256 public feeBasisPoints;
375 
376     constructor (uint256 _feeBasisPoints) public {
377       feeBasisPoints = _feeBasisPoints;
378     }
379 
380     struct TradeOffer {
381         address tokenFrom;
382         address tokenTo;
383         uint256 amountFrom;
384         uint256 amountTo;
385         address payable creator;
386         address optionalTaker;
387         bool active;
388         bool completed;
389         uint tradeID;
390     }
391 
392     TradeOffer[] public offers;
393 
394     function initiateTrade(
395         address _tokenFrom,
396         address _tokenTo,
397         uint256 _amountFrom,
398         uint256 _amountTo,
399         address _optionalTaker
400         ) public payable returns (uint newTradeID) {
401             if (_tokenFrom == address(0)) {
402                 require(msg.value == _amountFrom);
403             } else {
404                 require(msg.value == 0);
405                 IERC20(_tokenFrom).safeTransferFrom(msg.sender, address(this), _amountFrom);
406             }
407             newTradeID = offers.length;
408             offers.length++;
409             TradeOffer storage o = offers[newTradeID];
410             balanceTracker[_tokenFrom] = balanceTracker[_tokenFrom].add(_amountFrom);
411             o.tokenFrom = _tokenFrom;
412             o.tokenTo = _tokenTo;
413             o.amountFrom = _amountFrom;
414             o.amountTo = _amountTo;
415             o.creator = msg.sender;
416             o.optionalTaker = _optionalTaker;
417             o.active = true;
418             o.tradeID = newTradeID;
419             tradeTracker[msg.sender].push(newTradeID);
420             emit OfferCreated(newTradeID);
421     }
422 
423     function cancelTrade(uint tradeID) public returns (bool) {
424         TradeOffer storage o = offers[tradeID];
425         require(msg.sender == o.creator);
426         require(o.active == true);
427         o.active = false;
428         if (o.tokenFrom == address(0)) {
429           msg.sender.transfer(o.amountFrom);
430         } else {
431           IERC20(o.tokenFrom).safeTransfer(o.creator, o.amountFrom);
432         }
433         balanceTracker[o.tokenFrom] -= o.amountFrom;
434         emit OfferCancelled(tradeID);
435         return true;
436     }
437 
438     function take(uint tradeID) public payable returns (bool) {
439         TradeOffer storage o = offers[tradeID];
440         require(o.optionalTaker == msg.sender || o.optionalTaker == address(0));
441         require(o.active == true);
442         o.active = false;
443         balanceTracker[o.tokenFrom] = balanceTracker[o.tokenFrom].sub(o.amountFrom);
444         uint256 fee = o.amountFrom.mul(feeBasisPoints).div(10000);
445         feeTracker[o.tokenFrom] = feeTracker[o.tokenFrom].add(fee);
446         tradeTracker[msg.sender].push(tradeID);
447 
448         if (o.tokenFrom == address(0)) {
449             msg.sender.transfer(o.amountFrom.sub(fee));
450         } else {
451           IERC20(o.tokenFrom).safeTransfer(msg.sender, o.amountFrom.sub(fee));
452         }
453 
454         if (o.tokenTo == address(0)) {
455             require(msg.value == o.amountTo);
456             o.creator.transfer(msg.value);
457         } else {
458             require(msg.value == 0);
459             IERC20(o.tokenTo).safeTransferFrom(msg.sender, o.creator, o.amountTo);
460         }
461         o.completed = true;
462         emit OfferTaken(tradeID);
463         return true;
464     }
465 
466     function getOfferDetails(uint tradeID) external view returns (
467         address _tokenFrom,
468         address _tokenTo,
469         uint256 _amountFrom,
470         uint256 _amountTo,
471         address _creator,
472         uint256 _fee,
473         bool _active,
474         bool _completed
475     ) {
476         TradeOffer storage o = offers[tradeID];
477         _tokenFrom = o.tokenFrom;
478         _tokenTo = o.tokenTo;
479         _amountFrom = o.amountFrom;
480         _amountTo = o.amountTo;
481         _creator = o.creator;
482         _fee = o.amountFrom.mul(feeBasisPoints).div(10000);
483         _active = o.active;
484         _completed = o.completed;
485     }
486 
487     function getUserTrades(address user) external view returns (uint[] memory){
488       return tradeTracker[user];
489     }
490 
491     function reclaimToken(IERC20 _token) external onlyOwner {
492         uint256 balance = _token.balanceOf(address(this));
493         uint256 excess = balance.sub(balanceTracker[address(_token)]);
494         require(excess > 0);
495         if (address(_token) == address(0)) {
496             msg.sender.transfer(excess);
497         } else {
498             _token.safeTransfer(owner(), excess);
499         }
500     }
501 
502     function claimFees(IERC20 _token) external onlyOwner {
503         uint256 feesToClaim = feeTracker[address(_token)];
504         feeTracker[address(_token)] = 0;
505         require(feesToClaim > 0);
506         if (address(_token) == address(0)) {
507             msg.sender.transfer(feesToClaim);
508         } else {
509             _token.safeTransfer(owner(), feesToClaim);
510         }
511     }
512 
513 }