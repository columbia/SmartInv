1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.19;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IDexFactory {
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 }
19 
20 interface IDexRouter {
21     function factory() external pure returns (address);
22     function WETH() external pure returns (address);
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     function name() external view returns (string memory);
33     function symbol() external view returns (string memory);
34     function decimals() external view returns (uint8);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 contract ERC20 is Context, IERC20 {
41     mapping(address => uint256) private _balances;
42     mapping(address => mapping(address => uint256)) private _allowances;
43     uint256 private _totalSupply;
44     string private _name;
45     string private _symbol;
46 
47     constructor(string memory name_, string memory symbol_) {
48         _name = name_;
49         _symbol = symbol_;
50     }
51 
52     function name() public view virtual override returns (string memory) {
53         return _name;
54     }
55 
56     function symbol() public view virtual override returns (string memory) {
57         return _symbol;
58     }
59 
60     function decimals() public view virtual override returns (uint8) {
61         return 18;
62     }
63 
64     function totalSupply() public view virtual override returns (uint256) {
65         return _totalSupply;
66     }
67 
68     function balanceOf(address account) public view virtual override returns (uint256) {
69         return _balances[account];
70     }
71 
72     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
73         _transfer(_msgSender(), recipient, amount);
74         return true;
75     }
76 
77     function allowance(address owner, address spender) public view virtual override returns (uint256) {
78         return _allowances[owner][spender];
79     }
80 
81     function approve(address spender, uint256 amount) public virtual override returns (bool) {
82         _approve(_msgSender(), spender, amount);
83         return true;
84     }
85 
86     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
87         _transfer(sender, recipient, amount);
88 
89         uint256 currentAllowance = _allowances[sender][_msgSender()];
90         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
91         unchecked {
92             _approve(sender, _msgSender(), currentAllowance - amount);
93         }
94 
95         return true;
96     }
97 
98     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
100         return true;
101     }
102 
103     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
104         uint256 currentAllowance = _allowances[_msgSender()][spender];
105         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
106         unchecked {
107             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
108         }
109 
110         return true;
111     }
112 
113     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
114         require(sender != address(0), "ERC20: transfer from the zero address");
115         require(recipient != address(0), "ERC20: transfer to the zero address");
116 
117         uint256 senderBalance = _balances[sender];
118         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
119         unchecked {
120             _balances[sender] = senderBalance - amount;
121         }
122         _balances[recipient] += amount;
123 
124         emit Transfer(sender, recipient, amount);
125     }
126 
127     function _createInitialSupply(address account, uint256 amount) internal virtual {
128         require(account != address(0), "ERC20: mint to the zero address");
129 
130         _totalSupply += amount;
131         _balances[account] += amount;
132         emit Transfer(address(0), account, amount);
133     }
134 
135     function _approve(address owner, address spender, uint256 amount) internal virtual {
136         require(owner != address(0), "ERC20: approve from the zero address");
137         require(spender != address(0), "ERC20: approve to the zero address");
138 
139         _allowances[owner][spender] = amount;
140         emit Approval(owner, spender, amount);
141     }
142 }
143 
144 contract Ownable is Context {
145     address private _owner;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148     
149     constructor () {
150         address msgSender = _msgSender();
151         _owner = msgSender;
152         emit OwnershipTransferred(address(0), msgSender);
153     }
154 
155     function owner() public view returns (address) {
156         return _owner;
157     }
158 
159     modifier onlyOwner() {
160         require(_owner == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     function renounceOwnership() external virtual onlyOwner {
165         emit OwnershipTransferred(_owner, address(0));
166         _owner = address(0);
167     }
168 
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 }
175 
176 library Address {
177     function isContract(address account) internal view returns (bool) {
178         return account.code.length > 0;
179     }
180 
181     function sendValue(address payable recipient, uint256 amount) internal {
182         require(address(this).balance >= amount, "Address: insufficient balance");
183 
184         (bool success, ) = recipient.call{value: amount}("");
185         require(success, "Address: unable to send value, recipient may have reverted");
186     }
187 
188     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
190     }
191 
192     function functionCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, 0, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but also transferring `value` wei to `target`.
203      *
204      * Requirements:
205      *
206      * - the calling contract must have an ETH balance of at least `value`.
207      * - the called Solidity function must be `payable`.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value
215     ) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
221      * with `errorMessage` as a fallback revert reason when `target` reverts.
222      *
223      * _Available since v3.1._
224      */
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         require(address(this).balance >= value, "Address: insufficient balance for call");
232         (bool success, bytes memory returndata) = target.call{value: value}(data);
233         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a static call.
239      *
240      * _Available since v3.3._
241      */
242     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
243         return functionStaticCall(target, data, "Address: low-level static call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a static call.
249      *
250      * _Available since v3.3._
251      */
252     function functionStaticCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal view returns (bytes memory) {
257         (bool success, bytes memory returndata) = target.staticcall(data);
258         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         (bool success, bytes memory returndata) = target.delegatecall(data);
283         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
288      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
289      *
290      * _Available since v4.8._
291      */
292     function verifyCallResultFromTarget(
293         address target,
294         bool success,
295         bytes memory returndata,
296         string memory errorMessage
297     ) internal view returns (bytes memory) {
298         if (success) {
299             if (returndata.length == 0) {
300                 // only check isContract if the call was successful and the return data is empty
301                 // otherwise we already know that it was a contract
302                 require(isContract(target), "Address: call to non-contract");
303             }
304             return returndata;
305         } else {
306             _revert(returndata, errorMessage);
307         }
308     }
309 
310     /**
311      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
312      * revert reason or using the provided one.
313      *
314      * _Available since v4.3._
315      */
316     function verifyCallResult(
317         bool success,
318         bytes memory returndata,
319         string memory errorMessage
320     ) internal pure returns (bytes memory) {
321         if (success) {
322             return returndata;
323         } else {
324             _revert(returndata, errorMessage);
325         }
326     }
327 
328     function _revert(bytes memory returndata, string memory errorMessage) private pure {
329         // Look for revert reason and bubble it up if present
330         if (returndata.length > 0) {
331             // The easiest way to bubble the revert reason is using memory via assembly
332             /// @solidity memory-safe-assembly
333             assembly {
334                 let returndata_size := mload(returndata)
335                 revert(add(32, returndata), returndata_size)
336             }
337         } else {
338             revert(errorMessage);
339         }
340     }
341 }
342 
343 library SafeERC20 {
344     using Address for address;
345 
346     function safeTransfer(
347         IERC20 token,
348         address to,
349         uint256 value
350     ) internal {
351         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
352     }
353 
354     function _callOptionalReturn(IERC20 token, bytes memory data) private {
355         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
356         if (returndata.length > 0) {
357             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
358         }
359     }
360 }
361 
362 interface IUniswapV3Router {
363     function factory() external view returns (address);
364 }
365 
366 interface IUniswapV3Factory {
367     function createPool(
368         address tokenA,
369         address tokenB,
370         uint24 fee
371     ) external returns (address pool);
372 }
373 
374 contract ScamDevToken is Ownable, ERC20 {
375 
376     IUniswapV3Router public immutable v3Router;
377     address public pool;
378     IERC20 public immutable WETH;
379 
380     mapping (address => bool) public isPool;
381     mapping (address => bool) public isFeeExempt;
382     mapping (address => bool) public isMaxTxExempt;
383 
384 
385     uint256 public maxTransactionAmt;
386     uint256 public maxWallet;
387 
388     bool public limitsInEffect = true;
389     bool public tradingActive = false;
390 
391     receive() payable external{}
392 
393     constructor() ERC20("SCAM", "SCAM"){
394         address newOwner = 0xd54dc0BBDdFae747ffD51275d90B0ab8C5E7c702;
395         address wethContract;
396         address _v3Router;
397         // @dev assumes WETH pair
398         if(block.chainid == 1){
399             wethContract = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
400             _v3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
401         } else if(block.chainid == 5){
402             wethContract  = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
403             _v3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
404         } else {
405             revert("Chain not configured");
406         }
407         
408         WETH = IERC20(wethContract);
409         v3Router = IUniswapV3Router(_v3Router);
410         pool = IUniswapV3Factory(v3Router.factory()).createPool(address(this), address(WETH), 10000);
411         isPool[pool] = true;
412 
413         isFeeExempt[newOwner] = true;
414         isFeeExempt[address(v3Router)] = true;
415         isFeeExempt[address(0xdead)] = true;
416 
417         isMaxTxExempt[newOwner] = true;
418         isMaxTxExempt[address(v3Router)] = true;
419         isMaxTxExempt[address(0xdead)] = true;
420 
421         uint256 totalSupply = 100 * 1e6 * 1e18;
422         
423         maxTransactionAmt = totalSupply * 1 / 100; // @dev update
424         maxWallet = totalSupply * 1 / 100; // @dev update
425 
426         _createInitialSupply(newOwner, totalSupply);
427         transferOwnership(newOwner);
428     }
429 
430     function _transfer(
431         address from,
432         address to,
433         uint256 amount
434     ) internal override {
435         if(limitsInEffect && !isFeeExempt[to] && !isFeeExempt[from]) {
436             require(tradingActive, "Trading not active");
437             //when buy
438             if (isPool[from] && !isMaxTxExempt[to]) {
439                 require(amount <= maxTransactionAmt, "Buy transfer amt exceeds the max buy.");
440                 require(amount + balanceOf(to) <= maxWallet, "Cannot Exceed max wallet");
441             } 
442             //when sell
443             else if (isPool[to] && !isMaxTxExempt[from]) {
444                 require(amount <= maxTransactionAmt, "Sell transfer amt exceeds the max sell.");
445             }
446             //when transfer
447             else if (!isMaxTxExempt[to]){
448                 require(amount + balanceOf(to) <= maxWallet, "Cannot Exceed max wallet");
449             }
450         }
451         super._transfer(from, to, amount);
452     }
453 
454     function enableTrading() external onlyOwner {
455         tradingActive = true;
456     }
457 
458     function removeLimits() external onlyOwner {
459         limitsInEffect = false;
460     }
461 
462     function updateMaxAmt(uint256 newNum) external onlyOwner {
463         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
464         maxTransactionAmt = newNum * (10**18);
465     }
466     
467     function updateMaxWalletAmt(uint256 newNum) external onlyOwner {
468         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
469         maxWallet = newNum * (10**18);
470     }
471 
472     function setIsFeeEx(address account, bool exempt) external onlyOwner {
473         isFeeExempt[account] = exempt;
474     }
475 
476     function setIsMaxTxEx(address account, bool exempt) external onlyOwner {
477         require(!isPool[account], "Cannot remove exemption from pool");
478         isMaxTxExempt[account] = exempt;
479     }
480 
481     function setIsPool(address _pool, bool _isPool) external onlyOwner {
482         require(_pool != address(pool), "Cannot remove original pool");
483         isPool[_pool] = _isPool;
484     }
485 
486     function sendEth() external onlyOwner {
487         bool success;
488         (success, ) = msg.sender.call{value: address(this).balance}("");
489         require(success, "withdraw unsuccessful");
490     }
491 
492     function transferToken(address _token, address _to) external onlyOwner {
493         require(_token != address(0), "_token address cannot be 0");
494         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
495         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
496     }
497 }