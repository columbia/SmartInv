1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 interface IERC20 {
6   /**
7    * @dev Returns the amount of tokens in existence.
8    */
9   function totalSupply() external view returns (uint256);
10 
11   /**
12    * @dev Returns the token decimals.
13    */
14   function decimals() external view returns (uint8);
15 
16   /**
17    * @dev Returns the token symbol.
18    */
19   function symbol() external view returns (string memory);
20 
21   /**
22   * @dev Returns the token name.
23   */
24   function name() external view returns (string memory);
25 
26   /**
27    
28    */
29  
30 
31   /**
32    * @dev Returns the amount of tokens owned by `account`.
33    */
34   function balanceOf(address account) external view returns (uint256);
35 
36   /**
37    * @dev Moves `amount` tokens from the caller's account to `recipient`.
38    *
39    * Returns a boolean value indicating whether the operation succeeded.
40    *
41    * Emits a {Transfer} event.
42    */
43   function transfer(address recipient, uint256 amount) external returns (bool);
44 
45   /**
46    * @dev Returns the remaining number of tokens that `spender` will be
47    * allowed to spend on behalf of `owner` through {transferFrom}. This is
48    * zero by default.
49    *
50    * This value changes when {approve} or {transferFrom} are called.
51    */
52   function allowance(address _owner, address spender) external view returns (uint256);
53 
54   /**
55    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56    *
57    * Returns a boolean value indicating whether the operation succeeded.
58    *
59    * IMPORTANT: Beware that changing an allowance with this method brings the risk
60    * that someone may use both the old and the new allowance by unfortunate
61    * transaction ordering. One possible solution to mitigate this race
62    * condition is to first reduce the spender's allowance to 0 and set the
63    * desired value afterwards:
64    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65    *
66    * Emits an {Approval} event.
67    */
68   function approve(address spender, uint256 amount) external returns (bool);
69 
70   /**
71    * @dev Moves `amount` tokens from `sender` to `recipient` using the
72    * allowance mechanism. `amount` is then deducted from the caller's
73    * allowance.
74    *
75    * Returns a boolean value indicating whether the operation succeeded.
76    *
77    * Emits a {Transfer} event.
78    */
79   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81   /**
82    * @dev Emitted when `value` tokens are moved from one account (`from`) to
83    * another (`to`).
84    *
85    * Note that `value` may be zero.
86    */
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 
89   /**
90    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91    * a call to {approve}. `value` is the new allowance.
92    */
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 contract Context {
98   // Empty internal constructor, to prevent people from mistakenly deploying
99   // an instance of this contract, which should be used via inheritance.
100   constructor ()  { }
101 
102   function _msgSender() internal view returns (address payable) {
103     return payable (msg.sender);
104   }
105 
106   function _msgData() internal view returns (bytes memory) {
107     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
108     return msg.data;
109   }
110 }
111 
112 
113 library SafeMath {
114   /**
115    * @dev Returns the addition of two unsigned integers, reverting on
116    * overflow.
117    *
118    * Counterpart to Solidity's `+` operator.
119    *
120    * Requirements:
121    * - Addition cannot overflow.
122    */
123   function add(uint256 a, uint256 b) internal pure returns (uint256) {
124     uint256 c = a + b;
125     require(c >= a, "SafeMath: addition overflow");
126 
127     return c;
128   }
129 
130 
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     return sub(a, b, "SafeMath: subtraction overflow");
133   }
134 
135 
136   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137     require(b <= a, errorMessage);
138     uint256 c = a - b;
139 
140     return c;
141   }
142 
143 
144   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146     // benefit is lost if 'b' is also tested.
147     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148     if (a == 0) {
149       return 0;
150     }
151 
152     uint256 c = a * b;
153     require(c / a == b, "SafeMath: multiplication overflow");
154 
155     return c;
156   }
157 
158 
159   function div(uint256 a, uint256 b) internal pure returns (uint256) {
160     return div(a, b, "SafeMath: division by zero");
161   }
162 
163 
164   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165     // Solidity only automatically asserts when dividing by 0
166     require(b > 0, errorMessage);
167     uint256 c = a / b;
168     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170     return c;
171   }
172 
173 
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     return mod(a, b, "SafeMath: modulo by zero");
176   }
177 
178 
179   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180     require(b != 0, errorMessage);
181     return a % b;
182   }
183 }
184 
185 
186 contract Ownable is Context {
187   address private _owner;
188 
189   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191   /**
192    * @dev Initializes the contract setting the deployer as the initial owner.
193    */
194   constructor ()  {
195     address msgSender = _msgSender();
196     _owner = msgSender;
197     emit OwnershipTransferred(address(0), msgSender);
198   }
199 
200   /**
201    * @dev Returns the address of the current owner.
202    */
203   function owner() public view returns (address) {
204     return _owner;
205   }
206 
207   /**
208    * @dev Throws if called by any account other than the owner.
209    */
210   modifier onlyOwner() {
211     require(_owner == _msgSender(), "Ownable: caller is not the owner");
212     _;
213   }
214 
215   /**
216    * @dev Leaves the contract without owner. It will not be possible to call
217    * `onlyOwner` functions anymore. Can only be called by the current owner.
218    *
219    * NOTE: Renouncing ownership will leave the contract without an owner,
220    * thereby removing any functionality that is only available to the owner.
221    */
222   function renounceOwnership() public onlyOwner {
223     emit OwnershipTransferred(_owner, address(0));
224     _owner = address(0);
225   }
226 
227   /**
228    * @dev Transfers ownership of the contract to a new account (`newOwner`).
229    * Can only be called by the current owner.
230    */
231   function transferOwnership(address newOwner) public onlyOwner {
232     _transferOwnership(newOwner);
233   }
234 
235   /**
236    * @dev Transfers ownership of the contract to a new account (`newOwner`).
237    */
238   function _transferOwnership(address newOwner) internal {
239     require(newOwner != address(0), "Ownable: new owner is the zero address");
240     emit OwnershipTransferred(_owner, newOwner);
241     _owner = newOwner;
242   }
243 }
244 library Address {
245 
246     function isContract(address account) internal view returns (bool) {
247         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
248         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
249         // for accounts without code, i.e. `keccak256('')`
250         bytes32 codehash;
251         bytes32 accountHash =
252             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
253         // solhint-disable-next-line no-inline-assembly
254         assembly {
255             codehash := extcodehash(account)
256         }
257         return (codehash != accountHash && codehash != 0x0);
258     }
259 
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(
262             address(this).balance >= amount,
263             "Address: insufficient balance"
264         );
265 
266         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
267         (bool success, ) = recipient.call{value: amount}("");
268         require(
269             success,
270             "Address: unable to send value, recipient may have reverted"
271         );
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain`call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data)
293         internal
294         returns (bytes memory)
295     {
296         return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
301      * `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         return _functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but also transferring `value` wei to `target`.
316      *
317      * Requirements:
318      *
319      * - the calling contract must have an ETH balance of at least `value`.
320      * - the called Solidity function must be `payable`.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value
328     ) internal returns (bytes memory) {
329         return
330             functionCallWithValue(
331                 target,
332                 data,
333                 value,
334                 "Address: low-level call with value failed"
335             );
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         require(
351             address(this).balance >= value,
352             "Address: insufficient balance for call"
353         );
354         return _functionCallWithValue(target, data, value, errorMessage);
355     }
356 
357     function _functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 weiValue,
361         string memory errorMessage
362     ) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) =
367             target.call{value: weiValue}(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 contract AURA is Context, IERC20, Ownable {
388   using Address for address;
389   using SafeMath for uint256;
390   mapping (address => uint256) private _balances;
391 
392   mapping (address => mapping (address => uint256)) private _allowances;
393 
394   uint256 private _totalSupply;
395   uint8 public _decimals;
396   string public _symbol;
397   string public _name;
398 
399   constructor()  {
400     _name = "AURA";
401     _symbol = "AURA";
402     _decimals = 18;
403     _totalSupply = 100000000 * 10**18;
404     _balances[msg.sender] = _totalSupply;
405 
406     emit Transfer(address(0), msg.sender, _totalSupply);
407   }
408 
409 
410 
411 
412 
413   function decimals() external override view returns (uint8) {
414     return _decimals;
415   }
416 
417 
418   function symbol() external override view returns (string memory) {
419     return _symbol;
420   }
421 
422 
423   function name() external override view returns (string memory) {
424     return _name;
425   }
426 
427  
428   function totalSupply() public override view returns (uint256) {
429     return _totalSupply;
430   }
431 
432 
433   function balanceOf(address account) external override view returns (uint256) {
434     return _balances[account];
435   }
436 
437 
438   function transfer(address recipient, uint256 amount) external override returns (bool) {
439     _transfer(_msgSender(), recipient, amount);
440     return true;
441   }
442 
443 
444   function allowance(address owner, address spender) external override view returns (uint256) {
445     return _allowances[owner][spender];
446   }
447 
448   function approve(address spender, uint256 amount) external override returns (bool) {
449     _approve(_msgSender(), spender, amount);
450     return true;
451   }
452 
453 
454   function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
455     _transfer(sender, recipient, amount);
456     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, " transfer amount exceeds allowance"));
457     return true;
458   }
459 
460 
461   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
462     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
463     return true;
464   }
465 
466 
467   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
468     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, " decreased allowance below zero"));
469     return true;
470   }
471 
472 
473   function burn(uint256 amount) public returns (bool) {
474     _burn(_msgSender(), amount);
475     return true;
476   }
477 
478 
479   function _transfer(address sender, address recipient, uint256 amount) internal {
480     require(sender != address(0), " transfer from the zero address");
481     require(recipient != address(0), " transfer to the zero address");
482 
483     _balances[sender] = _balances[sender].sub(amount, " transfer amount exceeds balance");
484     _balances[recipient] = _balances[recipient].add(amount);
485     emit Transfer(sender, recipient, amount);
486   }
487 
488 
489   function _mint(address account, uint256 amount) internal {
490     require(account != address(0), " mint to the zero address");
491 
492     _totalSupply = _totalSupply.add(amount);
493     _balances[account] = _balances[account].add(amount);
494     emit Transfer(address(0), account, amount);
495   }
496 
497 
498   function _burn(address account, uint256 amount) internal {
499     require(account != address(0), "burn from the zero address");
500 
501     _balances[account] = _balances[account].sub(amount, ": burn amount exceeds balance");
502     _totalSupply = _totalSupply.sub(amount);
503     emit Transfer(account, address(0), amount);
504   }
505 
506   function _approve(address owner, address spender, uint256 amount) internal {
507     require(owner != address(0), ": approve fromm the zero address");
508     require(spender != address(0), ": approvee to the zero address");
509 
510     _allowances[owner][spender] = amount;
511     emit Approval(owner, spender, amount);
512   }
513 
514 
515   function _burnFrom(address account, uint256 amount) internal {
516     _burn(account, amount);
517     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, ": burn amount exceeds allowance"));
518   }
519 }