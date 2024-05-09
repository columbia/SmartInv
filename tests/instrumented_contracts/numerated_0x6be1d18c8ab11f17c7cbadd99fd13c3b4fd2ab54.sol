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
296 contract TokenSpender is Ownable {
297 
298     using SafeERC20 for IERC20;
299 
300     function claimTokens(IERC20 token, address who, address dest, uint256 amount) external onlyOwner {
301         token.safeTransferFrom(who, dest, amount);
302     }
303 
304 }
305 
306 
307 
308 
309 
310 contract AggregatedTokenSwap {
311 
312     using SafeERC20 for IERC20;
313     using SafeMath for uint;
314     using ExternalCall for address;
315 
316     address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
317 
318     TokenSpender public spender;
319     IGST2 gasToken;
320     address payable owner;
321     uint fee; // 10000 => 100%, 1 => 0.01%
322 
323     event OneInchFeePaid(
324         IERC20 indexed toToken,
325         address indexed referrer,
326         uint256 fee
327     );
328 
329     modifier onlyOwner {
330         require(
331             msg.sender == owner,
332             "Only owner can call this function."
333         );
334         _;
335     }
336 
337     constructor(
338         address payable _owner,
339         IGST2 _gasToken,
340         uint _fee
341     )
342     public
343     {
344         spender = new TokenSpender();
345         owner = _owner;
346         gasToken = _gasToken;
347         fee = _fee;
348     }
349 
350     function setFee(uint _fee) public onlyOwner {
351 
352         fee = _fee;
353     }
354 
355     function aggregate(
356         IERC20 fromToken,
357         IERC20 toToken,
358         uint tokensAmount,
359         address[] memory callAddresses,
360         bytes memory callDataConcat,
361         uint[] memory starts,
362         uint[] memory values,
363         uint mintGasPrice,
364         uint minTokensAmount,
365         address payable referrer
366     )
367     public
368     payable
369     returns (uint returnAmount)
370     {
371         returnAmount = gasleft();
372         uint gasTokenBalance = gasToken.balanceOf(address(this));
373 
374         require(callAddresses.length + 1 == starts.length);
375 
376         if (address(fromToken) != ETH_ADDRESS) {
377 
378             spender.claimTokens(fromToken, msg.sender, address(this), tokensAmount);
379         }
380 
381         for (uint i = 0; i < starts.length - 1; i++) {
382 
383             if (starts[i + 1] - starts[i] > 0) {
384 
385                 if (
386                     address(fromToken) != ETH_ADDRESS &&
387                     fromToken.allowance(address(this), callAddresses[i]) == 0
388                 ) {
389 
390                     fromToken.safeApprove(callAddresses[i], uint256(- 1));
391                 }
392 
393                 require(
394                     callDataConcat[starts[i] + 0] != spender.claimTokens.selector[0] ||
395                     callDataConcat[starts[i] + 1] != spender.claimTokens.selector[1] ||
396                     callDataConcat[starts[i] + 2] != spender.claimTokens.selector[2] ||
397                     callDataConcat[starts[i] + 3] != spender.claimTokens.selector[3]
398                 );
399                 require(callAddresses[i].externalCall(values[i], callDataConcat, starts[i], starts[i + 1] - starts[i]));
400             }
401         }
402 
403         if (address(toToken) == ETH_ADDRESS) {
404             require(address(this).balance >= minTokensAmount);
405         } else {
406             require(toToken.balanceOf(address(this)) >= minTokensAmount);
407         }
408 
409         //
410 
411         require(gasTokenBalance == gasToken.balanceOf(address(this)));
412         if (mintGasPrice > 0) {
413             audoRefundGas(returnAmount, mintGasPrice);
414         }
415 
416         //
417 
418         returnAmount = _balanceOf(toToken, address(this)) * fee / 10000;
419         if (referrer != address(0)) {
420             returnAmount /= 2;
421             if (!_transfer(toToken, referrer, returnAmount, true)) {
422                 returnAmount *= 2;
423                 emit OneInchFeePaid(toToken, address(0), returnAmount);
424             } else {
425                 emit OneInchFeePaid(toToken, referrer, returnAmount / 2);
426             }
427         }
428 
429         _transfer(toToken, owner, returnAmount, false);
430 
431         returnAmount = _balanceOf(toToken, address(this));
432         _transfer(toToken, msg.sender, returnAmount, false);
433     }
434 
435     function _balanceOf(IERC20 token, address who) internal view returns(uint256) {
436         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
437             return who.balance;
438         } else {
439             return token.balanceOf(who);
440         }
441     }
442 
443     function _transfer(IERC20 token, address payable to, uint256 amount, bool allowFail) internal returns(bool) {
444         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
445             if (allowFail) {
446                 return to.send(amount);
447             } else {
448                 to.transfer(amount);
449                 return true;
450             }
451         } else {
452             token.safeTransfer(to, amount);
453             return true;
454         }
455     }
456 
457     function audoRefundGas(
458         uint startGas,
459         uint mintGasPrice
460     )
461     private
462     returns (uint freed)
463     {
464         uint MINT_BASE = 32254;
465         uint MINT_TOKEN = 36543;
466         uint FREE_BASE = 14154;
467         uint FREE_TOKEN = 6870;
468         uint REIMBURSE = 24000;
469 
470         uint tokensAmount = ((startGas - gasleft()) + FREE_BASE) / (2 * REIMBURSE - FREE_TOKEN);
471         uint maxReimburse = tokensAmount * REIMBURSE;
472 
473         uint mintCost = MINT_BASE + (tokensAmount * MINT_TOKEN);
474         uint freeCost = FREE_BASE + (tokensAmount * FREE_TOKEN);
475 
476         uint efficiency = (maxReimburse * 100 * tx.gasprice) / (mintCost * mintGasPrice + freeCost * tx.gasprice);
477 
478         if (efficiency > 100) {
479 
480             return refundGas(
481                 tokensAmount
482             );
483         } else {
484 
485             return 0;
486         }
487     }
488 
489     function refundGas(
490         uint tokensAmount
491     )
492     private
493     returns (uint freed)
494     {
495 
496         if (tokensAmount > 0) {
497 
498             uint safeNumTokens = 0;
499             uint gas = gasleft();
500 
501             if (gas >= 27710) {
502                 safeNumTokens = (gas - 27710) / (1148 + 5722 + 150);
503             }
504 
505             if (tokensAmount > safeNumTokens) {
506                 tokensAmount = safeNumTokens;
507             }
508 
509             uint gasTokenBalance = IERC20(address(gasToken)).balanceOf(address(this));
510 
511             if (tokensAmount > 0 && gasTokenBalance >= tokensAmount) {
512 
513                 return gasToken.freeUpTo(tokensAmount);
514             } else {
515 
516                 return 0;
517             }
518         } else {
519 
520             return 0;
521         }
522     }
523 
524     function() external payable {
525 
526         if (msg.value == 0 && msg.sender == owner) {
527 
528             IERC20 _gasToken = IERC20(address(gasToken));
529 
530             owner.transfer(address(this).balance);
531             _gasToken.safeTransfer(owner, _gasToken.balanceOf(address(this)));
532         }
533     }
534 }