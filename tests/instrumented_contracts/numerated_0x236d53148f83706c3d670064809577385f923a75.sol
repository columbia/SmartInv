1 /**
2 
3                          ..+                         .:.                        
4                        ..+8N+.                      .+$8+.                      
5                       .++NNNN+=.                  .,+NNNN++..                   
6                       +7NNNNNN?+.               ...+NNNNNNN+.                   
7                    ..+NNNN..NNN++.              .,+NNN...NNN+.                  
8                  .  +DNN.....NNN+..             .+NNN  ...NNN+.                 
9                  ..+DNN ..N7. NNN+.             +NNN. .NN..NNN+.                
10                   ++NN..:NNN  .NN?+           .:?NN. .NNNO..NN7+                
11                  .+NN~..NNNN . .NN+,~=+++++++~,+NNN   NNNNN. NN=,.              
12                 .+NNN  NNNNN .  NNNNNNNNNNNNNNNNNN.. .NNNNNN .NN+               
13                 .+NN..NNNNN.    .NNNNNNNNNNNNNNNNN   ..NNNNN..NN++              
14                 +NNN.ONNNN,.   . NNNNNNNNNNNNNNNN...   .NNNNN..NN+..            
15               .,+NN..NNNNN    . .~NNNNNNNNNNNNNN7...   .=NNNNN.NN+,.            
16                +DNN NNNNNN~.   NNNNNNNNNNNNNNNNNNNN    .NNNNNN.,NN+             
17                +NN,DNNNNNN  .NNNNNNNNNNNNNNNNNNNNNNNN...NNNNNNN.NN+             
18               .+NN.NNNNNNN NNNNNNNNNNNNNNNNNNNNNNNNNNNN..NNNNNNNNN++            
19               +NNNNNNNNNNZNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN+            
20              .+NNNNNNNNNNNNNNNNNNNNNNNNNN.NNNNNNNNNNNNNNNNNNNNNNNNN+            
21              +NNNNNNNNNNNNNNNNNNNNNNNNNN..NNNNNNNNNNNNNNNNNNNNNNNNNN+           
22           ..+NNNNNNNNNNNNNNNNNNNNNNNNNNN..NNNNNNNNNNNNNNNNNNNNNNNNNNN+.         
23           .+ZNNNNNNNNNNNNNNNNNNI ,NNNNNN  NNNNNN?..NNNNNNNNNNNNNNNNNNN+         
24           .++NNNNNNNNNNNNNNNNNZ..  ~NNNN..ZNNNO.....NNNNNNNNNNNNNNNNN+++        
25           .+ZNNNNNNNNNNNNNNNNNZ.   . NNN. .NND    ..NNNNNNNNNNNNNNNNNN+         
26         .,+NNNNNNNNNNNNNNNNNN..    . NN=.  NN+      .NNNNNNNNNNNNNNNNNN++       
27         ++NNNNNNNNNNNNNNNNN... .   . NN.   NN+        .NNNNNNNNNNNNNNNNNI+      
28      . +7NNNNNNND.?NNNNNN .+ZI,N.. ..NN    NND   .N.+$I  ZNNNNND..NNNNNNN7+     
29      .+INNNNNNN       NNN..NN?NNN...,NN    NNN  .NNN+NN  DNN.     .=NNNNNNN+.   
30      =$NNNNNNNN..     .NN.  NN===N..NNN    ?NN..NN===N.  NN+.    ..NNNNNNNN$+   
31      .+NNNNND: ..      +N.  ..NNNNNNNNN    .NNNNNNNN  .  NN..   ....,ZNNNNN+.   
32       +$NNNN.          .N     ..NNNNN..     .NNNNN..   . N.           NNNNN+    
33        +NNNNN.         . O      NNNZ.       ..:NNN..    . .         .:NNNN+..   
34        +NNNNN.                  IN.           ..NN                  .NNNNN+ .   
35        .+NNNNN .                ..              .M                  INNNN+,     
36        .+7NNNN.                                                   . NNNNN+.     
37         .=NNNNN.                                                  ..NNNN+..     
38         .+=NNNN                                                   .NNNNO+..     
39          .+NNNNN..                      ..                      , NNNNN+.       
40          ..+NNNN+N$         N.     . MNN~:MNN.      .O.     .  .N.NNNN?~.       
41           .+?NNNNNNO.. N.   .N .   .ONNNNNNNNN      N    .N.. .NNNNNNN+         
42            .+NNNNNNN~ ..NI  ..N.    .NNNNNNNNN    .N:  ..NN. .NNNNNNN+          
43              +NNNNNNNN  NNN.  .N.  . NNNNNNNN.  ..$N...7NN. .NNNNNNN+:.         
44             .=+NINNNNNM..NNN . NN..  .8NNNNN    .8N  .=NN. ZNNNNN+NI=           
45               +7++NNNNNN:NNNN. .NN......NN......NNM. 7NNN.NNNNNN++7+..          
46               .++.+NNNNNNNNNN8. NNNNNNNNNNNNNNNNNN...NNNNNNNNNN+..+. .          
47               .....+NNNNNNNNNN: .NNNNNNNNNNNNNNNNZ  NNNNNNNNNN+. ...            
48                    .++NNNNNNNNN..NN~NN77NN77NN~NN..NNNNNNNNN8+ .                
49                    ..+?NNNNNNNNO.7N.NNN7777$NN.NN. NNNNNNNN8+.                  
50                      .:+NNNNNNNN. N .NNNNNNNN, N..NNNNNNNN++  .,,=..            
51                         ++NNNNNNN .N...NNNN...NN.,NNNNNNI+.    . :..            
52                          .+?NNNNN...N........NI..NNNNND+.                       
53                           ..++NNNN ..NNNNNNNN.  NNNNI+,..                       
54                             ..+NNNN  .. ,+..  .NNNN+:..                         
55                             . .+NNNNN..     .NNNNN+=.                           
56                               .:+NNNNNNNNNNNNNNNN++                             
57                                  +8NNNNNNNNNNNNN+...                            
58                                   ~+NNNNNNNNNN++.                               
59                                    ..++INN$++~     
60                                    
61     
62 
63     https://shusky.finance
64 
65 
66 */
67 
68 
69 // SPDX-License-Identifier: Unlicensed
70 
71 pragma solidity ^0.6.12;
72 
73 abstract contract Context {
74     function _msgSender() internal view virtual returns (address payable) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
80         return msg.data;
81     }
82 }
83 
84 interface IERC20 {
85     /**
86      * @dev Returns the amount of tokens in existence.
87      */
88     function totalSupply() external view returns (uint256);
89 
90     /**
91      * @dev Returns the amount of tokens owned by `account`.
92      */
93     function balanceOf(address account) external view returns (uint256);
94 
95     /**
96      * @dev Moves `amount` tokens from the caller's account to `recipient`.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transfer(address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Returns the remaining number of tokens that `spender` will be
106      * allowed to spend on behalf of `owner` through {transferFrom}. This is
107      * zero by default.
108      *
109      * This value changes when {approve} or {transferFrom} are called.
110      */
111     function allowance(address owner, address spender) external view returns (uint256);
112 
113     /**
114      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * IMPORTANT: Beware that changing an allowance with this method brings the risk
119      * that someone may use both the old and the new allowance by unfortunate
120      * transaction ordering. One possible solution to mitigate this race
121      * condition is to first reduce the spender's allowance to 0 and set the
122      * desired value afterwards:
123      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address spender, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Moves `amount` tokens from `sender` to `recipient` using the
131      * allowance mechanism. `amount` is then deducted from the caller's
132      * allowance.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Emitted when `value` tokens are moved from one account (`from`) to
142      * another (`to`).
143      *
144      * Note that `value` may be zero.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 value);
147 
148     /**
149      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
150      * a call to {approve}. `value` is the new allowance.
151      */
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 library SafeMath {
156     /**
157      * @dev Returns the addition of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `+` operator.
161      *
162      * Requirements:
163      *
164      * - Addition cannot overflow.
165      */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184         return sub(a, b, "SafeMath: subtraction overflow");
185     }
186 
187     /**
188      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
189      * overflow (when the result is negative).
190      *
191      * Counterpart to Solidity's `-` operator.
192      *
193      * Requirements:
194      *
195      * - Subtraction cannot overflow.
196      */
197     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b <= a, errorMessage);
199         uint256 c = a - b;
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `*` operator.
209      *
210      * Requirements:
211      *
212      * - Multiplication cannot overflow.
213      */
214     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
215         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
216         // benefit is lost if 'b' is also tested.
217         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
218         if (a == 0) {
219             return 0;
220         }
221 
222         uint256 c = a * b;
223         require(c / a == b, "SafeMath: multiplication overflow");
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers. Reverts on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b) internal pure returns (uint256) {
241         return div(a, b, "SafeMath: division by zero");
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b > 0, errorMessage);
258         uint256 c = a / b;
259         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
277         return mod(a, b, "SafeMath: modulo by zero");
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * Reverts with custom message when dividing by zero.
283      *
284      * Counterpart to Solidity's `%` operator. This function uses a `revert`
285      * opcode (which leaves remaining gas untouched) while Solidity uses an
286      * invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b != 0, errorMessage);
294         return a % b;
295     }
296 }
297 
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
318         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
319         // for accounts without code, i.e. `keccak256('')`
320         bytes32 codehash;
321         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
322         // solhint-disable-next-line no-inline-assembly
323         assembly { codehash := extcodehash(account) }
324         return (codehash != accountHash && codehash != 0x0);
325     }
326 
327     /**
328      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
329      * `recipient`, forwarding all available gas and reverting on errors.
330      *
331      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
332      * of certain opcodes, possibly making contracts go over the 2300 gas limit
333      * imposed by `transfer`, making them unable to receive funds via
334      * `transfer`. {sendValue} removes this limitation.
335      *
336      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
337      *
338      * IMPORTANT: because control is transferred to `recipient`, care must be
339      * taken to not create reentrancy vulnerabilities. Consider using
340      * {ReentrancyGuard} or the
341      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
342      */
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
347         (bool success, ) = recipient.call{ value: amount }("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 
351     /**
352      * @dev Performs a Solidity function call using a low level `call`. A
353      * plain`call` is an unsafe replacement for a function call: use this
354      * function instead.
355      *
356      * If `target` reverts with a revert reason, it is bubbled up by this
357      * function (like regular Solidity function calls).
358      *
359      * Returns the raw returned data. To convert to the expected return value,
360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
361      *
362      * Requirements:
363      *
364      * - `target` must be a contract.
365      * - calling `target` with `data` must not revert.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
370       return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
380         return _functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
395         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
400      * with `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         return _functionCallWithValue(target, data, value, errorMessage);
407     }
408 
409     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
410         require(isContract(target), "Address: call to non-contract");
411 
412         // solhint-disable-next-line avoid-low-level-calls
413         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
414         if (success) {
415             return returndata;
416         } else {
417             // Look for revert reason and bubble it up if present
418             if (returndata.length > 0) {
419                 // The easiest way to bubble the revert reason is using memory via assembly
420 
421                 // solhint-disable-next-line no-inline-assembly
422                 assembly {
423                     let returndata_size := mload(returndata)
424                     revert(add(32, returndata), returndata_size)
425                 }
426             } else {
427                 revert(errorMessage);
428             }
429         }
430     }
431 }
432 
433 contract Ownable is Context {
434     address private _owner;
435 
436     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438     /**
439      * @dev Initializes the contract setting the deployer as the initial owner.
440      */
441     constructor () internal {
442         address msgSender = _msgSender();
443         _owner = msgSender;
444         emit OwnershipTransferred(address(0), msgSender);
445     }
446 
447     /**
448      * @dev Returns the address of the current owner.
449      */
450     function owner() public view returns (address) {
451         return _owner;
452     }
453 
454     /**
455      * @dev Throws if called by any account other than the owner.
456      */
457     modifier onlyOwner() {
458         require(_owner == _msgSender(), "Ownable: caller is not the owner");
459         _;
460     }
461 
462     /**
463      * @dev Leaves the contract without owner. It will not be possible to call
464      * `onlyOwner` functions anymore. Can only be called by the current owner.
465      *
466      * NOTE: Renouncing ownership will leave the contract without an owner,
467      * thereby removing any functionality that is only available to the owner.
468      */
469     function renounceOwnership() public virtual onlyOwner {
470         emit OwnershipTransferred(_owner, address(0));
471         _owner = address(0);
472     }
473 
474     /**
475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
476      * Can only be called by the current owner.
477      */
478     function transferOwnership(address newOwner) public virtual onlyOwner {
479         require(newOwner != address(0), "Ownable: new owner is the zero address");
480         emit OwnershipTransferred(_owner, newOwner);
481         _owner = newOwner;
482     }
483 }
484 
485 
486 
487 contract SiberianHusky is Context, IERC20, Ownable {
488     using SafeMath for uint256;
489     using Address for address;
490 
491     mapping (address => uint256) private _rOwned;
492     mapping (address => uint256) private _tOwned;
493     mapping (address => mapping (address => uint256)) private _allowances;
494 
495     mapping (address => bool) private _isExcluded;
496     address[] private _excluded;
497    
498     uint256 private constant MAX = ~uint256(0);
499     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
500     uint256 private _rTotal = (MAX - (MAX % _tTotal));
501     uint256 private _tFeeTotal;
502 
503     string private _name = 'Siberian Husky';
504     string private _symbol = 'SHUSKY';
505     uint8 private _decimals = 9;
506     
507     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
508 
509     constructor () public {
510         _rOwned[_msgSender()] = _rTotal;
511         emit Transfer(address(0), _msgSender(), _tTotal);
512     }
513 
514     function name() public view returns (string memory) {
515         return _name;
516     }
517 
518     function symbol() public view returns (string memory) {
519         return _symbol;
520     }
521 
522     function decimals() public view returns (uint8) {
523         return _decimals;
524     }
525 
526     function totalSupply() public view override returns (uint256) {
527         return _tTotal;
528     }
529 
530     function balanceOf(address account) public view override returns (uint256) {
531         if (_isExcluded[account]) return _tOwned[account];
532         return tokenFromReflection(_rOwned[account]);
533     }
534 
535     function transfer(address recipient, uint256 amount) public override returns (bool) {
536         _transfer(_msgSender(), recipient, amount);
537         return true;
538     }
539 
540     function allowance(address owner, address spender) public view override returns (uint256) {
541         return _allowances[owner][spender];
542     }
543 
544     function approve(address spender, uint256 amount) public override returns (bool) {
545         _approve(_msgSender(), spender, amount);
546         return true;
547     }
548 
549     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
550         _transfer(sender, recipient, amount);
551         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
552         return true;
553     }
554 
555     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
556         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
557         return true;
558     }
559 
560     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
561         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
562         return true;
563     }
564 
565     function isExcluded(address account) public view returns (bool) {
566         return _isExcluded[account];
567     }
568 
569     function totalFees() public view returns (uint256) {
570         return _tFeeTotal;
571     }
572     
573     
574     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
575         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
576             10**2
577         );
578     }
579     
580     function rescueFromContract() external onlyOwner {
581         address payable _owner = _msgSender();
582         _owner.transfer(address(this).balance);
583     }
584 
585     function reflect(uint256 tAmount) public {
586         address sender = _msgSender();
587         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
588         (uint256 rAmount,,,,) = _getValues(tAmount);
589         _rOwned[sender] = _rOwned[sender].sub(rAmount);
590         _rTotal = _rTotal.sub(rAmount);
591         _tFeeTotal = _tFeeTotal.add(tAmount);
592     }
593 
594     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
595         require(tAmount <= _tTotal, "Amount must be less than supply");
596         if (!deductTransferFee) {
597             (uint256 rAmount,,,,) = _getValues(tAmount);
598             return rAmount;
599         } else {
600             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
601             return rTransferAmount;
602         }
603     }
604 
605     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
606         require(rAmount <= _rTotal, "Amount must be less than total reflections");
607         uint256 currentRate =  _getRate();
608         return rAmount.div(currentRate);
609     }
610 
611     function excludeAccount(address account) external onlyOwner() {
612         require(!_isExcluded[account], "Account is already excluded");
613         if(_rOwned[account] > 0) {
614             _tOwned[account] = tokenFromReflection(_rOwned[account]);
615         }
616         _isExcluded[account] = true;
617         _excluded.push(account);
618     }
619 
620     function includeAccount(address account) external onlyOwner() {
621         require(_isExcluded[account], "Account is already excluded");
622         for (uint256 i = 0; i < _excluded.length; i++) {
623             if (_excluded[i] == account) {
624                 _excluded[i] = _excluded[_excluded.length - 1];
625                 _tOwned[account] = 0;
626                 _isExcluded[account] = false;
627                 _excluded.pop();
628                 break;
629             }
630         }
631     }
632 
633     function _approve(address owner, address spender, uint256 amount) private {
634         require(owner != address(0), "ERC20: approve from the zero address");
635         require(spender != address(0), "ERC20: approve to the zero address");
636 
637         _allowances[owner][spender] = amount;
638         emit Approval(owner, spender, amount);
639     }
640 
641     function _transfer(address sender, address recipient, uint256 amount) private {
642         require(sender != address(0), "ERC20: transfer from the zero address");
643         require(recipient != address(0), "ERC20: transfer to the zero address");
644         require(amount > 0, "Transfer amount must be greater than zero");
645         if(sender != owner() && recipient != owner())
646           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
647             
648         if (_isExcluded[sender] && !_isExcluded[recipient]) {
649             _transferFromExcluded(sender, recipient, amount);
650         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
651             _transferToExcluded(sender, recipient, amount);
652         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
653             _transferStandard(sender, recipient, amount);
654         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
655             _transferBothExcluded(sender, recipient, amount);
656         } else {
657             _transferStandard(sender, recipient, amount);
658         }
659     }
660 
661     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
662         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
663         _rOwned[sender] = _rOwned[sender].sub(rAmount);
664         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
665         _reflectFee(rFee, tFee);
666         emit Transfer(sender, recipient, tTransferAmount);
667     }
668 
669     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
670         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
671         _rOwned[sender] = _rOwned[sender].sub(rAmount);
672         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
673         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
674         _reflectFee(rFee, tFee);
675         emit Transfer(sender, recipient, tTransferAmount);
676     }
677 
678     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
679         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
680         _tOwned[sender] = _tOwned[sender].sub(tAmount);
681         _rOwned[sender] = _rOwned[sender].sub(rAmount);
682         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
683         _reflectFee(rFee, tFee);
684         emit Transfer(sender, recipient, tTransferAmount);
685     }
686 
687     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
688         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
689         _tOwned[sender] = _tOwned[sender].sub(tAmount);
690         _rOwned[sender] = _rOwned[sender].sub(rAmount);
691         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
692         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
693         _reflectFee(rFee, tFee);
694         emit Transfer(sender, recipient, tTransferAmount);
695     }
696 
697     function _reflectFee(uint256 rFee, uint256 tFee) private {
698         _rTotal = _rTotal.sub(rFee);
699         _tFeeTotal = _tFeeTotal.add(tFee);
700     }
701 
702     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
703         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
704         uint256 currentRate =  _getRate();
705         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
706         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
707     }
708 
709     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
710         uint256 tFee = tAmount.div(100).mul(2);
711         uint256 tTransferAmount = tAmount.sub(tFee);
712         return (tTransferAmount, tFee);
713     }
714 
715     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
716         uint256 rAmount = tAmount.mul(currentRate);
717         uint256 rFee = tFee.mul(currentRate);
718         uint256 rTransferAmount = rAmount.sub(rFee);
719         return (rAmount, rTransferAmount, rFee);
720     }
721 
722     function _getRate() private view returns(uint256) {
723         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
724         return rSupply.div(tSupply);
725     }
726 
727     function _getCurrentSupply() private view returns(uint256, uint256) {
728         uint256 rSupply = _rTotal;
729         uint256 tSupply = _tTotal;      
730         for (uint256 i = 0; i < _excluded.length; i++) {
731             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
732             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
733             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
734         }
735         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
736         return (rSupply, tSupply);
737     }
738 }