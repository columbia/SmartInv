1 /**
2  *Submitted for verification at BscScan.com on 2021-09-29
3 */
4 
5 // File: contracts/AggregationRouter.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 // “Copyright (c) 2019-2021 1inch 
10 // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 
11 // The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. 
12 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE”.
13 
14 pragma solidity >=0.7.6;
15 pragma abicoder v2;
16 
17 interface IERC20 {
18     event Approval(
19         address indexed owner,
20         address indexed spender,
21         uint256 value
22     );
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     function name() external view returns (string memory);
26 
27     function symbol() external view returns (string memory);
28 
29     function decimals() external view returns (uint8);
30 
31     function totalSupply() external view returns (uint256);
32 
33     function balanceOf(address owner) external view returns (uint256);
34 
35     function allowance(address owner, address spender)
36         external
37         view
38         returns (uint256);
39 
40     function approve(address spender, uint256 value) external returns (bool);
41 
42     function transfer(address to, uint256 value) external returns (bool);
43 
44     function transferFrom(
45         address from,
46         address to,
47         uint256 value
48     ) external returns (bool);
49 }
50 
51 interface IAggregationExecutor {
52     function callBytes(bytes calldata data) external payable; // 0xd9c45357
53 }
54 
55 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
56 library TransferHelper {
57     function safeApprove(
58         address token,
59         address to,
60         uint256 value
61     ) internal {
62         // bytes4(keccak256(bytes('approve(address,uint256)')));
63         (bool success, bytes memory data) =
64             token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
65         require(
66             success && (data.length == 0 || abi.decode(data, (bool))),
67             "TransferHelper: APPROVE_FAILED"
68         );
69     }
70 
71     function safeTransfer(
72         address token,
73         address to,
74         uint256 value
75     ) internal {
76         // bytes4(keccak256(bytes('transfer(address,uint256)')));
77         (bool success, bytes memory data) =
78             token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
79         require(
80             success && (data.length == 0 || abi.decode(data, (bool))),
81             "TransferHelper: TRANSFER_FAILED"
82         );
83     }
84 
85     function safeTransferFrom(
86         address token,
87         address from,
88         address to,
89         uint256 value
90     ) internal {
91         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
92         (bool success, bytes memory data) =
93             token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
94         require(
95             success && (data.length == 0 || abi.decode(data, (bool))),
96             "TransferHelper: TRANSFER_FROM_FAILED"
97         );
98     }
99 
100     function safeTransferETH(address to, uint256 value) internal {
101         (bool success, ) = to.call{value: value}(new bytes(0));
102         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
103     }
104 }
105 
106 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
107 library SafeMath {
108     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
109         require((z = x + y) >= x, "ds-math-add-overflow");
110     }
111 
112     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
113         require((z = x - y) <= x, "ds-math-sub-underflow");
114     }
115 
116     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
117         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
118     }
119 
120     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
121         require(b > 0, "ds-math-division-by-zero");
122         c = a / b;
123     }
124 }
125 
126 interface IERC20Permit {
127     function permit(
128         address owner,
129         address spender,
130         uint256 amount,
131         uint256 deadline,
132         uint8 v,
133         bytes32 r,
134         bytes32 s
135     ) external;
136 }
137 
138 library RevertReasonParser {
139     function parse(bytes memory data, string memory prefix)
140         internal
141         pure
142         returns (string memory)
143     {
144         // https://solidity.readthedocs.io/en/latest/control-structures.html#revert
145         // We assume that revert reason is abi-encoded as Error(string)
146 
147         // 68 = 4-byte selector 0x08c379a0 + 32 bytes offset + 32 bytes length
148         if (
149             data.length >= 68 &&
150             data[0] == "\x08" &&
151             data[1] == "\xc3" &&
152             data[2] == "\x79" &&
153             data[3] == "\xa0"
154         ) {
155             string memory reason;
156             // solhint-disable no-inline-assembly
157             assembly {
158                 // 68 = 32 bytes data length + 4-byte selector + 32 bytes offset
159                 reason := add(data, 68)
160             }
161             /*
162                 revert reason is padded up to 32 bytes with ABI encoder: Error(string)
163                 also sometimes there is extra 32 bytes of zeros padded in the end:
164                 https://github.com/ethereum/solidity/issues/10170
165                 because of that we can't check for equality and instead check
166                 that string length + extra 68 bytes is less than overall data length
167             */
168             require(
169                 data.length >= 68 + bytes(reason).length,
170                 "Invalid revert reason"
171             );
172             return string(abi.encodePacked(prefix, "Error(", reason, ")"));
173         }
174         // 36 = 4-byte selector 0x4e487b71 + 32 bytes integer
175         else if (
176             data.length == 36 &&
177             data[0] == "\x4e" &&
178             data[1] == "\x48" &&
179             data[2] == "\x7b" &&
180             data[3] == "\x71"
181         ) {
182             uint256 code;
183             // solhint-disable no-inline-assembly
184             assembly {
185                 // 36 = 32 bytes data length + 4-byte selector
186                 code := mload(add(data, 36))
187             }
188             return
189                 string(abi.encodePacked(prefix, "Panic(", _toHex(code), ")"));
190         }
191 
192         return string(abi.encodePacked(prefix, "Unknown(", _toHex(data), ")"));
193     }
194 
195     function _toHex(uint256 value) private pure returns (string memory) {
196         return _toHex(abi.encodePacked(value));
197     }
198 
199     function _toHex(bytes memory data) private pure returns (string memory) {
200         bytes16 alphabet = 0x30313233343536373839616263646566;
201         bytes memory str = new bytes(2 + data.length * 2);
202         str[0] = "0";
203         str[1] = "x";
204         for (uint256 i = 0; i < data.length; i++) {
205             str[2 * i + 2] = alphabet[uint8(data[i] >> 4)];
206             str[2 * i + 3] = alphabet[uint8(data[i] & 0x0f)];
207         }
208         return string(str);
209     }
210 }
211 
212 contract Permitable {
213     event Error(string reason);
214 
215     function _permit(
216         IERC20 token,
217         uint256 amount,
218         bytes calldata permit
219     ) internal {
220         if (permit.length == 32 * 7) {
221             // solhint-disable-next-line avoid-low-level-calls
222             (bool success, bytes memory result) =
223                 address(token).call(
224                     abi.encodePacked(IERC20Permit.permit.selector, permit)
225                 );
226             if (!success) {
227                 string memory reason =
228                     RevertReasonParser.parse(result, "Permit call failed: ");
229                 if (token.allowance(msg.sender, address(this)) < amount) {
230                     revert(reason);
231                 } else {
232                     emit Error(reason);
233                 }
234             }
235         }
236     }
237 }
238 
239 /*
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with GSN meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 abstract contract Context {
250     function _msgSender() internal view virtual returns (address payable) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes memory) {
255         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256         return msg.data;
257     }
258 }
259 
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * By default, the owner account will be the one that deploys the contract. This
266  * can later be changed with {transferOwnership}.
267  *
268  * This module is used through inheritance. It will make available the modifier
269  * `onlyOwner`, which can be applied to your functions to restrict their use to
270  * the owner.
271  */
272 abstract contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(
276         address indexed previousOwner,
277         address indexed newOwner
278     );
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() internal {
284         address msgSender = _msgSender();
285         _owner = msgSender;
286         emit OwnershipTransferred(address(0), msgSender);
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view virtual returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public virtual onlyOwner {
312         emit OwnershipTransferred(_owner, address(0));
313         _owner = address(0);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Can only be called by the current owner.
319      */
320     function transferOwnership(address newOwner) public virtual onlyOwner {
321         require(
322             newOwner != address(0),
323             "Ownable: new owner is the zero address"
324         );
325         emit OwnershipTransferred(_owner, newOwner);
326         _owner = newOwner;
327     }
328 }
329 
330 contract AggregationRouter is Permitable, Ownable {
331     using SafeMath for uint256;
332     address public immutable WETH;
333     address private constant ETH_ADDRESS =
334         address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
335 
336     uint256 private constant _PARTIAL_FILL = 0x01;
337     uint256 private constant _REQUIRES_EXTRA_ETH = 0x02;
338     uint256 private constant _SHOULD_CLAIM = 0x04;
339     uint256 private constant _BURN_FROM_MSG_SENDER = 0x08;
340     uint256 private constant _BURN_FROM_TX_ORIGIN = 0x10;
341 
342     struct SwapDescription {
343         IERC20 srcToken;
344         IERC20 dstToken;
345         address srcReceiver;
346         address dstReceiver;
347         uint256 amount;
348         uint256 minReturnAmount;
349         uint256 flags;
350         bytes permit;
351     }
352 
353     event Swapped(
354         address sender,
355         IERC20 srcToken,
356         IERC20 dstToken,
357         address dstReceiver,
358         uint256 spentAmount,
359         uint256 returnAmount
360     );
361 
362     event Exchange(address pair, uint256 amountOut, address output);
363 
364     modifier ensure(uint256 deadline) {
365         require(deadline >= block.timestamp, "Router: EXPIRED");
366         _;
367     }
368 
369     constructor(address _WETH) public {
370         WETH = _WETH;
371     }
372 
373     receive() external payable {
374         assert(msg.sender == WETH);
375         // only accept ETH via fallback from the WETH contract
376     }
377 
378     function swap(
379         IAggregationExecutor caller,
380         SwapDescription calldata desc,
381         bytes calldata data
382     ) external payable returns (uint256 returnAmount) {
383         require(desc.minReturnAmount > 0, "Min return should not be 0");
384         require(data.length > 0, "data should be not zero");
385 
386         uint256 flags = desc.flags;
387         uint256 amount = desc.amount;
388         IERC20 srcToken = desc.srcToken;
389         IERC20 dstToken = desc.dstToken;
390 
391         if (flags & _REQUIRES_EXTRA_ETH != 0) {
392             require(
393                 msg.value > (isETH(srcToken) ? amount : 0),
394                 "Invalid msg.value"
395             );
396         } else {
397             require(
398                 msg.value == (isETH(srcToken) ? amount : 0),
399                 "Invalid msg.value"
400             );
401         }
402 
403         if (flags & _SHOULD_CLAIM != 0) {
404             require(!isETH(srcToken), "Claim token is ETH");
405             _permit(srcToken, amount, desc.permit);
406             TransferHelper.safeTransferFrom(
407                 address(srcToken),
408                 msg.sender,
409                 desc.srcReceiver,
410                 amount
411             );
412         }
413 
414         address dstReceiver =
415             (desc.dstReceiver == address(0)) ? msg.sender : desc.dstReceiver;
416         uint256 initialSrcBalance =
417             (flags & _PARTIAL_FILL != 0) ? getBalance(srcToken, msg.sender) : 0;
418         uint256 initialDstBalance = getBalance(dstToken, dstReceiver);
419 
420         {
421             // solhint-disable-next-line avoid-low-level-calls
422             (bool success, bytes memory result) =
423                 address(caller).call{value: msg.value}(
424                     abi.encodeWithSelector(caller.callBytes.selector, data)
425                 );
426             if (!success) {
427                 revert(RevertReasonParser.parse(result, "callBytes failed: "));
428             }
429         }
430 
431         uint256 spentAmount = amount;
432         returnAmount = getBalance(dstToken, dstReceiver).sub(initialDstBalance);
433 
434         if (flags & _PARTIAL_FILL != 0) {
435             spentAmount = initialSrcBalance.add(amount).sub(
436                 getBalance(srcToken, msg.sender)
437             );
438             require(
439                 returnAmount.mul(amount) >=
440                     desc.minReturnAmount.mul(spentAmount),
441                 "Return amount is not enough"
442             );
443         } else {
444             require(
445                 returnAmount >= desc.minReturnAmount,
446                 "Return amount is not enough"
447             );
448         }
449 
450         emit Swapped(
451             msg.sender,
452             srcToken,
453             dstToken,
454             dstReceiver,
455             spentAmount,
456             returnAmount
457         );
458         emit Exchange(
459             address(caller),
460             returnAmount,
461             isETH(dstToken) ? WETH : address(dstToken)
462         );
463     }
464 
465     function getBalance(IERC20 token, address account)
466         internal
467         view
468         returns (uint256)
469     {
470         if (isETH(token)) {
471             return account.balance;
472         } else {
473             return token.balanceOf(account);
474         }
475     }
476 
477     function isETH(IERC20 token) internal pure returns (bool) {
478         return (address(token) == ETH_ADDRESS);
479     }
480 
481     function rescueFunds(address token, uint256 amount) external onlyOwner {
482         if (isETH(IERC20(token))) {
483             TransferHelper.safeTransferETH(msg.sender, amount);
484         } else {
485             TransferHelper.safeTransfer(token, msg.sender, amount);
486         }
487     }
488 }