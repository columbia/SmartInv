1 /**
2  *  Created By: Fatsale
3  *  Website: https://fatsale.finance
4  *  Telegram: https://t.me/fatsale
5  *  The Best Tool for Token Presale
6  **/
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.4;
10 
11 
12 contract Context {
13     // Empty internal constructor, to prevent people from mistakenly deploying
14     // an instance of this contract, which should be used via inheritance.
15     //   constructor () internal { }
16 
17     function _msgSender() internal view returns (address) {
18         return payable(msg.sender);
19     }
20 
21     function _msgData() internal view returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 contract Ownable is Context {
28     address private _owner;
29 
30     event OwnershipTransferred(
31         address indexed previousOwner,
32         address indexed newOwner
33     );
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor() {
39         address msgSender = _msgSender();
40         _owner = msgSender;
41         emit OwnershipTransferred(address(0), msgSender);
42     }
43 
44     /**
45      * @dev Leaves the contract without owner. It will not be possible to call
46      * `onlyOwner` functions anymore. Can only be called by the current owner.
47      *
48      * NOTE: Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(
53             _owner,
54             0x000000000000000000000000000000000000dEaD
55         );
56         _owner = 0x000000000000000000000000000000000000dEaD;
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         require(
65             newOwner != address(0),
66             "Ownable: new owner is the zero address"
67         );
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 }
87 
88 interface IUniFactory {
89     function getPair(address tokenA, address tokenB)
90         external
91         view
92         returns (address);
93 }
94 
95 library SafeMath {
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         return sub(a, b, "SafeMath: subtraction overflow");
105     }
106 
107     function sub(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b <= a, errorMessage);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     function div(
134         uint256 a,
135         uint256 b,
136         string memory errorMessage
137     ) internal pure returns (uint256) {
138         require(b > 0, errorMessage);
139         uint256 c = a / b;
140         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 
142         return c;
143     }
144 
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return mod(a, b, "SafeMath: modulo by zero");
147     }
148 
149     function mod(
150         uint256 a,
151         uint256 b,
152         string memory errorMessage
153     ) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 library Address {
160     function isContract(address account) internal view returns (bool) {
161         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
162         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
163         // for accounts without code, i.e. `keccak256('')`
164         bytes32 codehash;
165         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
166         // solhint-disable-next-line no-inline-assembly
167         assembly {
168             codehash := extcodehash(account)
169         }
170         return (codehash != accountHash && codehash != 0x0);
171     }
172 
173     function sendValue(address payable recipient, uint256 amount) internal {
174         require(
175             address(this).balance >= amount,
176             "Address: insufficient balance"
177         );
178 
179         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
180         (bool success, ) = recipient.call{value: amount}("");
181         require(
182             success,
183             "Address: unable to send value, recipient may have reverted"
184         );
185     }
186 
187     function functionCall(address target, bytes memory data)
188         internal
189         returns (bytes memory)
190     {
191         return functionCall(target, data, "Address: low-level call failed");
192     }
193 
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return _functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return
208             functionCallWithValue(
209                 target,
210                 data,
211                 value,
212                 "Address: low-level call with value failed"
213             );
214     }
215 
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(
223             address(this).balance >= value,
224             "Address: insufficient balance for call"
225         );
226         return _functionCallWithValue(target, data, value, errorMessage);
227     }
228 
229     function _functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 weiValue,
233         string memory errorMessage
234     ) private returns (bytes memory) {
235         require(isContract(target), "Address: call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.call{value: weiValue}(
238             data
239         );
240         if (success) {
241             return returndata;
242         } else {
243             if (returndata.length > 0) {
244                 assembly {
245                     let returndata_size := mload(returndata)
246                     revert(add(32, returndata), returndata_size)
247                 }
248             } else {
249                 revert(errorMessage);
250             }
251         }
252     }
253 }
254 
255 interface IERC20 {
256     function name() external view returns (string memory);
257 
258     function symbol() external view returns (string memory);
259 
260     function totalSupply() external view returns (uint256);
261 
262     function decimals() external view returns (uint256);
263 
264     function balanceOf(address account) external view returns (uint256);
265 
266     function transfer(address recipient, uint256 amount)
267         external
268         returns (bool);
269 
270     function allowance(address owner, address spender)
271         external
272         view
273         returns (uint256);
274 
275     function approve(address spender, uint256 amount) external returns (bool);
276 
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) external returns (bool);
282 
283     event Transfer(address indexed from, address indexed to, uint256 value);
284     event Approval(
285         address indexed owner,
286         address indexed spender,
287         uint256 value
288     );
289 }
290 
291 interface IPancakeRouter01 {
292     function factory() external pure returns (address);
293 
294     function WETH() external pure returns (address);
295 
296     function addLiquidity(
297         address tokenA,
298         address tokenB,
299         uint256 amountADesired,
300         uint256 amountBDesired,
301         uint256 amountAMin,
302         uint256 amountBMin,
303         address to,
304         uint256 deadline
305     )
306         external
307         returns (
308             uint256 amountA,
309             uint256 amountB,
310             uint256 liquidity
311         );
312 
313     function addLiquidityETH(
314         address token,
315         uint256 amountTokenDesired,
316         uint256 amountTokenMin,
317         uint256 amountETHMin,
318         address to,
319         uint256 deadline
320     )
321         external
322         payable
323         returns (
324             uint256 amountToken,
325             uint256 amountETH,
326             uint256 liquidity
327         );
328 }
329 
330 interface IPancakeRouter02 is IPancakeRouter01 {
331     function removeLiquidityETHSupportingFeeOnTransferTokens(
332         address token,
333         uint256 liquidity,
334         uint256 amountTokenMin,
335         uint256 amountETHMin,
336         address to,
337         uint256 deadline
338     ) external returns (uint256 amountETH);
339 
340     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
341         address token,
342         uint256 liquidity,
343         uint256 amountTokenMin,
344         uint256 amountETHMin,
345         address to,
346         uint256 deadline,
347         bool approveMax,
348         uint8 v,
349         bytes32 r,
350         bytes32 s
351     ) external returns (uint256 amountETH);
352 
353     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
354         uint256 amountIn,
355         uint256 amountOutMin,
356         address[] calldata path,
357         address to,
358         uint256 deadline
359     ) external;
360 
361     function swapExactETHForTokensSupportingFeeOnTransferTokens(
362         uint256 amountOutMin,
363         address[] calldata path,
364         address to,
365         uint256 deadline
366     ) external payable;
367 
368     function swapExactTokensForETHSupportingFeeOnTransferTokens(
369         uint256 amountIn,
370         uint256 amountOutMin,
371         address[] calldata path,
372         address to,
373         uint256 deadline
374     ) external;
375 }
376 
377 interface IUniswapV2Factory {
378     event PairCreated(
379         address indexed token0,
380         address indexed token1,
381         address pair,
382         uint256
383     );
384 
385     function feeTo() external view returns (address);
386 
387     function feeToSetter() external view returns (address);
388 
389     function getPair(address tokenA, address tokenB)
390         external
391         view
392         returns (address pair);
393 
394     function allPairs(uint256) external view returns (address pair);
395 
396     function allPairsLength() external view returns (uint256);
397 
398     function createPair(address tokenA, address tokenB)
399         external
400         returns (address pair);
401 
402     function setFeeTo(address) external;
403 
404     function setFeeToSetter(address) external;
405 }
406 
407 
408 contract FatToken is Context, IERC20, Ownable {
409     using SafeMath for uint256;
410     using Address for address;
411 
412     string private _name;
413     string private _symbol;
414     uint256 private _decimals = 18;
415 
416     mapping(address => uint256) _balances;
417     mapping(address => mapping(address => uint256)) private _allowances;
418 
419     address public immutable deadAddress =
420         0x000000000000000000000000000000000000dEaD;
421     uint256 private _totalSupply;
422 
423     constructor( 
424         string[] memory stringParams,
425         address[] memory addressParams,
426         uint256[] memory numberParams,
427         bool[] memory boolParams
428     ) {
429         require(addressParams.length==0);
430         require(boolParams.length==0);
431 
432         address receiveAddr = tx.origin;
433         _name = stringParams[0];
434         _symbol = stringParams[1];
435         _decimals = numberParams[0];
436         _totalSupply = numberParams[1];
437         _balances[receiveAddr] = _totalSupply;
438         emit Transfer(address(0), receiveAddr, _totalSupply);
439     }
440 
441     function name() public view override returns (string memory) {
442         return _name;
443     }
444 
445     function symbol() public view override returns (string memory) {
446         return _symbol;
447     }
448 
449     function decimals() public view override returns (uint256) {
450         return _decimals;
451     }
452 
453     function totalSupply() public view override returns (uint256) {
454         return _totalSupply;
455     }
456 
457     function balanceOf(address account) public view override returns (uint256) {
458         return _balances[account];
459     }
460 
461     function allowance(address owner, address spender)
462         public
463         view
464         override
465         returns (uint256)
466     {
467         return _allowances[owner][spender];
468     }
469 
470     function increaseAllowance(address spender, uint256 addedValue)
471         public
472         virtual
473         returns (bool)
474     {
475         _approve(
476             _msgSender(),
477             spender,
478             _allowances[_msgSender()][spender].add(addedValue)
479         );
480         return true;
481     }
482 
483     function decreaseAllowance(address spender, uint256 subtractedValue)
484         public
485         virtual
486         returns (bool)
487     {
488         _approve(
489             _msgSender(),
490             spender,
491             _allowances[_msgSender()][spender].sub(
492                 subtractedValue,
493                 "ERC20: decreased allowance below zero"
494             )
495         );
496         return true;
497     }
498 
499     function approve(address spender, uint256 amount)
500         public
501         override
502         returns (bool)
503     {
504         _approve(_msgSender(), spender, amount);
505         return true;
506     }
507 
508     function _approve(
509         address owner,
510         address spender,
511         uint256 amount
512     ) private {
513         require(owner != address(0), "ERC20: approve from the zero address");
514         require(spender != address(0), "ERC20: approve to the zero address");
515 
516         _allowances[owner][spender] = amount;
517         emit Approval(owner, spender, amount);
518     }
519 
520     function getCirculatingSupply() public view returns (uint256) {
521         return _totalSupply.sub(balanceOf(deadAddress));
522     }
523 
524     //to recieve ETH from uniswapV2Router when swaping
525     receive() external payable {}
526 
527     function transfer(address recipient, uint256 amount)
528         public
529         override
530         returns (bool)
531     {
532         _transfer(_msgSender(), recipient, amount);
533         return true;
534     }
535 
536     function transferFrom(
537         address sender,
538         address recipient,
539         uint256 amount
540     ) public override returns (bool) {
541         _transfer(sender, recipient, amount);
542         _approve(
543             sender,
544             _msgSender(),
545             _allowances[sender][_msgSender()].sub(
546                 amount,
547                 "ERC20: transfer amount exceeds allowance"
548             )
549         );
550         return true;
551     }
552 
553     function _transfer(
554         address sender,
555         address recipient,
556         uint256 amount
557     ) private returns (bool) {
558         require(sender != address(0), "ERC20: transfer from the zero address");
559         require(recipient != address(0), "ERC20: transfer to the zero address");
560         return _basicTransfer(sender, recipient, amount);
561     }
562 
563     function _basicTransfer(
564         address sender,
565         address recipient,
566         uint256 amount
567     ) internal returns (bool) {
568         _balances[sender] = _balances[sender].sub(
569             amount,
570             "Insufficient Balance"
571         );
572         _balances[recipient] = _balances[recipient].add(amount);
573         emit Transfer(sender, recipient, amount);
574         return true;
575     }
576 }