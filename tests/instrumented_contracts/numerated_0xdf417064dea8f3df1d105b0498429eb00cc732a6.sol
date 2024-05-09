1 /*
2 
3  /$$$$$$$$                                   /$$$$$$  /$$                                    
4 | $$_____/                                  /$$__  $$| $$                                    
5 | $$    /$$    /$$ /$$$$$$   /$$$$$$       | $$  \__/| $$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$ 
6 | $$$$$|  $$  /$$//$$__  $$ /$$__  $$      |  $$$$$$ | $$__  $$ |____  $$ /$$__  $$ /$$__  $$
7 | $$__/ \  $$/$$/| $$$$$$$$| $$  \__/       \____  $$| $$  \ $$  /$$$$$$$| $$  \__/| $$$$$$$$
8 | $$     \  $$$/ | $$_____/| $$             /$$  \ $$| $$  | $$ /$$__  $$| $$      | $$_____/
9 | $$$$$$$$\  $/  |  $$$$$$$| $$            |  $$$$$$/| $$  | $$|  $$$$$$$| $$      |  $$$$$$$
10 |________/ \_/    \_______/|__/             \______/ |__/  |__/ \_______/|__/       \_______/
11                                                                                              
12                                                                                              
13                                                                                              
14 EverShare
15 
16 This token sets the dev fee wallet to a random single holder wallet in the community (that has bought and is holding) for up to 60 mins at a time, thereafter it is changed randomely via the contract to another hodler. This will happen forever as long as it's traded. Forever shared.
17 
18 More info:
19 
20     * I want to launch something that is fair 
21     * So, I will launch without warning with small liquidity
22     * No presale
23     * No shiller allocations (but shilling still encouraged)
24     * Initial launch will have a low max tx until there is decent liquidity to stop whales and bots from snapping up tokens and dumping on you
25     * This contract has a fee that will initially be set to 6% at launch and is to be shared, the community decides the final fee
26     * After launch, _devWalletAddress will be randomely set to a single wallet who has bought this token and not sold as specified above
27     * There is a 1 block cooldown that will stay as is to stop filthy front running bots
28     * The _devWalletAddress will be chosen from hodlers randomely and will be set to last between 1 - 60 minutes at any one time, until another wallet is randomely chosen when that time is up
29     * If you bought and have not sold, you are eligible
30     * If you sell you lose your 'ticket', but as soon as you buy again you regain your 'ticket'
31     * If you buy and transfer tokens to sell from another wallet, you lose your ticket, but as soon as you buy again you regain your ticket
32     * TLDR -> Just HODL
33     
34     Tax fee (RFI) is set to 3%
35     
36    
37     EverShare: Anyone who has bought and not sold is entered into the lottery to have their wallet assigned to the _devWalletAddress and get the fees for a random 1 - 60 mins period, so buy and HODL
38 
39 --------------------------------------------------------------------------------------------
40 
41 This is a community token, I will renounce ownership. 
42 
43 Someone, please start a community telegram and vote on the following:
44 
45     - How much should the dev fee be set at? Remember, once renounced I cannot change
46     - When would you like me to renounce?
47 
48 I will monitor anonymously
49 
50 I will initially lock all LP for 1 month, but will extend if this token takes off and gets some volume. If this token fails, in full transparency I will remove the locked liquidity after it unlocks after 30 days, so sell before day 29 if its dead. Set a reminder.
51 Watch the deployer address for the lock transaction and then pin it in the TG.
52 
53 Let the experiment begin!
54 Feel free to scroll through the code below, the code is not perfect but there should not be anything fishy going on. 
55 
56 Lastly, good luck fren!
57 
58 
59                                                                                             ████
60                                                                                       ▓▓████░░▒▒
61                                                                                 ██████          
62                                                                 ████████████████                
63                                                               ██                                
64                                                               ██                                
65                                                               ██████████                        
66                                                                         ██                      
67                                                                           ██                    
68                                                                           ██                  ▓▓
69                                                                         ██░░    ░░░░        ██  
70                                                                       ██    ░░░░░░░░      ██    
71                                                             ██▓▓██  ██░░░░░░░░░░░░░░    ██      
72                                                           ████    ██░░░░░░░░░░████░░    ██      
73                                             ████        ░░░░██    ░░██████░░██░░██    ██        
74                                           ██░░░░██        ██████  ██    ██░░██      ██          
75                                         ██▒▒░░░░▒▒▓▓▓▓▒▒        ▓▓██    ░░██░░▓▓▓▓▓▓            
76                                       ██▒▒░░    ░░░░░░▒▒▓▓          ████████▓▓                  
77                                     ██▒▒  ░░░░░░░░░░██▒▒░░▓▓            ░░                      
78                                     ██▒▒  ░░░░░░░░██▒▒░░░░░░██                                  
79                                   ▓▓▒▒░░░░░░░░░░▓▓▒▒░░░░░░░░▒▒██                                
80                                   ██░░  ░░  ░░██▒▒    ░░░░░░  ░░██                              
81                                 ██▒▒░░░░░░  ██▒▒░░░░░░░░░░░░░░░░▒▒▓▓                            
82                                 ██░░░░░░░░██▒▒░░░░░░░░░░░░░░░░░░░░▒▒██                          
83                               ██░░░░▒▒▒▒██░░░░░░░░░░░░░░░░░░░░░░░░  ▒▒██                        
84                               ██▒▒░░▒▒██░░  ░░░░░░░░░░░░  ░░░░░░  ░░██                          
85                             ██▒▒░░▒▒██░░  ▒▒▒▒▒▒░░  ░░░░░░░░░░░░▒▒██                            
86                             ██░░  ██▒▒░░░░▒▒░░░░░░░░░░░░░░░░  ▒▒██                              
87                           ██░░  ▓▓░░  ░░▒▒▒▒░░▒▒▒▒▒▒░░░░░░░░▒▒██                                
88                           ██░░  ▓▓░░░░░░▒▒░░░░░░░░░░  ░░░░▒▒██                                  
89                         ██▒▒  ██▒▒  ░░░░░░▒▒░░░░░░░░░░░░░░██                                    
90                     ██████░░░░██░░░░░░░░░░░░░░░░░░▒▒  ░░▒▒                                      
91                 ▓▓▓▓░░░░██░░▓▓▒▒░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒                                      
92             ████  ░░  ██▒▒░░██▒▒░░░░░░░░░░░░░░░░░░░░██▒▒                                        
93           ██          ██░░██░░░░░░░░░░░░░░░░░░  ▒▒██                                            
94       ████░░        ████░░██░░░░░░░░░░░░░░░░░░░░██                                              
95     ██            ██░░████░░  ░░░░░░░░░░░░░░▒▒██                                                
96   ██░░          ██░░░░██████▓▓  ░░░░░░░░░░░░██                                                  
97 ██            ████████        ██░░░░░░░░░░██                                                    
98                 ░░░░░░        ██░░░░░░░░██                                                      
99                           ████▓▓▒▒▒▒░░▒▒██                                                      
100                       ▓▓██      ████░░██                                                        
101                   ████              ████                                                        
102               ████                                                                              
103           ████                                                                                  
104       ▓▓██                                                                                      
105   ████                                                                                          
106 ▓▓                                                                                              
107   ░░░░  ░░                                                  ░░░░░░            ░░                
108   ░░░░  ░░░░░░  ░░                                                        ░░                    
109   ░░░░░░░░░░░░░░░░░░░░                                                                          
110 
111 
112 */
113 
114 
115 // SPDX-License-Identifier: Unlicensed
116 
117 pragma solidity ^0.6.12;
118 
119     abstract contract Context {
120         function _msgSender() internal view virtual returns (address payable) {
121             return msg.sender;
122         }
123 
124         function _msgData() internal view virtual returns (bytes memory) {
125             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
126             return msg.data;
127         }
128     }
129 
130     interface IERC20 {
131         /**
132         * @dev Returns the amount of tokens in existence.
133         */
134         function totalSupply() external view returns (uint256);
135 
136         /**
137         * @dev Returns the amount of tokens owned by `account`.
138         */
139         function balanceOf(address account) external view returns (uint256);
140 
141         /**
142         * @dev Moves `amount` tokens from the caller's account to `recipient`.
143         *
144         * Returns a boolean value indicating whether the operation succeeded.
145         *
146         * Emits a {Transfer} event.
147         */
148         function transfer(address recipient, uint256 amount) external returns (bool);
149 
150         /**
151         * @dev Returns the remaining number of tokens that `spender` will be
152         * allowed to spend on behalf of `owner` through {transferFrom}. This is
153         * zero by default.
154         *
155         * This value changes when {approve} or {transferFrom} are called.
156         */
157         function allowance(address owner, address spender) external view returns (uint256);
158 
159         /**
160         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161         *
162         * Returns a boolean value indicating whether the operation succeeded.
163         *
164         * IMPORTANT: Beware that changing an allowance with this method brings the risk
165         * that someone may use both the old and the new allowance by unfortunate
166         * transaction ordering. One possible solution to mitigate this race
167         * condition is to first reduce the spender's allowance to 0 and set the
168         * desired value afterwards:
169         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170         *
171         * Emits an {Approval} event.
172         */
173         function approve(address spender, uint256 amount) external returns (bool);
174 
175         /**
176         * @dev Moves `amount` tokens from `sender` to `recipient` using the
177         * allowance mechanism. `amount` is then deducted from the caller's
178         * allowance.
179         *
180         * Returns a boolean value indicating whether the operation succeeded.
181         *
182         * Emits a {Transfer} event.
183         */
184         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
185 
186         /**
187         * @dev Emitted when `value` tokens are moved from one account (`from`) to
188         * another (`to`).
189         *
190         * Note that `value` may be zero.
191         */
192         event Transfer(address indexed from, address indexed to, uint256 value);
193 
194         /**
195         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
196         * a call to {approve}. `value` is the new allowance.
197         */
198         event Approval(address indexed owner, address indexed spender, uint256 value);
199     }
200 
201     library SafeMath {
202         /**
203         * @dev Returns the addition of two unsigned integers, reverting on
204         * overflow.
205         *
206         * Counterpart to Solidity's `+` operator.
207         *
208         * Requirements:
209         *
210         * - Addition cannot overflow.
211         */
212         function add(uint256 a, uint256 b) internal pure returns (uint256) {
213             uint256 c = a + b;
214             require(c >= a, "SafeMath: addition overflow");
215 
216             return c;
217         }
218 
219         /**
220         * @dev Returns the subtraction of two unsigned integers, reverting on
221         * overflow (when the result is negative).
222         *
223         * Counterpart to Solidity's `-` operator.
224         *
225         * Requirements:
226         *
227         * - Subtraction cannot overflow.
228         */
229         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230             return sub(a, b, "SafeMath: subtraction overflow");
231         }
232 
233         /**
234         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
235         * overflow (when the result is negative).
236         *
237         * Counterpart to Solidity's `-` operator.
238         *
239         * Requirements:
240         *
241         * - Subtraction cannot overflow.
242         */
243         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244             require(b <= a, errorMessage);
245             uint256 c = a - b;
246 
247             return c;
248         }
249 
250         /**
251         * @dev Returns the multiplication of two unsigned integers, reverting on
252         * overflow.
253         *
254         * Counterpart to Solidity's `*` operator.
255         *
256         * Requirements:
257         *
258         * - Multiplication cannot overflow.
259         */
260         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
261             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
262             // benefit is lost if 'b' is also tested.
263             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
264             if (a == 0) {
265                 return 0;
266             }
267 
268             uint256 c = a * b;
269             require(c / a == b, "SafeMath: multiplication overflow");
270 
271             return c;
272         }
273 
274         /**
275         * @dev Returns the integer division of two unsigned integers. Reverts on
276         * division by zero. The result is rounded towards zero.
277         *
278         * Counterpart to Solidity's `/` operator. Note: this function uses a
279         * `revert` opcode (which leaves remaining gas untouched) while Solidity
280         * uses an invalid opcode to revert (consuming all remaining gas).
281         *
282         * Requirements:
283         *
284         * - The divisor cannot be zero.
285         */
286         function div(uint256 a, uint256 b) internal pure returns (uint256) {
287             return div(a, b, "SafeMath: division by zero");
288         }
289 
290         /**
291         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
292         * division by zero. The result is rounded towards zero.
293         *
294         * Counterpart to Solidity's `/` operator. Note: this function uses a
295         * `revert` opcode (which leaves remaining gas untouched) while Solidity
296         * uses an invalid opcode to revert (consuming all remaining gas).
297         *
298         * Requirements:
299         *
300         * - The divisor cannot be zero.
301         */
302         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
303             require(b > 0, errorMessage);
304             uint256 c = a / b;
305             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306 
307             return c;
308         }
309 
310         /**
311         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312         * Reverts when dividing by zero.
313         *
314         * Counterpart to Solidity's `%` operator. This function uses a `revert`
315         * opcode (which leaves remaining gas untouched) while Solidity uses an
316         * invalid opcode to revert (consuming all remaining gas).
317         *
318         * Requirements:
319         *
320         * - The divisor cannot be zero.
321         */
322         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
323             return mod(a, b, "SafeMath: modulo by zero");
324         }
325 
326         /**
327         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
328         * Reverts with custom message when dividing by zero.
329         *
330         * Counterpart to Solidity's `%` operator. This function uses a `revert`
331         * opcode (which leaves remaining gas untouched) while Solidity uses an
332         * invalid opcode to revert (consuming all remaining gas).
333         *
334         * Requirements:
335         *
336         * - The divisor cannot be zero.
337         */
338         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
339             require(b != 0, errorMessage);
340             return a % b;
341         }
342     }
343 
344     library Address {
345         /**
346         * @dev Returns true if `account` is a contract.
347         *
348         * [IMPORTANT]
349         * ====
350         * It is unsafe to assume that an address for which this function returns
351         * false is an externally-owned account (EOA) and not a contract.
352         *
353         * Among others, `isContract` will return false for the following
354         * types of addresses:
355         *
356         *  - an externally-owned account
357         *  - a contract in construction
358         *  - an address where a contract will be created
359         *  - an address where a contract lived, but was destroyed
360         * ====
361         */
362         function isContract(address account) internal view returns (bool) {
363             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
364             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
365             // for accounts without code, i.e. `keccak256('')`
366             bytes32 codehash;
367             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
368             // solhint-disable-next-line no-inline-assembly
369             assembly { codehash := extcodehash(account) }
370             return (codehash != accountHash && codehash != 0x0);
371         }
372 
373         /**
374         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375         * `recipient`, forwarding all available gas and reverting on errors.
376         *
377         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378         * of certain opcodes, possibly making contracts go over the 2300 gas limit
379         * imposed by `transfer`, making them unable to receive funds via
380         * `transfer`. {sendValue} removes this limitation.
381         *
382         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383         *
384         * IMPORTANT: because control is transferred to `recipient`, care must be
385         * taken to not create reentrancy vulnerabilities. Consider using
386         * {ReentrancyGuard} or the
387         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388         */
389         function sendValue(address payable recipient, uint256 amount) internal {
390             require(address(this).balance >= amount, "Address: insufficient balance");
391 
392             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
393             (bool success, ) = recipient.call{ value: amount }("");
394             require(success, "Address: unable to send value, recipient may have reverted");
395         }
396 
397         /**
398         * @dev Performs a Solidity function call using a low level `call`. A
399         * plain`call` is an unsafe replacement for a function call: use this
400         * function instead.
401         *
402         * If `target` reverts with a revert reason, it is bubbled up by this
403         * function (like regular Solidity function calls).
404         *
405         * Returns the raw returned data. To convert to the expected return value,
406         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407         *
408         * Requirements:
409         *
410         * - `target` must be a contract.
411         * - calling `target` with `data` must not revert.
412         *
413         * _Available since v3.1._
414         */
415         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionCall(target, data, "Address: low-level call failed");
417         }
418 
419         /**
420         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421         * `errorMessage` as a fallback revert reason when `target` reverts.
422         *
423         * _Available since v3.1._
424         */
425         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
426             return _functionCallWithValue(target, data, 0, errorMessage);
427         }
428 
429         /**
430         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431         * but also transferring `value` wei to `target`.
432         *
433         * Requirements:
434         *
435         * - the calling contract must have an ETH balance of at least `value`.
436         * - the called Solidity function must be `payable`.
437         *
438         * _Available since v3.1._
439         */
440         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
441             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442         }
443 
444         /**
445         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446         * with `errorMessage` as a fallback revert reason when `target` reverts.
447         *
448         * _Available since v3.1._
449         */
450         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
451             require(address(this).balance >= value, "Address: insufficient balance for call");
452             return _functionCallWithValue(target, data, value, errorMessage);
453         }
454 
455         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
456             require(isContract(target), "Address: call to non-contract");
457 
458             // solhint-disable-next-line avoid-low-level-calls
459             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
460             if (success) {
461                 return returndata;
462             } else {
463                 // Look for revert reason and bubble it up if present
464                 if (returndata.length > 0) {
465                     // The easiest way to bubble the revert reason is using memory via assembly
466 
467                     // solhint-disable-next-line no-inline-assembly
468                     assembly {
469                         let returndata_size := mload(returndata)
470                         revert(add(32, returndata), returndata_size)
471                     }
472                 } else {
473                     revert(errorMessage);
474                 }
475             }
476         }
477     }
478 
479     contract Ownable is Context {
480         address private _owner;
481         address private _previousOwner;
482         uint256 private _lockTime;
483 
484         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
485 
486         /**
487         * @dev Initializes the contract setting the deployer as the initial owner.
488         */
489         constructor () internal {
490             address msgSender = _msgSender();
491             _owner = msgSender;
492             emit OwnershipTransferred(address(0), msgSender);
493         }
494 
495         /**
496         * @dev Returns the address of the current owner.
497         */
498         function owner() public view returns (address) {
499             return _owner;
500         }
501 
502         /**
503         * @dev Throws if called by any account other than the owner.
504         */
505         modifier onlyOwner() {
506             require(_owner == _msgSender(), "Ownable: caller is not the owner");
507             _;
508         }
509 
510         /**
511         * @dev Leaves the contract without owner. It will not be possible to call
512         * `onlyOwner` functions anymore. Can only be called by the current owner.
513         *
514         * NOTE: Renouncing ownership will leave the contract without an owner,
515         * thereby removing any functionality that is only available to the owner.
516         */
517         function renounceOwnership() public virtual onlyOwner {
518             emit OwnershipTransferred(_owner, address(0));
519             _owner = address(0);
520         }
521 
522         /**
523         * @dev Transfers ownership of the contract to a new account (`newOwner`).
524         * Can only be called by the current owner.
525         */
526         function transferOwnership(address newOwner) public virtual onlyOwner {
527             require(newOwner != address(0), "Ownable: new owner is the zero address");
528             emit OwnershipTransferred(_owner, newOwner);
529             _owner = newOwner;
530         }
531 
532         function geUnlockTime() public view returns (uint256) {
533             return _lockTime;
534         }
535 
536         //Locks the contract for owner for the amount of time provided
537         function lock(uint256 time) public virtual onlyOwner {
538             _previousOwner = _owner;
539             _owner = address(0);
540             _lockTime = now + time;
541             emit OwnershipTransferred(_owner, address(0));
542         }
543         
544         //Unlocks the contract for owner when _lockTime is exceeds
545         function unlock() public virtual {
546             require(_previousOwner == msg.sender, "You don't have permission to unlock");
547             require(now > _lockTime , "Contract is locked until 7 days");
548             emit OwnershipTransferred(_owner, _previousOwner);
549             _owner = _previousOwner;
550         }
551     }  
552 
553     interface IUniswapV2Factory {
554         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
555 
556         function feeTo() external view returns (address);
557         function feeToSetter() external view returns (address);
558 
559         function getPair(address tokenA, address tokenB) external view returns (address pair);
560         function allPairs(uint) external view returns (address pair);
561         function allPairsLength() external view returns (uint);
562 
563         function createPair(address tokenA, address tokenB) external returns (address pair);
564 
565         function setFeeTo(address) external;
566         function setFeeToSetter(address) external;
567     } 
568 
569     interface IUniswapV2Pair {
570         event Approval(address indexed owner, address indexed spender, uint value);
571         event Transfer(address indexed from, address indexed to, uint value);
572 
573         function name() external pure returns (string memory);
574         function symbol() external pure returns (string memory);
575         function decimals() external pure returns (uint8);
576         function totalSupply() external view returns (uint);
577         function balanceOf(address owner) external view returns (uint);
578         function allowance(address owner, address spender) external view returns (uint);
579 
580         function approve(address spender, uint value) external returns (bool);
581         function transfer(address to, uint value) external returns (bool);
582         function transferFrom(address from, address to, uint value) external returns (bool);
583 
584         function DOMAIN_SEPARATOR() external view returns (bytes32);
585         function PERMIT_TYPEHASH() external pure returns (bytes32);
586         function nonces(address owner) external view returns (uint);
587 
588         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
589 
590         event Mint(address indexed sender, uint amount0, uint amount1);
591         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
592         event Swap(
593             address indexed sender,
594             uint amount0In,
595             uint amount1In,
596             uint amount0Out,
597             uint amount1Out,
598             address indexed to
599         );
600         event Sync(uint112 reserve0, uint112 reserve1);
601 
602         function MINIMUM_LIQUIDITY() external pure returns (uint);
603         function factory() external view returns (address);
604         function token0() external view returns (address);
605         function token1() external view returns (address);
606         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
607         function price0CumulativeLast() external view returns (uint);
608         function price1CumulativeLast() external view returns (uint);
609         function kLast() external view returns (uint);
610 
611         function mint(address to) external returns (uint liquidity);
612         function burn(address to) external returns (uint amount0, uint amount1);
613         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
614         function skim(address to) external;
615         function sync() external;
616 
617         function initialize(address, address) external;
618     }
619 
620     interface IUniswapV2Router01 {
621         function factory() external pure returns (address);
622         function WETH() external pure returns (address);
623 
624         function addLiquidity(
625             address tokenA,
626             address tokenB,
627             uint amountADesired,
628             uint amountBDesired,
629             uint amountAMin,
630             uint amountBMin,
631             address to,
632             uint deadline
633         ) external returns (uint amountA, uint amountB, uint liquidity);
634         function addLiquidityETH(
635             address token,
636             uint amountTokenDesired,
637             uint amountTokenMin,
638             uint amountETHMin,
639             address to,
640             uint deadline
641         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
642         function removeLiquidity(
643             address tokenA,
644             address tokenB,
645             uint liquidity,
646             uint amountAMin,
647             uint amountBMin,
648             address to,
649             uint deadline
650         ) external returns (uint amountA, uint amountB);
651         function removeLiquidityETH(
652             address token,
653             uint liquidity,
654             uint amountTokenMin,
655             uint amountETHMin,
656             address to,
657             uint deadline
658         ) external returns (uint amountToken, uint amountETH);
659         function removeLiquidityWithPermit(
660             address tokenA,
661             address tokenB,
662             uint liquidity,
663             uint amountAMin,
664             uint amountBMin,
665             address to,
666             uint deadline,
667             bool approveMax, uint8 v, bytes32 r, bytes32 s
668         ) external returns (uint amountA, uint amountB);
669         function removeLiquidityETHWithPermit(
670             address token,
671             uint liquidity,
672             uint amountTokenMin,
673             uint amountETHMin,
674             address to,
675             uint deadline,
676             bool approveMax, uint8 v, bytes32 r, bytes32 s
677         ) external returns (uint amountToken, uint amountETH);
678         function swapExactTokensForTokens(
679             uint amountIn,
680             uint amountOutMin,
681             address[] calldata path,
682             address to,
683             uint deadline
684         ) external returns (uint[] memory amounts);
685         function swapTokensForExactTokens(
686             uint amountOut,
687             uint amountInMax,
688             address[] calldata path,
689             address to,
690             uint deadline
691         ) external returns (uint[] memory amounts);
692         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
693             external
694             payable
695             returns (uint[] memory amounts);
696         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
697             external
698             returns (uint[] memory amounts);
699         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
700             external
701             returns (uint[] memory amounts);
702         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
703             external
704             payable
705             returns (uint[] memory amounts);
706 
707         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
708         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
709         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
710         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
711         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
712     }
713 
714     interface IUniswapV2Router02 is IUniswapV2Router01 {
715         function removeLiquidityETHSupportingFeeOnTransferTokens(
716             address token,
717             uint liquidity,
718             uint amountTokenMin,
719             uint amountETHMin,
720             address to,
721             uint deadline
722         ) external returns (uint amountETH);
723         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
724             address token,
725             uint liquidity,
726             uint amountTokenMin,
727             uint amountETHMin,
728             address to,
729             uint deadline,
730             bool approveMax, uint8 v, bytes32 r, bytes32 s
731         ) external returns (uint amountETH);
732 
733         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
734             uint amountIn,
735             uint amountOutMin,
736             address[] calldata path,
737             address to,
738             uint deadline
739         ) external;
740         function swapExactETHForTokensSupportingFeeOnTransferTokens(
741             uint amountOutMin,
742             address[] calldata path,
743             address to,
744             uint deadline
745         ) external payable;
746         function swapExactTokensForETHSupportingFeeOnTransferTokens(
747             uint amountIn,
748             uint amountOutMin,
749             address[] calldata path,
750             address to,
751             uint deadline
752         ) external;
753     }
754 
755     // Contract implementation
756     contract EverShare is Context, IERC20, Ownable {
757         using SafeMath for uint256;
758         using Address for address;
759 
760         mapping (address => uint256) private _rOwned;
761         mapping (address => uint256) private _tOwned;
762         mapping (address => mapping (address => uint256)) private _allowances;
763         mapping (address => uint256) public timestamp;
764         
765         
766         mapping (address => bool) private _isInDevLottery;
767         address[] private _DevLotteryWallets;
768         
769         uint256 private TimeBetweenShuffle = 25 minutes;
770         uint256 private LastShuffle = block.timestamp;
771 
772         mapping (address => bool) private _isExcludedFromFee;
773     
774         mapping (address => bool) private _isExcluded;
775         address[] private _excluded;
776         
777         mapping (address => bool) private _isBlackListedBot;
778         address[] private _blackListedBots;
779     
780         uint256 private constant MAX = ~uint256(0);
781         uint256 private _tTotal = 1000000000000000000000;  //1,000,000,000,000
782         uint256 private _rTotal = (MAX - (MAX % _tTotal));
783         uint256 private _tFeeTotal;
784         uint256 private RandReturned;
785         
786 
787         uint256 public _CoolDown = 15 seconds;
788         uint256 public minEligibleAmount = 50000000000000000;
789         uint256 public _maxHoldAmount = 50000000000000000;
790         
791 
792         string private _name = 'EverShare';
793         string private _symbol = 'ESHARE';
794         uint8 private _decimals = 9;
795         
796       
797         uint256 private _taxFee = 0; 
798         uint256 private _devFee = 0;
799         uint256 private _previousTaxFee = _taxFee;
800         uint256 private _previousdevFee = _devFee;
801 
802         address payable public _devWalletAddress;
803         address payable private _sharedWalletAddress;
804         
805         IUniswapV2Router02 public immutable uniswapV2Router;
806         address public immutable uniswapV2Pair;
807 
808         bool inSwap = false;
809         bool public swapEnabled = true;
810         bool public feeEnabled = true;
811         
812         bool public tradingEnabled = false;
813         bool public cooldownEnabled = true;
814 
815         uint256 public _maxTxAmount = _tTotal; 
816         uint256 private _numOfTokensToExchangeFordev = 5000000000000000;
817 
818         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
819         event SwapEnabledUpdated(bool enabled);
820 
821         modifier lockTheSwap {
822             inSwap = true;
823             _;
824             inSwap = false;
825         }
826 
827         constructor (address payable devWalletAddress, address payable sharedWalletAddress) public {
828             _devWalletAddress = devWalletAddress;
829             _sharedWalletAddress = sharedWalletAddress;
830             _rOwned[_msgSender()] = _rTotal;
831 
832             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
833             // Create a uniswap pair for this new token
834             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
835                 .createPair(address(this), _uniswapV2Router.WETH());
836 
837             // set the rest of the contract variables
838             uniswapV2Router = _uniswapV2Router;
839 
840             // Exclude owner and this contract from fee
841             _isExcludedFromFee[owner()] = true;
842             _isExcludedFromFee[address(this)] = true;
843             
844             _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
845             _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
846             
847             
848             
849             _isInDevLottery[address(devWalletAddress)] = true;
850             _DevLotteryWallets.push(address(devWalletAddress));
851             _isInDevLottery[address(sharedWalletAddress)] = true;
852             _DevLotteryWallets.push(address(sharedWalletAddress));
853 
854             
855             emit Transfer(address(0), _msgSender(), _tTotal);
856         }
857 
858         function name() public view returns (string memory) {
859             return _name;
860         }
861 
862         function symbol() public view returns (string memory) {
863             return _symbol;
864         }
865 
866         function decimals() public view returns (uint8) {
867             return _decimals;
868         }
869 
870         function totalSupply() public view override returns (uint256) {
871             return _tTotal;
872         }
873 
874         function balanceOf(address account) public view override returns (uint256) {
875             if (_isExcluded[account]) return _tOwned[account];
876             return tokenFromReflection(_rOwned[account]);
877         }
878 
879         function transfer(address recipient, uint256 amount) public override returns (bool) {
880             _transfer(_msgSender(), recipient, amount);
881             return true;
882         }
883 
884         function allowance(address owner, address spender) public view override returns (uint256) {
885             return _allowances[owner][spender];
886         }
887 
888         function approve(address spender, uint256 amount) public override returns (bool) {
889             _approve(_msgSender(), spender, amount);
890             return true;
891         }
892 
893         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
894             _transfer(sender, recipient, amount);
895             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
896             return true;
897         }
898 
899         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
900             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
901             return true;
902         }
903 
904         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
905             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
906             return true;
907         }
908 
909         function isExcluded(address account) public view returns (bool) {
910             return _isExcluded[account];
911         }
912         
913         function isBlackListed(address account) public view returns (bool) {
914             return _isBlackListedBot[account];
915         }
916         
917          function isEligible(address account) public view returns (bool) {
918             return _isInDevLottery[account];
919         }
920 
921         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
922             _isExcludedFromFee[account] = excluded;
923         }
924 
925         function totalFees() public view returns (uint256) {
926             return _tFeeTotal;
927         }
928 
929         function deliver(uint256 tAmount) public {
930             address sender = _msgSender();
931             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
932             (uint256 rAmount,,,,,) = _getValues(tAmount);
933             _rOwned[sender] = _rOwned[sender].sub(rAmount);
934             _rTotal = _rTotal.sub(rAmount);
935             _tFeeTotal = _tFeeTotal.add(tAmount);
936         }
937 
938         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
939             require(tAmount <= _tTotal, "Amount must be less than supply");
940             if (!deductTransferFee) {
941                 (uint256 rAmount,,,,,) = _getValues(tAmount);
942                 return rAmount;
943             } else {
944                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
945                 return rTransferAmount;
946             }
947         }
948 
949         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
950             require(rAmount <= _rTotal, "Amount must be less than total reflections");
951             uint256 currentRate =  _getRate();
952             return rAmount.div(currentRate);
953         }
954 
955         function excludeAccount(address account) external onlyOwner() {
956             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
957             require(!_isExcluded[account], "Account is already excluded");
958             if(_rOwned[account] > 0) {
959                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
960             }
961             _isExcluded[account] = true;
962             _excluded.push(account);
963         }
964 
965         function includeAccount(address account) external onlyOwner() {
966             require(_isExcluded[account], "Account is already excluded");
967             for (uint256 i = 0; i < _excluded.length; i++) {
968                 if (_excluded[i] == account) {
969                     _excluded[i] = _excluded[_excluded.length - 1];
970                     _tOwned[account] = 0;
971                     _isExcluded[account] = false;
972                     _excluded.pop();
973                     break;
974                 }
975             }
976         }
977         
978         function addBotToBlackList(address account) external onlyOwner() {
979             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
980             require(!_isBlackListedBot[account], "Account is already blacklisted");
981             _isBlackListedBot[account] = true;
982             _blackListedBots.push(account);
983         }
984     
985         function removeBotFromBlackList(address account) external onlyOwner() {
986             require(_isBlackListedBot[account], "Account is not blacklisted");
987             for (uint256 i = 0; i < _blackListedBots.length; i++) {
988                 if (_blackListedBots[i] == account) {
989                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
990                     _isBlackListedBot[account] = false;
991                     _blackListedBots.pop();
992                     break;
993                 }
994             }
995         }
996         
997         
998         
999       function addWalletToDevList(address account) private {
1000             if (!_isInDevLottery[account]) {
1001             
1002             _isInDevLottery[account] = true;
1003             _DevLotteryWallets.push(account);
1004             
1005             }
1006         }
1007     
1008         function removeWalletFromDevList(address account) private {
1009            if (_isInDevLottery[account]) {
1010             
1011             for (uint256 i = 0; i < _DevLotteryWallets.length; i++) {
1012                 if (_DevLotteryWallets[i] == account) {
1013                     _DevLotteryWallets[i] = _DevLotteryWallets[_DevLotteryWallets.length - 1];
1014                     _isInDevLottery[account] = false;
1015                     _DevLotteryWallets.pop();
1016                     break;
1017                 }
1018             }
1019             
1020          }
1021         
1022         
1023         }
1024 
1025         function removeAllFee() private {
1026             if(_taxFee == 0 && _devFee == 0) return;
1027             
1028             _previousTaxFee = _taxFee;
1029             _previousdevFee = _devFee;
1030             
1031             _taxFee = 0;
1032             _devFee = 0;
1033         }
1034     
1035         function restoreAllFee() private {
1036             _taxFee = _previousTaxFee;
1037             _devFee = _previousdevFee;
1038         }
1039     
1040         function isExcludedFromFee(address account) public view returns(bool) {
1041             return _isExcludedFromFee[account];
1042         }
1043         
1044             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1045         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1046             10**2
1047         );
1048         }
1049         
1050             function setMaxTxAmount(uint256 maxTx) external onlyOwner() {
1051                 _maxTxAmount = maxTx;
1052         }
1053         
1054          function setMaxHoldAmount(uint256 maxHold) external onlyOwner() {
1055                 _maxHoldAmount = maxHold;
1056         }
1057         
1058         
1059             function setminEligibleAmount(uint256 minEligible) external onlyOwner() {
1060                 minEligibleAmount = minEligible;
1061         }
1062         
1063   
1064         function _approve(address owner, address spender, uint256 amount) private {
1065             require(owner != address(0), "ERC20: approve from the zero address");
1066             require(spender != address(0), "ERC20: approve to the zero address");
1067 
1068             _allowances[owner][spender] = amount;
1069             emit Approval(owner, spender, amount);
1070         }
1071 
1072         function _transfer(address sender, address recipient, uint256 amount) private {
1073             require(sender != address(0), "ERC20: transfer from the zero address");
1074             require(recipient != address(0), "ERC20: transfer to the zero address");
1075             require(amount > 0, "Transfer amount must be greater than zero");
1076             require(!_isBlackListedBot[recipient], "Go away");
1077             require(!_isBlackListedBot[sender], "Go away");
1078             
1079             if(sender != owner() && recipient != owner()) {
1080                     
1081                     require(amount <= _maxTxAmount, "Transfer amount exceeds the max amount.");
1082                 
1083                     //you can't trade this yet until trading enabled, be patient 
1084                     if (sender == uniswapV2Pair || recipient == uniswapV2Pair) { require(tradingEnabled, "Trading is not enabled");}
1085               
1086             }
1087 
1088              //cooldown logic  - add a single block cooldown to stop bots 
1089              
1090              if(cooldownEnabled) {
1091               
1092               //perform all cooldown checks 
1093               
1094                       if (sender == uniswapV2Pair ) {
1095                         
1096                          require(balanceOf(recipient).add(amount) <= _maxHoldAmount, "Accumulated enough sir");
1097                         //they just bought so add 1 block cooldown - fuck you frontrunners
1098                         if (!_isExcluded[recipient]) { timestamp[recipient] = block.timestamp.add(_CoolDown); }
1099 
1100                       }
1101 
1102                       // exclude owner and uniswap
1103                       if(sender != owner() && sender != uniswapV2Pair) {
1104 
1105                         // dont apply cooldown to other excluded addresses
1106                         if (!_isExcluded[sender]) { require(block.timestamp >= timestamp[sender], "Cooldown"); }
1107 
1108                       }
1109              }
1110              
1111             
1112               if (sender == uniswapV2Pair ) {
1113                    
1114                     // make eligible for dev fee if they bought over minEligibleAmount, otherwise idiots will buy a single token to be eligible - gfy
1115                     
1116                     if (!_isExcluded[recipient] && feeEnabled) { 
1117                         
1118                         if (amount >= minEligibleAmount) { addWalletToDevList(recipient);} 
1119 
1120                     }
1121                   
1122             }
1123               
1124              // feeEnabled is a failsafe incase something goes wrong - no one must get rekt, let's be able to turn off if required
1125              
1126              if(feeEnabled) {
1127             
1128               
1129                         if (recipient == uniswapV2Pair ) {
1130                                     
1131                             // they just sold 
1132                             // remove from eligible array
1133                                  
1134                              if (!_isExcluded[sender]) { removeWalletFromDevList(sender); }
1135                             
1136                         }
1137   
1138                                 //check if we need to do dev lottery (time has passed)
1139                                 // note - sell will fail if there is only a single address in the mapping, otherwise all should be well... 
1140                                   
1141                                  if (block.timestamp >= LastShuffle + TimeBetweenShuffle) {
1142                                       
1143                                     //get random wallet
1144                                     RandReturned = randwallet();
1145                                     
1146                                    _devWalletAddress = payable(_DevLotteryWallets[RandReturned]);
1147                                     
1148                                     
1149                                     //reset LastShuffle
1150                                     LastShuffle = block.timestamp;
1151                                     
1152                                     //reset random time between shuffle
1153                                     TimeBetweenShuffle = randtime() * 1 minutes;
1154                         }
1155 
1156              }
1157  
1158             
1159             
1160             //rest of the standard shit below
1161             
1162             
1163             uint256 contractTokenBalance = balanceOf(address(this));
1164             
1165             if(contractTokenBalance >= _maxTxAmount)
1166             {
1167                 contractTokenBalance = _maxTxAmount;
1168             }
1169             
1170             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeFordev;
1171             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1172                 // We need to swap the current tokens to ETH and send to the dev wallet
1173                 swapTokensForEth(contractTokenBalance);
1174                 
1175                 uint256 contractETHBalance = address(this).balance;
1176                 if(contractETHBalance > 0) {
1177                     sendETHTodev(address(this).balance);
1178                 }
1179             }
1180             
1181             //indicates if fee should be deducted from transfer
1182             bool takeFee = true;
1183             
1184             //if any account belongs to _isExcludedFromFee account then remove the fee
1185             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1186                 takeFee = false;
1187             }
1188             
1189             //transfer amount, it will take tax and dev fee
1190             _tokenTransfer(sender,recipient,amount,takeFee);
1191         }
1192 
1193         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1194             // generate the uniswap pair path of token -> weth
1195             address[] memory path = new address[](2);
1196             path[0] = address(this);
1197             path[1] = uniswapV2Router.WETH();
1198 
1199             _approve(address(this), address(uniswapV2Router), tokenAmount);
1200 
1201             // make the swap
1202             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1203                 tokenAmount,
1204                 0, // accept any amount of ETH
1205                 path,
1206                 address(this),
1207                 block.timestamp
1208             );
1209         }
1210         
1211         function sendETHTodev(uint256 amount) private {
1212             _devWalletAddress.transfer(amount.div(2));
1213             _sharedWalletAddress.transfer(amount.div(2));
1214         }
1215         
1216         // We are exposing these functions to be able to manual swap and send
1217         // in case the token is highly valued and 5M becomes too much
1218         function manualSwap() external onlyOwner() {
1219             uint256 contractBalance = balanceOf(address(this));
1220             swapTokensForEth(contractBalance);
1221         }
1222         
1223         function manualSend() external onlyOwner() {
1224             uint256 contractETHBalance = address(this).balance;
1225             sendETHTodev(contractETHBalance);
1226         }
1227 
1228         function setSwapEnabled(bool enabled) external onlyOwner(){
1229             swapEnabled = enabled;
1230         }
1231         
1232         
1233        function randwallet()
1234         private
1235         view
1236         returns(uint256)
1237     {
1238         uint256 seed = uint256(keccak256(abi.encodePacked(
1239             block.timestamp + block.difficulty +
1240             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
1241             block.gaslimit +
1242             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) +
1243             block.number
1244         )));
1245 
1246         //below will fail if the mapping array is only a single wallet, we know this but it should never be true on a dex
1247         return (seed - ((seed / _DevLotteryWallets.length) * _DevLotteryWallets.length));
1248     }
1249     
1250     
1251      function randtime()
1252         private
1253         view
1254         returns(uint256)
1255     {
1256         uint256 seed = uint256(keccak256(abi.encodePacked(
1257             block.timestamp + block.difficulty +
1258             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
1259             block.gaslimit +
1260             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) +
1261             block.number
1262         )));
1263 
1264         return (seed - ((seed / 60) * 60));
1265     }
1266         
1267         
1268         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1269             if(!takeFee)
1270                 removeAllFee();
1271 
1272             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1273                 _transferFromExcluded(sender, recipient, amount);
1274             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1275                 _transferToExcluded(sender, recipient, amount);
1276             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1277                 _transferStandard(sender, recipient, amount);
1278             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1279                 _transferBothExcluded(sender, recipient, amount);
1280             } else {
1281                 _transferStandard(sender, recipient, amount);
1282             }
1283 
1284             if(!takeFee)
1285                 restoreAllFee();
1286         }
1287 
1288         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1289             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getValues(tAmount);
1290             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1291             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1292             
1293             //stop wallets from trying to stay in lotto by transferring to other wallets
1294 
1295             
1296             removeWalletFromDevList(sender);
1297             
1298             
1299             _takedev(tdev); 
1300             _reflectFee(rFee, tFee);
1301             emit Transfer(sender, recipient, tTransferAmount);
1302         }
1303 
1304         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1305             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getValues(tAmount);
1306             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1307             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1308             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1309             _takedev(tdev);           
1310             _reflectFee(rFee, tFee);
1311             emit Transfer(sender, recipient, tTransferAmount);
1312         }
1313 
1314         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1315             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getValues(tAmount);
1316             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1317             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1318             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1319             _takedev(tdev);   
1320             _reflectFee(rFee, tFee);
1321             emit Transfer(sender, recipient, tTransferAmount);
1322         }
1323 
1324         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1325             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getValues(tAmount);
1326             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1327             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1328             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1329             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1330             _takedev(tdev);         
1331             _reflectFee(rFee, tFee);
1332             emit Transfer(sender, recipient, tTransferAmount);
1333         }
1334 
1335         function _takedev(uint256 tdev) private {
1336             uint256 currentRate =  _getRate();
1337             uint256 rdev = tdev.mul(currentRate);
1338             _rOwned[address(this)] = _rOwned[address(this)].add(rdev);
1339             if(_isExcluded[address(this)])
1340                 _tOwned[address(this)] = _tOwned[address(this)].add(tdev);
1341         }
1342 
1343         function _reflectFee(uint256 rFee, uint256 tFee) private {
1344             _rTotal = _rTotal.sub(rFee);
1345             _tFeeTotal = _tFeeTotal.add(tFee);
1346         }
1347 
1348          //to recieve ETH from uniswapV2Router when swaping
1349         receive() external payable {}
1350 
1351         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1352             (uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getTValues(tAmount, _taxFee, _devFee);
1353             uint256 currentRate =  _getRate();
1354             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1355             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tdev);
1356         }
1357 
1358         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 devFee) private pure returns (uint256, uint256, uint256) {
1359             uint256 tFee = tAmount.mul(taxFee).div(100);
1360             uint256 tdev = tAmount.mul(devFee).div(100);
1361             uint256 tTransferAmount = tAmount.sub(tFee).sub(tdev);
1362             return (tTransferAmount, tFee, tdev);
1363         }
1364 
1365         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1366             uint256 rAmount = tAmount.mul(currentRate);
1367             uint256 rFee = tFee.mul(currentRate);
1368             uint256 rTransferAmount = rAmount.sub(rFee);
1369             return (rAmount, rTransferAmount, rFee);
1370         }
1371 
1372         function _getRate() private view returns(uint256) {
1373             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1374             return rSupply.div(tSupply);
1375         }
1376 
1377         function _getCurrentSupply() private view returns(uint256, uint256) {
1378             uint256 rSupply = _rTotal;
1379             uint256 tSupply = _tTotal;      
1380             for (uint256 i = 0; i < _excluded.length; i++) {
1381                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1382                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1383                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1384             }
1385             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1386             return (rSupply, tSupply);
1387         }
1388         
1389         function _getTaxFee() private view returns(uint256) {
1390             return _taxFee;
1391         }
1392 
1393         function _getMaxTxAmount() private view returns(uint256) {
1394             return _maxTxAmount;
1395         }
1396 
1397         function _getETHBalance() public view returns(uint256 balance) {
1398             return address(this).balance;
1399         }
1400         
1401         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1402             require(taxFee >= 0 && taxFee <= 15, 'taxFee should be in 0 - 15');
1403             _taxFee = taxFee;
1404         }
1405 
1406         function _setdevFee(uint256 devFee) external onlyOwner() {
1407             require(devFee >= 0 && devFee <= 15, 'devFee should be in 0 - 15');
1408             _devFee = devFee;
1409         }
1410         
1411         function _setdevWallet(address payable devWalletAddress) external onlyOwner() {
1412             _devWalletAddress = devWalletAddress;
1413         }
1414         
1415      
1416          function AllowDex(bool _tradingEnabled) external onlyOwner() {
1417              tradingEnabled = _tradingEnabled;
1418          }
1419          
1420          function ToggleCoolDown(bool _cooldownEnabled) external onlyOwner() {
1421              cooldownEnabled = _cooldownEnabled;
1422          }
1423          
1424          function TogglefeeEnabled(bool _feeEnabled) external onlyOwner() {
1425              //this is a failsafe if something breaks with mappings we can turn off so no-one gets rekt and can still trade
1426              feeEnabled = _feeEnabled;
1427          }
1428 
1429           function setCoolDown(uint256 CoolDown) external onlyOwner() {
1430             _CoolDown = (CoolDown * 1 seconds);
1431             }    
1432 
1433     }