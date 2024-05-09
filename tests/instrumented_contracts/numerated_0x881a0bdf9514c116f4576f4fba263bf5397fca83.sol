1 pragma solidity 0.5.8;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be aplied to your functions to restrict their use to
116  * the owner.
117  */
118 contract Ownable {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor () internal {
127         _owner = msg.sender;
128         emit OwnershipTransferred(address(0), _owner);
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(isOwner(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Returns true if the caller is the current owner.
148      */
149     function isOwner() public view returns (bool) {
150         return msg.sender == _owner;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * > Note: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public onlyOwner {
161         emit OwnershipTransferred(_owner, address(0));
162         _owner = address(0);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public onlyOwner {
170         _transferOwnership(newOwner);
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      */
176     function _transferOwnership(address newOwner) internal {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         emit OwnershipTransferred(_owner, newOwner);
179         _owner = newOwner;
180     }
181 }
182 
183 /**
184  * @dev Contract module that helps prevent reentrant calls to a function.
185  *
186  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
187  * available, which can be aplied to functions to make sure there are no nested
188  * (reentrant) calls to them.
189  *
190  * Note that because there is a single `nonReentrant` guard, functions marked as
191  * `nonReentrant` may not call one another. This can be worked around by making
192  * those functions `private`, and then adding `external` `nonReentrant` entry
193  * points to them.
194  */
195 contract ReentrancyGuard {
196     /// @dev counter to allow mutex lock with only one SSTORE operation
197     uint256 private _guardCounter;
198 
199     constructor () internal {
200         // The counter starts at one to prevent changing it from zero to a non-zero
201         // value, which is a more expensive operation.
202         _guardCounter = 1;
203     }
204 
205     /**
206      * @dev Prevents a contract from calling itself, directly or indirectly.
207      * Calling a `nonReentrant` function from another `nonReentrant`
208      * function is not supported. It is possible to prevent this from happening
209      * by making the `nonReentrant` function external, and make it call a
210      * `private` function that does the actual work.
211      */
212     modifier nonReentrant() {
213         _guardCounter += 1;
214         uint256 localCounter = _guardCounter;
215         _;
216         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
217     }
218 }
219 
220 interface IMiniMeToken {
221     function balanceOf(address _owner) external view returns (uint256 balance);
222     function totalSupply() external view returns(uint);
223     function generateTokens(address _owner, uint _amount) external returns (bool);
224     function destroyTokens(address _owner, uint _amount) external returns (bool);
225     function totalSupplyAt(uint _blockNumber) external view returns(uint);
226     function balanceOfAt(address _holder, uint _blockNumber) external view returns (uint);
227     function transferOwnership(address newOwner) external;
228 }
229 
230 /// @dev The token controller contract must implement these functions
231 contract TokenController {
232   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
233   /// @param _owner The address that sent the ether to create tokens
234   /// @return True if the ether is accepted, false if it throws
235   function proxyPayment(address _owner) public payable returns(bool);
236 
237   /// @notice Notifies the controller about a token transfer allowing the
238   ///  controller to react if desired
239   /// @param _from The origin of the transfer
240   /// @param _to The destination of the transfer
241   /// @param _amount The amount of the transfer
242   /// @return False if the controller does not authorize the transfer
243   function onTransfer(address _from, address _to, uint _amount) public returns(bool);
244 
245   /// @notice Notifies the controller about an approval allowing the
246   ///  controller to react if desired
247   /// @param _owner The address that calls `approve()`
248   /// @param _spender The spender in the `approve()` call
249   /// @param _amount The amount in the `approve()` call
250   /// @return False if the controller does not authorize the approval
251   function onApprove(address _owner, address _spender, uint _amount) public
252     returns(bool);
253 }
254 
255 /**
256  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
257  * the optional functions; to access them see `ERC20Detailed`.
258  */
259 interface IERC20 {
260     /**
261      * @dev Returns the amount of tokens in existence.
262      */
263     function totalSupply() external view returns (uint256);
264 
265     /**
266      * @dev Returns the amount of tokens owned by `account`.
267      */
268     function balanceOf(address account) external view returns (uint256);
269 
270     /**
271      * @dev Moves `amount` tokens from the caller's account to `recipient`.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a `Transfer` event.
276      */
277     function transfer(address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Returns the remaining number of tokens that `spender` will be
281      * allowed to spend on behalf of `owner` through `transferFrom`. This is
282      * zero by default.
283      *
284      * This value changes when `approve` or `transferFrom` are called.
285      */
286     function allowance(address owner, address spender) external view returns (uint256);
287 
288     /**
289      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * > Beware that changing an allowance with this method brings the risk
294      * that someone may use both the old and the new allowance by unfortunate
295      * transaction ordering. One possible solution to mitigate this race
296      * condition is to first reduce the spender's allowance to 0 and set the
297      * desired value afterwards:
298      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
299      *
300      * Emits an `Approval` event.
301      */
302     function approve(address spender, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Moves `amount` tokens from `sender` to `recipient` using the
306      * allowance mechanism. `amount` is then deducted from the caller's
307      * allowance.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * Emits a `Transfer` event.
312      */
313     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Emitted when `value` tokens are moved from one account (`from`) to
317      * another (`to`).
318      *
319      * Note that `value` may be zero.
320      */
321     event Transfer(address indexed from, address indexed to, uint256 value);
322 
323     /**
324      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
325      * a call to `approve`. `value` is the new allowance.
326      */
327     event Approval(address indexed owner, address indexed spender, uint256 value);
328 }
329 
330 /**
331  * @dev Optional functions from the ERC20 standard.
332  */
333 contract ERC20Detailed is IERC20 {
334     string private _name;
335     string private _symbol;
336     uint8 private _decimals;
337 
338     /**
339      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
340      * these values are immutable: they can only be set once during
341      * construction.
342      */
343     constructor (string memory name, string memory symbol, uint8 decimals) public {
344         _name = name;
345         _symbol = symbol;
346         _decimals = decimals;
347     }
348 
349     /**
350      * @dev Returns the name of the token.
351      */
352     function name() public view returns (string memory) {
353         return _name;
354     }
355 
356     /**
357      * @dev Returns the symbol of the token, usually a shorter version of the
358      * name.
359      */
360     function symbol() public view returns (string memory) {
361         return _symbol;
362     }
363 
364     /**
365      * @dev Returns the number of decimals used to get its user representation.
366      * For example, if `decimals` equals `2`, a balance of `505` tokens should
367      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
368      *
369      * Tokens usually opt for a value of 18, imitating the relationship between
370      * Ether and Wei.
371      *
372      * > Note that this information is only used for _display_ purposes: it in
373      * no way affects any of the arithmetic of the contract, including
374      * `IERC20.balanceOf` and `IERC20.transfer`.
375      */
376     function decimals() public view returns (uint8) {
377         return _decimals;
378     }
379 }
380 
381 /**
382  * @dev Collection of functions related to the address type,
383  */
384 library Address {
385     /**
386      * @dev Returns true if `account` is a contract.
387      *
388      * This test is non-exhaustive, and there may be false-negatives: during the
389      * execution of a contract's constructor, its address will be reported as
390      * not containing a contract.
391      *
392      * > It is unsafe to assume that an address for which this function returns
393      * false is an externally-owned account (EOA) and not a contract.
394      */
395     function isContract(address account) internal view returns (bool) {
396         // This method relies in extcodesize, which returns 0 for contracts in
397         // construction, since the code is only stored at the end of the
398         // constructor execution.
399 
400         uint256 size;
401         // solhint-disable-next-line no-inline-assembly
402         assembly { size := extcodesize(account) }
403         return size > 0;
404     }
405 }
406 
407 /**
408  * @title SafeERC20
409  * @dev Wrappers around ERC20 operations that throw on failure (when the token
410  * contract returns false). Tokens that return no value (and instead revert or
411  * throw on failure) are also supported, non-reverting calls are assumed to be
412  * successful.
413  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417     using SafeMath for uint256;
418     using Address for address;
419 
420     function safeTransfer(IERC20 token, address to, uint256 value) internal {
421         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
422     }
423 
424     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
425         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
426     }
427 
428     function safeApprove(IERC20 token, address spender, uint256 value) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require((value == 0) || (token.allowance(address(this), spender) == 0),
434             "SafeERC20: approve from non-zero to non-zero allowance"
435         );
436         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
437     }
438 
439     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).add(value);
441         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
446         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     /**
450      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
451      * on the return value: the return value is optional (but if data is returned, it must not be false).
452      * @param token The token targeted by the call.
453      * @param data The call data (encoded using abi.encode or one of its variants).
454      */
455     function callOptionalReturn(IERC20 token, bytes memory data) private {
456         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
457         // we're implementing it ourselves.
458 
459         // A Solidity high level call has three parts:
460         //  1. The target address is checked to verify it contains contract code
461         //  2. The call itself is made, and success asserted
462         //  3. The return value is decoded, which in turn checks the size of the returned data.
463         // solhint-disable-next-line max-line-length
464         require(address(token).isContract(), "SafeERC20: call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = address(token).call(data);
468         require(success, "SafeERC20: low-level call failed");
469 
470         if (returndata.length > 0) { // Return data is optional
471             // solhint-disable-next-line max-line-length
472             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
473         }
474     }
475 }
476 
477 /**
478  * @title The interface for the Kyber Network smart contract
479  * @author Zefram Lou (Zebang Liu)
480  */
481 interface KyberNetwork {
482   function getExpectedRate(ERC20Detailed src, ERC20Detailed dest, uint srcQty) external view
483       returns (uint expectedRate, uint slippageRate);
484 
485   function tradeWithHint(
486     ERC20Detailed src, uint srcAmount, ERC20Detailed dest, address payable destAddress, uint maxDestAmount,
487     uint minConversionRate, address walletId, bytes calldata hint) external payable returns(uint);
488 }
489 
490 /**
491  * @title The smart contract for useful utility functions and constants.
492  * @author Zefram Lou (Zebang Liu)
493  */
494 contract Utils {
495   using SafeMath for uint256;
496   using SafeERC20 for ERC20Detailed;
497 
498   /**
499    * @notice Checks if `_token` is a valid token.
500    * @param _token the token's address
501    */
502   modifier isValidToken(address _token) {
503     require(_token != address(0));
504     if (_token != address(ETH_TOKEN_ADDRESS)) {
505       require(isContract(_token));
506     }
507     _;
508   }
509 
510   address public DAI_ADDR;
511   address payable public KYBER_ADDR;
512   
513   bytes public constant PERM_HINT = "PERM";
514 
515   ERC20Detailed internal constant ETH_TOKEN_ADDRESS = ERC20Detailed(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
516   ERC20Detailed internal dai;
517   KyberNetwork internal kyber;
518 
519   uint constant internal PRECISION = (10**18);
520   uint constant internal MAX_QTY   = (10**28); // 10B tokens
521   uint constant internal ETH_DECIMALS = 18;
522   uint constant internal MAX_DECIMALS = 18;
523 
524   constructor(
525     address _daiAddr,
526     address payable _kyberAddr
527   ) public {
528     DAI_ADDR = _daiAddr;
529     KYBER_ADDR = _kyberAddr;
530 
531     dai = ERC20Detailed(_daiAddr);
532     kyber = KyberNetwork(_kyberAddr);
533   }
534 
535   /**
536    * @notice Get the number of decimals of a token
537    * @param _token the token to be queried
538    * @return number of decimals
539    */
540   function getDecimals(ERC20Detailed _token) internal view returns(uint256) {
541     if (address(_token) == address(ETH_TOKEN_ADDRESS)) {
542       return uint256(ETH_DECIMALS);
543     }
544     return uint256(_token.decimals());
545   }
546 
547   /**
548    * @notice Get the token balance of an account
549    * @param _token the token to be queried
550    * @param _addr the account whose balance will be returned
551    * @return token balance of the account
552    */
553   function getBalance(ERC20Detailed _token, address _addr) internal view returns(uint256) {
554     if (address(_token) == address(ETH_TOKEN_ADDRESS)) {
555       return uint256(_addr.balance);
556     }
557     return uint256(_token.balanceOf(_addr));
558   }
559 
560   /**
561    * @notice Calculates the rate of a trade. The rate is the price of the source token in the dest token, in 18 decimals.
562    *         Note: the rate is on the token level, not the wei level, so for example if 1 Atoken = 10 Btoken, then the rate
563    *         from A to B is 10 * 10**18, regardless of how many decimals each token uses.
564    * @param srcAmount amount of source token
565    * @param destAmount amount of dest token
566    * @param srcDecimals decimals used by source token
567    * @param dstDecimals decimals used by dest token
568    */
569   function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
570         internal pure returns(uint)
571   {
572     require(srcAmount <= MAX_QTY);
573     require(destAmount <= MAX_QTY);
574 
575     if (dstDecimals >= srcDecimals) {
576       require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
577       return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
578     } else {
579       require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
580       return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
581     }
582   }
583 
584   /**
585    * @notice Wrapper function for doing token conversion on Kyber Network
586    * @param _srcToken the token to convert from
587    * @param _srcAmount the amount of tokens to be converted
588    * @param _destToken the destination token
589    * @return _destPriceInSrc the price of the dest token, in terms of source tokens
590    *         _srcPriceInDest the price of the source token, in terms of dest tokens
591    *         _actualDestAmount actual amount of dest token traded
592    *         _actualSrcAmount actual amount of src token traded
593    */
594   function __kyberTrade(ERC20Detailed _srcToken, uint256 _srcAmount, ERC20Detailed _destToken)
595     internal
596     returns(
597       uint256 _destPriceInSrc,
598       uint256 _srcPriceInDest,
599       uint256 _actualDestAmount,
600       uint256 _actualSrcAmount
601     )
602   {
603     require(_srcToken != _destToken);
604 
605     // Get current rate & ensure token is listed on Kyber
606     (, uint256 rate) = kyber.getExpectedRate(_srcToken, _destToken, _srcAmount);
607     require(rate > 0);
608 
609     uint256 beforeSrcBalance = getBalance(_srcToken, address(this));
610     uint256 msgValue;
611     if (_srcToken != ETH_TOKEN_ADDRESS) {
612       msgValue = 0;
613       _srcToken.safeApprove(KYBER_ADDR, 0);
614       _srcToken.safeApprove(KYBER_ADDR, _srcAmount);
615     } else {
616       msgValue = _srcAmount;
617     }
618     _actualDestAmount = kyber.tradeWithHint.value(msgValue)(
619       _srcToken,
620       _srcAmount,
621       _destToken,
622       toPayableAddr(address(this)),
623       MAX_QTY,
624       rate,
625       0x332D87209f7c8296389C307eAe170c2440830A47,
626       PERM_HINT
627     );
628     require(_actualDestAmount > 0);
629     if (_srcToken != ETH_TOKEN_ADDRESS) {
630       _srcToken.safeApprove(KYBER_ADDR, 0);
631     }
632 
633     _actualSrcAmount = beforeSrcBalance.sub(getBalance(_srcToken, address(this)));
634     _destPriceInSrc = calcRateFromQty(_actualDestAmount, _actualSrcAmount, getDecimals(_destToken), getDecimals(_srcToken));
635     _srcPriceInDest = calcRateFromQty(_actualSrcAmount, _actualDestAmount, getDecimals(_srcToken), getDecimals(_destToken));
636   }
637 
638   /**
639    * @notice Checks if an Ethereum account is a smart contract
640    * @param _addr the account to be checked
641    * @return True if the account is a smart contract, false otherwise
642    */
643   function isContract(address _addr) view internal returns(bool) {
644     uint size;
645     if (_addr == address(0)) return false;
646     assembly {
647         size := extcodesize(_addr)
648     }
649     return size>0;
650   }
651 
652   function toPayableAddr(address _addr) pure internal returns (address payable) {
653     return address(uint160(_addr));
654   }
655 }
656 
657 interface BetokenProxyInterface {
658   function betokenFundAddress() external view returns (address payable);
659   function updateBetokenFundAddress() external;
660 }
661 
662 /**
663  * @title The storage layout of BetokenFund
664  * @author Zefram Lou (Zebang Liu)
665  */
666 contract BetokenStorage is Ownable, ReentrancyGuard {
667   using SafeMath for uint256;
668 
669   enum CyclePhase { Intermission, Manage }
670   enum VoteDirection { Empty, For, Against }
671   enum Subchunk { Propose, Vote }
672 
673   struct Investment {
674     address tokenAddress;
675     uint256 cycleNumber;
676     uint256 stake;
677     uint256 tokenAmount;
678     uint256 buyPrice; // token buy price in 18 decimals in DAI
679     uint256 sellPrice; // token sell price in 18 decimals in DAI
680     uint256 buyTime;
681     uint256 buyCostInDAI;
682     bool isSold;
683   }
684 
685   // Fund parameters
686   uint256 public constant COMMISSION_RATE = 20 * (10 ** 16); // The proportion of profits that gets distributed to Kairo holders every cycle.
687   uint256 public constant ASSET_FEE_RATE = 1 * (10 ** 15); // The proportion of fund balance that gets distributed to Kairo holders every cycle.
688   uint256 public constant NEXT_PHASE_REWARD = 1 * (10 ** 18); // Amount of Kairo rewarded to the user who calls nextPhase().
689   uint256 public constant MAX_BUY_KRO_PROP = 1 * (10 ** 16); // max Kairo you can buy is 1% of total supply
690   uint256 public constant FALLBACK_MAX_DONATION = 100 * (10 ** 18); // If payment cap for registration is below 100 DAI, use 100 DAI instead
691   uint256 public constant MIN_KRO_PRICE = 25 * (10 ** 17); // 1 KRO >= 2.5 DAI
692   uint256 public constant COLLATERAL_RATIO_MODIFIER = 75 * (10 ** 16); // Modifies Compound's collateral ratio, gets 2:1 ratio from current 1.5:1 ratio
693   uint256 public constant MIN_RISK_TIME = 3 days; // Mininum risk taken to get full commissions is 9 days * kairoBalance
694   uint256 public constant INACTIVE_THRESHOLD = 6; // Number of inactive cycles after which a manager's Kairo balance can be burned
695   // Upgrade constants
696   uint256 public constant CHUNK_SIZE = 3 days;
697   uint256 public constant PROPOSE_SUBCHUNK_SIZE = 1 days;
698   uint256 public constant CYCLES_TILL_MATURITY = 3;
699   uint256 public constant QUORUM = 10 * (10 ** 16); // 10% quorum
700   uint256 public constant VOTE_SUCCESS_THRESHOLD = 75 * (10 ** 16); // Votes on upgrade candidates need >75% voting weight to pass
701 
702   // Instance variables
703 
704   // Checks if the token listing initialization has been completed.
705   bool public hasInitializedTokenListings;
706 
707   // Address of the Kairo token contract.
708   address public controlTokenAddr;
709 
710   // Address of the share token contract.
711   address public shareTokenAddr;
712 
713   // Address of the BetokenProxy contract.
714   address payable public proxyAddr;
715 
716   // Address of the CompoundOrderFactory contract.
717   address public compoundFactoryAddr;
718 
719   // Address of the BetokenLogic contract.
720   address public betokenLogic;
721 
722   // Address to which the development team funding will be sent.
723   address payable public devFundingAccount;
724 
725   // Address of the previous version of BetokenFund.
726   address payable public previousVersion;
727 
728   // The number of the current investment cycle.
729   uint256 public cycleNumber;
730 
731   // The amount of funds held by the fund.
732   uint256 public totalFundsInDAI;
733 
734   // The start time for the current investment cycle phase, in seconds since Unix epoch.
735   uint256 public startTimeOfCyclePhase;
736 
737   // The proportion of Betoken Shares total supply to mint and use for funding the development team. Fixed point decimal.
738   uint256 public devFundingRate;
739 
740   // Total amount of commission unclaimed by managers
741   uint256 public totalCommissionLeft;
742 
743   // Stores the lengths of each cycle phase in seconds.
744   uint256[2] public phaseLengths;
745 
746   // The last cycle where a user redeemed all of their remaining commission.
747   mapping(address => uint256) public lastCommissionRedemption;
748 
749   // Marks whether a manager has redeemed their commission for a certain cycle
750   mapping(address => mapping(uint256 => bool)) public hasRedeemedCommissionForCycle;
751 
752   // The stake-time measured risk that a manager has taken in a cycle
753   mapping(address => mapping(uint256 => uint256)) public riskTakenInCycle;
754 
755   // In case a manager joined the fund during the current cycle, set the fallback base stake for risk threshold calculation
756   mapping(address => uint256) public baseRiskStakeFallback;
757 
758   // List of investments of a manager in the current cycle.
759   mapping(address => Investment[]) public userInvestments;
760 
761   // List of short/long orders of a manager in the current cycle.
762   mapping(address => address payable[]) public userCompoundOrders;
763 
764   // Total commission to be paid for work done in a certain cycle (will be redeemed in the next cycle's Intermission)
765   mapping(uint256 => uint256) public totalCommissionOfCycle;
766 
767   // The block number at which the Manage phase ended for a given cycle
768   mapping(uint256 => uint256) public managePhaseEndBlock;
769 
770   // The last cycle where a manager made an investment
771   mapping(address => uint256) public lastActiveCycle;
772 
773   // Checks if an address points to a whitelisted Kyber token.
774   mapping(address => bool) public isKyberToken;
775 
776   // Checks if an address points to a whitelisted Compound token. Returns false for cDAI and other stablecoin CompoundTokens.
777   mapping(address => bool) public isCompoundToken;
778 
779   // Check if an address points to a whitelisted Fulcrum position token.
780   mapping(address => bool) public isPositionToken;
781 
782   // The current cycle phase.
783   CyclePhase public cyclePhase;
784 
785   // Upgrade governance related variables
786   bool public hasFinalizedNextVersion; // Denotes if the address of the next smart contract version has been finalized
787   bool public upgradeVotingActive; // Denotes if the vote for which contract to upgrade to is active
788   address payable public nextVersion; // Address of the next version of BetokenFund.
789   address[5] public proposers; // Manager who proposed the upgrade candidate in a chunk
790   address payable[5] public candidates; // Candidates for a chunk
791   uint256[5] public forVotes; // For votes for a chunk
792   uint256[5] public againstVotes; // Against votes for a chunk
793   uint256 public proposersVotingWeight; // Total voting weight of previous and current proposers. This is used for excluding the voting weight of proposers.
794   mapping(uint256 => mapping(address => VoteDirection[5])) public managerVotes; // Records each manager's vote
795   mapping(uint256 => uint256) public upgradeSignalStrength; // Denotes the amount of Kairo that's signalling in support of beginning the upgrade process during a cycle
796   mapping(uint256 => mapping(address => bool)) public upgradeSignal; // Maps manager address to whether they support initiating an upgrade
797 
798   // Contract instances
799   IMiniMeToken internal cToken;
800   IMiniMeToken internal sToken;
801   BetokenProxyInterface internal proxy;
802 
803   // Events
804 
805   event ChangedPhase(uint256 indexed _cycleNumber, uint256 indexed _newPhase, uint256 _timestamp, uint256 _totalFundsInDAI);
806 
807   event Deposit(uint256 indexed _cycleNumber, address indexed _sender, address _tokenAddress, uint256 _tokenAmount, uint256 _daiAmount, uint256 _timestamp);
808   event Withdraw(uint256 indexed _cycleNumber, address indexed _sender, address _tokenAddress, uint256 _tokenAmount, uint256 _daiAmount, uint256 _timestamp);
809 
810   event CreatedInvestment(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _tokenAddress, uint256 _stakeInWeis, uint256 _buyPrice, uint256 _costDAIAmount, uint256 _tokenAmount);
811   event SoldInvestment(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _tokenAddress, uint256 _receivedKairo, uint256 _sellPrice, uint256 _earnedDAIAmount);
812 
813   event CreatedCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order, bool _orderType, address _tokenAddress, uint256 _stakeInWeis, uint256 _costDAIAmount);
814   event SoldCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order,  bool _orderType, address _tokenAddress, uint256 _receivedKairo, uint256 _earnedDAIAmount);
815   event RepaidCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order, uint256 _repaidDAIAmount);
816 
817   event CommissionPaid(uint256 indexed _cycleNumber, address indexed _sender, uint256 _commission);
818   event TotalCommissionPaid(uint256 indexed _cycleNumber, uint256 _totalCommissionInDAI);
819 
820   event Register(address indexed _manager, uint256 _donationInDAI, uint256 _kairoReceived);
821   
822   event SignaledUpgrade(uint256 indexed _cycleNumber, address indexed _sender, bool indexed _inSupport);
823   event DeveloperInitiatedUpgrade(uint256 indexed _cycleNumber, address _candidate);
824   event InitiatedUpgrade(uint256 indexed _cycleNumber);
825   event ProposedCandidate(uint256 indexed _cycleNumber, uint256 indexed _voteID, address indexed _sender, address _candidate);
826   event Voted(uint256 indexed _cycleNumber, uint256 indexed _voteID, address indexed _sender, bool _inSupport, uint256 _weight);
827   event FinalizedNextVersion(uint256 indexed _cycleNumber, address _nextVersion);
828 
829   /*
830   Helper functions shared by both BetokenLogic & BetokenFund
831   */
832 
833   /**
834    * @notice The manage phase is divided into 9 3-day chunks. Determines which chunk the fund's in right now.
835    * @return The index of the current chunk (starts from 0). Returns 0 if not in Manage phase.
836    */
837   function currentChunk() public view returns (uint) {
838     if (cyclePhase != CyclePhase.Manage) {
839       return 0;
840     }
841     return (now - startTimeOfCyclePhase) / CHUNK_SIZE;
842   }
843 
844   /**
845    * @notice There are two subchunks in each chunk: propose (1 day) and vote (2 days).
846    *         Determines which subchunk the fund is in right now.
847    * @return The Subchunk the fund is in right now
848    */
849   function currentSubchunk() public view returns (Subchunk _subchunk) {
850     if (cyclePhase != CyclePhase.Manage) {
851       return Subchunk.Vote;
852     }
853     uint256 timeIntoCurrChunk = (now - startTimeOfCyclePhase) % CHUNK_SIZE;
854     return timeIntoCurrChunk < PROPOSE_SUBCHUNK_SIZE ? Subchunk.Propose : Subchunk.Vote;
855   }
856 
857   /**
858    * @notice Calculates an account's voting weight based on their Kairo balance
859    *         3 cycles ago
860    * @param _of the account to be queried
861    * @return The account's voting weight
862    */
863   function getVotingWeight(address _of) public view returns (uint256 _weight) {
864     if (cycleNumber <= CYCLES_TILL_MATURITY || _of == address(0)) {
865       return 0;
866     }
867     return cToken.balanceOfAt(_of, managePhaseEndBlock[cycleNumber.sub(CYCLES_TILL_MATURITY)]);
868   }
869 
870   /**
871    * @notice Calculates the total voting weight based on the total Kairo supply
872    *         3 cycles ago. The weights of proposers are deducted.
873    * @return The total voting weight right now
874    */
875   function getTotalVotingWeight() public view returns (uint256 _weight) {
876     if (cycleNumber <= CYCLES_TILL_MATURITY) {
877       return 0;
878     }
879     return cToken.totalSupplyAt(managePhaseEndBlock[cycleNumber.sub(CYCLES_TILL_MATURITY)]).sub(proposersVotingWeight);
880   }
881 
882   /**
883    * @notice Calculates the current price of Kairo. The price is equal to the amount of DAI each Kairo
884    *         can control, and it's kept above MIN_KRO_PRICE.
885    * @return Kairo's current price
886    */
887   function kairoPrice() public view returns (uint256 _kairoPrice) {
888     if (cToken.totalSupply() == 0) { return MIN_KRO_PRICE; }
889     uint256 controlPerKairo = totalFundsInDAI.mul(10 ** 18).div(cToken.totalSupply());
890     if (controlPerKairo < MIN_KRO_PRICE) {
891       // keep price above minimum price
892       return MIN_KRO_PRICE;
893     }
894     return controlPerKairo;
895   }
896 }
897 
898 // Compound finance comptroller
899 interface Comptroller {
900     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
901     function markets(address cToken) external view returns (bool isListed, uint256 collateralFactorMantissa);
902 }
903 
904 // Compound finance's price oracle
905 interface PriceOracle {
906   function getPrice(address asset) external view returns (uint);
907 }
908 
909 // Compound finance ERC20 market interface
910 interface CERC20 {
911   function mint(uint mintAmount) external returns (uint);
912   function redeemUnderlying(uint redeemAmount) external returns (uint);
913   function borrow(uint borrowAmount) external returns (uint);
914   function repayBorrow(uint repayAmount) external returns (uint);
915   function borrowBalanceCurrent(address account) external returns (uint);
916   function exchangeRateCurrent() external returns (uint);
917 
918   function balanceOf(address account) external view returns (uint);
919   function decimals() external view returns (uint);
920   function underlying() external view returns (address);
921 }
922 
923 contract CompoundOrderStorage is Ownable {
924   // Constants
925   uint256 internal constant NEGLIGIBLE_DEBT = 10 ** 14; // we don't care about debts below 10^-4 DAI (0.1 cent)
926   uint256 internal constant MAX_REPAY_STEPS = 3; // Max number of times we attempt to repay remaining debt
927 
928   // Contract instances
929   Comptroller public COMPTROLLER; // The Compound comptroller
930   PriceOracle public ORACLE; // The Compound price oracle
931   CERC20 public CDAI; // The Compound DAI market token
932   address public CETH_ADDR;
933 
934   // Instance variables
935   uint256 public stake;
936   uint256 public collateralAmountInDAI;
937   uint256 public loanAmountInDAI;
938   uint256 public cycleNumber;
939   uint256 public buyTime; // Timestamp for order execution
940   uint256 public outputAmount; // Records the total output DAI after order is sold
941   address public compoundTokenAddr;
942   bool public isSold;
943   bool public orderType; // True for shorting, false for longing
944 
945   // The contract containing the code to be executed
946   address public logicContract;
947 }
948 
949 contract CompoundOrder is CompoundOrderStorage, Utils {
950   constructor(
951     address _compoundTokenAddr,
952     uint256 _cycleNumber,
953     uint256 _stake,
954     uint256 _collateralAmountInDAI,
955     uint256 _loanAmountInDAI,
956     bool _orderType,
957     address _logicContract,
958     address _daiAddr,
959     address payable _kyberAddr,
960     address _comptrollerAddr,
961     address _priceOracleAddr,
962     address _cDAIAddr,
963     address _cETHAddr
964   ) public Utils(_daiAddr, _kyberAddr)  {
965     // Initialize details of short order
966     require(_compoundTokenAddr != _cDAIAddr);
967     require(_stake > 0 && _collateralAmountInDAI > 0 && _loanAmountInDAI > 0); // Validate inputs
968     stake = _stake;
969     collateralAmountInDAI = _collateralAmountInDAI;
970     loanAmountInDAI = _loanAmountInDAI;
971     cycleNumber = _cycleNumber;
972     compoundTokenAddr = _compoundTokenAddr;
973     orderType = _orderType;
974     logicContract = _logicContract;
975 
976     COMPTROLLER = Comptroller(_comptrollerAddr);
977     ORACLE = PriceOracle(_priceOracleAddr);
978     CDAI = CERC20(_cDAIAddr);
979     CETH_ADDR = _cETHAddr;
980   }
981   
982   /**
983    * @notice Executes the Compound order
984    * @param _minPrice the minimum token price
985    * @param _maxPrice the maximum token price
986    */
987   function executeOrder(uint256 _minPrice, uint256 _maxPrice) public {
988     (bool success,) = logicContract.delegatecall(abi.encodeWithSelector(this.executeOrder.selector, _minPrice, _maxPrice));
989     if (!success) { revert(); }
990   }
991 
992   /**
993    * @notice Sells the Compound order and returns assets to BetokenFund
994    * @param _minPrice the minimum token price
995    * @param _maxPrice the maximum token price
996    */
997   function sellOrder(uint256 _minPrice, uint256 _maxPrice) public returns (uint256 _inputAmount, uint256 _outputAmount) {
998     (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.sellOrder.selector, _minPrice, _maxPrice));
999     if (!success) { revert(); }
1000     return abi.decode(result, (uint256, uint256));
1001   }
1002 
1003   /**
1004    * @notice Repays the loans taken out to prevent the collateral ratio from dropping below threshold
1005    * @param _repayAmountInDAI the amount to repay, in DAI
1006    */
1007   function repayLoan(uint256 _repayAmountInDAI) public {
1008     (bool success,) = logicContract.delegatecall(abi.encodeWithSelector(this.repayLoan.selector, _repayAmountInDAI));
1009     if (!success) { revert(); }
1010   }
1011 
1012   /**
1013    * @notice Calculates the current liquidity (supply - collateral) on the Compound platform
1014    * @return the liquidity
1015    */
1016   function getCurrentLiquidityInDAI() public returns (bool _isNegative, uint256 _amount) {
1017     (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentLiquidityInDAI.selector));
1018     if (!success) { revert(); }
1019     return abi.decode(result, (bool, uint256));
1020   }
1021 
1022   /**
1023    * @notice Calculates the current collateral ratio on Compound, using 18 decimals
1024    * @return the collateral ratio
1025    */
1026   function getCurrentCollateralRatioInDAI() public returns (uint256 _amount) {
1027     (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentCollateralRatioInDAI.selector));
1028     if (!success) { revert(); }
1029     return abi.decode(result, (uint256));
1030   }
1031 
1032   /**
1033    * @notice Calculates the current profit in DAI
1034    * @return the profit amount
1035    */
1036   function getCurrentProfitInDAI() public returns (bool _isNegative, uint256 _amount) {
1037     (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentProfitInDAI.selector));
1038     if (!success) { revert(); }
1039     return abi.decode(result, (bool, uint256));
1040   }
1041 
1042   function getMarketCollateralFactor() public returns (uint256) {
1043     (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getMarketCollateralFactor.selector));
1044     if (!success) { revert(); }
1045     return abi.decode(result, (uint256));
1046   }
1047 
1048   function getCurrentCollateralInDAI() public returns (uint256 _amount) {
1049     (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentCollateralInDAI.selector));
1050     if (!success) { revert(); }
1051     return abi.decode(result, (uint256));
1052   }
1053 
1054   function getCurrentBorrowInDAI() public returns (uint256 _amount) {
1055     (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentBorrowInDAI.selector));
1056     if (!success) { revert(); }
1057     return abi.decode(result, (uint256));
1058   }
1059 
1060   function getCurrentCashInDAI() public returns (uint256 _amount) {
1061     (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentCashInDAI.selector));
1062     if (!success) { revert(); }
1063     return abi.decode(result, (uint256));
1064   }
1065 
1066   function() external payable {}
1067 }
1068 
1069 contract CompoundOrderFactory {
1070   address public SHORT_CERC20_LOGIC_CONTRACT;
1071   address public SHORT_CEther_LOGIC_CONTRACT;
1072   address public LONG_CERC20_LOGIC_CONTRACT;
1073   address public LONG_CEther_LOGIC_CONTRACT;
1074 
1075   address public DAI_ADDR;
1076   address payable public KYBER_ADDR;
1077   address public COMPTROLLER_ADDR;
1078   address public ORACLE_ADDR;
1079   address public CDAI_ADDR;
1080   address public CETH_ADDR;
1081 
1082   constructor(
1083     address _shortCERC20LogicContract,
1084     address _shortCEtherLogicContract,
1085     address _longCERC20LogicContract,
1086     address _longCEtherLogicContract,
1087     address _daiAddr,
1088     address payable _kyberAddr,
1089     address _comptrollerAddr,
1090     address _priceOracleAddr,
1091     address _cDAIAddr,
1092     address _cETHAddr
1093   ) public {
1094     SHORT_CERC20_LOGIC_CONTRACT = _shortCERC20LogicContract;
1095     SHORT_CEther_LOGIC_CONTRACT = _shortCEtherLogicContract;
1096     LONG_CERC20_LOGIC_CONTRACT = _longCERC20LogicContract;
1097     LONG_CEther_LOGIC_CONTRACT = _longCEtherLogicContract;
1098 
1099     DAI_ADDR = _daiAddr;
1100     KYBER_ADDR = _kyberAddr;
1101     COMPTROLLER_ADDR = _comptrollerAddr;
1102     ORACLE_ADDR = _priceOracleAddr;
1103     CDAI_ADDR = _cDAIAddr;
1104     CETH_ADDR = _cETHAddr;
1105   }
1106 
1107   function createOrder(
1108     address _compoundTokenAddr,
1109     uint256 _cycleNumber,
1110     uint256 _stake,
1111     uint256 _collateralAmountInDAI,
1112     uint256 _loanAmountInDAI,
1113     bool _orderType
1114   ) public returns (CompoundOrder) {
1115     require(_compoundTokenAddr != address(0));
1116 
1117     CompoundOrder order;
1118     address logicContract;
1119 
1120     if (_compoundTokenAddr != CETH_ADDR) {
1121       logicContract = _orderType ? SHORT_CERC20_LOGIC_CONTRACT : LONG_CERC20_LOGIC_CONTRACT;
1122     } else {
1123       logicContract = _orderType ? SHORT_CEther_LOGIC_CONTRACT : LONG_CEther_LOGIC_CONTRACT;
1124     }
1125     order = new CompoundOrder(_compoundTokenAddr, _cycleNumber, _stake, _collateralAmountInDAI, _loanAmountInDAI, _orderType, logicContract, DAI_ADDR, KYBER_ADDR, COMPTROLLER_ADDR, ORACLE_ADDR, CDAI_ADDR, CETH_ADDR);
1126     order.transferOwnership(msg.sender);
1127     return order;
1128   }
1129 
1130   function getMarketCollateralFactor(address _compoundTokenAddr) public view returns (uint256) {
1131     Comptroller troll = Comptroller(COMPTROLLER_ADDR);
1132     (, uint256 factor) = troll.markets(_compoundTokenAddr);
1133     return factor;
1134   }
1135 }
1136 
1137 /**
1138  * @title The main smart contract of the Betoken hedge fund.
1139  * @author Zefram Lou (Zebang Liu)
1140  */
1141 contract BetokenFund is BetokenStorage, Utils, TokenController {
1142   /**
1143    * @notice Executes function only during the given cycle phase.
1144    * @param phase the cycle phase during which the function may be called
1145    */
1146   modifier during(CyclePhase phase) {
1147     require(cyclePhase == phase);
1148     _;
1149   }
1150 
1151   /**
1152    * @notice Passes if the fund is ready for migrating to the next version
1153    */
1154   modifier readyForUpgradeMigration {
1155     require(hasFinalizedNextVersion == true);
1156     require(now > startTimeOfCyclePhase.add(phaseLengths[uint(CyclePhase.Intermission)]));
1157     _;
1158   }
1159 
1160   /**
1161    * @notice Passes if the fund has not finalized the next smart contract to upgrade to
1162    */
1163   modifier notReadyForUpgrade {
1164     require(hasFinalizedNextVersion == false);
1165     _;
1166   }
1167 
1168   /**
1169    * Meta functions
1170    */
1171 
1172   constructor(
1173     address payable _kroAddr,
1174     address payable _sTokenAddr,
1175     address payable _devFundingAccount,
1176     uint256[2] memory _phaseLengths,
1177     uint256 _devFundingRate,
1178     address payable _previousVersion,
1179     address _daiAddr,
1180     address payable _kyberAddr,
1181     address _compoundFactoryAddr,
1182     address _betokenLogic
1183   )
1184     public
1185     Utils(_daiAddr, _kyberAddr)
1186   {
1187     controlTokenAddr = _kroAddr;
1188     shareTokenAddr = _sTokenAddr;
1189     devFundingAccount = _devFundingAccount;
1190     phaseLengths = _phaseLengths;
1191     devFundingRate = _devFundingRate;
1192     cyclePhase = CyclePhase.Manage;
1193     compoundFactoryAddr = _compoundFactoryAddr;
1194     betokenLogic = _betokenLogic;
1195     previousVersion = _previousVersion;
1196 
1197     cToken = IMiniMeToken(_kroAddr);
1198     sToken = IMiniMeToken(_sTokenAddr);
1199   }
1200 
1201   function initTokenListings(
1202     address[] memory _kyberTokens,
1203     address[] memory _compoundTokens,
1204     address[] memory _positionTokens
1205   )
1206     public
1207     onlyOwner
1208   {
1209     // May only initialize once
1210     require(!hasInitializedTokenListings);
1211     hasInitializedTokenListings = true;
1212 
1213     uint256 i;
1214     for (i = 0; i < _kyberTokens.length; i = i.add(1)) {
1215       isKyberToken[_kyberTokens[i]] = true;
1216     }
1217 
1218     for (i = 0; i < _compoundTokens.length; i = i.add(1)) {
1219       isCompoundToken[_compoundTokens[i]] = true;
1220     }
1221 
1222     for (i = 0; i < _positionTokens.length; i = i.add(1)) {
1223       isPositionToken[_positionTokens[i]] = true;
1224     }
1225   }
1226 
1227   /**
1228    * @notice Used during deployment to set the BetokenProxy contract address.
1229    * @param _proxyAddr the proxy's address
1230    */
1231   function setProxy(address payable _proxyAddr) public onlyOwner {
1232     require(_proxyAddr != address(0));
1233     require(proxyAddr == address(0));
1234     proxyAddr = _proxyAddr;
1235     proxy = BetokenProxyInterface(_proxyAddr);
1236   }
1237 
1238   /**
1239    * Upgrading functions
1240    */
1241 
1242   /**
1243    * @notice Allows the developer to propose a candidate smart contract for the fund to upgrade to.
1244    *          The developer may change the candidate during the Intermission phase.
1245    * @param _candidate the address of the candidate smart contract
1246    * @return True if successfully changed candidate, false otherwise.
1247    */
1248   function developerInitiateUpgrade(address payable _candidate) public during(CyclePhase.Intermission) onlyOwner notReadyForUpgrade returns (bool _success) {
1249     (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.developerInitiateUpgrade.selector, _candidate));
1250     if (!success) { return false; }
1251     return abi.decode(result, (bool));
1252   }
1253 
1254   /**
1255    * @notice Allows a manager to signal their support of initiating an upgrade. They can change their signal before the end of the Intermission phase.
1256    *          Managers who oppose initiating an upgrade don't need to call this function, unless they origianlly signalled in support.
1257    *          Signals are reset every cycle.
1258    * @param _inSupport True if the manager supports initiating upgrade, false if the manager opposes it.
1259    * @return True if successfully changed signal, false if no changes were made.
1260    */
1261   function signalUpgrade(bool _inSupport) public during(CyclePhase.Intermission) notReadyForUpgrade returns (bool _success) {
1262     (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.signalUpgrade.selector, _inSupport));
1263     if (!success) { return false; }
1264     return abi.decode(result, (bool));
1265   }
1266 
1267   /**
1268    * @notice Allows manager to propose a candidate smart contract for the fund to upgrade to. Among the managers who have proposed a candidate,
1269    *          the manager with the most voting weight's candidate will be used in the vote. Ties are broken in favor of the larger address.
1270    *          The proposer may change the candidate they support during the Propose subchunk in their chunk.
1271    * @param _chunkNumber the chunk for which the sender is proposing the candidate
1272    * @param _candidate the address of the candidate smart contract
1273    * @return True if successfully proposed/changed candidate, false otherwise.
1274    */
1275   function proposeCandidate(uint256 _chunkNumber, address payable _candidate) public during(CyclePhase.Manage) notReadyForUpgrade returns (bool _success) {
1276     (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.proposeCandidate.selector, _chunkNumber, _candidate));
1277     if (!success) { return false; }
1278     return abi.decode(result, (bool));
1279   }
1280 
1281   /**
1282    * @notice Allows a manager to vote for or against a candidate smart contract the fund will upgrade to. The manager may change their vote during
1283    *          the Vote subchunk. A manager who has been a proposer may not vote.
1284    * @param _inSupport True if the manager supports initiating upgrade, false if the manager opposes it.
1285    * @return True if successfully changed vote, false otherwise.
1286    */
1287   function voteOnCandidate(uint256 _chunkNumber, bool _inSupport) public during(CyclePhase.Manage) notReadyForUpgrade returns (bool _success) {
1288     (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.voteOnCandidate.selector, _chunkNumber, _inSupport));
1289     if (!success) { return false; }
1290     return abi.decode(result, (bool));
1291   }
1292 
1293   /**
1294    * @notice Performs the necessary state changes after a successful vote
1295    * @param _chunkNumber the chunk number of the successful vote
1296    * @return True if successful, false otherwise
1297    */
1298   function finalizeSuccessfulVote(uint256 _chunkNumber) public during(CyclePhase.Manage) notReadyForUpgrade returns (bool _success) {
1299     (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.finalizeSuccessfulVote.selector, _chunkNumber));
1300     if (!success) { return false; }
1301     return abi.decode(result, (bool));
1302   }
1303 
1304   /**
1305    * @notice Transfers ownership of Kairo & Share token contracts to the next version. Also updates BetokenFund's
1306    *         address in BetokenProxy.
1307    */
1308   function migrateOwnedContractsToNextVersion() public nonReentrant readyForUpgradeMigration {
1309     cToken.transferOwnership(nextVersion);
1310     sToken.transferOwnership(nextVersion);
1311     proxy.updateBetokenFundAddress();
1312   }
1313 
1314   /**
1315    * @notice Transfers assets to the next version.
1316    * @param _assetAddress the address of the asset to be transferred. Use ETH_TOKEN_ADDRESS to transfer Ether.
1317    */
1318   function transferAssetToNextVersion(address _assetAddress) public nonReentrant readyForUpgradeMigration isValidToken(_assetAddress) {
1319     if (_assetAddress == address(ETH_TOKEN_ADDRESS)) {
1320       nextVersion.transfer(address(this).balance);
1321     } else {
1322       ERC20Detailed token = ERC20Detailed(_assetAddress);
1323       token.safeTransfer(nextVersion, token.balanceOf(address(this)));
1324     }
1325   }
1326 
1327   /**
1328    * Getters
1329    */
1330 
1331   /**
1332    * @notice Returns the length of the user's investments array.
1333    * @return length of the user's investments array
1334    */
1335   function investmentsCount(address _userAddr) public view returns(uint256 _count) {
1336     return userInvestments[_userAddr].length;
1337   }
1338 
1339   /**
1340    * @notice Returns the length of the user's compound orders array.
1341    * @return length of the user's compound orders array
1342    */
1343   function compoundOrdersCount(address _userAddr) public view returns(uint256 _count) {
1344     return userCompoundOrders[_userAddr].length;
1345   }
1346 
1347   /**
1348    * @notice Returns the phaseLengths array.
1349    * @return the phaseLengths array
1350    */
1351   function getPhaseLengths() public view returns(uint256[2] memory _phaseLengths) {
1352     return phaseLengths;
1353   }
1354 
1355   /**
1356    * @notice Returns the commission balance of `_manager`
1357    * @return the commission balance and the received penalty, denoted in DAI
1358    */
1359   function commissionBalanceOf(address _manager) public view returns (uint256 _commission, uint256 _penalty) {
1360     if (lastCommissionRedemption[_manager] >= cycleNumber) { return (0, 0); }
1361     uint256 cycle = lastCommissionRedemption[_manager] > 0 ? lastCommissionRedemption[_manager] : 1;
1362     uint256 cycleCommission;
1363     uint256 cyclePenalty;
1364     for (; cycle < cycleNumber; cycle = cycle.add(1)) {
1365       (cycleCommission, cyclePenalty) = commissionOfAt(_manager, cycle);
1366       _commission = _commission.add(cycleCommission);
1367       _penalty = _penalty.add(cyclePenalty);
1368     }
1369   }
1370 
1371   /**
1372    * @notice Returns the commission amount received by `_manager` in the `_cycle`th cycle
1373    * @return the commission amount and the received penalty, denoted in DAI
1374    */
1375   function commissionOfAt(address _manager, uint256 _cycle) public view returns (uint256 _commission, uint256 _penalty) {
1376     if (hasRedeemedCommissionForCycle[_manager][_cycle]) { return (0, 0); }
1377     // take risk into account
1378     uint256 baseKairoBalance = cToken.balanceOfAt(_manager, managePhaseEndBlock[_cycle.sub(1)]);
1379     uint256 baseStake = baseKairoBalance == 0 ? baseRiskStakeFallback[_manager] : baseKairoBalance;
1380     if (baseKairoBalance == 0 && baseRiskStakeFallback[_manager] == 0) { return (0, 0); }
1381     uint256 riskTakenProportion = riskTakenInCycle[_manager][_cycle].mul(PRECISION).div(baseStake.mul(MIN_RISK_TIME)); // risk / threshold
1382     riskTakenProportion = riskTakenProportion > PRECISION ? PRECISION : riskTakenProportion; // max proportion is 1
1383 
1384     uint256 fullCommission = totalCommissionOfCycle[_cycle].mul(cToken.balanceOfAt(_manager, managePhaseEndBlock[_cycle]))
1385       .div(cToken.totalSupplyAt(managePhaseEndBlock[_cycle]));
1386 
1387     _commission = fullCommission.mul(riskTakenProportion).div(PRECISION);
1388     _penalty = fullCommission.sub(_commission);
1389   }
1390 
1391   /**
1392    * Parameter setters
1393    */
1394 
1395   /**
1396    * @notice Changes the address to which the developer fees will be sent. Only callable by owner.
1397    * @param _newAddr the new developer fee address
1398    */
1399   function changeDeveloperFeeAccount(address payable _newAddr) public onlyOwner {
1400     require(_newAddr != address(0) && _newAddr != address(this));
1401     devFundingAccount = _newAddr;
1402   }
1403 
1404   /**
1405    * @notice Changes the proportion of fund balance sent to the developers each cycle. May only decrease. Only callable by owner.
1406    * @param _newProp the new proportion, fixed point decimal
1407    */
1408   function changeDeveloperFeeRate(uint256 _newProp) public onlyOwner {
1409     require(_newProp < PRECISION);
1410     require(_newProp < devFundingRate);
1411     devFundingRate = _newProp;
1412   }
1413 
1414   /**
1415    * @notice Allows managers to invest in a token. Only callable by owner.
1416    * @param _token address of the token to be listed
1417    */
1418   function listKyberToken(address _token) public onlyOwner {
1419     isKyberToken[_token] = true;
1420   }
1421 
1422   /**
1423    * @notice Moves the fund to the next phase in the investment cycle.
1424    */
1425   function nextPhase()
1426     public
1427   {
1428     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.nextPhase.selector));
1429     if (!success) { revert(); }
1430   }
1431 
1432 
1433   /**
1434    * Manager registration
1435    */
1436 
1437   /**
1438    * @notice Registers `msg.sender` as a manager, using DAI as payment. The more one pays, the more Kairo one gets.
1439    *         There's a max Kairo amount that can be bought, and excess payment will be sent back to sender.
1440    * @param _donationInDAI the amount of DAI to be used for registration
1441    */
1442   function registerWithDAI(uint256 _donationInDAI) public nonReentrant {
1443     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.registerWithDAI.selector, _donationInDAI));
1444     if (!success) { revert(); }
1445   }
1446 
1447   /**
1448    * @notice Registers `msg.sender` as a manager, using ETH as payment. The more one pays, the more Kairo one gets.
1449    *         There's a max Kairo amount that can be bought, and excess payment will be sent back to sender.
1450    */
1451   function registerWithETH() public payable nonReentrant {
1452     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.registerWithETH.selector));
1453     if (!success) { revert(); }
1454   }
1455 
1456   /**
1457    * @notice Registers `msg.sender` as a manager, using tokens as payment. The more one pays, the more Kairo one gets.
1458    *         There's a max Kairo amount that can be bought, and excess payment will be sent back to sender.
1459    * @param _token the token to be used for payment
1460    * @param _donationInTokens the amount of tokens to be used for registration, should use the token's native decimals
1461    */
1462   function registerWithToken(address _token, uint256 _donationInTokens) public nonReentrant {
1463     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.registerWithToken.selector, _token, _donationInTokens));
1464     if (!success) { revert(); }
1465   }
1466 
1467 
1468   /**
1469    * Intermission phase functions
1470    */
1471 
1472    /**
1473    * @notice Deposit Ether into the fund. Ether will be converted into DAI.
1474    */
1475   function depositEther()
1476     public
1477     payable
1478     during(CyclePhase.Intermission)
1479     nonReentrant
1480     notReadyForUpgrade
1481   {
1482     // Buy DAI with ETH
1483     uint256 actualDAIDeposited;
1484     uint256 actualETHDeposited;
1485     (,, actualDAIDeposited, actualETHDeposited) = __kyberTrade(ETH_TOKEN_ADDRESS, msg.value, dai);
1486 
1487     // Send back leftover ETH
1488     uint256 leftOverETH = msg.value.sub(actualETHDeposited);
1489     if (leftOverETH > 0) {
1490       msg.sender.transfer(leftOverETH);
1491     }
1492 
1493     // Register investment
1494     __deposit(actualDAIDeposited);
1495 
1496     // Emit event
1497     emit Deposit(cycleNumber, msg.sender, address(ETH_TOKEN_ADDRESS), actualETHDeposited, actualDAIDeposited, now);
1498   }
1499 
1500   /**
1501    * @notice Deposit DAI Stablecoin into the fund.
1502    * @param _daiAmount The amount of DAI to be deposited. May be different from actual deposited amount.
1503    */
1504   function depositDAI(uint256 _daiAmount)
1505     public
1506     during(CyclePhase.Intermission)
1507     nonReentrant
1508     notReadyForUpgrade
1509   {
1510     dai.safeTransferFrom(msg.sender, address(this), _daiAmount);
1511 
1512     // Register investment
1513     __deposit(_daiAmount);
1514 
1515     // Emit event
1516     emit Deposit(cycleNumber, msg.sender, DAI_ADDR, _daiAmount, _daiAmount, now);
1517   }
1518 
1519   /**
1520    * @notice Deposit ERC20 tokens into the fund. Tokens will be converted into DAI.
1521    * @param _tokenAddr the address of the token to be deposited
1522    * @param _tokenAmount The amount of tokens to be deposited. May be different from actual deposited amount.
1523    */
1524   function depositToken(address _tokenAddr, uint256 _tokenAmount)
1525     public
1526     nonReentrant
1527     during(CyclePhase.Intermission)
1528     isValidToken(_tokenAddr)  
1529     notReadyForUpgrade
1530   {
1531     require(_tokenAddr != DAI_ADDR && _tokenAddr != address(ETH_TOKEN_ADDRESS));
1532 
1533     ERC20Detailed token = ERC20Detailed(_tokenAddr);
1534 
1535     token.safeTransferFrom(msg.sender, address(this), _tokenAmount);
1536 
1537     // Convert token into DAI
1538     uint256 actualDAIDeposited;
1539     uint256 actualTokenDeposited;
1540     (,, actualDAIDeposited, actualTokenDeposited) = __kyberTrade(token, _tokenAmount, dai);
1541 
1542     // Give back leftover tokens
1543     uint256 leftOverTokens = _tokenAmount.sub(actualTokenDeposited);
1544     if (leftOverTokens > 0) {
1545       token.safeTransfer(msg.sender, leftOverTokens);
1546     }
1547 
1548     // Register investment
1549     __deposit(actualDAIDeposited);
1550 
1551     // Emit event
1552     emit Deposit(cycleNumber, msg.sender, _tokenAddr, actualTokenDeposited, actualDAIDeposited, now);
1553   }
1554 
1555 
1556   /**
1557    * @notice Withdraws Ether by burning Shares.
1558    * @param _amountInDAI Amount of funds to be withdrawn expressed in DAI. Fixed-point decimal. May be different from actual amount.
1559    */
1560   function withdrawEther(uint256 _amountInDAI)
1561     public
1562     during(CyclePhase.Intermission)
1563     nonReentrant
1564   {
1565     // Buy ETH
1566     uint256 actualETHWithdrawn;
1567     uint256 actualDAIWithdrawn;
1568     (,, actualETHWithdrawn, actualDAIWithdrawn) = __kyberTrade(dai, _amountInDAI, ETH_TOKEN_ADDRESS);
1569 
1570     __withdraw(actualDAIWithdrawn);
1571 
1572     // Transfer Ether to user
1573     msg.sender.transfer(actualETHWithdrawn);
1574 
1575     // Emit event
1576     emit Withdraw(cycleNumber, msg.sender, address(ETH_TOKEN_ADDRESS), actualETHWithdrawn, actualDAIWithdrawn, now);
1577   }
1578 
1579   /**
1580    * @notice Withdraws Ether by burning Shares.
1581    * @param _amountInDAI Amount of funds to be withdrawn expressed in DAI. Fixed-point decimal. May be different from actual amount.
1582    */
1583   function withdrawDAI(uint256 _amountInDAI)
1584     public
1585     during(CyclePhase.Intermission)
1586     nonReentrant
1587   {
1588     __withdraw(_amountInDAI);
1589 
1590     // Transfer DAI to user
1591     dai.safeTransfer(msg.sender, _amountInDAI);
1592 
1593     // Emit event
1594     emit Withdraw(cycleNumber, msg.sender, DAI_ADDR, _amountInDAI, _amountInDAI, now);
1595   }
1596 
1597   /**
1598    * @notice Withdraws funds by burning Shares, and converts the funds into the specified token using Kyber Network.
1599    * @param _tokenAddr the address of the token to be withdrawn into the caller's account
1600    * @param _amountInDAI The amount of funds to be withdrawn expressed in DAI. Fixed-point decimal. May be different from actual amount.
1601    */
1602   function withdrawToken(address _tokenAddr, uint256 _amountInDAI)
1603     public
1604     nonReentrant
1605     during(CyclePhase.Intermission)
1606     isValidToken(_tokenAddr)
1607   {
1608     require(_tokenAddr != DAI_ADDR && _tokenAddr != address(ETH_TOKEN_ADDRESS));
1609 
1610     ERC20Detailed token = ERC20Detailed(_tokenAddr);
1611 
1612     // Convert DAI into desired tokens
1613     uint256 actualTokenWithdrawn;
1614     uint256 actualDAIWithdrawn;
1615     (,, actualTokenWithdrawn, actualDAIWithdrawn) = __kyberTrade(dai, _amountInDAI, token);
1616 
1617     __withdraw(actualDAIWithdrawn);
1618 
1619     // Transfer tokens to user
1620     token.safeTransfer(msg.sender, actualTokenWithdrawn);
1621 
1622     // Emit event
1623     emit Withdraw(cycleNumber, msg.sender, _tokenAddr, actualTokenWithdrawn, actualDAIWithdrawn, now);
1624   }
1625 
1626   /**
1627    * @notice Redeems commission.
1628    */
1629   function redeemCommission(bool _inShares)
1630     public
1631     during(CyclePhase.Intermission)
1632     nonReentrant
1633   {
1634     uint256 commission = __redeemCommission();
1635 
1636     if (_inShares) {
1637       // Deposit commission into fund
1638       __deposit(commission);
1639 
1640       // Emit deposit event
1641       emit Deposit(cycleNumber, msg.sender, DAI_ADDR, commission, commission, now);
1642     } else {
1643       // Transfer the commission in DAI
1644       dai.safeTransfer(msg.sender, commission);
1645     }
1646   }
1647 
1648   /**
1649    * @notice Redeems commission for a particular cycle.
1650    * @param _inShares true to redeem in Betoken Shares, false to redeem in DAI
1651    * @param _cycle the cycle for which the commission will be redeemed.
1652    *        Commissions for a cycle will be redeemed during the Intermission phase of the next cycle, so _cycle must < cycleNumber.
1653    */
1654   function redeemCommissionForCycle(bool _inShares, uint256 _cycle)
1655     public
1656     during(CyclePhase.Intermission)
1657     nonReentrant
1658   {
1659     require(_cycle < cycleNumber);
1660 
1661     uint256 commission = __redeemCommissionForCycle(_cycle);
1662 
1663     if (_inShares) {
1664       // Deposit commission into fund
1665       __deposit(commission);
1666 
1667       // Emit deposit event
1668       emit Deposit(cycleNumber, msg.sender, DAI_ADDR, commission, commission, now);
1669     } else {
1670       // Transfer the commission in DAI
1671       dai.safeTransfer(msg.sender, commission);
1672     }
1673   }
1674 
1675   /**
1676    * @notice Sells tokens left over due to manager not selling or KyberNetwork not having enough volume. Callable by anyone. Money goes to developer.
1677    * @param _tokenAddr address of the token to be sold
1678    */
1679   function sellLeftoverToken(address _tokenAddr)
1680     public
1681     nonReentrant
1682     during(CyclePhase.Intermission)
1683     isValidToken(_tokenAddr)
1684   {
1685     ERC20Detailed token = ERC20Detailed(_tokenAddr);
1686     (,,uint256 actualDAIReceived,) = __kyberTrade(token, getBalance(token, address(this)), dai);
1687     totalFundsInDAI = totalFundsInDAI.add(actualDAIReceived);
1688   }
1689 
1690   /**
1691    * @notice Sells CompoundOrder left over due to manager not selling or KyberNetwork not having enough volume. Callable by anyone. Money goes to developer.
1692    * @param _orderAddress address of the CompoundOrder to be sold
1693    */
1694   function sellLeftoverCompoundOrder(address payable _orderAddress)
1695     public
1696     nonReentrant
1697     during(CyclePhase.Intermission)
1698   {
1699     // Load order info
1700     require(_orderAddress != address(0));
1701     CompoundOrder order = CompoundOrder(_orderAddress);
1702     require(order.isSold() == false && order.cycleNumber() < cycleNumber);
1703 
1704     // Sell short order
1705     // Not using outputAmount returned by order.sellOrder() because _orderAddress could point to a malicious contract
1706     uint256 beforeDAIBalance = dai.balanceOf(address(this));
1707     order.sellOrder(0, MAX_QTY);
1708     uint256 actualDAIReceived = dai.balanceOf(address(this)).sub(beforeDAIBalance);
1709 
1710     totalFundsInDAI = totalFundsInDAI.add(actualDAIReceived);
1711   }
1712 
1713   /**
1714    * @notice Burns the Kairo balance of a manager who has been inactive for a certain number of cycles
1715    * @param _deadman the manager whose Kairo balance will be burned
1716    */
1717   function burnDeadman(address _deadman)
1718     public
1719     nonReentrant
1720     during(CyclePhase.Intermission)
1721   {
1722     require(_deadman != address(this));
1723     require(cycleNumber.sub(lastActiveCycle[_deadman]) >= INACTIVE_THRESHOLD);
1724     require(cToken.destroyTokens(_deadman, cToken.balanceOf(_deadman)));
1725   }
1726 
1727   /**
1728    * Manage phase functions
1729    */
1730 
1731   /**
1732    * @notice Creates a new investment for an ERC20 token.
1733    * @param _tokenAddress address of the ERC20 token contract
1734    * @param _stake amount of Kairos to be staked in support of the investment
1735    * @param _minPrice the minimum price for the trade
1736    * @param _maxPrice the maximum price for the trade
1737    */
1738   function createInvestment(
1739     address _tokenAddress,
1740     uint256 _stake,
1741     uint256 _minPrice,
1742     uint256 _maxPrice
1743   )
1744     public
1745     nonReentrant
1746     isValidToken(_tokenAddress)
1747     during(CyclePhase.Manage)
1748   {
1749     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.createInvestment.selector, _tokenAddress, _stake, _minPrice, _maxPrice));
1750     if (!success) { revert(); }
1751   }
1752 
1753   /**
1754    * @notice Called by user to sell the assets an investment invested in. Returns the staked Kairo plus rewards/penalties to the user.
1755    *         The user can sell only part of the investment by changing _tokenAmount.
1756    * @dev When selling only part of an investment, the old investment would be "fully" sold and a new investment would be created with
1757    *   the original buy price and however much tokens that are not sold.
1758    * @param _investmentId the ID of the investment
1759    * @param _tokenAmount the amount of tokens to be sold.
1760    * @param _minPrice the minimum price for the trade
1761    * @param _maxPrice the maximum price for the trade
1762    */
1763   function sellInvestmentAsset(
1764     uint256 _investmentId,
1765     uint256 _tokenAmount,
1766     uint256 _minPrice,
1767     uint256 _maxPrice
1768   )
1769     public
1770     during(CyclePhase.Manage)
1771     nonReentrant
1772   {
1773     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.sellInvestmentAsset.selector, _investmentId, _tokenAmount, _minPrice, _maxPrice));
1774     if (!success) { revert(); }
1775   }
1776 
1777   /**
1778    * @notice Creates a new Compound order to either short or leverage long a token.
1779    * @param _orderType true for a short order, false for a levarage long order
1780    * @param _tokenAddress address of the Compound token to be traded
1781    * @param _stake amount of Kairos to be staked
1782    * @param _minPrice the minimum token price for the trade
1783    * @param _maxPrice the maximum token price for the trade
1784    */
1785   function createCompoundOrder(
1786     bool _orderType,
1787     address _tokenAddress,
1788     uint256 _stake,
1789     uint256 _minPrice,
1790     uint256 _maxPrice
1791   )
1792     public
1793     nonReentrant
1794     during(CyclePhase.Manage)
1795     isValidToken(_tokenAddress)
1796   {
1797     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.createCompoundOrder.selector, _orderType, _tokenAddress, _stake, _minPrice, _maxPrice));
1798     if (!success) { revert(); }
1799   }
1800 
1801   /**
1802    * @notice Sells a compound order
1803    * @param _orderId the ID of the order to be sold (index in userCompoundOrders[msg.sender])
1804    * @param _minPrice the minimum token price for the trade
1805    * @param _maxPrice the maximum token price for the trade
1806    */
1807   function sellCompoundOrder(
1808     uint256 _orderId,
1809     uint256 _minPrice,
1810     uint256 _maxPrice
1811   )
1812     public
1813     during(CyclePhase.Manage)
1814     nonReentrant
1815   {
1816     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.sellCompoundOrder.selector, _orderId, _minPrice, _maxPrice));
1817     if (!success) { revert(); }
1818   }
1819 
1820   /**
1821    * @notice Repys debt for a Compound order to prevent the collateral ratio from dropping below threshold.
1822    * @param _orderId the ID of the Compound order
1823    * @param _repayAmountInDAI amount of DAI to use for repaying debt
1824    */
1825   function repayCompoundOrder(uint256 _orderId, uint256 _repayAmountInDAI) public during(CyclePhase.Manage) nonReentrant {
1826     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.repayCompoundOrder.selector, _orderId, _repayAmountInDAI));
1827     if (!success) { revert(); }
1828   }
1829 
1830   /**
1831    * Internal use functions
1832    */
1833 
1834   // MiniMe TokenController functions, not used right now
1835   /**
1836    * @notice Called when `_owner` sends ether to the MiniMe Token contract
1837    * @param _owner The address that sent the ether to create tokens
1838    * @return True if the ether is accepted, false if it throws
1839    */
1840   function proxyPayment(address _owner) public payable returns(bool) {
1841     return false;
1842   }
1843 
1844   /**
1845    * @notice Notifies the controller about a token transfer allowing the
1846    *  controller to react if desired
1847    * @param _from The origin of the transfer
1848    * @param _to The destination of the transfer
1849    * @param _amount The amount of the transfer
1850    * @return False if the controller does not authorize the transfer
1851    */
1852   function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
1853     return true;
1854   }
1855 
1856   /**
1857    * @notice Notifies the controller about an approval allowing the
1858    *  controller to react if desired
1859    * @param _owner The address that calls `approve()`
1860    * @param _spender The spender in the `approve()` call
1861    * @param _amount The amount in the `approve()` call
1862    * @return False if the controller does not authorize the approval
1863    */
1864   function onApprove(address _owner, address _spender, uint _amount) public
1865       returns(bool) {
1866     return true;
1867   }
1868 
1869   /**
1870    * @notice Handles deposits by minting Betoken Shares & updating total funds.
1871    * @param _depositDAIAmount The amount of the deposit in DAI
1872    */
1873   function __deposit(uint256 _depositDAIAmount) internal {
1874     // Register investment and give shares
1875     if (sToken.totalSupply() == 0 || totalFundsInDAI == 0) {
1876       require(sToken.generateTokens(msg.sender, _depositDAIAmount));
1877     } else {
1878       require(sToken.generateTokens(msg.sender, _depositDAIAmount.mul(sToken.totalSupply()).div(totalFundsInDAI)));
1879     }
1880     totalFundsInDAI = totalFundsInDAI.add(_depositDAIAmount);
1881   }
1882 
1883   /**
1884    * @notice Handles deposits by burning Betoken Shares & updating total funds.
1885    * @param _withdrawDAIAmount The amount of the withdrawal in DAI
1886    */
1887   function __withdraw(uint256 _withdrawDAIAmount) internal {
1888     // Burn Shares
1889     require(sToken.destroyTokens(msg.sender, _withdrawDAIAmount.mul(sToken.totalSupply()).div(totalFundsInDAI)));
1890     totalFundsInDAI = totalFundsInDAI.sub(_withdrawDAIAmount);
1891   }
1892 
1893   /**
1894    * @notice Redeems the commission for all previous cycles. Updates the related variables.
1895    * @return the amount of commission to be redeemed
1896    */
1897   function __redeemCommission() internal returns (uint256 _commission) {
1898     require(lastCommissionRedemption[msg.sender] < cycleNumber);
1899 
1900     uint256 penalty; // penalty received for not taking enough risk
1901     (_commission, penalty) = commissionBalanceOf(msg.sender);
1902 
1903     // record the redemption to prevent double-redemption
1904     for (uint256 i = lastCommissionRedemption[msg.sender]; i < cycleNumber; i = i.add(1)) {
1905       hasRedeemedCommissionForCycle[msg.sender][i] = true;
1906     }
1907     lastCommissionRedemption[msg.sender] = cycleNumber;
1908 
1909     // record the decrease in commission pool
1910     totalCommissionLeft = totalCommissionLeft.sub(_commission);
1911     // include commission penalty to this cycle's total commission pool
1912     totalCommissionOfCycle[cycleNumber] = totalCommissionOfCycle[cycleNumber].add(penalty);
1913     // clear investment arrays to save space
1914     delete userInvestments[msg.sender];
1915     delete userCompoundOrders[msg.sender];
1916 
1917     emit CommissionPaid(cycleNumber, msg.sender, _commission);
1918   }
1919 
1920   /**
1921    * @notice Redeems commission for a particular cycle. Updates the related variables.
1922    * @param _cycle the cycle for which the commission will be redeemed
1923    * @return the amount of commission to be redeemed
1924    */
1925   function __redeemCommissionForCycle(uint256 _cycle) internal returns (uint256 _commission) {
1926     require(!hasRedeemedCommissionForCycle[msg.sender][_cycle]);
1927 
1928     uint256 penalty; // penalty received for not taking enough risk
1929     (_commission, penalty) = commissionOfAt(msg.sender, _cycle);
1930 
1931     hasRedeemedCommissionForCycle[msg.sender][_cycle] = true;
1932 
1933     // record the decrease in commission pool
1934     totalCommissionLeft = totalCommissionLeft.sub(_commission);
1935     // include commission penalty to this cycle's total commission pool
1936     totalCommissionOfCycle[cycleNumber] = totalCommissionOfCycle[cycleNumber].add(penalty);
1937     // clear investment arrays to save space
1938     delete userInvestments[msg.sender];
1939     delete userCompoundOrders[msg.sender];
1940 
1941     emit CommissionPaid(_cycle, msg.sender, _commission);
1942   }
1943 
1944   function() external payable {}
1945 }