1 pragma solidity ^0.5.0;
2 
3 interface IGST2 {
4 
5     function freeUpTo(uint256 value) external returns (uint256 freed);
6 
7     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
8 
9     function balanceOf(address who) external view returns (uint256);
10 }
11 
12 
13 
14 library ExternalCall {
15     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
16     // call has been separated into its own function in order to take advantage
17     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
18     function externalCall(address destination, uint value, bytes memory data, uint dataOffset, uint dataLength) internal returns(bool result) {
19         // solium-disable-next-line security/no-inline-assembly
20         assembly {
21             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
22             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
23             result := call(
24                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
25                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
26                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
27                 destination,
28                 value,
29                 add(d, dataOffset),
30                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
31                 x,
32                 0                  // Output is ignored, therefore the output size is zero
33             )
34         }
35     }
36 }
37 
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://eips.ethereum.org/EIPS/eip-20
42  */
43 interface IERC20 {
44     function transfer(address to, uint256 value) external returns (bool);
45 
46     function approve(address spender, uint256 value) external returns (bool);
47 
48     function transferFrom(address from, address to, uint256 value) external returns (bool);
49 
50     function totalSupply() external view returns (uint256);
51 
52     function balanceOf(address who) external view returns (uint256);
53 
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * @title SafeMath
64  * @dev Unsigned math operations with safety checks that revert on error
65  */
66 library SafeMath {
67     /**
68      * @dev Multiplies two unsigned integers, reverts on overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b);
80 
81         return c;
82     }
83 
84     /**
85      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Adds two unsigned integers, reverts on overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a);
112 
113         return c;
114     }
115 
116     /**
117      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118      * reverts when dividing by zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 
126 
127 /**
128  * Utility library of inline functions on addresses
129  */
130 library Address {
131     /**
132      * Returns whether the target address is a contract
133      * @dev This function will return false if invoked during the constructor of a contract,
134      * as the code is not actually created until after the constructor finishes.
135      * @param account address of the account to check
136      * @return whether the target address is a contract
137      */
138     function isContract(address account) internal view returns (bool) {
139         uint256 size;
140         // XXX Currently there is no better way to check if there is a contract in an address
141         // than to check the size of the code at that address.
142         // See https://ethereum.stackexchange.com/a/14016/36603
143         // for more details about how this works.
144         // TODO Check this again before the Serenity release, because all addresses will be
145         // contracts then.
146         // solhint-disable-next-line no-inline-assembly
147         assembly { size := extcodesize(account) }
148         return size > 0;
149     }
150 }
151 
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     /**
164      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165      * account.
166      */
167     constructor () internal {
168         _owner = msg.sender;
169         emit OwnershipTransferred(address(0), _owner);
170     }
171 
172     /**
173      * @return the address of the owner.
174      */
175     function owner() public view returns (address) {
176         return _owner;
177     }
178 
179     /**
180      * @dev Throws if called by any account other than the owner.
181      */
182     modifier onlyOwner() {
183         require(isOwner());
184         _;
185     }
186 
187     /**
188      * @return true if `msg.sender` is the owner of the contract.
189      */
190     function isOwner() public view returns (bool) {
191         return msg.sender == _owner;
192     }
193 
194     /**
195      * @dev Allows the current owner to relinquish control of the contract.
196      * It will not be possible to call the functions with the `onlyOwner`
197      * modifier anymore.
198      * @notice Renouncing ownership will leave the contract without an owner,
199      * thereby removing any functionality that is only available to the owner.
200      */
201     function renounceOwnership() public onlyOwner {
202         emit OwnershipTransferred(_owner, address(0));
203         _owner = address(0);
204     }
205 
206     /**
207      * @dev Allows the current owner to transfer control of the contract to a newOwner.
208      * @param newOwner The address to transfer ownership to.
209      */
210     function transferOwnership(address newOwner) public onlyOwner {
211         _transferOwnership(newOwner);
212     }
213 
214     /**
215      * @dev Transfers control of the contract to a newOwner.
216      * @param newOwner The address to transfer ownership to.
217      */
218     function _transferOwnership(address newOwner) internal {
219         require(newOwner != address(0));
220         emit OwnershipTransferred(_owner, newOwner);
221         _owner = newOwner;
222     }
223 }
224 
225 
226 
227 
228 /**
229  * @title SafeERC20
230  * @dev Wrappers around ERC20 operations that throw on failure (when the token
231  * contract returns false). Tokens that return no value (and instead revert or
232  * throw on failure) are also supported, non-reverting calls are assumed to be
233  * successful.
234  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
235  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
236  */
237 library SafeERC20 {
238     using SafeMath for uint256;
239     using Address for address;
240 
241     function safeTransfer(IERC20 token, address to, uint256 value) internal {
242         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
243     }
244 
245     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
246         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
247     }
248 
249     function safeApprove(IERC20 token, address spender, uint256 value) internal {
250         // safeApprove should only be called when setting an initial allowance,
251         // or when resetting it to zero. To increase and decrease it, use
252         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
253         require((value == 0) || (token.allowance(address(this), spender) == 0));
254         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
255     }
256 
257     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
258         uint256 newAllowance = token.allowance(address(this), spender).add(value);
259         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
260     }
261 
262     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
263         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
264         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
265     }
266 
267     /**
268      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
269      * on the return value: the return value is optional (but if data is returned, it must equal true).
270      * @param token The token targeted by the call.
271      * @param data The call data (encoded using abi.encode or one of its variants).
272      */
273     function callOptionalReturn(IERC20 token, bytes memory data) private {
274         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
275         // we're implementing it ourselves.
276 
277         // A Solidity high level call has three parts:
278         //  1. The target address is checked to verify it contains contract code
279         //  2. The call itself is made, and success asserted
280         //  3. The return value is decoded, which in turn checks the size of the returned data.
281 
282         require(address(token).isContract());
283 
284         // solhint-disable-next-line avoid-low-level-calls
285         (bool success, bytes memory returndata) = address(token).call(data);
286         require(success);
287 
288         if (returndata.length > 0) { // Return data is optional
289             require(abi.decode(returndata, (bool)));
290         }
291     }
292 }
293 
294 
295 
296 contract IWETH is IERC20 {
297 
298     function deposit() external payable;
299 
300     function withdraw(uint256 amount) external;
301 }
302 
303 
304 
305 contract TokenSpender is Ownable {
306 
307     using SafeERC20 for IERC20;
308 
309     function claimTokens(IERC20 token, address who, address dest, uint256 amount) external onlyOwner {
310         token.safeTransferFrom(who, dest, amount);
311     }
312 
313 }
314 
315 
316 
317 
318 
319 
320 contract AggregatedTokenSwap {
321 
322     using SafeERC20 for IERC20;
323     using SafeMath for uint;
324     using ExternalCall for address;
325 
326     address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
327 
328     TokenSpender public spender;
329     IGST2 gasToken;
330     address payable owner;
331     uint fee; // 10000 => 100%, 1 => 0.01%
332 
333     event OneInchFeePaid(
334         IERC20 indexed toToken,
335         address indexed referrer,
336         uint256 fee
337     );
338 
339     modifier onlyOwner {
340         require(
341             msg.sender == owner,
342             "Only owner can call this function."
343         );
344         _;
345     }
346 
347     constructor(
348         address payable _owner,
349         IGST2 _gasToken,
350         uint _fee
351     )
352     public
353     {
354         spender = new TokenSpender();
355         owner = _owner;
356         gasToken = _gasToken;
357         fee = _fee;
358     }
359 
360     function setFee(uint _fee) public onlyOwner {
361 
362         fee = _fee;
363     }
364 
365     function aggregate(
366         IERC20 fromToken,
367         IERC20 toToken,
368         uint tokensAmount,
369         address[] memory callAddresses,
370         bytes memory callDataConcat,
371         uint[] memory starts,
372         uint[] memory values,
373         uint mintGasPrice,
374         uint minTokensAmount,
375         address payable referrer
376     )
377     public
378     payable
379     returns (uint returnAmount)
380     {
381         returnAmount = gasleft();
382         uint gasTokenBalance = gasToken.balanceOf(address(this));
383 
384         require(callAddresses.length + 1 == starts.length);
385 
386         if (address(fromToken) != ETH_ADDRESS) {
387 
388             spender.claimTokens(fromToken, msg.sender, address(this), tokensAmount);
389         }
390 
391         for (uint i = 0; i < starts.length - 1; i++) {
392 
393             if (starts[i + 1] - starts[i] > 0) {
394 
395                 require(
396                     callDataConcat[starts[i] + 0] != spender.claimTokens.selector[0] ||
397                     callDataConcat[starts[i] + 1] != spender.claimTokens.selector[1] ||
398                     callDataConcat[starts[i] + 2] != spender.claimTokens.selector[2] ||
399                     callDataConcat[starts[i] + 3] != spender.claimTokens.selector[3]
400                 );
401                 require(callAddresses[i].externalCall(values[i], callDataConcat, starts[i], starts[i + 1] - starts[i]));
402             }
403         }
404 
405         if (address(toToken) == ETH_ADDRESS) {
406             require(address(this).balance >= minTokensAmount);
407         } else {
408             require(toToken.balanceOf(address(this)) >= minTokensAmount);
409         }
410 
411         //
412 
413         require(gasTokenBalance == gasToken.balanceOf(address(this)));
414         if (mintGasPrice > 0) {
415             audoRefundGas(returnAmount, mintGasPrice);
416         }
417 
418         //
419 
420         returnAmount = _balanceOf(toToken, address(this)) * fee / 10000;
421         if (referrer != address(0)) {
422             returnAmount /= 2;
423             if (!_transfer(toToken, referrer, returnAmount, true)) {
424                 returnAmount *= 2;
425                 emit OneInchFeePaid(toToken, address(0), returnAmount);
426             } else {
427                 emit OneInchFeePaid(toToken, referrer, returnAmount / 2);
428             }
429         }
430 
431         _transfer(toToken, owner, returnAmount, false);
432 
433         returnAmount = _balanceOf(toToken, address(this));
434         _transfer(toToken, msg.sender, returnAmount, false);
435     }
436 
437     function infiniteApproveIfNeeded(IERC20 token, address to) external {
438         if (
439             address(token) != ETH_ADDRESS &&
440             token.allowance(address(this), to) == 0
441         ) {
442             token.safeApprove(to, uint256(-1));
443         }
444     }
445 
446     function withdrawAllToken(IWETH token) external {
447         uint256 amount = token.balanceOf(address(this));
448         token.withdraw(amount);
449     }
450 
451     function _balanceOf(IERC20 token, address who) internal view returns(uint256) {
452         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
453             return who.balance;
454         } else {
455             return token.balanceOf(who);
456         }
457     }
458 
459     function _transfer(IERC20 token, address payable to, uint256 amount, bool allowFail) internal returns(bool) {
460         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
461             if (allowFail) {
462                 return to.send(amount);
463             } else {
464                 to.transfer(amount);
465                 return true;
466             }
467         } else {
468             token.safeTransfer(to, amount);
469             return true;
470         }
471     }
472 
473     function audoRefundGas(
474         uint startGas,
475         uint mintGasPrice
476     )
477     private
478     returns (uint freed)
479     {
480         uint MINT_BASE = 32254;
481         uint MINT_TOKEN = 36543;
482         uint FREE_BASE = 14154;
483         uint FREE_TOKEN = 6870;
484         uint REIMBURSE = 24000;
485 
486         uint tokensAmount = ((startGas - gasleft()) + FREE_BASE) / (2 * REIMBURSE - FREE_TOKEN);
487         uint maxReimburse = tokensAmount * REIMBURSE;
488 
489         uint mintCost = MINT_BASE + (tokensAmount * MINT_TOKEN);
490         uint freeCost = FREE_BASE + (tokensAmount * FREE_TOKEN);
491 
492         uint efficiency = (maxReimburse * 100 * tx.gasprice) / (mintCost * mintGasPrice + freeCost * tx.gasprice);
493 
494         if (efficiency > 100) {
495 
496             return refundGas(
497                 tokensAmount
498             );
499         } else {
500 
501             return 0;
502         }
503     }
504 
505     function refundGas(
506         uint tokensAmount
507     )
508     private
509     returns (uint freed)
510     {
511 
512         if (tokensAmount > 0) {
513 
514             uint safeNumTokens = 0;
515             uint gas = gasleft();
516 
517             if (gas >= 27710) {
518                 safeNumTokens = (gas - 27710) / (1148 + 5722 + 150);
519             }
520 
521             if (tokensAmount > safeNumTokens) {
522                 tokensAmount = safeNumTokens;
523             }
524 
525             uint gasTokenBalance = IERC20(address(gasToken)).balanceOf(address(this));
526 
527             if (tokensAmount > 0 && gasTokenBalance >= tokensAmount) {
528 
529                 return gasToken.freeUpTo(tokensAmount);
530             } else {
531 
532                 return 0;
533             }
534         } else {
535 
536             return 0;
537         }
538     }
539 
540     function() external payable {
541 
542         if (msg.value == 0 && msg.sender == owner) {
543 
544             IERC20 _gasToken = IERC20(address(gasToken));
545 
546             owner.transfer(address(this).balance);
547             _gasToken.safeTransfer(owner, _gasToken.balanceOf(address(this)));
548         }
549     }
550 }
