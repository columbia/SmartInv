1 pragma solidity >=0.4.22 <0.8.0;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41 
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         return mod(a, b, "SafeMath: modulo by zero");
47     }
48 
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b != 0, errorMessage);
51         return a % b;
52     }
53 
54     function pow(uint256 base, uint256 exponent) internal pure returns (uint256) {
55         if (exponent == 0) {
56             return 1;
57         }
58         else if (exponent == 1) {
59             return base;
60         }
61         else if (base == 0 && exponent != 0) {
62             return 0;
63         }
64         else {
65             uint256 z = base;
66             for (uint256 i = 1; i < exponent; i++)
67                 z = mul(z, base);
68             return z;
69         }
70     }
71 }
72 
73 library Address {
74     /**
75      * @dev Returns true if `account` is a contract.
76      *
77      * [IMPORTANT]
78      * ====
79      * It is unsafe to assume that an address for which this function returns
80      * false is an externally-owned account (EOA) and not a contract.
81      *
82      * Among others, `isContract` will return false for the following
83      * types of addresses:
84      *
85      *  - an externally-owned account
86      *  - a contract in construction
87      *  - an address where a contract will be created
88      *  - an address where a contract lived, but was destroyed
89      * ====
90      */
91     function isContract(address account) internal view returns (bool) {
92         // This method relies on extcodesize, which returns 0 for contracts in
93         // construction, since the code is only stored at the end of the
94         // constructor execution.
95 
96         uint256 size;
97         // solhint-disable-next-line no-inline-assembly
98         assembly { size := extcodesize(account) }
99         return size > 0;
100     }
101 
102     /**
103      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
104      * `recipient`, forwarding all available gas and reverting on errors.
105      *
106      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
107      * of certain opcodes, possibly making contracts go over the 2300 gas limit
108      * imposed by `transfer`, making them unable to receive funds via
109      * `transfer`. {sendValue} removes this limitation.
110      *
111      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
112      *
113      * IMPORTANT: because control is transferred to `recipient`, care must be
114      * taken to not create reentrancy vulnerabilities. Consider using
115      * {ReentrancyGuard} or the
116      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
117      */
118     function sendValue(address payable recipient, uint256 amount) internal {
119         require(address(this).balance >= amount, "Address: insufficient balance");
120 
121         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
122         (bool success, ) = recipient.call{ value: amount }("");
123         require(success, "Address: unable to send value, recipient may have reverted");
124     }
125 
126     /**
127      * @dev Performs a Solidity function call using a low level `call`. A
128      * plain`call` is an unsafe replacement for a function call: use this
129      * function instead.
130      *
131      * If `target` reverts with a revert reason, it is bubbled up by this
132      * function (like regular Solidity function calls).
133      *
134      * Returns the raw returned data. To convert to the expected return value,
135      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
136      *
137      * Requirements:
138      *
139      * - `target` must be a contract.
140      * - calling `target` with `data` must not revert.
141      *
142      * _Available since v3.1._
143      */
144     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
145         return functionCall(target, data, "Address: low-level call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
150      * `errorMessage` as a fallback revert reason when `target` reverts.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
155         return functionCallWithValue(target, data, 0, errorMessage);
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
160      * but also transferring `value` wei to `target`.
161      *
162      * Requirements:
163      *
164      * - the calling contract must have an ETH balance of at least `value`.
165      * - the called Solidity function must be `payable`.
166      *
167      * _Available since v3.1._
168      */
169     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
175      * with `errorMessage` as a fallback revert reason when `target` reverts.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
180         require(address(this).balance >= value, "Address: insufficient balance for call");
181         require(isContract(target), "Address: call to non-contract");
182 
183         // solhint-disable-next-line avoid-low-level-calls
184         (bool success, bytes memory returndata) = target.call{ value: value }(data);
185         return _verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but performing a static call.
191      *
192      * _Available since v3.3._
193      */
194     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
195         return functionStaticCall(target, data, "Address: low-level static call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
200      * but performing a static call.
201      *
202      * _Available since v3.3._
203      */
204     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
205         require(isContract(target), "Address: static call to non-contract");
206 
207         // solhint-disable-next-line avoid-low-level-calls
208         (bool success, bytes memory returndata) = target.staticcall(data);
209         return _verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but performing a delegate call.
215      *
216      * _Available since v3.4._
217      */
218     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
224      * but performing a delegate call.
225      *
226      * _Available since v3.4._
227      */
228     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
229         require(isContract(target), "Address: delegate call to non-contract");
230 
231         // solhint-disable-next-line avoid-low-level-calls
232         (bool success, bytes memory returndata) = target.delegatecall(data);
233         return _verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
237         if (success) {
238             return returndata;
239         } else {
240             // Look for revert reason and bubble it up if present
241             if (returndata.length > 0) {
242                 // The easiest way to bubble the revert reason is using memory via assembly
243 
244                 // solhint-disable-next-line no-inline-assembly
245                 assembly {
246                     let returndata_size := mload(returndata)
247                     revert(add(32, returndata), returndata_size)
248                 }
249             } else {
250                 revert(errorMessage);
251             }
252         }
253     }
254 }
255 
256 
257 library SafeERC20 {
258     using SafeMath for uint256;
259     using Address for address;
260 
261     function safeTransfer(IERC20 token, address to, uint256 value) internal {
262         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
263     }
264 
265     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
266         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
267     }
268 
269     /**
270      * @dev Deprecated. This function has issues similar to the ones found in
271      * {IERC20-approve}, and its usage is discouraged.
272      *
273      * Whenever possible, use {safeIncreaseAllowance} and
274      * {safeDecreaseAllowance} instead.
275      */
276     function safeApprove(IERC20 token, address spender, uint256 value) internal {
277         // safeApprove should only be called when setting an initial allowance,
278         // or when resetting it to zero. To increase and decrease it, use
279         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
280         // solhint-disable-next-line max-line-length
281         require((value == 0) || (token.allowance(address(this), spender) == 0),
282             "SafeERC20: approve from non-zero to non-zero allowance"
283         );
284         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
285     }
286 
287     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
288         uint256 newAllowance = token.allowance(address(this), spender).add(value);
289         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
290     }
291 
292     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
293         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
294         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
295     }
296 
297     /**
298      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
299      * on the return value: the return value is optional (but if data is returned, it must not be false).
300      * @param token The token targeted by the call.
301      * @param data The call data (encoded using abi.encode or one of its variants).
302      */
303     function _callOptionalReturn(IERC20 token, bytes memory data) private {
304         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
305         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
306         // the target address contains contract code and also asserts for success in the low-level call.
307 
308         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
309         if (returndata.length > 0) { // Return data is optional
310             // solhint-disable-next-line max-line-length
311             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
312         }
313     }
314 }
315 
316 contract Context {
317     function _msgSender() internal view returns (address payable) {
318         return msg.sender;
319     }
320 
321     function _msgData() internal view returns (bytes memory) {
322         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
323         return msg.data;
324     }
325 }
326 
327 contract Ownable is Context {
328     address private _owner;
329 
330     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
331 
332     constructor() {
333         address msgSender = _msgSender();
334         _owner = msgSender;
335         emit OwnershipTransferred(address(0), msgSender);
336     }
337 
338     function owner() public view returns (address) {
339         return _owner;
340     }
341 
342     modifier onlyOwner() {
343         require(_owner == _msgSender(), "Ownable: caller is not the owner");
344         _;
345     }
346 
347     function transferOwnership(address newOwner) public onlyOwner {
348         require(newOwner != address(0), "Ownable: new owner is the zero address");
349         emit OwnershipTransferred(_owner, newOwner);
350         _owner = newOwner;
351     }
352 }
353 
354 contract Accessible is Ownable {
355     mapping(address => bool) private access;
356     
357     constructor() {
358         access[msg.sender] = true;
359     }
360     
361      modifier hasAccess() {
362         require(checkAccess(msg.sender));
363         _;
364     }
365     
366     function checkAccess(address sender) public view returns (bool) {
367         if (access[sender] == true) 
368             return true;
369         return false;
370     }
371     
372     function removeAccess(address addr) public hasAccess returns (bool success) {
373         access[addr] = false;
374         return true;
375     }
376     
377     function addAccess(address addr) public hasAccess returns (bool) {
378         access[addr] = true;
379         return true;
380     }
381 }
382 
383 contract ExternalAccessible {
384     
385     address public accessContract;
386 
387     function checkAccess(address sender) public returns (bool) {
388         bool result = Accessible(accessContract).checkAccess(sender);
389         require(result == true);
390         return true;
391     }
392 
393     modifier hasAccess() {
394         require(checkAccess(msg.sender));
395         _;
396     }
397 }
398 
399 interface IERC20 {
400     function totalSupply() external view returns (uint256);
401     function balanceOf(address account) external view returns (uint256);
402     function transfer(address recipient, uint256 amount) external returns (bool);
403     function allowance(address owner, address spender) external view returns (uint256);
404     function approve(address spender, uint256 amount) external returns (bool);
405     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
406     event Transfer(address indexed from, address indexed to, uint256 value);
407     event Approval(address indexed owner, address indexed spender, uint256 value);
408 }
409 
410 abstract contract ERC20 is Context, IERC20, ExternalAccessible {
411     using SafeMath for uint256;
412 
413     mapping (address => uint256) private _balances;
414 
415     mapping (address => mapping (address => uint256)) private _allowances;
416 
417     uint256 private _totalSupply;
418 
419     string public _name;
420     string public _symbol;
421     uint8 public _decimals;
422 
423     function name() public view returns (string memory) {
424         return _name;
425     }
426 
427     function symbol() public view returns (string memory) {
428         return _symbol;
429     }
430 
431     function decimals() public view returns (uint8) {
432         return _decimals;
433     }
434 
435     function totalSupply() public view override returns (uint256) {
436         return _totalSupply;
437     }
438 
439     function balanceOf(address account) public view override returns (uint256) {
440         return _balances[account];
441     }
442 
443     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
444         _transfer(_msgSender(), recipient, amount);
445         return true;
446     }
447 
448     function allowance(address owner, address spender) public view virtual override returns (uint256) {
449         return _allowances[owner][spender];
450     }
451 
452     function approve(address spender, uint256 amount) public virtual override returns (bool) {
453         _approve(_msgSender(), spender, amount);
454         return true;
455     }
456 
457     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
458         _transfer(sender, recipient, amount);
459         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
460         return true;
461     }
462 
463     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
465         return true;
466     }
467 
468     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
469         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
470         return true;
471     }
472 
473     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
474         require(sender != address(0), "ERC20: transfer from the zero address");
475         require(recipient != address(0), "ERC20: transfer to the zero address");
476 
477         _beforeTokenTransfer(sender, recipient, amount);
478 
479         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
480         _balances[recipient] = _balances[recipient].add(amount);
481         emit Transfer(sender, recipient, amount);
482     }
483 
484     function _mint(address account, uint256 amount) external virtual hasAccess {
485         require(account != address(0), "ERC20: mint to the zero address");
486 
487         _beforeTokenTransfer(address(0), account, amount);
488 
489         _totalSupply = _totalSupply.add(amount);
490         _balances[account] = _balances[account].add(amount);
491         emit Transfer(address(0), account, amount);
492     }
493 
494     function _burn(address account, uint256 amount) external virtual hasAccess {
495         require(account != address(0), "ERC20: burn from the zero address");
496 
497         _beforeTokenTransfer(account, address(0), amount);
498 
499         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
500         _totalSupply = _totalSupply.sub(amount);
501         emit Transfer(account, address(0), amount);
502     }
503 
504     function _approve(address owner, address spender, uint256 amount) internal virtual {
505         require(owner != address(0), "ERC20: approve from the zero address");
506         require(spender != address(0), "ERC20: approve to the zero address");
507 
508         _allowances[owner][spender] = amount;
509         emit Approval(owner, spender, amount);
510     }
511 
512     function _setupDecimals(uint8 decimals_) internal {
513         _decimals = decimals_;
514     }
515 
516     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
517 }
518 
519 contract wXEQ is ERC20 {
520     
521     constructor(address _accessContract) {
522         _name = "Wrapped Equilibria v2";
523         _symbol = "wXEQ";
524         _decimals = 18;
525         accessContract = _accessContract;
526     }
527 }