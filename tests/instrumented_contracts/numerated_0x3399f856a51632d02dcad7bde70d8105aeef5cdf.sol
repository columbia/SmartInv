1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.20;
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
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     function name() external view returns (string memory);
24     function symbol() external view returns (string memory);
25     function decimals() external view returns (uint8);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 contract ERC20 is Context, IERC20 {
32     mapping(address => uint256) private _balances;
33     mapping(address => mapping(address => uint256)) private _allowances;
34     uint256 private _totalSupply;
35     string private _name;
36     string private _symbol;
37 
38     constructor(string memory name_, string memory symbol_) {
39         _name = name_;
40         _symbol = symbol_;
41     }
42 
43     function name() public view virtual override returns (string memory) {
44         return _name;
45     }
46 
47     function symbol() public view virtual override returns (string memory) {
48         return _symbol;
49     }
50 
51     function decimals() public view virtual override returns (uint8) {
52         return 18;
53     }
54 
55     function totalSupply() public view virtual override returns (uint256) {
56         return _totalSupply;
57     }
58 
59     function balanceOf(address account) public view virtual override returns (uint256) {
60         return _balances[account];
61     }
62 
63     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
64         _transfer(_msgSender(), recipient, amount);
65         return true;
66     }
67 
68     function allowance(address owner, address spender) public view virtual override returns (uint256) {
69         return _allowances[owner][spender];
70     }
71 
72     function approve(address spender, uint256 amount) public virtual override returns (bool) {
73         _approve(_msgSender(), spender, amount);
74         return true;
75     }
76 
77     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
78         _transfer(sender, recipient, amount);
79 
80         uint256 currentAllowance = _allowances[sender][_msgSender()];
81         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
82         unchecked {
83             _approve(sender, _msgSender(), currentAllowance - amount);
84         }
85 
86         return true;
87     }
88 
89     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
90         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
91         return true;
92     }
93 
94     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
95         uint256 currentAllowance = _allowances[_msgSender()][spender];
96         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
97         unchecked {
98             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
99         }
100 
101         return true;
102     }
103 
104     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
105         require(sender != address(0), "ERC20: transfer from the zero address");
106         require(recipient != address(0), "ERC20: transfer to the zero address");
107 
108         uint256 senderBalance = _balances[sender];
109         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
110         unchecked {
111             _balances[sender] = senderBalance - amount;
112         }
113         _balances[recipient] += amount;
114 
115         emit Transfer(sender, recipient, amount);
116     }
117 
118     function _createInitialSupply(address account, uint256 amount) internal virtual {
119         require(account != address(0), "ERC20: mint to the zero address");
120 
121         _totalSupply += amount;
122         _balances[account] += amount;
123         emit Transfer(address(0), account, amount);
124     }
125 
126     function _approve(address owner, address spender, uint256 amount) internal virtual {
127         require(owner != address(0), "ERC20: approve from the zero address");
128         require(spender != address(0), "ERC20: approve to the zero address");
129 
130         _allowances[owner][spender] = amount;
131         emit Approval(owner, spender, amount);
132     }
133 }
134 
135 contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139     
140     constructor () {
141         address msgSender = _msgSender();
142         _owner = msgSender;
143         emit OwnershipTransferred(address(0), msgSender);
144     }
145 
146     function owner() public view returns (address) {
147         return _owner;
148     }
149 
150     modifier onlyOwner() {
151         require(_owner == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     function renounceOwnership() external virtual onlyOwner {
156         emit OwnershipTransferred(_owner, address(0));
157         _owner = address(0);
158     }
159 
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         emit OwnershipTransferred(_owner, newOwner);
163         _owner = newOwner;
164     }
165 }
166 
167 library Address {
168     function isContract(address account) internal view returns (bool) {
169         return account.code.length > 0;
170     }
171 
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         (bool success, ) = recipient.call{value: amount}("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
181     }
182 
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
234         return functionStaticCall(target, data, "Address: low-level static call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal view returns (bytes memory) {
248         (bool success, bytes memory returndata) = target.staticcall(data);
249         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         (bool success, bytes memory returndata) = target.delegatecall(data);
274         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
279      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
280      *
281      * _Available since v4.8._
282      */
283     function verifyCallResultFromTarget(
284         address target,
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal view returns (bytes memory) {
289         if (success) {
290             if (returndata.length == 0) {
291                 // only check isContract if the call was successful and the return data is empty
292                 // otherwise we already know that it was a contract
293                 require(isContract(target), "Address: call to non-contract");
294             }
295             return returndata;
296         } else {
297             _revert(returndata, errorMessage);
298         }
299     }
300 
301     /**
302      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
303      * revert reason or using the provided one.
304      *
305      * _Available since v4.3._
306      */
307     function verifyCallResult(
308         bool success,
309         bytes memory returndata,
310         string memory errorMessage
311     ) internal pure returns (bytes memory) {
312         if (success) {
313             return returndata;
314         } else {
315             _revert(returndata, errorMessage);
316         }
317     }
318 
319     function _revert(bytes memory returndata, string memory errorMessage) private pure {
320         // Look for revert reason and bubble it up if present
321         if (returndata.length > 0) {
322             // The easiest way to bubble the revert reason is using memory via assembly
323             /// @solidity memory-safe-assembly
324             assembly {
325                 let returndata_size := mload(returndata)
326                 revert(add(32, returndata), returndata_size)
327             }
328         } else {
329             revert(errorMessage);
330         }
331     }
332 }
333 
334 library SafeERC20 {
335     using Address for address;
336 
337     function safeTransfer(
338         IERC20 token,
339         address to,
340         uint256 value
341     ) internal {
342         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
343     }
344 
345     function _callOptionalReturn(IERC20 token, bytes memory data) private {
346         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
347         if (returndata.length > 0) {
348             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
349         }
350     }
351 }
352 
353 interface IUniswapV3Router {
354     function factory() external view returns (address);
355 }
356 
357 interface IUniswapV3Factory {
358     function createPool(
359         address tokenA,
360         address tokenB,
361         uint24 fee
362     ) external returns (address pool);
363 }
364 
365 contract Spock is Ownable, ERC20 {
366 
367     IUniswapV3Router public immutable v3Router;
368     address public immutable pool;
369     IERC20 public immutable WETH;
370 
371     mapping (address => bool) public isPool;
372     mapping (address => bool) public isFeeExempt;
373     mapping (address => bool) public isMaxTxExempt;
374 
375 
376     uint256 public maxTransactionAmt;
377     uint256 public maxWallet;
378 
379     bool public limitsInEffect = true;
380     bool public tradingActive = false;
381 
382     receive() payable external{}
383 
384     constructor() ERC20("Spock", "Spock"){
385         address wethContract;
386         address _v3Router;
387         // @dev assumes WETH pair
388         if(block.chainid == 1){
389             wethContract = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
390             _v3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
391         } else if(block.chainid == 5){
392             wethContract  = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
393             _v3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
394         } else {
395             revert("Chain not configured");
396         }
397         
398         WETH = IERC20(wethContract);
399         v3Router = IUniswapV3Router(_v3Router);
400         pool = IUniswapV3Factory(v3Router.factory()).createPool(address(this), address(WETH), 10000);
401         isPool[pool] = true;
402 
403         isFeeExempt[msg.sender] = true;
404         isFeeExempt[address(v3Router)] = true;
405         isFeeExempt[address(0xdead)] = true;
406 
407         isMaxTxExempt[msg.sender] = true;
408         isMaxTxExempt[address(v3Router)] = true;
409         isMaxTxExempt[address(0xdead)] = true;
410 
411         uint256 totalSupply = 1 * 1e9 * 1e18;
412         
413         maxTransactionAmt = totalSupply * 5 / 1000; // @dev update
414         maxWallet = totalSupply * 1 / 100; // @dev update
415 
416         _createInitialSupply(msg.sender, totalSupply);
417         super._transfer(msg.sender, 0xC2630500a28968811a0352466DEB8a281b704C51, totalSupply * 2 / 100);
418         super._transfer(msg.sender, 0xf1dE5768369209E374E83758EB982A0fe4F044dA, totalSupply * 2 / 100);
419         super._transfer(msg.sender, 0x71bc43746E5baA3a6e1299512Cb3357FDdab9649, totalSupply * 2 / 100);
420         super._transfer(msg.sender, 0x0a551cB697f810a769C025Ef820dbBdDb3E72E5B, totalSupply * 2 / 100);
421         super._transfer(msg.sender, 0x235238dfbf6C3D880704675523625D9Ee754c24e, totalSupply * 2 / 100);
422     }
423 
424     function _transfer(
425         address from,
426         address to,
427         uint256 amount
428     ) internal override {
429         if(limitsInEffect && !isFeeExempt[to] && !isFeeExempt[from]) {
430             require(tradingActive, "Trading not active");
431             //when buy
432             if (isPool[from] && !isMaxTxExempt[to]) {
433                 require(amount <= maxTransactionAmt, "Buy transfer amt exceeds the max buy.");
434                 require(amount + balanceOf(to) <= maxWallet, "Cannot Exceed max wallet");
435             } 
436             //when sell
437             else if (isPool[to] && !isMaxTxExempt[from]) {
438                 require(amount <= maxTransactionAmt, "Sell transfer amt exceeds the max sell.");
439             }
440             //when transfer
441             else if (!isMaxTxExempt[to]){
442                 require(amount + balanceOf(to) <= maxWallet, "Cannot Exceed max wallet");
443             }
444         }
445         super._transfer(from, to, amount);
446     }
447 
448     function enableTrading() external onlyOwner {
449         tradingActive = true;
450     }
451 
452     function removeLimits() external onlyOwner {
453         limitsInEffect = false;
454     }
455 
456     function updateMaxAmt(uint256 newNum) external onlyOwner {
457         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
458         maxTransactionAmt = newNum * (10**18);
459     }
460     
461     function updateMaxWalletAmt(uint256 newNum) external onlyOwner {
462         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
463         maxWallet = newNum * (10**18);
464     }
465 
466     function setIsFeeEx(address account, bool exempt) external onlyOwner {
467         isFeeExempt[account] = exempt;
468     }
469 
470     function setIsMaxTxEx(address account, bool exempt) external onlyOwner {
471         require(!isPool[account], "Cannot remove exemption from pool");
472         isMaxTxExempt[account] = exempt;
473     }
474 
475     function setIsPool(address _pool, bool _isPool) external onlyOwner {
476         require(_pool != address(pool), "Cannot remove original pool");
477         isPool[_pool] = _isPool;
478     }
479 
480     function sendEth() external onlyOwner {
481         bool success;
482         (success, ) = msg.sender.call{value: address(this).balance}("");
483         require(success, "withdraw unsuccessful");
484     }
485 
486     function transferToken(address _token, address _to) external onlyOwner {
487         require(_token != address(0), "_token address cannot be 0");
488         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
489         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
490     }
491 }