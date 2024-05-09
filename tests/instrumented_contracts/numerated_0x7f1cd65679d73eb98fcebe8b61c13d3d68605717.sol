1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 /**
274  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
275  * the optional functions; to access them see {ERC20Detailed}.
276  */
277 interface IERC20 {
278     /**
279      * @dev Returns the amount of tokens in existence.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     /**
284      * @dev Returns the amount of tokens owned by `account`.
285      */
286     function balanceOf(address account) external view returns (uint256);
287 
288     /**
289      * @dev Moves `amount` tokens from the caller's account to `recipient`.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transfer(address recipient, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Returns the remaining number of tokens that `spender` will be
299      * allowed to spend on behalf of `owner` through {transferFrom}. This is
300      * zero by default.
301      *
302      * This value changes when {approve} or {transferFrom} are called.
303      */
304     function allowance(address owner, address spender) external view returns (uint256);
305 
306     /**
307      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * IMPORTANT: Beware that changing an allowance with this method brings the risk
312      * that someone may use both the old and the new allowance by unfortunate
313      * transaction ordering. One possible solution to mitigate this race
314      * condition is to first reduce the spender's allowance to 0 and set the
315      * desired value afterwards:
316      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address spender, uint256 amount) external returns (bool);
321 
322     /**
323      * @dev Moves `amount` tokens from `sender` to `recipient` using the
324      * allowance mechanism. `amount` is then deducted from the caller's
325      * allowance.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Emitted when `value` tokens are moved from one account (`from`) to
335      * another (`to`).
336      *
337      * Note that `value` may be zero.
338      */
339     event Transfer(address indexed from, address indexed to, uint256 value);
340 
341     /**
342      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
343      * a call to {approve}. `value` is the new allowance.
344      */
345     event Approval(address indexed owner, address indexed spender, uint256 value);
346 }
347 
348 // File: contracts/Not_upgradable_done/MultiPoolZapV1_4.sol
349 
350 // Copyright (C) 2019, 2020 dipeshsukhani, nodar, suhailg, apoorvlathey
351 
352 // This program is free software: you can redistribute it and/or modify
353 // it under the terms of the GNU Affero General Public License as published by
354 // the Free Software Foundation, either version 2 of the License, or
355 // (at your option) any later version.
356 //
357 // This program is distributed in the hope that it will be useful,
358 // but WITHOUT ANY WARRANTY; without even the implied warranty of
359 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
360 // GNU Affero General Public License for more details.
361 //
362 // Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License
363 
364 
365 
366 
367 pragma solidity ^0.5.0;
368 
369 interface UniswapFactoryInterface {
370     function getExchange(address token) external view returns (address exchange);
371 }
372 
373 interface UniswapExchangeInterface {
374     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
375     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
376 }
377 
378 interface uniswapPoolZap {
379     function LetsInvest(address _TokenContractAddress, address _towhomtoissue) external payable returns (uint256);
380 }
381 
382 /**
383     @title Multiple Pool Zap
384     @author Zapper
385     @notice Use this contract to Add liquidity to Multiple Uniswap Pools at once using ETH or ERC20
386 */
387 contract MultiPoolZapV1_4 is Ownable {
388     using SafeMath for uint;
389 
390     uniswapPoolZap public uniswapPoolZapAddress;
391     UniswapFactoryInterface public UniswapFactory;
392     uint16 public goodwill;
393     address payable public dzgoodwillAddress;
394     mapping(address => uint256) private userBalance;
395 
396     constructor(uint16 _goodwill, address payable _dzgoodwillAddress) public {
397         goodwill = _goodwill;
398         dzgoodwillAddress = _dzgoodwillAddress;
399         uniswapPoolZapAddress = uniswapPoolZap(0x97402249515994Cc0D22092D3375033Ad0ea438A);
400         UniswapFactory = UniswapFactoryInterface(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
401     }
402 
403     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
404         require(
405             _new_goodwill > 0 && _new_goodwill < 10000,
406             "GoodWill Value not allowed"
407         );
408         goodwill = _new_goodwill;
409     }
410 
411     function set_new_dzgoodwillAddress(address payable _new_dzgoodwillAddress)
412         public
413         onlyOwner
414     {
415         dzgoodwillAddress = _new_dzgoodwillAddress;
416     }
417 
418     function set_uniswapPoolZapAddress(address _uniswapPoolZapAddress) onlyOwner public {
419         uniswapPoolZapAddress = uniswapPoolZap(_uniswapPoolZapAddress);
420     }
421 
422     function set_UniswapFactory(address _UniswapFactory) onlyOwner public {
423         UniswapFactory = UniswapFactoryInterface(_UniswapFactory);
424     }
425 
426     /**
427         @notice Add liquidity to Multiple Uniswap Pools at once using ETH or ERC20
428         @param _IncomingTokenContractAddress The token address for ERC20 being deposited. Input address(0) in case of ETH deposit.
429         @param _IncomingTokenQty Quantity of ERC20 being deposited. 0 in case of ETH deposit.
430         @param underlyingTokenAddresses Array of Token Addresses to which's Uniswap Pool to add liquidity to.
431         @param respectiveWeightedValues Array of Relative Ratios (corresponding to underlyingTokenAddresses) to proportionally distribute received ETH or ERC20 into various pools.
432     */
433     function multipleZapIn(address _IncomingTokenContractAddress, uint256 _IncomingTokenQty, address[] memory underlyingTokenAddresses, uint256[] memory respectiveWeightedValues) public payable {
434 
435         uint totalWeights;
436         require(underlyingTokenAddresses.length == respectiveWeightedValues.length);
437         for(uint i=0;i<underlyingTokenAddresses.length;i++) {
438             totalWeights = (totalWeights).add(respectiveWeightedValues[i]);
439         }
440 
441         uint256 eth2Trade;
442 
443         if (msg.value > 0) {
444             require (_IncomingTokenContractAddress == address(0), "Incoming token address should be address(0)");
445             eth2Trade = msg.value;
446         } else if(_IncomingTokenContractAddress == address(0) && msg.value == 0) {
447             revert("Please send ETH along with function call");
448         } else if(_IncomingTokenContractAddress != address(0)) {
449             require(msg.value == 0, "Cannot send Tokens and ETH at the same time");
450             require(
451                 IERC20(_IncomingTokenContractAddress).transferFrom(
452                     msg.sender,
453                     address(this),
454                     _IncomingTokenQty
455                 ),
456                 "Error in transferring ERC20"
457             );
458             eth2Trade = _token2Eth(
459               _IncomingTokenContractAddress,
460               _IncomingTokenQty,
461               address(this)
462             );
463         }
464 
465         uint goodwillPortion = ((eth2Trade).mul(goodwill)).div(10000);
466         uint totalInvestable = (eth2Trade).sub(goodwillPortion);
467         uint totalLeftToBeInvested = totalInvestable;
468 
469         require(address(dzgoodwillAddress).send(goodwillPortion));
470 
471         uint residualETH;
472         for (uint i=0;i<underlyingTokenAddresses.length;i++) {
473             uint LPT = uniswapPoolZapAddress.LetsInvest.value((((totalInvestable).mul(respectiveWeightedValues[i])).div(totalWeights)+residualETH))(underlyingTokenAddresses[i], address(this));
474             IERC20(UniswapFactory.getExchange(address(underlyingTokenAddresses[i]))).transfer(msg.sender, LPT);
475             totalLeftToBeInvested = (totalLeftToBeInvested).sub(((totalInvestable).mul(respectiveWeightedValues[i])).div(totalWeights));
476             residualETH = (address(this).balance).sub(totalLeftToBeInvested);
477         }
478 
479         if(address(this).balance >= 250000000000000000){
480             totalInvestable = address(this).balance;
481             totalLeftToBeInvested = totalInvestable;
482             residualETH = 0;
483             for (uint i=0;i<underlyingTokenAddresses.length;i++) {
484                 uint LPT = uniswapPoolZapAddress.LetsInvest.value((((totalInvestable).mul(respectiveWeightedValues[i])).div(totalWeights)+residualETH))(underlyingTokenAddresses[i], address(this));
485                 IERC20(UniswapFactory.getExchange(address(underlyingTokenAddresses[i]))).transfer(msg.sender, LPT);
486                 totalLeftToBeInvested = (totalLeftToBeInvested).sub(((totalInvestable).mul(respectiveWeightedValues[i])).div(totalWeights));
487                 residualETH = (address(this).balance).sub(totalLeftToBeInvested);
488             }
489         }
490 
491         userBalance[msg.sender] = address(this).balance;
492         require (send_out_eth(msg.sender));
493     }
494 
495     /**
496         @notice This function swaps ERC20 to ERC20 via Uniswap
497         @param _FromTokenContractAddress Address of Token to swap
498         @param tokens2Trade The quantity of tokens to swap
499         @param _toWhomToIssue Address of user to send the swapped ETH to
500         @return The amount of ETH Received.
501     */
502     function _token2Eth(
503         address _FromTokenContractAddress,
504         uint256 tokens2Trade,
505         address _toWhomToIssue
506     ) internal returns (uint256 ethBought) {
507 
508             UniswapExchangeInterface FromUniSwapExchangeContractAddress
509          = UniswapExchangeInterface(
510             UniswapFactory.getExchange(_FromTokenContractAddress)
511         );
512 
513         IERC20(_FromTokenContractAddress).approve(
514             address(FromUniSwapExchangeContractAddress),
515             tokens2Trade
516         );
517 
518         ethBought = FromUniSwapExchangeContractAddress.tokenToEthTransferInput(
519             tokens2Trade,
520             ((FromUniSwapExchangeContractAddress.getTokenToEthInputPrice(tokens2Trade)).mul(99).div(100)),
521             SafeMath.add(block.timestamp, 300),
522             _toWhomToIssue
523         );
524         require(ethBought > 0, "Error in swapping Eth: 1");
525     }
526 
527     /**
528         @notice This function sends the user's remaining ETH back to them.
529         @param _towhomtosendtheETH The Address of the user
530         @return Boolean corresponding to successful execution.
531     */
532     function send_out_eth(address _towhomtosendtheETH) internal returns (bool) {
533         require(userBalance[_towhomtosendtheETH] > 0);
534         uint256 amount = userBalance[_towhomtosendtheETH];
535         userBalance[_towhomtosendtheETH] = 0;
536         (bool success, ) = _towhomtosendtheETH.call.value(amount)("");
537         return success;
538     }
539 
540     // - fallback function let you / anyone send ETH to this wallet without the need to call any function
541     function() external payable {
542     }
543 }