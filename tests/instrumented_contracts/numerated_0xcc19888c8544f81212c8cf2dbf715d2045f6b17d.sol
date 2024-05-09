1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 pragma solidity 0.7.5;
4 
5 library LowGasSafeMath {
6     /// @notice Returns x + y, reverts if sum overflows uint256
7     /// @param x The augend
8     /// @param y The addend
9     /// @return z The sum of x and y
10     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
11         require((z = x + y) >= x);
12     }
13 
14     function add32(uint32 x, uint32 y) internal pure returns (uint32 z) {
15         require((z = x + y) >= x);
16     }
17 
18     /// @notice Returns x - y, reverts if underflows
19     /// @param x The minuend
20     /// @param y The subtrahend
21     /// @return z The difference of x and y
22     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
23         require((z = x - y) <= x);
24     }
25 
26     function sub32(uint32 x, uint32 y) internal pure returns (uint32 z) {
27         require((z = x - y) <= x);
28     }
29 
30     /// @notice Returns x * y, reverts if overflows
31     /// @param x The multiplicand
32     /// @param y The multiplier
33     /// @return z The product of x and y
34     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
35         require(x == 0 || (z = x * y) / x == y);
36     }
37 
38     /// @notice Returns x + y, reverts if overflows or underflows
39     /// @param x The augend
40     /// @param y The addend
41     /// @return z The sum of x and y
42     function add(int256 x, int256 y) internal pure returns (int256 z) {
43         require((z = x + y) >= x == (y >= 0));
44     }
45 
46     /// @notice Returns x - y, reverts if overflows or underflows
47     /// @param x The minuend
48     /// @param y The subtrahend
49     /// @return z The difference of x and y
50     function sub(int256 x, int256 y) internal pure returns (int256 z) {
51         require((z = x - y) <= x == (y >= 0));
52     }
53 
54     function div(uint256 x, uint256 y) internal pure returns(uint256 z){
55         require(y > 0);
56         z=x/y;
57     }
58 }
59 
60 interface IERC20 {
61 
62     function totalSupply() external view returns (uint256);
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 library Address {
80 
81     function isContract(address account) internal view returns (bool) {
82         // This method relies in extcodesize, which returns 0 for contracts in
83         // construction, since the code is only stored at the end of the
84         // constructor execution.
85 
86         uint256 size;
87         // solhint-disable-next-line no-inline-assembly
88         assembly { size := extcodesize(account) }
89         return size > 0;
90     }
91 
92     function sendValue(address payable recipient, uint256 amount) internal {
93         require(address(this).balance >= amount, "Address: insufficient balance");
94 
95         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
96         (bool success, ) = recipient.call{ value: amount }("");
97         require(success, "Address: unable to send value, recipient may have reverted");
98     }
99 
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101       return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     function functionCall(
105         address target, 
106         bytes memory data, 
107         string memory errorMessage
108     ) internal returns (bytes memory) {
109         return _functionCallWithValue(target, data, 0, errorMessage);
110     }
111 
112     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114     }
115 
116     function functionCallWithValue(
117         address target, 
118         bytes memory data, 
119         uint256 value, 
120         string memory errorMessage
121     ) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         require(isContract(target), "Address: call to non-contract");
124 
125         // solhint-disable-next-line avoid-low-level-calls
126         (bool success, bytes memory returndata) = target.call{ value: value }(data);
127         return _verifyCallResult(success, returndata, errorMessage);
128     }
129 
130     function _functionCallWithValue(
131         address target, 
132         bytes memory data, 
133         uint256 weiValue, 
134         string memory errorMessage
135     ) private returns (bytes memory) {
136         require(isContract(target), "Address: call to non-contract");
137 
138         // solhint-disable-next-line avoid-low-level-calls
139         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
140         if (success) {
141             return returndata;
142         } else {
143             // Look for revert reason and bubble it up if present
144             if (returndata.length > 0) {
145                 // The easiest way to bubble the revert reason is using memory via assembly
146 
147                 // solhint-disable-next-line no-inline-assembly
148                 assembly {
149                     let returndata_size := mload(returndata)
150                     revert(add(32, returndata), returndata_size)
151                 }
152             } else {
153                 revert(errorMessage);
154             }
155         }
156     }
157 
158     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
159         return functionStaticCall(target, data, "Address: low-level static call failed");
160     }
161 
162     function functionStaticCall(
163         address target, 
164         bytes memory data, 
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         // solhint-disable-next-line avoid-low-level-calls
170         (bool success, bytes memory returndata) = target.staticcall(data);
171         return _verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
176     }
177 
178     function functionDelegateCall(
179         address target, 
180         bytes memory data, 
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         require(isContract(target), "Address: delegate call to non-contract");
184         (bool success, bytes memory returndata) = target.delegatecall(data);
185         return _verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     function _verifyCallResult(
189         bool success, 
190         bytes memory returndata, 
191         string memory errorMessage
192     ) private pure returns(bytes memory) {
193         if (success) {
194             return returndata;
195         } else {
196             if (returndata.length > 0) {
197                 assembly {
198                     let returndata_size := mload(returndata)
199                     revert(add(32, returndata), returndata_size)
200                 }
201             } else {
202                 revert(errorMessage);
203             }
204         }
205     }
206 
207     function addressToString(address _address) internal pure returns(string memory) {
208         bytes32 _bytes = bytes32(uint256(_address));
209         bytes memory HEX = "0123456789abcdef";
210         bytes memory _addr = new bytes(42);
211 
212         _addr[0] = '0';
213         _addr[1] = 'x';
214 
215         for(uint256 i = 0; i < 20; i++) {
216             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
217             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
218         }
219 
220         return string(_addr);
221 
222     }
223 }
224 
225 
226 interface IUniswapV2Router01 {
227     function factory() external pure returns (address);
228     function WETH() external pure returns (address);
229 
230     function addLiquidity(
231         address tokenA,
232         address tokenB,
233         uint amountADesired,
234         uint amountBDesired,
235         uint amountAMin,
236         uint amountBMin,
237         address to,
238         uint deadline
239     ) external returns (uint amountA, uint amountB, uint liquidity);
240     function addLiquidityETH(
241         address token,
242         uint amountTokenDesired,
243         uint amountTokenMin,
244         uint amountETHMin,
245         address to,
246         uint deadline
247     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
248     function removeLiquidity(
249         address tokenA,
250         address tokenB,
251         uint liquidity,
252         uint amountAMin,
253         uint amountBMin,
254         address to,
255         uint deadline
256     ) external returns (uint amountA, uint amountB);
257     function removeLiquidityETH(
258         address token,
259         uint liquidity,
260         uint amountTokenMin,
261         uint amountETHMin,
262         address to,
263         uint deadline
264     ) external returns (uint amountToken, uint amountETH);
265     function removeLiquidityWithPermit(
266         address tokenA,
267         address tokenB,
268         uint liquidity,
269         uint amountAMin,
270         uint amountBMin,
271         address to,
272         uint deadline,
273         bool approveMax, uint8 v, bytes32 r, bytes32 s
274     ) external returns (uint amountA, uint amountB);
275     function removeLiquidityETHWithPermit(
276         address token,
277         uint liquidity,
278         uint amountTokenMin,
279         uint amountETHMin,
280         address to,
281         uint deadline,
282         bool approveMax, uint8 v, bytes32 r, bytes32 s
283     ) external returns (uint amountToken, uint amountETH);
284     function swapExactTokensForTokens(
285         uint amountIn,
286         uint amountOutMin,
287         address[] calldata path,
288         address to,
289         uint deadline
290     ) external returns (uint[] memory amounts);
291     function swapTokensForExactTokens(
292         uint amountOut,
293         uint amountInMax,
294         address[] calldata path,
295         address to,
296         uint deadline
297     ) external returns (uint[] memory amounts);
298     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
299         external
300         payable
301         returns (uint[] memory amounts);
302     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
303         external
304         returns (uint[] memory amounts);
305     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
306         external
307         returns (uint[] memory amounts);
308     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
309         external
310         payable
311         returns (uint[] memory amounts);
312 
313     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
314     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
315     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
316     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
317     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
318 }
319 
320 interface IUniswapV2Router02 is IUniswapV2Router01 {
321     function removeLiquidityETHSupportingFeeOnTransferTokens(
322         address token,
323         uint liquidity,
324         uint amountTokenMin,
325         uint amountETHMin,
326         address to,
327         uint deadline
328     ) external returns (uint amountETH);
329     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
330         address token,
331         uint liquidity,
332         uint amountTokenMin,
333         uint amountETHMin,
334         address to,
335         uint deadline,
336         bool approveMax, uint8 v, bytes32 r, bytes32 s
337     ) external returns (uint amountETH);
338 
339     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
340         uint amountIn,
341         uint amountOutMin,
342         address[] calldata path,
343         address to,
344         uint deadline
345     ) external;
346     function swapExactETHForTokensSupportingFeeOnTransferTokens(
347         uint amountOutMin,
348         address[] calldata path,
349         address to,
350         uint deadline
351     ) external payable;
352     function swapExactTokensForETHSupportingFeeOnTransferTokens(
353         uint amountIn,
354         uint amountOutMin,
355         address[] calldata path,
356         address to,
357         uint deadline
358     ) external;
359 }
360 
361 
362 contract OwnableData {
363     address public owner;
364     address public Sins;
365     address public Nodes;
366     address public pendingOwner;
367 }
368 
369 contract Ownable is OwnableData {
370     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372     /// @notice `owner` defaults to msg.sender on construction.
373     constructor() {
374         owner = msg.sender;
375         emit OwnershipTransferred(address(0), msg.sender);
376     }
377 
378     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
379     /// Can only be invoked by the current `owner`.
380     /// @param newOwner Address of the new owner.
381     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
382     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
383     function transferOwnership(
384         address newOwner,
385         bool direct,
386         bool renounce
387     ) public onlyOwner {
388         if (direct) {
389             // Checks
390             require(newOwner != address(0) || renounce, "Ownable: zero address");
391 
392             // Effects
393             emit OwnershipTransferred(owner, newOwner);
394             owner = newOwner;
395             pendingOwner = address(0);
396         } else {
397             // Effects
398             pendingOwner = newOwner;
399         }
400     }
401 
402     /// @notice Needs to be called by `pendingOwner` to claim ownership.
403     function claimOwnership() public {
404         address _pendingOwner = pendingOwner;
405 
406         // Checks
407         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
408 
409         // Effects
410         emit OwnershipTransferred(owner, _pendingOwner);
411         owner = _pendingOwner;
412         pendingOwner = address(0);
413     }
414 
415     function setSinsAddress(address _sins) public {
416         require(msg.sender == owner, "Ownable: caller is not the owner");
417         Sins = _sins;
418     } 
419 
420     function setNodesAddress(address _nodes) public {
421         require(msg.sender == owner, "Ownable: caller is not the owner");
422         Nodes = _nodes;
423     }
424     /// @notice Only allows the `owner` to execute the function.
425     modifier onlyOwner() {
426         require(msg.sender == owner, "Ownable: caller is not the owner");
427         _;
428     }
429 
430     /// @notice Only allows the `owner` to execute the function.
431     modifier onlySins() {
432         require(msg.sender == Sins, "Ownable: caller is not the sins");
433         _;
434     }
435 
436     modifier onlyNodes() {
437         require(msg.sender == Nodes, "Ownable: caller is not the nodes");
438         _;
439     }
440 
441 }
442 
443 contract rewardPool is Ownable {
444     using LowGasSafeMath for uint;
445     using LowGasSafeMath for uint32;
446     struct NftData{
447         uint nodeType;
448         address owner;
449         uint256 lastClaim;
450     }
451     uint256[5] public rewardRates;
452     IUniswapV2Router02 public uniswapV2Router;
453     mapping (uint => NftData) public nftInfo;
454     uint totalNodes = 0;
455 
456     constructor(address _sinAddress) {     
457         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
458         uniswapV2Router = _uniswapV2Router;
459         Sins = _sinAddress;
460     }
461     
462     receive() external payable {
463 
464   	}
465 
466     function addNodeInfo(uint _nftId, uint _nodeType, address _owner) external onlyNodes returns (bool success) {
467         require(nftInfo[_nftId].owner == address(0), "Node already exists");
468         nftInfo[_nftId].nodeType = _nodeType;
469         nftInfo[_nftId].owner = _owner;
470         nftInfo[_nftId].lastClaim = block.timestamp;
471         totalNodes += 1;
472         return true;
473     }
474 
475     function updateNodeOwner(uint _nftId, address _owner) external onlyNodes returns (bool success) {
476         require(nftInfo[_nftId].owner != address(0), "Node does not exist");
477         nftInfo[_nftId].owner = _owner;
478         return true;
479     }
480 
481     function updateRewardRates(uint256[5] memory _rewardRates) external onlyOwner {
482         // Reward rate per day for each type of node (1e9 = 1 Sin)
483         for (uint i = 1; i < totalNodes; i++) {
484             claimReward(i);
485         }
486         rewardRates = _rewardRates;
487     }    
488 
489     function pendingRewardFor(uint _nftId) public view returns (uint256 _reward) {
490         uint _nodeType = nftInfo[_nftId].nodeType;
491         uint _lastClaim = nftInfo[_nftId].lastClaim;
492         uint _daysSinceLastClaim = ((block.timestamp - _lastClaim).mul(1e9)) / 86400;
493         _reward = (_daysSinceLastClaim * rewardRates[_nodeType-1]).div(1e9);
494         return _reward;
495     }
496 
497     function claimReward(uint _nftId) public returns (bool success) {
498         uint _reward = pendingRewardFor(_nftId);
499         nftInfo[_nftId].lastClaim = block.timestamp;
500         IERC20(Sins).transfer(nftInfo[_nftId].owner, _reward);
501         return true;
502     }
503 
504 }