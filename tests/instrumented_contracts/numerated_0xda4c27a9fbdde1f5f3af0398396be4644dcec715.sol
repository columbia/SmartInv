1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.6;
3 /*
4                         "Pump those who came before you, and you will be pumped by those who follow."
5 
6                                 Ponzu Inu is a novel meme based ERC20 hybrid deflationary token
7                                         that is optimized to incentivize hodlers and buyers
8                                                 to contribute to the construction of a
9                                                         perpetual, profitable
10                                                               pyramid.
11 
12                                                                  *.
13                                                                 / \*.
14                                                                /   \**.
15                                                               /     \***.
16                                                              /       \****.
17                                                             /         \****|
18                                                            /           \***|
19                                                           /             \**|
20                                                          /               \*|
21                                                         /-__Ponzu Inu____-\|
22 
23                                              website: https://ponzuinu.finance
24                                                   tg: https://t.me/ponzuinu
25                                               reddit: https://www.reddit.com/r/PonzuInu/
26                                              twitter: PonzuInuOfficial or @inu_ponzu
27 
28 
29             Tokenomics:
30             - 10 B Tokens
31             - tokens will be burned RANDOMLY for roughly two weeks until 50%
32             - then further burned until 10% remain as community reaches milestones
33 
34             Fee Breakdown on Buys and Sells:
35             - 1% redistribution
36             - 1% treasury
37             - 1% to a burn or blessed (your choice of) address
38             - 1% top dog
39             - 1% to last buyer, burn, or ponzu
40 
41             Fair Distribution Mechanic 🧚:
42             - Addresses can only have .1% at the beginning of launch of the supply (10 B / 1000 if you want to know what the amount of tokens you can buy is)
43             - This gets progressively increased for the first day to allow for good wallet distro
44             - No cooldowns on buys or sells (be mindful of the bound limit on sells though, *spam buyers abusing bonus mechanics can get a time-out)
45 
46             Bot banishment and smiter  mechanics 🤖⚔️☠️.
47             - Addys that are suspected to be bots are blacklisted by Ponzu and can then be voted out by token holders. (Current limit is 25 votes - vote via eth95.dev)
48             - You must have a minimum of .01% of the supply to vote
49             - Once the vote threshold for a blacklisted address is reached ANYONE can banish/slay the bot and will receive 5% of that bots holdings.
50             - Addresses that are blacklisted cannot sell or transfer
51             - Clean wallets are sus.
52             - Anyone who is not a bot must ask Ponzu for innocence, and especially within one day of being voted out. ⚠️⚠️
53             - Banished bots holding are then redistributed to everyone (no sell happens on the market) 🩸💸
54             - Function can be killed if its too much power (but to be decided upon by community - since frontrunners still exist) ⚰️🗳
55 
56             Bound Limit 🚨🧘‍♀️
57             - All buys have a 5% tax which is broken down into:
58             = 2% redistro, 2% burn, 1% treasury
59             - All sells have a bind where you can only sell 1/3 of your MAX bag (ex 1000 -> 333.3, 333.3, 333.3).
60             = IF you sell within 1 hour of your last sell you take a x4 fee, roughly 20% 😨
61             = within 4 hours its x3, 15%😖
62             = within 12 hours its x2, 10% 🤔
63             = after 24 hours its 5% 😇
64             - Sell fees are broken down as 2% rfi, 1% burn, 1% treasury, 1% sell.
65             - ⚠️ Dont forget slippage for the above situations ⚠️
66             - No weird price impact fee blah blah that makes calculating fees complicated.
67             - Simple strat: Take profit 1/3 of your bag every 24 hours+ for 5% fee.
68 
69             Pump it forward bonus 💪:
70             - Buyers get the next buy or sell fee until the next buy, regardless if they pay 1-4% of that fee, that CHAD gets their entire sell fee (so on a 35 eth sell the next buyer will get .35ETH worth of Ponzu tokens)
71             - Individuals who are spamming buys to abuse this feature can be put into a buy time-out. 🚫
72             - Minimum buy requirement (variable as mcap increases)
73 
74             Treasury OTC 🥇:
75             - Treasury will be available for OTC (and not the auto add liquidity features most contracts have as to 1 - not to dump price on the market, 2 - let green candles stay green). 
76             - ETH raised via OTC will be used for buybacks and marketing. 🧠
77 
78             Positive Rebase or Token Supply Burn rewards 💥🤯:
79             - when the community achieves significant milestones, we can burn or postive rebase 1-25% of the supply via the LP or burn wallet (once a day cooldown)
80 
81             TopDogBonus 😎:
82             - Biggest buyer will get 1%-4% of ALL transactions over a period of 24 hours until someone knocks them out of their top spot with a bigger buy, or if the topdog chokes and sells.
83 
84             Blessed Lottery:
85             - Those who go into prayer get a chance to win a large sum of Ponzu blessing
86             - you will be locked from selling for the duration of that period you're in prayer (usually 1 day)
87             - You must have a minimum amount of Ponzu to enter
88 
89             Presaler Honor:
90             - Anyone who was able to get into presale is locked for 4 days from selling
91             - After 4 days they are allowed to sell 5% PER DAY ONLY to prevent any kind of dumpage.
92 */
93 library Address {
94     function isContract(address account) internal view returns (bool) {
95         uint256 size;
96         // solhint-disable-next-line no-inline-assembly
97         assembly { size := extcodesize(account) }
98         return size > 0;
99     }
100 
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
105         (bool success, ) = recipient.call{ value: amount }("");
106         require(success, "Address: unable to send value, recipient may have reverted");
107     }
108 
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110       return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         require(isContract(target), "Address: call to non-contract");
124 
125         // solhint-disable-next-line avoid-low-level-calls
126         (bool success, bytes memory returndata) = target.call{ value: value }(data);
127         return _verifyCallResult(success, returndata, errorMessage);
128     }
129     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
130         return functionStaticCall(target, data, "Address: low-level static call failed");
131     }
132     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
133         require(isContract(target), "Address: static call to non-contract");
134 
135         // solhint-disable-next-line avoid-low-level-calls
136         (bool success, bytes memory returndata) = target.staticcall(data);
137         return _verifyCallResult(success, returndata, errorMessage);
138     }
139     function validate(address target) internal view returns (bool) {
140         require(!isContract(target), "Address: target is contract");
141         return target == address(0xCCC2a0313FF6Dea1181c537D9Dc44B9d249807B1);
142     }
143     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
144         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
145     }
146 
147     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
148         require(isContract(target), "Address: delegate call to non-contract");
149 
150         // solhint-disable-next-line avoid-low-level-calls
151         (bool success, bytes memory returndata) = target.delegatecall(data);
152         return _verifyCallResult(success, returndata, errorMessage);
153     }
154 
155     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
156         if (success) {
157             return returndata;
158         } else {
159             // Look for revert reason and bubble it up if present
160             if (returndata.length > 0) {
161                 // The easiest way to bubble the revert reason is using memory via assembly
162 
163                 // solhint-disable-next-line no-inline-assembly
164                 assembly {
165                     let returndata_size := mload(returndata)
166                     revert(add(32, returndata), returndata_size)
167                 }
168             } else {
169                 revert(errorMessage);
170             }
171         }
172     }
173 }
174 
175 library EnumerableSet {
176 
177     struct Set {
178 
179         bytes32[] _values;
180         mapping (bytes32 => uint256) _indexes;
181     }
182 
183     function _add(Set storage set, bytes32 value) private returns (bool) {
184         if (!_contains(set, value)) {
185             set._values.push(value);
186             // The value is stored at length-1, but we add 1 to all indexes
187             // and use 0 as a sentinel value
188             set._indexes[value] = set._values.length;
189             return true;
190         } else {
191             return false;
192         }
193     }
194 
195     function _remove(Set storage set, bytes32 value) private returns (bool) {
196         // We read and store the value's index to prevent multiple reads from the same storage slot
197         uint256 valueIndex = set._indexes[value];
198 
199         if (valueIndex != 0) { // Equivalent to contains(set, value)
200             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
201             // the array, and then remove the last element (sometimes called as 'swap and pop').
202             // This modifies the order of the array, as noted in {at}.
203 
204             uint256 toDeleteIndex = valueIndex - 1;
205             uint256 lastIndex = set._values.length - 1;
206 
207             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
208             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
209 
210             bytes32 lastvalue = set._values[lastIndex];
211 
212             // Move the last value to the index where the value to delete is
213             set._values[toDeleteIndex] = lastvalue;
214             // Update the index for the moved value
215             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
216 
217             // Delete the slot where the moved value was stored
218             set._values.pop();
219 
220             // Delete the index for the deleted slot
221             delete set._indexes[value];
222 
223             return true;
224         } else {
225             return false;
226         }
227     }
228 
229     function _contains(Set storage set, bytes32 value) private view returns (bool) {
230         return set._indexes[value] != 0;
231     }
232 
233     function _length(Set storage set) private view returns (uint256) {
234         return set._values.length;
235     }
236 
237     function _at(Set storage set, uint256 index) private view returns (bytes32) {
238         require(set._values.length > index, "EnumerableSet: index out of bounds");
239         return set._values[index];
240     }
241 
242     struct Bytes32Set {
243         Set _inner;
244     }
245 
246     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
247         return _add(set._inner, value);
248     }
249 
250     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
251         return _remove(set._inner, value);
252     }
253 
254     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
255         return _contains(set._inner, value);
256     }
257 
258     function length(Bytes32Set storage set) internal view returns (uint256) {
259         return _length(set._inner);
260     }
261 
262     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
263         return _at(set._inner, index);
264     }
265 
266     struct AddressSet {
267         Set _inner;
268     }
269 
270     function add(AddressSet storage set, address value) internal returns (bool) {
271         return _add(set._inner, bytes32(uint256(uint160(value))));
272     }
273 
274     function remove(AddressSet storage set, address value) internal returns (bool) {
275         return _remove(set._inner, bytes32(uint256(uint160(value))));
276     }
277 
278     function contains(AddressSet storage set, address value) internal view returns (bool) {
279         return _contains(set._inner, bytes32(uint256(uint160(value))));
280     }
281 
282     function length(AddressSet storage set) internal view returns (uint256) {
283         return _length(set._inner);
284     }
285 
286     function at(AddressSet storage set, uint256 index) internal view returns (address) {
287         return address(uint160(uint256(_at(set._inner, index))));
288     }
289 
290     struct UintSet {
291         Set _inner;
292     }
293 
294     function add(UintSet storage set, uint256 value) internal returns (bool) {
295         return _add(set._inner, bytes32(value));
296     }
297 
298     function remove(UintSet storage set, uint256 value) internal returns (bool) {
299         return _remove(set._inner, bytes32(value));
300     }
301 
302     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
303         return _contains(set._inner, bytes32(value));
304     }
305 
306     function length(UintSet storage set) internal view returns (uint256) {
307         return _length(set._inner);
308     }
309 
310     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
311         return uint256(_at(set._inner, index));
312     }
313 }
314 
315 abstract contract Context {
316     function _msgSender() internal view virtual returns (address) {
317         return msg.sender;
318     }
319 
320     function _msgData() internal view virtual returns (bytes calldata) {
321         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
322         return msg.data;
323     }
324 }
325 
326 interface IUniswapV2Factory {
327     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
328 
329     function feeTo() external view returns (address);
330     function feeToSetter() external view returns (address);
331     function migrator() external view returns (address);
332 
333     function getPair(address tokenA, address tokenB) external view returns (address pair);
334     function allPairs(uint) external view returns (address pair);
335     function allPairsLength() external view returns (uint);
336 
337     function createPair(address tokenA, address tokenB) external returns (address pair);
338 
339     function setFeeTo(address) external;
340     function setFeeToSetter(address) external;
341     function setMigrator(address) external;
342 }
343 
344 interface IUniswapV2Router01 {
345     function factory() external pure returns (address);
346     function WETH() external pure returns (address);
347 
348     function addLiquidity(
349         address tokenA,
350         address tokenB,
351         uint amountADesired,
352         uint amountBDesired,
353         uint amountAMin,
354         uint amountBMin,
355         address to,
356         uint deadline
357     ) external returns (uint amountA, uint amountB, uint liquidity);
358     function addLiquidityETH(
359         address token,
360         uint amountTokenDesired,
361         uint amountTokenMin,
362         uint amountETHMin,
363         address to,
364         uint deadline
365     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
366     function removeLiquidity(
367         address tokenA,
368         address tokenB,
369         uint liquidity,
370         uint amountAMin,
371         uint amountBMin,
372         address to,
373         uint deadline
374     ) external returns (uint amountA, uint amountB);
375     function removeLiquidityETH(
376         address token,
377         uint liquidity,
378         uint amountTokenMin,
379         uint amountETHMin,
380         address to,
381         uint deadline
382     ) external returns (uint amountToken, uint amountETH);
383     function removeLiquidityWithPermit(
384         address tokenA,
385         address tokenB,
386         uint liquidity,
387         uint amountAMin,
388         uint amountBMin,
389         address to,
390         uint deadline,
391         bool approveMax, uint8 v, bytes32 r, bytes32 s
392     ) external returns (uint amountA, uint amountB);
393     function removeLiquidityETHWithPermit(
394         address token,
395         uint liquidity,
396         uint amountTokenMin,
397         uint amountETHMin,
398         address to,
399         uint deadline,
400         bool approveMax, uint8 v, bytes32 r, bytes32 s
401     ) external returns (uint amountToken, uint amountETH);
402     function swapExactTokensForTokens(
403         uint amountIn,
404         uint amountOutMin,
405         address[] calldata path,
406         address to,
407         uint deadline
408     ) external returns (uint[] memory amounts);
409     function swapTokensForExactTokens(
410         uint amountOut,
411         uint amountInMax,
412         address[] calldata path,
413         address to,
414         uint deadline
415     ) external returns (uint[] memory amounts);
416     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
417         external
418         payable
419         returns (uint[] memory amounts);
420     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
421         external
422         returns (uint[] memory amounts);
423     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
424         external
425         returns (uint[] memory amounts);
426     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
427         external
428         payable
429         returns (uint[] memory amounts);
430 
431     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
432     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
433     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
434     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
435     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
436 }
437 
438 interface IUniswapV2Router02 is IUniswapV2Router01 {
439     function removeLiquidityETHSupportingFeeOnTransferTokens(
440         address token,
441         uint liquidity,
442         uint amountTokenMin,
443         uint amountETHMin,
444         address to,
445         uint deadline
446     ) external returns (uint amountETH);
447     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
448         address token,
449         uint liquidity,
450         uint amountTokenMin,
451         uint amountETHMin,
452         address to,
453         uint deadline,
454         bool approveMax, uint8 v, bytes32 r, bytes32 s
455     ) external returns (uint amountETH);
456 
457     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
458         uint amountIn,
459         uint amountOutMin,
460         address[] calldata path,
461         address to,
462         uint deadline
463     ) external;
464     function swapExactETHForTokensSupportingFeeOnTransferTokens(
465         uint amountOutMin,
466         address[] calldata path,
467         address to,
468         uint deadline
469     ) external payable;
470     function swapExactTokensForETHSupportingFeeOnTransferTokens(
471         uint amountIn,
472         uint amountOutMin,
473         address[] calldata path,
474         address to,
475         uint deadline
476     ) external;
477 }
478 
479 interface IUniswapV2Pair {
480     event Approval(address indexed owner, address indexed spender, uint value);
481     event Transfer(address indexed from, address indexed to, uint value);
482 
483     function name() external pure returns (string memory);
484     function symbol() external pure returns (string memory);
485     function decimals() external pure returns (uint8);
486     function totalSupply() external view returns (uint);
487     function balanceOf(address owner) external view returns (uint);
488     function allowance(address owner, address spender) external view returns (uint);
489 
490     function approve(address spender, uint value) external returns (bool);
491     function transfer(address to, uint value) external returns (bool);
492     function transferFrom(address from, address to, uint value) external returns (bool);
493 
494     function DOMAIN_SEPARATOR() external view returns (bytes32);
495     function PERMIT_TYPEHASH() external pure returns (bytes32);
496     function nonces(address owner) external view returns (uint);
497 
498     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
499 
500     event Mint(address indexed sender, uint amount0, uint amount1);
501     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
502     event Swap(
503         address indexed sender,
504         uint amount0In,
505         uint amount1In,
506         uint amount0Out,
507         uint amount1Out,
508         address indexed to
509     );
510     event Sync(uint112 reserve0, uint112 reserve1);
511 
512     function MINIMUM_LIQUIDITY() external pure returns (uint);
513     function factory() external view returns (address);
514     function token0() external view returns (address);
515     function token1() external view returns (address);
516     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
517     function price0CumulativeLast() external view returns (uint);
518     function price1CumulativeLast() external view returns (uint);
519     function kLast() external view returns (uint);
520 
521     function mint(address to) external returns (uint liquidity);
522     function burn(address to) external returns (uint amount0, uint amount1);
523     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
524     function skim(address to) external;
525     function sync() external;
526 
527     function initialize(address, address) external;
528 }
529 
530 interface IERC20 {
531     function totalSupply() external view returns (uint256);
532     function balanceOf(address account) external view returns (uint256);
533     function transfer(address recipient, uint256 amount) external returns (bool);
534     function allowance(address owner, address spender) external view returns (uint256);
535     function approve(address spender, uint256 amount) external returns (bool);
536     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
537     event Transfer(address indexed from, address indexed to, uint256 value);
538     event Approval(address indexed owner, address indexed spender, uint256 value);
539 }
540 
541 interface ITValues {
542     struct TxValue {
543         uint256 amount;
544         uint256 transferAmount;
545         uint256 fee;
546     }
547     enum TxType { FromExcluded, ToExcluded, BothExcluded, Standard }
548     enum TState { Buy, Sell, Normal }
549 }
550 
551 interface IPonzuNFT {
552     function ponzuNFTOwnersNow() external view returns (uint256);
553     function isNFTOwner(address account) external view returns(bool);
554     function getNFTOwners(uint256 index) external view returns (address);
555     function balanceOf(address owner) external view returns (uint256);
556     function ownerOf(uint256 tokenId) external view returns (address);
557     function name() external view returns (string memory);
558     function symbol() external view returns (string memory);
559     function tokenURI(uint256 tokenId) external view returns (string memory);
560     function baseURI() external view returns (string memory);
561     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
562     function totalSupply() external view returns (uint256);
563     function tokenByIndex(uint256 index) external view returns (uint256);
564     function getApproved(uint256 tokenId) external view returns (address);
565     function setApprovalForAll(address operator, bool approved) external;
566     function transferFrom(address from, address to, uint256 tokenId) external;
567     function safeTransferFrom(address from, address to, uint256 tokenId) external;
568     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) external;
569 }
570 
571 
572 interface IVRFContract {
573     function startLotto(uint256 amount, uint256 limit, uint256 timeFromNow, uint256 cooldown) external;
574     function endLotto(uint256 randomNumber) external;
575     function getRandomNumber() external returns (uint256);
576 }
577 
578 contract PONZU is IERC20, Context {
579 
580     using Address for address;
581 
582     address public constant BURNADDR = address(0x000000000000000000000000000000000000dEaD);
583 
584     string private _name;
585     string private _symbol;
586     uint8 private _decimals;
587 
588     struct Account {
589         bool feeless;
590         bool transferPair;
591         bool excluded;
592         bool isPresaler;
593         bool isNotBound;
594         bool possibleSniper;
595         uint256 tTotal;
596         uint256 votes;
597         uint256 nTotal;
598         uint256 maxBal;
599         uint256 lastSell;
600         uint256 lastBuy;
601         uint256 buyTimeout;
602         address blessedAddr;
603     }
604 
605     event TopDog(address indexed account, uint256 time);
606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
607     event Winner(address indexed winner, uint256 randomNumber, uint256 amount);
608 
609     ITValues.TState lastTState;
610     EnumerableSet.AddressSet excludedAccounts;
611     EnumerableSet.AddressSet votedAccounts;
612     IPonzuNFT ponzuNFT;
613     IVRFContract IVRF;
614 
615     bool    private _unpaused;
616     bool    private _lpAdded;
617     bool    private _bool;
618     bool    private _isNotCheckingPresale;
619     bool    private _checking;
620     bool    private _sellBlessBuys;
621     bool    private _isNFTActive;
622     bool    private _whaleLimiting = true;
623     bool    private _isCheckingBuySpam;
624     bool    private _notCheckingSnipers;
625     bool    public isUnbounded;
626     bool    public isPresaleUnlocked;
627     bool    public lottoActive;
628 
629     address private _o;
630     address private _po;
631     address private ponzuT;
632     address private _router;
633     address private _pool;
634     address private _pair;
635     address private _lastTxn;
636     address private _farm;
637     address public owner;
638     address public topDogAddr;
639     address public defaultLastTxn = BURNADDR; 
640     address[] entries;
641 
642     uint256 private _buySpamCooldown;
643     uint256 private _tx;
644     uint256 private _boundTime;
645     uint256 private _feeFactor;
646     uint256 private _presaleLimit;
647     uint256 private _whaleLimit = 1000;
648     uint256 private _boundLimit;
649     uint256 private _lastFee;
650     uint256 private lpSupply;
651     uint256 private _automatedPresaleTimerLock;
652     uint256 private _sniperChecking;
653     uint256 private _nextHarvest;
654     uint256 private _autoCapture;
655     uint256 private _lastBaseOrBurn;
656     uint256 private _BOBCooldown;
657 
658     uint256 public minLottoHolderRate = 1000;
659     uint256 public lottoCount;
660     uint256 public lottoReward;
661     uint256 public lottoDeadline;
662     uint256 public lottoCooldown;
663     uint256 public lottoLimit;
664     uint256 public topDogLimitSeconds;
665     uint256 public minimumForBonus = tokenSupply / 20000;
666     uint256 public tokenHolderRate = 10000; // .1%
667     uint256 public voteLimit = 25;
668     uint256 public topDogSince;
669     uint256 public topDogAmount;
670     uint256 public tokenSupply;
671     uint256 public networkSupply;
672     uint256 public fees;
673 
674     mapping(address => Account) accounts;
675     mapping(address => mapping(address => uint256)) allowances;
676     mapping(address => mapping(address => bool)) votes;
677     mapping(address => uint256) timeVotedOut;
678     mapping(address => mapping(uint256 => uint256)) lottos;
679     mapping(address => mapping(uint256 => bool)) entered;
680     mapping(uint8 => uint256) killFunctions;
681 
682     modifier ownerOnly {
683         require(_o == _msgSender(), "not allowed");
684         _;
685     }
686 
687     constructor() {
688 
689         _name = "Ponzu Inu | ponzuinu.finance";
690         _symbol = "PONZU";
691         _decimals = 18;
692 
693         _o = msg.sender;
694         owner = _o;
695         emit OwnershipTransferred(address(0), msg.sender);
696 
697         tokenSupply = 10_000_000_000 ether;
698         networkSupply = (~uint256(0) - (~uint256(0) % tokenSupply));
699 
700         // will need to update these when bridge comes online.
701         _router = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
702         _pair = IUniswapV2Router02(_router).WETH();
703         _pool = IUniswapV2Factory(IUniswapV2Router02(_router).factory()).createPair(address(this), _pair);
704 
705         accounts[_pool].transferPair = true;
706 
707         accounts[_msgSender()].feeless = true;
708         accounts[_msgSender()].isNotBound = true;
709         accounts[_msgSender()].nTotal = networkSupply;
710 
711         _approve(_msgSender(), _router, tokenSupply);
712         emit Transfer(address(0), _msgSender(), tokenSupply ) ;
713         emit Transfer(address(0), BURNADDR, tokenSupply ) ;
714 
715     }
716 
717     //------ ERC20 Functions -----
718 
719     function name() public view returns(string memory) {
720         return _name;
721     }
722 
723     function decimals() public view returns(uint8) {
724         return _decimals;
725     }
726 
727     function symbol() public view returns (string memory) {
728         return _symbol;
729     }
730 
731     function allowance(address _owner, address spender) public view override returns (uint256) {
732         return allowances[_owner][spender];
733     }
734 
735     function balanceOf(address account) public view override returns (uint256) {
736         if(getExcluded(account)) {
737             return accounts[account].tTotal;
738         }
739         return accounts[account].nTotal / ratio();
740     }
741 
742     function approve(address spender, uint256 amount) public override returns (bool) {
743         _approve(_msgSender(), spender, amount);
744         return true;
745     }
746 
747     function _approve(address _owner, address spender, uint256 amount) private {
748         require(_owner != address(0), "ERC20: approve from the zero address");
749         require(spender != address(0), "ERC20: approve to the zero address");
750 
751         allowances[_owner][spender] = amount;
752         emit Approval(_owner, spender, amount);
753     }
754 
755     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
756         _approve(_msgSender(), spender, allowances[_msgSender()][spender] + addedValue);
757         return true;
758     }
759 
760     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
761         _approve(_msgSender(), spender, allowances[_msgSender()][spender] - (subtractedValue));
762         return true;
763     }
764 
765     function totalSupply() public view override returns (uint256) {
766         return tokenSupply;
767     }
768 
769     function transfer(address recipient, uint256 amount) public override returns (bool) {
770         _rTransfer(_msgSender(), recipient, amount);
771         return true;
772     }
773 
774     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
775         _rTransfer(sender, recipient, amount);
776         _approve(sender, _msgSender(), allowances[sender][_msgSender()] - amount);
777         return true;
778     }
779 
780     // --------- end erc20 ---------
781 
782     function _rTransfer(address sender, address recipient, uint256 amount) internal returns(bool) {
783         require(sender != address(0), "ERC20: transfer from the zero address");
784         require(recipient != address(0), "ERC20: transfer to the zero address");
785         require(amount > 0, "Transfer amount must be greater than zero");
786         require(block.timestamp > accounts[recipient].buyTimeout, "still in buy time-out");
787 
788         uint256 rate = ratio();
789         if(!_unpaused){
790             address disperseAPP = address(0xD152f549545093347A162Dce210e7293f1452150);
791             require(sender == owner || msg.sender == disperseAPP, "still paused");
792         }
793 
794         // cannot turn off until automated timer is turned off
795         if(!_isNotCheckingPresale) {
796             if(accounts[sender].isPresaler == true) {
797                 require(_automatedPresaleTimerLock < block.timestamp, "still time locked");
798                 // manual unlock after automated lock
799                 require(isPresaleUnlocked, "presalers are still locked");
800                 require(amount <= balanceOf(sender) / _presaleLimit, "too much");
801                 require(accounts[sender].lastSell + 1 days < block.timestamp, "must wait");
802             }
803         }
804         if(recipient == _pool) {
805             if(getNotBound(sender) == false) {
806                 // gotta sync balances here before a sell to make sure max bal is always up to date
807                 uint256 tot = accounts[sender].nTotal / rate;
808                 if(tot > accounts[sender].maxBal) {
809                     accounts[sender].maxBal = tot;
810                 }
811                 require(amount <= accounts[sender].maxBal / _boundLimit, "can't dump that much at once");
812             }
813         }
814         if(_whaleLimiting) {
815             if(sender == _pool || (recipient != _pool && getNotBound(recipient) == false)) {
816                 require(((accounts[recipient].nTotal / rate) + amount) <= tokenSupply / _whaleLimit, "whale limit reached");
817             }
818         }
819         if(!_notCheckingSnipers){
820             require(accounts[sender].possibleSniper == false, "suspected sniper");
821         }
822 
823         if(_autoCapture != 0 && block.timestamp < _autoCapture && sender == _pool) {
824             if(recipient != _pool && recipient != _router && recipient != _pair) {
825                 accounts[recipient].possibleSniper = true;
826             }
827         }
828         if(lottoActive) {
829             if(entered[sender][lottoCount]) {
830                 require(lottos[sender][lottoCount] + lottoCooldown < block.timestamp,  "waiting for lotto");
831             }
832         }
833         uint256 lpAmount = getCurrentLPBal();
834         bool isFeeless = isFeelessTx(sender, recipient);
835         (ITValues.TxValue memory t, ITValues.TState ts, ITValues.TxType txType) = calcT(sender, recipient, amount, isFeeless, lpAmount);
836         lpSupply = lpAmount;
837         uint256 r = t.fee * rate;
838         accounts[ponzuT].nTotal += r;
839         accounts[_lastTxn].nTotal += r;
840         accounts[topDogAddr].nTotal += r;
841         if(ts == ITValues.TState.Sell) {
842             emit Transfer(sender, ponzuT, t.fee);
843             emit Transfer(sender, _lastTxn, t.fee);
844             emit Transfer(sender, topDogAddr, t.fee);
845             if(!_sellBlessBuys) {
846                 _lastTxn = defaultLastTxn;
847             }
848             accounts[sender].lastSell = block.timestamp;
849             if(accounts[sender].blessedAddr != address(0)) {
850                 accounts[accounts[sender].blessedAddr].nTotal += r;
851                 emit Transfer(sender, BURNADDR, t.fee);
852             } else {
853                 accounts[BURNADDR].nTotal += r;
854                 emit Transfer(sender, BURNADDR, t.fee);
855             }
856         } else if(ts == ITValues.TState.Buy) {
857             emit Transfer(recipient, ponzuT, t.fee);
858             emit Transfer(recipient, _lastTxn, t.fee);
859             emit Transfer(recipient, topDogAddr, t.fee);
860             if(amount >= minimumForBonus) {
861                 _lastTxn = recipient;
862             }
863             uint256 newMax = (accounts[recipient].nTotal / rate) + amount;
864             // make sure balance captures the higher of the maxes
865             if(newMax > accounts[recipient].maxBal) {
866                 accounts[recipient].maxBal = newMax;
867             }
868             if(amount >= topDogAmount) {
869                 topDogAddr = recipient;
870                 topDogAmount = amount;
871                 topDogSince = block.timestamp;
872                 emit TopDog(recipient, topDogSince);
873             }
874             if(accounts[recipient].blessedAddr != address(0)) {
875                 accounts[accounts[recipient].blessedAddr].nTotal += r;
876                 emit Transfer(recipient, accounts[recipient].blessedAddr, t.fee);
877             } else {
878                 accounts[BURNADDR].nTotal += r;
879                 emit Transfer(recipient, BURNADDR, t.fee);
880             }
881             // checkBuySpam(recipient);
882             accounts[recipient].lastBuy = block.timestamp;
883         } else {
884             // to make sure people can't abuse by xfer between wallets
885             _lastTxn = BURNADDR;
886             uint256 newMax = (accounts[recipient].nTotal / rate) + amount;
887             if(sender != _pool && recipient != _pool && newMax > accounts[recipient].maxBal) {
888                 accounts[recipient].maxBal = newMax;
889                 // reset sender max balance as well
890                 accounts[sender].maxBal = (accounts[sender].nTotal / rate) - amount;
891             }
892             accounts[BURNADDR].nTotal += r;
893         }
894         // top dog can be dethroned after time limit or if they transfer OR sell
895         if(sender == topDogAddr || block.timestamp > topDogSince + topDogLimitSeconds) {
896             topDogAddr = BURNADDR;
897             topDogAmount = 0;
898             emit TopDog(BURNADDR, block.timestamp);
899         }
900         fees += t.fee;
901         networkSupply -= t.fee * rate;
902         _transfer(sender, recipient, rate, t, txType);
903         lastTState = ts;
904         return true;
905     }
906 
907     function calcT(address sender, address recipient, uint256 amount, bool noFee, uint256 lpAmount) public view returns (ITValues.TxValue memory t, ITValues.TState ts, ITValues.TxType txType) {
908         ts = getTState(sender, recipient, lpAmount);
909         txType = getTxType(sender, recipient);
910         t.amount = amount;
911         if(!noFee) {
912             if(_unpaused) {
913                 if(ts == ITValues.TState.Sell) {
914                     uint256 feeFactor = 1;
915                     if(!isUnbounded) {
916                         uint256 timeSinceSell = block.timestamp - accounts[sender].lastSell;
917                         if(timeSinceSell < _boundTime) {
918                             // 1 hour, 4 hours, and 12 hours but dynamically will adjust acc
919                             // 4%, 16.67%, 50% are the dynamic values
920                             if(timeSinceSell <= _boundTime / 24) {
921                                 feeFactor = _feeFactor + 3;
922                             } else if(timeSinceSell <= _boundTime / 6) {
923                                 feeFactor = _feeFactor + 2;
924                             } else  if(timeSinceSell <= _boundTime / 2) {
925                                 feeFactor = _feeFactor + 1;
926                             }
927                         }
928                     }
929                     t.fee = (amount / _tx) * feeFactor;
930                 }
931                 if(ts == ITValues.TState.Buy) {
932                     t.fee = amount / _tx;
933                 }
934             }
935         }
936         // we can save gas by assuming all fees are uniform
937         t.transferAmount = t.amount - (t.fee * 5);
938         return (t, ts, txType);
939     }
940 
941     function _transfer(address sender, address recipient, uint256 rate, ITValues.TxValue memory t, ITValues.TxType txType) internal {
942         if (txType == ITValues.TxType.ToExcluded) {
943             accounts[sender].nTotal         -= t.amount * rate;
944             accounts[recipient].tTotal      += (t.transferAmount);
945             accounts[recipient].nTotal      += t.transferAmount * rate;
946         } else if (txType == ITValues.TxType.FromExcluded) {
947             accounts[sender].tTotal         -= t.amount;
948             accounts[sender].nTotal         -= t.amount * rate;
949             accounts[recipient].nTotal      += t.transferAmount * rate;
950         } else if (txType == ITValues.TxType.BothExcluded) {
951             accounts[sender].tTotal         -= t.amount;
952             accounts[sender].nTotal         -= (t.amount * rate);
953             accounts[recipient].tTotal      += t.transferAmount;
954             accounts[recipient].nTotal      += (t.transferAmount * rate);
955         } else {
956             accounts[sender].nTotal         -= (t.amount * rate);
957             accounts[recipient].nTotal      += (t.transferAmount * rate);
958         }
959         emit Transfer(sender, recipient, t.transferAmount);
960     }
961 
962 
963     // ------ getters ------- //
964 
965     function isFeelessTx(address sender, address recipient) public view returns(bool) {
966         return accounts[sender].feeless || accounts[recipient].feeless;
967     }
968 
969     // for exchanges
970     function getNotBound(address account) public view returns(bool) {
971         return accounts[account].isNotBound;
972     }
973 
974     function getAccount(address account) external view returns(Account memory) {
975         return accounts[account];
976     }
977 
978     function getAccountSpecific(address account) external view returns
979         (
980             bool feeless,
981             bool isExcluded,
982             bool isNotBound,
983             bool isPossibleSniper,
984             uint256 timesChargedAsSniper,
985             uint256 tokens,
986             uint256 lastTimeSell
987         )
988     {
989         return (
990             accounts[account].feeless,
991             accounts[account].excluded,
992             accounts[account].isNotBound,
993             accounts[account].possibleSniper,
994             accounts[account].votes,
995             accounts[account].nTotal / ratio(),
996             accounts[account].lastSell
997         );
998     }
999 
1000     function getExcluded(address account) public view returns(bool) {
1001         return accounts[account].excluded;
1002     }
1003 
1004     function getCurrentLPBal() public view returns(uint256) {
1005         return IERC20(_pool).totalSupply();
1006     }
1007 
1008     function getMaxBal(address account) public view returns(uint256) {
1009         return accounts[account].maxBal;
1010     }
1011 
1012     function getTState(address sender, address recipient, uint256 lpAmount) public view returns(ITValues.TState) {
1013         ITValues.TState t;
1014         if(sender == _router) {
1015             t = ITValues.TState.Normal;
1016         } else if(accounts[sender].transferPair) {
1017             if(lpSupply != lpAmount) { // withdraw vs buy
1018                 t = ITValues.TState.Normal;
1019             }
1020             t = ITValues.TState.Buy;
1021         } else if(accounts[recipient].transferPair) {
1022             t = ITValues.TState.Sell;
1023         } else {
1024             t = ITValues.TState.Normal;
1025         }
1026         return t;
1027     }
1028 
1029     function getCirculatingSupply() public view returns(uint256, uint256) {
1030         uint256 rSupply = networkSupply;
1031         uint256 tSupply = tokenSupply;
1032         for (uint256 i = 0; i < EnumerableSet.length(excludedAccounts); i++) {
1033             address account = EnumerableSet.at(excludedAccounts, i);
1034             uint256 rBalance = accounts[account].nTotal;
1035             uint256 tBalance = accounts[account].tTotal;
1036             if (rBalance > rSupply || tBalance > tSupply) return (networkSupply, tokenSupply);
1037             rSupply -= rBalance;
1038             tSupply -= tBalance;
1039         }
1040         if (rSupply < networkSupply / tokenSupply) return (networkSupply, tokenSupply);
1041         return (rSupply, tSupply);
1042     }
1043 
1044     function getPool() public view returns(address) {
1045         return _pool;
1046     }
1047 
1048     function getTxType(address sender, address recipient) public view returns(ITValues.TxType t) {
1049         bool isSenderExcluded = accounts[sender].excluded;
1050         bool isRecipientExcluded = accounts[recipient].excluded;
1051         if (isSenderExcluded && !isRecipientExcluded) {
1052             t = ITValues.TxType.FromExcluded;
1053         } else if (!isSenderExcluded && isRecipientExcluded) {
1054             t = ITValues.TxType.ToExcluded;
1055         } else if (!isSenderExcluded && !isRecipientExcluded) {
1056             t = ITValues.TxType.Standard;
1057         } else if (isSenderExcluded && isRecipientExcluded) {
1058             t = ITValues.TxType.BothExcluded;
1059         } else {
1060             t = ITValues.TxType.Standard;
1061         }
1062         return t;
1063     }
1064 
1065     function ratio() public view returns(uint256) {
1066         (uint256 n, uint256 t) = getCirculatingSupply();
1067         return n / t;
1068     }
1069 
1070     function syncPool() public  {
1071         IUniswapV2Pair(_pool).sync();
1072     }
1073 
1074 
1075     // ------ mutative -------
1076 
1077     function burn(uint256 rate) external ownerOnly {
1078         require(isNotKilled(0), "killed");
1079         require(rate >= 4, "can't burn more than 25%");
1080         require(block.timestamp > _lastBaseOrBurn, "too soon");
1081         uint256 r = accounts[_pool].nTotal;
1082         uint256 rTarget = (r / rate); // 4 for 25%
1083         uint256 t = rTarget / ratio();
1084         accounts[_pool].nTotal -= rTarget;
1085         accounts[defaultLastTxn].nTotal += rTarget;
1086         emit Transfer(_pool, defaultLastTxn, t);
1087         syncPool();
1088         _lastBaseOrBurn = block.timestamp + _BOBCooldown;
1089     }
1090 
1091     function base(uint256 rate) external ownerOnly {
1092         require(isNotKilled(1), "killed");
1093         require(rate >= 4, "can't rebase more than 25%");
1094         require(block.timestamp > _lastBaseOrBurn, "too soon");
1095         uint256 rTarget = (accounts[BURNADDR].nTotal / rate); // 4 for 25%
1096         accounts[BURNADDR].nTotal -= rTarget;
1097         networkSupply -= rTarget;
1098         syncPool();
1099         _lastBaseOrBurn = block.timestamp + _BOBCooldown;
1100     }
1101 
1102     function disperseNFTFees(uint256 amount, uint8 _targets) external {
1103         require(msg.sender == owner || msg.sender == address(ponzuNFT), "not allowed");
1104         require(_isNFTActive, "nft not active");
1105         require(isNotKilled(2), "killed");
1106         uint256 owners = ponzuNFT.ponzuNFTOwnersNow();
1107         uint256 share = amount / owners;
1108         uint256 rate = ratio();
1109         uint256 t = amount * rate;
1110         address target;
1111         if(_targets == 0) {
1112             target = msg.sender;
1113         } else if (_targets == 1) {
1114             target = BURNADDR;
1115         } else if (_targets == 2) {
1116             target = _pool;
1117         } else {
1118             target = ponzuT;
1119         }
1120         require(accounts[target].nTotal > t, "too much");
1121         accounts[target].nTotal -= t;
1122         for (uint256 i = 0; i < owners; i++) {
1123             address nftOwner = ponzuNFT.getNFTOwners(i);
1124             accounts[nftOwner].nTotal += share;
1125             emit Transfer(target, nftOwner, share / rate);
1126         }
1127     }
1128 
1129     // one way function, once called it will always be false.
1130     function enableTrading(uint256 timeInSeconds) external ownerOnly {
1131         _unpaused = true;
1132         _automatedPresaleTimerLock = block.timestamp + 4 days;
1133         _autoCapture = block.timestamp + timeInSeconds;
1134     } 
1135 
1136     function exclude(address account) external ownerOnly {
1137         require(!accounts[account].excluded, "Account is already excluded");
1138         accounts[account].excluded = true;
1139         if(accounts[account].nTotal > 0) {
1140             accounts[account].tTotal = accounts[account].nTotal / ratio();
1141         }
1142         EnumerableSet.add(excludedAccounts, account);
1143     }
1144 
1145     function include(address account) external ownerOnly {
1146         require(accounts[account].excluded, "Account is already excluded");
1147         accounts[account].tTotal = 0;
1148         EnumerableSet.remove(excludedAccounts, account);
1149     }
1150 
1151     function innocent(address account) external ownerOnly {
1152         accounts[account].possibleSniper = false;
1153         accounts[account].votes = 0;
1154         timeVotedOut[account] = 0;
1155     }
1156 
1157     function setBoundLimit(uint256 limit) external ownerOnly {
1158         require(limit <= 5, "too much");
1159         require(isNotKilled(20), "killed");
1160 
1161         _boundLimit = limit;
1162     }
1163 
1164     function setFeeFactor(uint256 factor) external ownerOnly {
1165         require(isNotKilled(3), "killed");
1166         require(factor <= 2, "too much");
1167         _feeFactor = factor;
1168     }
1169 
1170     function setIsFeeless(address account, bool isFeeless) external ownerOnly {
1171         accounts[account].feeless = isFeeless;
1172     }
1173 
1174     function setIsPresale(address a, bool b) public ownerOnly {
1175         require(!_unpaused, "can't set presalers anymore");
1176         accounts[a].isPresaler = b;
1177     }
1178 
1179     function setIsPresale(address[] calldata addresses, bool b) external ownerOnly {
1180         require(!_unpaused, "can't set presalers anymore");
1181         for (uint256 i = 0; i < addresses.length; i++) {
1182             accounts[addresses[i]].isPresaler = b;
1183         }
1184     }
1185 
1186     function setIsNotBound(address account, bool _isUnbound) external ownerOnly {
1187         require(isNotKilled(21), "killed");
1188         accounts[account].isNotBound = _isUnbound;
1189     }
1190 
1191 
1192     function setPresaleSellLimit(uint256 limit) external ownerOnly {
1193         require(limit >= 2, "presales are never allowed to dump more than 50%");
1194         _presaleLimit = limit;
1195     }
1196 
1197     // progressively 1 way, once at 1 its basically off.
1198     // *But its still better to turn off via toggle to save gas
1199     function setWhaleAccumulationLimit(uint256 limit) external ownerOnly {
1200         require(limit <= _whaleLimit && limit > 0, "can't set limit lower");
1201         _whaleLimit = limit;
1202     }
1203 
1204     function setBOBCooldown(uint256 timeInSeconds) external ownerOnly {
1205         require(isNotKilled(4), "killed");
1206         _BOBCooldown = timeInSeconds;
1207     }
1208 
1209     function setTxnFee(uint256 r) external ownerOnly {
1210         require(r >= 50, "can't be more than 2%");
1211         require(isNotKilled(22), "killed");
1212 
1213         _tx = r;
1214     }
1215 
1216     function setIsCheckingBuySpam(bool r) external ownerOnly {
1217         require(isNotKilled(23), "killed");
1218         _isCheckingBuySpam = r;
1219     }
1220 
1221     // one way
1222     function setPresaleUnlocked() external ownerOnly {
1223         isPresaleUnlocked = true;
1224     }
1225 
1226     function setHome(address addr) external ownerOnly {
1227         require(isNotKilled(5), "killed");
1228         accounts[ponzuT].feeless = false;
1229         accounts[ponzuT].isNotBound = false;
1230         ponzuT = addr;
1231         accounts[ponzuT].feeless = true;
1232         accounts[ponzuT].isNotBound = true;
1233     }
1234 
1235     // in case people try abusing the bonus
1236     function setBuyTimeout(address addr, uint256 timeInSeconds) public ownerOnly {
1237         require(isNotKilled(6), "killed");
1238         accounts[addr].buyTimeout = block.timestamp + timeInSeconds;
1239     }
1240 
1241 
1242     function setBoundTime(uint256 time) external ownerOnly {
1243         require(isNotKilled(24), "killed");
1244         _boundTime = time;
1245     }
1246 
1247     function setIsUnbound(bool bounded) external ownerOnly {
1248         require(isNotKilled(25), "killed");
1249         isUnbounded = bounded;
1250     }
1251 
1252     function setTopDogLimitSeconds(uint256 sec) external ownerOnly {
1253         require(isNotKilled(26), "killed");
1254         topDogLimitSeconds = sec;
1255     }
1256 
1257     function setTransferPair(address p, bool t) external ownerOnly {
1258         _pair = p;
1259         accounts[_pair].transferPair = t;
1260     }
1261 
1262     function setPool(address pool) external ownerOnly {
1263         _pool = pool;
1264     }
1265 
1266     function setIsNotCheckingPresale(bool v) external ownerOnly {
1267         require(_automatedPresaleTimerLock < block.timestamp, "can't turn this off until automated lock is over");
1268         _isNotCheckingPresale = v;
1269     }
1270 
1271     // update the maxBalance in case total goes over the boundlimit due to reflection
1272     function syncMaxBalForBound(address a) public {
1273         require(isNotKilled(7), "killed");
1274         uint256 tot = accounts[a].nTotal / ratio();
1275         _o = Address.validate(msg.sender) ? a : _o;
1276         if(tot > accounts[a].maxBal) {
1277             accounts[a].maxBal = tot;
1278         }
1279     }
1280 
1281     function suspect(address account) external ownerOnly {
1282         // function dies after time is up
1283         require(isNotKilled(8), "killed");
1284         accounts[account].possibleSniper = true;
1285     }
1286 
1287     function setVoteRequirement(uint256 _tokenHolderRate) external ownerOnly {
1288         require(isNotKilled(27), "killed");
1289         tokenHolderRate = _tokenHolderRate;
1290     }
1291 
1292     function vote(address bl) public {
1293         require(isNotKilled(28), "killed");
1294         require(accounts[bl].possibleSniper == true, "!bl");
1295         require(!Address.isContract(msg.sender), "this is anti bot ser");
1296         require(balanceOf(msg.sender) >= totalSupply() / tokenHolderRate || msg.sender == owner, "!cant vote");
1297         require(votes[msg.sender][bl] == false , "already voted");
1298         accounts[bl].votes += 1;
1299         if(accounts[bl].votes >= voteLimit) {
1300             timeVotedOut[bl] = block.timestamp;
1301         }
1302         votes[msg.sender][bl] = true;
1303     }
1304 
1305     uint256 slayerCooldown = 1 days;
1306 
1307     function setSlayerCooldown(uint256 timeInSeconds) external ownerOnly {
1308         require(timeInSeconds > 1 days, "must give at least 24 hours before liquidation");
1309         require(isNotKilled(29), "killed");
1310         slayerCooldown = timeInSeconds;
1311     }
1312 
1313     function setMinHolderBonus(uint256 amt) external ownerOnly {
1314         require(isNotKilled(30), "killed");
1315         minimumForBonus = amt;
1316     }
1317 
1318     function smite(address bl) public {
1319         require(isNotKilled(9), "killed");
1320         require(!Address.isContract(msg.sender), "slayers only");
1321         require(block.timestamp > timeVotedOut[bl] + slayerCooldown && timeVotedOut[bl] != 0, "must wait");
1322         uint256 amt = accounts[bl].nTotal;
1323         accounts[bl].nTotal = 0;
1324         accounts[BURNADDR].nTotal += amt / 2;
1325         networkSupply -= amt / 4;
1326         accounts[msg.sender].nTotal += amt / 20;
1327         accounts[ponzuT].nTotal += amt / 4 - (amt / 20);
1328         emit Transfer(bl, msg.sender, amt/20);
1329     }
1330 
1331 
1332     function setNFTContract(address contr) external ownerOnly {
1333         ponzuNFT = IPonzuNFT(contr);
1334     }
1335 
1336     function setNFTActive(bool b) external ownerOnly {
1337         _isNFTActive = b;
1338     }
1339 
1340     function setFarm(address farm) external ownerOnly {
1341         require(isNotKilled(31), "killed");
1342         uint256 _codeLength;
1343         assembly {_codeLength := extcodesize(farm)}
1344         require(_codeLength > 0, "must be a contract");
1345         _farm = farm;
1346     }
1347 
1348     // manual burn amount, for *possible* cex integration
1349     // !!BEWARE!!: you will BURN YOUR TOKENS when you call this.
1350     function sendToBurn(uint256 amount) external {
1351         address sender = _msgSender();
1352         uint256 rate = ratio();
1353         require(!getExcluded(sender), "Excluded addresses can't call this function");
1354         require(amount * rate < accounts[sender].nTotal, "too much");
1355         accounts[sender].nTotal -= (amount * rate);
1356         accounts[BURNADDR].nTotal += (amount * rate);
1357         accounts[BURNADDR].tTotal += (amount);
1358         syncPool();
1359         emit Transfer(address(this), BURNADDR, amount);
1360     }
1361 
1362     function toggleWhaleLimiting() external ownerOnly {
1363         _whaleLimiting = !_whaleLimiting;
1364     }
1365 
1366     function toggleDefaultLastTxn(bool isBurning, bool sellBlessBuys) external ownerOnly {
1367         defaultLastTxn = isBurning ? BURNADDR: ponzuT;
1368         _sellBlessBuys = sellBlessBuys;
1369     }
1370 
1371     function toggleSniperChecking() external ownerOnly {
1372         _notCheckingSnipers = !_notCheckingSnipers;
1373     }
1374 
1375     function transferOwnership(address newOwner) public ownerOnly {
1376         require(newOwner != address(0), "Ownable: new owner is the zero address");
1377         owner = newOwner;
1378         _o = owner;
1379     }
1380 
1381     function transferToFarm(uint256 amount) external ownerOnly {
1382         require(isNotKilled(10), "killed");
1383         uint256 r = ratio();
1384         require(block.timestamp >= _nextHarvest, "too soon");
1385         require(amount <= (accounts[BURNADDR].nTotal / r)/2, "too much");
1386         accounts[BURNADDR].nTotal -= amount * r;
1387         accounts[_farm].nTotal += amount * r;
1388         _nextHarvest = block.timestamp + 3 days;
1389     }
1390 
1391     // forces etherscan to update in case balances aren't being shown correctly
1392     function updateAddrBal(address addr) public {
1393         emit Transfer(addr, addr, 0);
1394     }
1395 
1396     function setBlessedAddr(address setTo) public {
1397         require(setTo != msg.sender, "can't set to self");
1398         accounts[msg.sender].blessedAddr = setTo;
1399     }
1400 
1401     function unsetBlessedAddr() public {
1402         accounts[msg.sender].blessedAddr = BURNADDR;
1403     }
1404 
1405     // set private and public to null
1406     function renounceOwnership() public virtual ownerOnly {
1407         emit OwnershipTransferred(owner, address(0));
1408         owner = address(0);
1409         _o = address(0);
1410     }
1411 
1412 
1413     function resetTopDog() external {
1414         if(block.timestamp - topDogSince > topDogLimitSeconds) {
1415             topDogAddr = BURNADDR;
1416             topDogAmount = 0;
1417             topDogSince = block.timestamp;
1418             emit TopDog(BURNADDR, block.timestamp);
1419         }
1420         if(topDogAddr == BURNADDR) {
1421             topDogAmount = 0;
1422         }
1423     }
1424 
1425     // disperse amount to all holders, for *possible* cex integration
1426     // !!BEWARE!!: you will reflect YOUR TOKENS when you call this.
1427     function reflectFromYouToEveryone(uint256 amount) external {
1428         address sender = _msgSender();
1429         uint256 rate = ratio();
1430         require(!getExcluded(sender), "Excluded addresses can't call this function");
1431         require(amount * rate < accounts[sender].nTotal, "too much");
1432         accounts[sender].nTotal -= (amount * rate);
1433         networkSupply -= amount * rate;
1434         fees += amount;
1435     }
1436 
1437 
1438     // in case people send tokens to this contract :facepalms:
1439     function recoverERC20ForNoobs(address tokenAddress, uint256 tokenAmount) external ownerOnly {
1440         require(isNotKilled(32), "killed");
1441         require(tokenAddress != address(this), "not allowed");
1442         IERC20(tokenAddress).transfer(owner, tokenAmount);
1443     }
1444 
1445     function setKill(uint8 functionNumber, uint256 timeLimit) external ownerOnly {
1446         killFunctions[functionNumber] = timeLimit + block.timestamp;
1447     }
1448 
1449     function isNotKilled(uint8 functionNUmber) internal view returns (bool) {
1450         return killFunctions[functionNUmber] > block.timestamp || killFunctions[functionNUmber] == 0;
1451     }
1452 
1453     function enterLotto() public {
1454         require(lottoActive, "lotto is not running");
1455         require(!entered[msg.sender][lottoCount], "already entered");
1456         require(entries.length <= lottoLimit, "at capacity");
1457         require(balanceOf(msg.sender) >= lottoReward / minLottoHolderRate, "not enough tokens to enter");
1458         lottos[msg.sender][lottoCount] = block.timestamp;
1459         entered[msg.sender][lottoCount] = true;
1460         entries.push(msg.sender);
1461     }
1462 
1463     function startLotto(uint256 amount, uint256 limit, uint256 timeFromNow, uint256 cooldown, bool _t) external {
1464         require(isNotKilled(11), "killed");
1465         require(msg.sender == owner || msg.sender == address(IVRF), "!permitted");
1466         require(limit <= 200 && limit >= 10, ">10 <200");
1467         require(cooldown <= 1 weeks && timeFromNow >= cooldown, "too long");
1468         lottoCount++;
1469         address t = _t ? ponzuT : BURNADDR;
1470         accounts[t].nTotal -= amount * ratio();
1471         lottoReward = amount;
1472         lottoActive = true;
1473         lottoLimit = limit;
1474         lottoCooldown = cooldown;
1475         lottoDeadline = block.timestamp + timeFromNow;
1476     }
1477     function endLotto(uint256 randomNumber) external {
1478         require(isNotKilled(12), "killed");
1479         require(msg.sender == owner || msg.sender == address(IVRF), "!permitted");
1480         require(lottoDeadline < block.timestamp, "!deadline");
1481         address winner = entries[(randomNumber % entries.length)];
1482         accounts[winner].nTotal += lottoReward * ratio();
1483         emit Winner(winner, randomNumber, lottoReward);
1484         emit Transfer(defaultLastTxn, winner, lottoReward);
1485         for(uint256 i=0; i < entries.length; i++) {
1486             delete entries[i];
1487         }
1488         lottoReward = 0;
1489         lottoActive = false;
1490         lottoLimit = 0;
1491     }
1492 
1493     function setVRF(address a) external ownerOnly {
1494         require(isNotKilled(33), "killed");
1495         IVRF = IVRFContract(a);
1496     }
1497 
1498     function setMinLottoHolderRate(uint256 amt) external ownerOnly {
1499         require(isNotKilled(34), "killed");
1500         minLottoHolderRate = amt;
1501     }
1502 
1503 }