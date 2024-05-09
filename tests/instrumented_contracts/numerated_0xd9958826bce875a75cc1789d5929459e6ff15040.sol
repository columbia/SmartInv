1 pragma solidity 0.5.17;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19 
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      * - Subtraction cannot overflow.
28      */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      *
42      * _Available since v2.4.0._
43      */
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      *
100      * _Available since v2.4.0._
101      */
102     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         // Solidity only automatically asserts when dividing by 0
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
113      * Reverts when dividing by zero.
114      *
115      * Counterpart to Solidity's `%` operator. This function uses a `revert`
116      * opcode (which leaves remaining gas untouched) while Solidity uses an
117      * invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      * - The divisor cannot be zero.
121      */
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         return mod(a, b, "SafeMath: modulo by zero");
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts with custom message when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      *
137      * _Available since v2.4.0._
138      */
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 contract Context {
146     // Empty internal constructor, to prevent people from mistakenly deploying
147     // an instance of this contract, which should be used via inheritance.
148     constructor () internal { }
149     // solhint-disable-previous-line no-empty-blocks
150 
151     function _msgSender() internal view returns (address payable) {
152         return msg.sender;
153     }
154 
155     function _msgData() internal view returns (bytes memory) {
156         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
157         return msg.data;
158     }
159 }
160 
161 contract Ownable is Context {
162     address private _owner;
163 
164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166     /**
167      * @dev Initializes the contract setting the deployer as the initial owner.
168      */
169     constructor () internal {
170         _owner = _msgSender();
171         emit OwnershipTransferred(address(0), _owner);
172     }
173 
174     /**
175      * @dev Returns the address of the current owner.
176      */
177     function owner() public view returns (address) {
178         return _owner;
179     }
180 
181     /**
182      * @dev Throws if called by any account other than the owner.
183      */
184     modifier onlyOwner() {
185         require(isOwner(), "Ownable: caller is not the owner");
186         _;
187     }
188 
189     /**
190      * @dev Returns true if the caller is the current owner.
191      */
192     function isOwner() public view returns (bool) {
193         return _msgSender() == _owner;
194     }
195 
196     /**
197      * @dev Leaves the contract without owner. It will not be possible to call
198      * `onlyOwner` functions anymore. Can only be called by the current owner.
199      *
200      * NOTE: Renouncing ownership will leave the contract without an owner,
201      * thereby removing any functionality that is only available to the owner.
202      */
203     function renounceOwnership() public onlyOwner {
204         emit OwnershipTransferred(_owner, address(0));
205         _owner = address(0);
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public onlyOwner {
213         _transferOwnership(newOwner);
214     }
215 
216     /**
217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
218      */
219     function _transferOwnership(address newOwner) internal {
220         require(newOwner != address(0), "Ownable: new owner is the zero address");
221         emit OwnershipTransferred(_owner, newOwner);
222         _owner = newOwner;
223     }
224 }
225 
226 interface IERC20 {
227     /**
228      * @dev Returns the amount of tokens in existence.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     /**
233      * @dev Returns the amount of tokens owned by `account`.
234      */
235     function balanceOf(address account) external view returns (uint256);
236 
237     /**
238      * @dev Moves `amount` tokens from the caller's account to `recipient`.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transfer(address recipient, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Returns the remaining number of tokens that `spender` will be
248      * allowed to spend on behalf of `owner` through {transferFrom}. This is
249      * zero by default.
250      *
251      * This value changes when {approve} or {transferFrom} are called.
252      */
253     function allowance(address owner, address spender) external view returns (uint256);
254 
255     /**
256      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * IMPORTANT: Beware that changing an allowance with this method brings the risk
261      * that someone may use both the old and the new allowance by unfortunate
262      * transaction ordering. One possible solution to mitigate this race
263      * condition is to first reduce the spender's allowance to 0 and set the
264      * desired value afterwards:
265      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266      *
267      * Emits an {Approval} event.
268      */
269     function approve(address spender, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Moves `amount` tokens from `sender` to `recipient` using the
273      * allowance mechanism. `amount` is then deducted from the caller's
274      * allowance.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Emitted when `value` tokens are moved from one account (`from`) to
284      * another (`to`).
285      *
286      * Note that `value` may be zero.
287      */
288     event Transfer(address indexed from, address indexed to, uint256 value);
289 
290     /**
291      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
292      * a call to {approve}. `value` is the new allowance.
293      */
294     event Approval(address indexed owner, address indexed spender, uint256 value);
295 }
296 
297 library Address {
298     /**
299      * @dev Returns true if `account` is a contract.
300      *
301      * This test is non-exhaustive, and there may be false-negatives: during the
302      * execution of a contract's constructor, its address will be reported as
303      * not containing a contract.
304      *
305      * IMPORTANT: It is unsafe to assume that an address for which this
306      * function returns false is an externally-owned account (EOA) and not a
307      * contract.
308      */
309     function isContract(address account) internal view returns (bool) {
310         // This method relies in extcodesize, which returns 0 for contracts in
311         // construction, since the code is only stored at the end of the
312         // constructor execution.
313 
314         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
315         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
316         // for accounts without code, i.e. `keccak256('')`
317         bytes32 codehash;
318         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
319         // solhint-disable-next-line no-inline-assembly
320         assembly { codehash := extcodehash(account) }
321         return (codehash != 0x0 && codehash != accountHash);
322     }
323 
324     /**
325      * @dev Converts an `address` into `address payable`. Note that this is
326      * simply a type cast: the actual underlying value is not changed.
327      *
328      * _Available since v2.4.0._
329      */
330     function toPayable(address account) internal pure returns (address payable) {
331         return address(uint160(account));
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      *
350      * _Available since v2.4.0._
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         // solhint-disable-next-line avoid-call-value
356         (bool success, ) = recipient.call.value(amount)("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 }
360 
361 library SafeERC20 {
362     using SafeMath for uint256;
363     using Address for address;
364 
365     function safeTransfer(IERC20 token, address to, uint256 value) internal {
366         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
367     }
368 
369     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
370         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
371     }
372 
373     function safeApprove(IERC20 token, address spender, uint256 value) internal {
374         // safeApprove should only be called when setting an initial allowance,
375         // or when resetting it to zero. To increase and decrease it, use
376         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
377         // solhint-disable-next-line max-line-length
378         require((value == 0) || (token.allowance(address(this), spender) == 0),
379             "SafeERC20: approve from non-zero to non-zero allowance"
380         );
381         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
382     }
383 
384     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
385         uint256 newAllowance = token.allowance(address(this), spender).add(value);
386         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
387     }
388 
389     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
390         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
391         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
392     }
393 
394     /**
395      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
396      * on the return value: the return value is optional (but if data is returned, it must not be false).
397      * @param token The token targeted by the call.
398      * @param data The call data (encoded using abi.encode or one of its variants).
399      */
400     function callOptionalReturn(IERC20 token, bytes memory data) private {
401         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
402         // we're implementing it ourselves.
403 
404         // A Solidity high level call has three parts:
405         //  1. The target address is checked to verify it contains contract code
406         //  2. The call itself is made, and success asserted
407         //  3. The return value is decoded, which in turn checks the size of the returned data.
408         // solhint-disable-next-line max-line-length
409         require(address(token).isContract(), "SafeERC20: call to non-contract");
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = address(token).call(data);
413         require(success, "SafeERC20: low-level call failed");
414 
415         if (returndata.length > 0) { // Return data is optional
416             // solhint-disable-next-line max-line-length
417             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
418         }
419     }
420 }
421 
422 contract ERC20 is IERC20 {
423     using SafeMath for uint256;
424 
425     mapping (address => uint256) internal _balances;
426     mapping (address => mapping (address => uint256)) internal _allowed;
427     
428     event Transfer(address indexed from, address indexed to, uint256 value);
429     event Approval(address indexed owner, address indexed spender, uint256 value);
430 
431     uint256 internal _totalSupply;
432 
433     function totalSupply() public view returns (uint256) {
434         return _totalSupply;
435     }
436 
437     function balanceOf(address owner) public view returns (uint256) {
438         return _balances[owner];
439     }
440 
441     function allowance(address owner, address spender) public view returns (uint256) {
442         return _allowed[owner][spender];
443     }
444 
445     function transfer(address to, uint256 value) public returns (bool) {
446         _transfer(msg.sender, to, value);
447         return true;
448     }
449 
450     function approve(address spender, uint256 value) public returns (bool) {
451         _allowed[msg.sender][spender] = value;
452         emit Approval(msg.sender, spender, value);
453         return true;
454     }
455 
456     function transferFrom(address from, address to, uint256 value) public returns (bool) {
457         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
458         _transfer(from, to, value);
459         return true;
460     }
461 
462     function _transfer(address from, address to, uint256 value) internal {
463         require(to != address(0));
464         _balances[from] = _balances[from].sub(value);
465         _balances[to] = _balances[to].add(value);
466         emit Transfer(from, to, value);
467     }
468 }
469 
470 contract ERC20Mintable is ERC20 {
471     string public name;
472     string public symbol;
473     uint8 public decimals;
474 
475     function _mint(address to, uint256 amount) internal {
476         _balances[to] = _balances[to].add(amount);
477         _totalSupply = _totalSupply.add(amount);
478         emit Transfer(address(0), to, amount);
479     }
480 
481     function _burn(address from, uint256 amount) internal {
482         _balances[from] = _balances[from].sub(amount);
483         _totalSupply = _totalSupply.sub(amount);
484         emit Transfer(from, address(0), amount);
485     }
486 }
487 
488 contract stakingRateModel {
489     using SafeMath for *;
490 
491     uint256 lastUpdateTimestamp;
492     uint256 stakingRateStored;
493     uint256 constant ratePerSecond = 21979553177; //(1+ratePerSecond)^(86400*365) = 2
494     constructor() public {
495         stakingRateStored = 1e18;
496         lastUpdateTimestamp = block.timestamp;
497     }
498 
499     function stakingRate(uint256 time) external returns (uint256 rate) {
500         if(time == 30 days) return stakingRateMax().div(12);
501         else if(time == 90 days) return stakingRateMax().div(4);
502         else if(time == 180 days) return stakingRateMax().div(2);
503         else if(time == 360 days) return stakingRateMax();
504     }
505 
506     function stakingRateMax() public returns (uint256 rate) {
507         uint256 timeElapsed = block.timestamp.sub(lastUpdateTimestamp);
508         if(timeElapsed > 0) {
509             lastUpdateTimestamp = block.timestamp;
510             rate = timeElapsed.mul(ratePerSecond).add(1e18).mul(stakingRateStored).div(1e18);
511             stakingRateStored = rate;
512         }
513         else rate = stakingRateStored;
514     }
515 
516 }
517 
518 contract sHakka is Ownable, ERC20Mintable{
519     using SafeMath for *;
520     using SafeERC20 for IERC20;
521 
522     struct vault {
523         uint256 hakkaAmount;
524         uint256 wAmount;
525         uint256 unlockTime;
526     }
527 
528     event Stake(address indexed holder, address indexed depositor, uint256 amount, uint256 wAmount, uint256 time);
529     event Unstake(address indexed holder, address indexed receiver, uint256 amount, uint256 wAmount);
530 
531     IERC20 public constant Hakka = IERC20(0x0E29e5AbbB5FD88e28b2d355774e73BD47dE3bcd);
532     stakingRateModel public currentModel;
533 
534     mapping(address => mapping(uint256 => vault)) public vaults;
535     mapping(address => uint256) public vaultCount;
536     mapping(address => uint256) public stakedHakka;
537     mapping(address => uint256) public votingPower;
538 
539     constructor() public {
540         symbol = "sHAKKA";
541         name = "Sealed Hakka";
542         decimals = 18;
543         _balances[address(this)] = uint256(-1);
544         _balances[address(0)] = uint256(-1);
545     }
546 
547     function getStakingRate(uint256 time) public returns (uint256 rate) {
548         return currentModel.stakingRate(time);
549     }
550 
551     function setStakingRateModel(address newModel) external onlyOwner {
552         currentModel = stakingRateModel(newModel);
553     }
554 
555     function stake(address to, uint256 amount, uint256 time) external returns (uint256 wAmount) {
556         vault storage v = vaults[to][vaultCount[to]];
557         wAmount = getStakingRate(time).mul(amount).div(1e18);
558         require(wAmount > 0, "invalid lockup");
559 
560         v.hakkaAmount = amount;
561         v.wAmount = wAmount;
562         v.unlockTime = block.timestamp.add(time);
563         
564         stakedHakka[to] = stakedHakka[to].add(amount);
565         votingPower[to] = votingPower[to].add(wAmount);
566         vaultCount[to]++;
567 
568         _mint(to, wAmount);
569         Hakka.safeTransferFrom(msg.sender, address(this), amount);
570 
571         emit Stake(to, msg.sender, amount, wAmount, time);
572     }
573 
574     function unstake(address to, uint256 index, uint256 wAmount) external returns (uint256 amount) {
575         vault storage v = vaults[msg.sender][index];
576         require(block.timestamp >= v.unlockTime, "locked");
577         require(wAmount <= v.wAmount, "exceed locked amount");
578         amount = wAmount.mul(v.hakkaAmount).div(v.wAmount);
579 
580         v.hakkaAmount = v.hakkaAmount.sub(amount);
581         v.wAmount = v.wAmount.sub(wAmount);
582 
583         stakedHakka[msg.sender] = stakedHakka[msg.sender].sub(amount);
584         votingPower[msg.sender] = votingPower[msg.sender].sub(wAmount);
585 
586         _burn(msg.sender, wAmount);
587         Hakka.safeTransfer(to, amount);
588         
589         emit Unstake(msg.sender, to, amount, wAmount);
590     }
591 
592     function inCaseTokenGetsStuckPartial(IERC20 _TokenAddress, uint256 _amount) onlyOwner external {
593         require(_TokenAddress != Hakka);
594         _TokenAddress.safeTransfer(msg.sender, _amount);
595     }
596 
597 }