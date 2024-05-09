1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9   /**
10    * @dev Returns true if `account` is a contract.
11    *
12    * [IMPORTANT]
13    * ====
14    * It is unsafe to assume that an address for which this function returns
15    * false is an externally-owned account (EOA) and not a contract.
16    *
17    * Among others, `isContract` will return false for the following
18    * types of addresses:
19    *
20    *  - an externally-owned account
21    *  - a contract in construction
22    *  - an address where a contract will be created
23    *  - an address where a contract lived, but was destroyed
24    * ====
25    */
26   function isContract(address account) internal view returns (bool) {
27     // This method relies in extcodesize, which returns 0 for contracts in
28     // construction, since the code is only stored at the end of the
29     // constructor execution.
30 
31     uint256 size;
32     // solhint-disable-next-line no-inline-assembly
33     assembly { size := extcodesize(account) }
34     return size > 0;
35   }
36 
37   /**
38    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39    * `recipient`, forwarding all available gas and reverting on errors.
40    *
41    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42    * of certain opcodes, possibly making contracts go over the 2300 gas limit
43    * imposed by `transfer`, making them unable to receive funds via
44    * `transfer`. {sendValue} removes this limitation.
45    *
46    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47    *
48    * IMPORTANT: because control is transferred to `recipient`, care must be
49    * taken to not create reentrancy vulnerabilities. Consider using
50    * {ReentrancyGuard} or the
51    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52    */
53   function sendValue(address payable recipient, uint256 amount) internal {
54     require(address(this).balance >= amount, "Address: insufficient balance");
55 
56     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57     (bool success, ) = recipient.call{ value: amount }("");
58     require(success, "Address: unable to send value, recipient may have reverted");
59   }
60 
61   /**
62    * @dev Performs a Solidity function call using a low level `call`. A
63    * plain`call` is an unsafe replacement for a function call: use this
64    * function instead.
65    *
66    * If `target` reverts with a revert reason, it is bubbled up by this
67    * function (like regular Solidity function calls).
68    *
69    * Returns the raw returned data. To convert to the expected return value,
70    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71    *
72    * Requirements:
73    *
74    * - `target` must be a contract.
75    * - calling `target` with `data` must not revert.
76    *
77    * _Available since v3.1._
78    */
79   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80     return functionCall(target, data, "Address: low-level call failed");
81   }
82 
83   /**
84    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85    * `errorMessage` as a fallback revert reason when `target` reverts.
86    *
87    * _Available since v3.1._
88    */
89   function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90     return _functionCallWithValue(target, data, 0, errorMessage);
91   }
92 
93   /**
94    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95    * but also transferring `value` wei to `target`.
96    *
97    * Requirements:
98    *
99    * - the calling contract must have an ETH balance of at least `value`.
100    * - the called Solidity function must be `payable`.
101    *
102    * _Available since v3.1._
103    */
104   function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106   }
107 
108   /**
109    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110    * with `errorMessage` as a fallback revert reason when `target` reverts.
111    *
112    * _Available since v3.1._
113    */
114   function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115     require(address(this).balance >= value, "Address: insufficient balance for call");
116     return _functionCallWithValue(target, data, value, errorMessage);
117   }
118 
119   function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120     require(isContract(target), "Address: call to non-contract");
121 
122     // solhint-disable-next-line avoid-low-level-calls
123     (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124     if (success) {
125       return returndata;
126     } else {
127       // Look for revert reason and bubble it up if present
128       if (returndata.length > 0) {
129         // The easiest way to bubble the revert reason is using memory via assembly
130 
131         // solhint-disable-next-line no-inline-assembly
132         assembly {
133           let returndata_size := mload(returndata)
134           revert(add(32, returndata), returndata_size)
135         }
136       } else {
137         revert(errorMessage);
138       }
139     }
140   }
141 }
142 
143 /**
144  * @dev Interface of the ERC20 standard as defined in the EIP.
145  */
146 interface IERC20 {
147   /**
148    * @dev Returns the amount of tokens in existence.
149    */
150   function totalSupply() external view returns (uint256);
151 
152   /**
153    * @dev Returns the amount of tokens owned by `account`.
154    */
155   function balanceOf(address account) external view returns (uint256);
156 
157   /**
158    * @dev Moves `amount` tokens from the caller's account to `recipient`.
159    *
160    * Returns a boolean value indicating whether the operation succeeded.
161    *
162    * Emits a {Transfer} event.
163    */
164   function transfer(address recipient, uint256 amount) external returns (bool);
165 
166   /**
167    * @dev Returns the remaining number of tokens that `spender` will be
168    * allowed to spend on behalf of `owner` through {transferFrom}. This is
169    * zero by default.
170    *
171    * This value changes when {approve} or {transferFrom} are called.
172    */
173   function allowance(address owner, address spender) external view returns (uint256);
174 
175   /**
176    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
177    *
178    * Returns a boolean value indicating whether the operation succeeded.
179    *
180    * IMPORTANT: Beware that changing an allowance with this method brings the risk
181    * that someone may use both the old and the new allowance by unfortunate
182    * transaction ordering. One possible solution to mitigate this race
183    * condition is to first reduce the spender's allowance to 0 and set the
184    * desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    *
187    * Emits an {Approval} event.
188    */
189   function approve(address spender, uint256 amount) external returns (bool);
190 
191   /**
192    * @dev Moves `amount` tokens from `sender` to `recipient` using the
193    * allowance mechanism. `amount` is then deducted from the caller's
194    * allowance.
195    *
196    * Returns a boolean value indicating whether the operation succeeded.
197    *
198    * Emits a {Transfer} event.
199    */
200   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
201 
202   /**
203    * @dev Emitted when `value` tokens are moved from one account (`from`) to
204    * another (`to`).
205    *
206    * Note that `value` may be zero.
207    */
208   event Transfer(address indexed from, address indexed to, uint256 value);
209 
210   /**
211    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
212    * a call to {approve}. `value` is the new allowance.
213    */
214   event Approval(address indexed owner, address indexed spender, uint256 value);
215 
216 }
217 
218 abstract contract Context {
219   function _msgSender() internal view virtual returns (address payable) {
220     return msg.sender;
221   }
222 
223   function _msgData() internal view virtual returns (bytes memory) {
224     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
225     return msg.data;
226   }
227 }
228 
229 /**
230  * @dev Wrappers over Solidity's arithmetic operations with added overflow
231  * checks.
232  *
233  * Arithmetic operations in Solidity wrap on overflow. This can easily result
234  * in bugs, because programmers usually assume that an overflow raises an
235  * error, which is the standard behavior in high level programming languages.
236  * `SafeMath` restores this intuition by reverting the transaction when an
237  * operation overflows.
238  *
239  * Using this library instead of the unchecked operations eliminates an entire
240  * class of bugs, so it's recommended to use it always.
241  */
242 library SafeMath {
243   /**
244    * @dev Returns the addition of two unsigned integers, reverting on
245    * overflow.
246    *
247    * Counterpart to Solidity's `+` operator.
248    *
249    * Requirements:
250    * - Addition cannot overflow.
251    */
252   function add(uint256 a, uint256 b) internal pure returns (uint256) {
253     uint256 c = a + b;
254     require(c >= a, "SafeMath: addition overflow");
255 
256     return c;
257   }
258 
259   /**
260    * @dev Returns the subtraction of two unsigned integers, reverting on
261    * overflow (when the result is negative).
262    *
263    * Counterpart to Solidity's `-` operator.
264    *
265    * Requirements:
266    * - Subtraction cannot overflow.
267    */
268   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269     return sub(a, b, "SafeMath: subtraction overflow");
270   }
271 
272   /**
273    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
274    * overflow (when the result is negative).
275    *
276    * Counterpart to Solidity's `-` operator.
277    *
278    * Requirements:
279    * - Subtraction cannot overflow.
280    */
281   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282     require(b <= a, errorMessage);
283     uint256 c = a - b;
284 
285     return c;
286   }
287 
288   /**
289    * @dev Returns the multiplication of two unsigned integers, reverting on
290    * overflow.
291    *
292    * Counterpart to Solidity's `*` operator.
293    *
294    * Requirements:
295    * - Multiplication cannot overflow.
296    */
297   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
299     // benefit is lost if 'b' is also tested.
300     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
301     if (a == 0) {
302       return 0;
303     }
304 
305     uint256 c = a * b;
306     require(c / a == b, "SafeMath: multiplication overflow");
307 
308     return c;
309   }
310 
311   /**
312    * @dev Returns the integer division of two unsigned integers. Reverts on
313    * division by zero. The result is rounded towards zero.
314    *
315    * Counterpart to Solidity's `/` operator. Note: this function uses a
316    * `revert` opcode (which leaves remaining gas untouched) while Solidity
317    * uses an invalid opcode to revert (consuming all remaining gas).
318    *
319    * Requirements:
320    * - The divisor cannot be zero.
321    */
322   function div(uint256 a, uint256 b) internal pure returns (uint256) {
323     return div(a, b, "SafeMath: division by zero");
324   }
325 
326   /**
327    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
328    * division by zero. The result is rounded towards zero.
329    *
330    * Counterpart to Solidity's `/` operator. Note: this function uses a
331    * `revert` opcode (which leaves remaining gas untouched) while Solidity
332    * uses an invalid opcode to revert (consuming all remaining gas).
333    *
334    * Requirements:
335    * - The divisor cannot be zero.
336    */
337   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338     require(b > 0, errorMessage);
339     uint256 c = a / b;
340     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
341 
342     return c;
343   }
344 
345   /**
346    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
347    * Reverts when dividing by zero.
348    *
349    * Counterpart to Solidity's `%` operator. This function uses a `revert`
350    * opcode (which leaves remaining gas untouched) while Solidity uses an
351    * invalid opcode to revert (consuming all remaining gas).
352    *
353    * Requirements:
354    * - The divisor cannot be zero.
355    */
356   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
357     return mod(a, b, "SafeMath: modulo by zero");
358   }
359 
360   /**
361    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
362    * Reverts with custom message when dividing by zero.
363    *
364    * Counterpart to Solidity's `%` operator. This function uses a `revert`
365    * opcode (which leaves remaining gas untouched) while Solidity uses an
366    * invalid opcode to revert (consuming all remaining gas).
367    *
368    * Requirements:
369    * - The divisor cannot be zero.
370    */
371   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372     require(b != 0, errorMessage);
373     return a % b;
374   }
375 }
376 
377 contract Ownable is Context {
378   address private _owner;
379 
380   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
381 
382   /**
383    * @dev Initializes the contract setting the deployer as the initial owner.
384    */
385   constructor () internal {
386     address msgSender = _msgSender();
387     _owner = msgSender;
388     emit OwnershipTransferred(address(0), msgSender);
389   }
390 
391   /**
392    * @dev Returns the address of the current owner.
393    */
394   function owner() public view returns (address) {
395     return _owner;
396   }
397 
398   /**
399    * @dev Throws if called by any account other than the owner.
400    */
401   modifier onlyOwner() {
402     require(_owner == _msgSender(), "Ownable: caller is not the owner");
403     _;
404   }
405 
406   /**
407    * @dev Leaves the contract without owner. It will not be possible to call
408    * `onlyOwner` functions anymore. Can only be called by the current owner.
409    *
410    * NOTE: Renouncing ownership will leave the contract without an owner,
411    * thereby removing any functionality that is only available to the owner.
412    */
413   function renounceOwnership() public virtual onlyOwner {
414     emit OwnershipTransferred(_owner, address(0));
415     _owner = address(0);
416   }
417 
418   /**
419    * @dev Transfers ownership of the contract to a new account (`newOwner`).
420    * Can only be called by the current owner.
421    */
422   function transferOwnership(address newOwner) public virtual onlyOwner {
423     require(newOwner != address(0), "Ownable: new owner is the zero address");
424     emit OwnershipTransferred(_owner, newOwner);
425     _owner = newOwner;
426   }
427 }
428 
429 abstract contract StakeBLVToken {
430   function transferHook(address sender, address recipient, uint256 amount, uint256 senderBalance, uint256 recipientBalance) external virtual returns (uint256, uint256, uint256);
431   function updateMyStakes(address staker, uint256 balance, uint256 totalSupply) external virtual returns (uint256);
432 }
433 
434 
435 /**
436  * @dev Implementation of the  BLV
437  * BLV is a price-reactive cryptocurrency.
438  * That is, the inflation rate of the token is wholly dependent on its market activity.
439  * Minting does not happen when the price is less than the day prior.
440  * When the price is greater than the day prior, the inflation for that day is
441  * a function of its price, percent increase, volume, any positive price streaks,
442  * and the amount of time any given holder has been holding.
443  * In the first iteration, the dev team acts as the price oracle, but in the future, we plan to integrate a Chainlink price oracle.
444  */
445 contract Token is Ownable, IERC20 {
446   using SafeMath for uint256;
447   using Address for address;
448 
449   mapping (address => uint256) private _balances;
450 
451   mapping (address => mapping (address => uint256)) private _allowances;
452 
453   uint256 private _totalSupply;
454 
455   string public constant _name = "Bellevue Network";
456   string public constant _symbol = "BLV";
457   uint8 public constant _decimals = 18;
458 
459   StakeBLVToken public _stakingContract;
460 
461   address public _intervalWatcher;
462 
463   address public _teamWallet;
464   address public _treasuryWallet;
465     
466   uint public startTimestamp;
467   
468   bool public freeze;
469   
470   bool private _stakingEnabled;
471   
472   struct Vester {
473       uint lastRelease;
474       uint balanceRemaining;
475       uint balanceInit;
476   }
477     
478   mapping (address => Vester) public vesters;
479 
480 
481   modifier onlyWatcher() {
482     assert(_msgSender() == _intervalWatcher/*, "Caller must be watcher."*/);
483     _;
484   }
485 
486   modifier onlyStakingContract() {
487     require(msg.sender == address(_stakingContract), "Ownable: caller is not the staking contract");
488     _;
489   }
490 
491   event ErrorMessage(string errorMessage);
492 
493   constructor () public {
494     
495     startTimestamp = block.timestamp;
496 
497     _stakingEnabled = false;
498     _treasuryWallet = 0xF40B0918D6b78fd705F30D92C9626ad218F1aEcE;
499     _teamWallet = 0x2BFA783D7f38aAAa997650aE0EfdBDF632288A7F;
500     _intervalWatcher = msg.sender;
501     
502     freeze = false;
503     transferOwnership(0x6f3Bdb71C8d42b5a5DEe58b1a66f8a299EC4d216);
504     
505     _mint(0xb1412DFFBb7db18F8686Ea4787c30cA40BC6D1a8, 1000000E18);
506     _mint(0xd1d784920983CdB17EE125887c875548D149E856, 1000000E18);
507     _mint(0x2366ff0577e53984Bc0E103c803658DA1Ef7d19A, 425000E18);
508     _mint(0x380D463383201f1758a7c59aE569d79bA84D7263, 425000E18);
509     _mint(0xf8880975805Fc659C756aBfE879002FDa1470768, 425000E18);
510     _mint(0xE20cf34fD6B38689eb68968E90F25CC6B80B16FB, 425000E18);
511     _mint(0xa2B9a5f796ef1f68B2aEF0c984F961beD1085500, 425000E18);
512     _mint(0x15DD94C2F7A78Be9b7d8711C09083F4F6EFc1029, 425000E18);
513     _mint(0xD388BD277F390Cb36A90DEf9771c47869b266BAE, 425000E18);
514     _mint(0x93f5af632Ce523286e033f0510E9b3C9710F4489, 425000E18);
515     _mint(0x85D72d2D43c7BF149abf2132bDA2992087a9527e, 425000E18);
516     _mint(0x4f5304E7CC2efD8a12d92703fF4964A79276a638, 425000E18);
517     _mint(0xD733801c2512ce294a34b3a8878365dd30c7d791, 425000E18);
518     
519     _mint(0x7af6701EF2456F25e22a6e4Bfd70bCdFA0aEeB97, 425000E18);
520     _mint(0x41a9A2bb121FE08592678Fc2c6fd0498b914a3c7, 425000E18);
521     _mint(0x4530B100BF6400268E22fE64d7548fFaafA8dC39, 425000E18);
522     _mint(0xbb257625458a12374daf2AD0c91d5A215732F206, 425000E18);
523     _mint(0x84998f375355AE7AE7f60e8ecF1D24ad59948e9a, 425000E18);
524     _mint(0x25054f27C9972B341Aee6c0D373A652566075431, 425000E18);
525     _mint(0x7Da3c02716676f81790726c91BF4D05f14E98677, 425000E18);
526     _mint(0xbbDBD6Bb3C05a7c966c203502e0a5A373E01e103, 425000E18);
527     _mint(0x2604afb5A64992e5aBBF25865C9d3387adE92bad, 425000E18);
528     _mint(0x4f6EB296cCAC2668640934208538EE8e3d3C846c, 425000E18);
529     _mint(0x2F7B7aFbcaC8A70a1E0fe712a644e4621EdBB832, 425000E18);
530     _mint(0x0C780749E6d0bE3C64c130450B20C40b843fbEC4, 425000E18);
531     
532     
533     _mint(0xa4e74aE45F53045e07e3189933Bb5B1286BaeD54, 425000E18);
534     _mint(0x6766c0Ad04d5aA6B53D8E42738dafBA490B0A7a3, 425000E18);
535     _mint(0xC419528eDA383691e1aA13C381D977343CB9E5D0, 425000E18);
536     _mint(0x515e4940850c217B8f4f2E3D2bE0aC6A52F17624, 425000E18);
537     _mint(0x946C2a67373e64D5B318f9A669fE5664256491d6, 425000E18);
538     _mint(0x6CDB0A4902C81E9C63De8c486F31e8d5DDc0A9f7, 425000E18);
539     _mint(0x907b4128FF43eD92b14b8145a01e8f9bC6890E3E, 425000E18);
540     _mint(0x3481fBA85c1b227Cd401d4ef2e2390f505738B08, 425000E18);
541     _mint(0x06C8940CFEc1e9596123a2b0fA965F9E3758422f, 425000E18);
542     _mint(0x5AaAEF91F93bE4dE932b8e7324aBBF9f26DAa706, 425000E18);
543     _mint(0xEF572FbBdB552A00bdc2a3E3Bc9306df9E9e169d, 425000E18);
544     _mint(0xE8609d2608Fb5555cb84e5D03c5B837A116fA8AD, 425000E18);
545     
546     _mint(0x05BaD2724b1415a8B6B3000a30E37d9C637D7340, 425000E18);
547     _mint(0x2b82FEaC8778CE69eBbaE549DcfB558C6024714a, 425000E18);
548     _mint(0xDBe24A37f06CAb8C8A786dDF0439ea5cB28e5328, 425000E18);
549     _mint(0x318f1cFD866BE8a0835412A02127271B3e0F6485, 425000E18);
550     _mint(0x5516F15603707EE1e854E149F0f0E33F443cC9C4, 425000E18);
551     _mint(0x7723000de847d13856Aa46993e6D1d499D13af1B, 425000E18);
552     _mint(0x76a7aa09e047fc0Cd56d206b986A67772ED936FD, 425000E18);
553     _mint(0x4d6f7D3EC5ab66D14a494b4650717e7D44E527bD, 425000E18);
554     _mint(0xA3839Cb3b18d0d8372cc1ba8ACb3C693329FD92B, 425000E18);
555     _mint(0x7729370DA4bfeE1Ee183eEdD35176fCB20F9E8eb, 425000E18);
556     _mint(0xa4b949fb6B2979E383b753f7b086ee1a7adB552a, 425000E18);
557     _mint(0xc7861b59e2193424AfC83a83bD65c8B5216c7EB0, 425000E18);
558     _mint(0x94054865f83f9Df3fAE7D4B8E6B08b7ff420b0e2, 425000E18);
559     
560     _mint(0x6766c0Ad04d5aA6B53D8E42738dafBA490B0A7a3, 29125000E18);
561     
562     
563     
564     
565     vesters[_treasuryWallet] = (Vester(now, 25000000E18, 25000000E18));  // Treasury
566     vesters[_teamWallet] = (Vester(now, 25000000E18, 25000000E18));  // Team
567     
568     
569     vesters[0x8Ff5Ceb90FAb0e98fDfB3b9eACdF162dFFAaFeb4] = (Vester(now, 1000000E18, 1000000E18));
570     vesters[0x48FFB1b31D30b59b54FEe7744fFd2Be62ae40E80] = (Vester(now, 1000000E18, 1000000E18));
571     vesters[0xa626FDF1F62176EFFB78E00d579E421e67ADa485] = (Vester(now, 1000000E18, 1000000E18));
572     vesters[0x814035FD80140Af0a5b7502c9b1a10f6eC8aD38A] = (Vester(now, 1000000E18, 1000000E18));
573     vesters[0x3300D317713938007cFeC35268aaC7d54dB3a85b] = (Vester(now, 1000000E18, 1000000E18));
574     vesters[0x99D34cAf247fCfB23570D1B29468DB1659604c96] = (Vester(now, 1000000E18, 1000000E18));
575     vesters[0xFEDED73b3b2b74441C8Bf42218e7Ff24030A9705] = (Vester(now, 1000000E18, 1000000E18));
576     vesters[0x0793F2c24bDc8353951Dcb9b14D30801bb608421] = (Vester(now, 1000000E18, 1000000E18));
577     vesters[0x4342e82B94b128fcCBe1bDDF454e51336cC5fde2] = (Vester(now, 1000000E18, 1000000E18));
578     vesters[0xd62a38Bd99376013D485214CC968322C20A6cC40] = (Vester(now, 1000000E18, 1000000E18));
579     vesters[0xC419528eDA383691e1aA13C381D977343CB9E5D0] = (Vester(now, 1000000E18, 1000000E18));
580     vesters[0xdF1cb2e9B48C830154CE6030FFc5E2ce7fD6c328] = (Vester(now, 1000000E18, 1000000E18));
581     vesters[0x88Eb97E5ECbf1c5b4ecA19aCF659d4724392eD86] = (Vester(now, 1000000E18, 1000000E18));
582     vesters[0x13f0B3e3351ff54bA8daF733167436D46CBa8623] = (Vester(now, 1000000E18, 1000000E18));
583     vesters[0x0793F2c24bDc8353951Dcb9b14D30801bb608421] = (Vester(now, 1000000E18, 1000000E18));
584     vesters[0xd7741872efC695be77C9bc8B7E7AFCF928dd4912] = (Vester(now, 1000000E18, 1000000E18));
585     vesters[0xbcd670eB38fE7937245324F8a9689c49c7A8e91e] = (Vester(now, 875000E18, 875000E18));
586     vesters[0x875e5d68cED80a84F1D0bdE9a864CF387690aBC1] = (Vester(now, 425000E18, 425000E18));
587     vesters[0xD61545c9f495Da3d556e0474A102DE3937eB8451] = (Vester(now, 425000E18, 425000E18));
588     vesters[0x42415d75FD3Bfc6cD44F232109925e04Fc5610d8] = (Vester(now, 425000E18, 425000E18));
589     vesters[0xaC6dE509E1B5c1C619afe64e0dfA567bd5b58503] = (Vester(now, 850000E18, 850000E18));
590     vesters[0x88B1fAb25703a07cACd2C9Da4797df2379F43A32] = (Vester(now, 850000E18, 850000E18));
591     vesters[0xDfBB98446715dCCFcE6Fc231952d2e16884fD0d5] = (Vester(now, 850000E18, 850000E18));
592     vesters[0x7947dD50cF73fdd44dBc8f7A4BE28E490B4D5D1B] = (Vester(now, 850000E18, 850000E18));
593     
594     vesters[0x6F0AB036b74a8d8263823609858C3F7efB9Ab782] = (Vester(now, 500000E18, 500000E18));
595     vesters[0xB6f526ef7820BCA52058Be5c75dC05c7C456d22B] = (Vester(now, 500000E18, 500000E18));
596     vesters[0xa3ccA0E4B6C70c2fdFbf95bB35BEA1CA604F7207] = (Vester(now, 750000E18, 750000E18));
597     vesters[0x7BE8C8FEF3C323bEBd0338D7DB2F9370f896fecD] = (Vester(now, 750000E18, 750000E18));
598     vesters[0x9c10FfeF1AeC731b616cc22fEdECA5d81d61859e] = (Vester(now, 750000E18, 750000E18));
599     vesters[0x9F22318d7ceE9e22be01bD3bf64fB9257FB7F4B8] = (Vester(now, 750000E18, 750000E18));
600     vesters[0xf4EdFf75aD10030DF1412317ea38Ed84e12Ef41C] = (Vester(now, 750000E18, 750000E18));
601     vesters[0xbaFf5f62BF40cbBFC0Be450F11126Fc4e094aAc3] = (Vester(now, 500000E18, 500000E18));
602     vesters[0x1C96aFc64A706695A9558E76679f8Bc72e354854] = (Vester(now, 1000000E18, 1000000E18));
603     vesters[0x0d0D3321bBeAFF438D68Ad58a77fdA6309920E86] = (Vester(now, 1000000E18, 1000000E18));
604     vesters[0xB016539a2d7A0dFa98237C93AC4AF0f46Ba74BAD] = (Vester(now, 1000000E18, 1000000E18));
605     vesters[0x66d4bdF37AA4c04c7C66a743396caE3FA2425f79] = (Vester(now, 1000000E18, 1000000E18));
606     vesters[0x00893fAc04C1F1B6e30847Dcc1F24761271c81c7] = (Vester(now, 1000000E18, 1000000E18));
607     vesters[0x20d256Ae504F7459532f3711035133624F83C15B] = (Vester(now, 1000000E18, 1000000E18));
608     vesters[0x082faa352c52365c0B6e0D8F52523Acf8eA511f4] = (Vester(now, 1000000E18, 1000000E18));
609     vesters[0x0Bbc35b239209C7819bC8e0008FF476DD637DFca] = (Vester(now, 1000000E18, 1000000E18));
610     vesters[0xb2103ACE0eca26D55dfC827cD59d51DD87Bd0e03] = (Vester(now, 1000000E18, 1000000E18));
611     vesters[0x80DFbf3cF73f6bbA8B5175976ae8338D4Ced26A7] = (Vester(now, 1000000E18, 1000000E18));
612     vesters[0xE1aF2f6ba1B34656e72005d1cFc25a80a6248211] = (Vester(now, 1000000E18, 1000000E18));
613     vesters[0x9E667b5277A38fE2d0f9297447fa7C62d3d6aE69] = (Vester(now, 1000000E18, 1000000E18));
614     vesters[0x1BAf30992f4F37e0c5909276bA0e1a3F96Eaf9Cb] = (Vester(now, 1000000E18, 1000000E18));
615     vesters[0xbDfBFd5B4123566D358f69882A5909492049be8A] = (Vester(now, 1000000E18, 1000000E18));
616     vesters[0x19e61Dbc204BA4A5E3Ef57721c7ab139399df7c6] = (Vester(now, 1000000E18, 1000000E18));
617     vesters[0x87f84EEc3adAC507372018DA187661726867f316] = (Vester(now, 1000000E18, 1000000E18));
618     vesters[0x0Cbd15145285B9cd05e95c19cB1E2d1Fdc71Cf90] = (Vester(now, 1000000E18, 1000000E18));
619     vesters[0x174818EB82C976083591d0eaa720B70498616561] = (Vester(now, 1000000E18, 1000000E18));
620     vesters[0x643a7B5Cb05486626594b17280dcb051D2725155] = (Vester(now, 1000000E18, 1000000E18));
621     vesters[0xf422c173264dCd512E3CEE0DB4AcB568707C0b8D] = (Vester(now, 850000E18, 850000E18));
622     vesters[0xf916D5D0310BFCD0D9B8c43D0a29070670D825f9] = (Vester(now, 850000E18, 850000E18));
623     vesters[0xE58Ea0ceD4417f0551Fb82ddF4F6477072DFb430] = (Vester(now, 850000E18, 850000E18));
624   }
625   
626   
627   
628   function release() public {
629       
630     if(msg.sender == _treasuryWallet) {
631         releaseTreasury();
632         return;
633     } else if (msg.sender == _teamWallet) {
634         releaseTeam();
635         return;
636     }
637     
638     Vester storage vester = vesters[msg.sender];
639     require(vester.balanceInit > 0 && vester.balanceRemaining > 0, "Timelock: no tokens to release");
640     
641     if(vester.lastRelease == startTimestamp) {
642         uint tokens = mulDiv(vester.balanceInit, 25, 100);
643         vester.lastRelease = block.timestamp;
644         vester.balanceRemaining = vester.balanceRemaining.sub(tokens);
645         _mint(msg.sender, tokens);
646         return;
647     }
648     
649     uint daysSinceLast = block.timestamp.sub(vester.lastRelease) / 86400;
650     
651     require(daysSinceLast >= 30);
652     
653     uint tokens = mulDiv(vester.balanceInit, 25, 100);
654     if(tokens > vester.balanceRemaining) {
655         tokens = vester.balanceRemaining;
656     }
657     vester.lastRelease = block.timestamp;
658     vester.balanceRemaining = vester.balanceRemaining.sub(tokens);
659     _mint(msg.sender, tokens);
660 }
661 
662     function releaseTreasury() internal {
663         Vester storage vester = vesters[_treasuryWallet];
664         if(vester.lastRelease == startTimestamp) {
665             uint tokens = mulDiv(vester.balanceInit, 25, 100);
666             vester.lastRelease = block.timestamp;
667             vester.balanceRemaining = vester.balanceRemaining.sub(tokens);
668             _mint(_treasuryWallet, tokens);
669             return;
670         }
671         uint daysSinceLast = block.timestamp.sub(vester.lastRelease) / 86400;
672         require(daysSinceLast >= 90);
673         uint tokens = mulDiv(vester.balanceInit, 25, 100);
674         if(tokens > vester.balanceRemaining) {
675             tokens = vester.balanceRemaining;
676         }
677         vester.lastRelease = block.timestamp;
678         vester.balanceRemaining = vester.balanceRemaining.sub(tokens);
679         _mint(_treasuryWallet, tokens);
680     }
681     
682     function releaseTeam() internal {
683         Vester storage vester = vesters[_teamWallet];
684         uint daysSinceLast = block.timestamp.sub(vester.lastRelease) / 86400;
685         require(daysSinceLast >= 90);
686         uint tokens = mulDiv(vester.balanceInit, 25, 100);
687         if(tokens > vester.balanceRemaining) {
688             tokens = vester.balanceRemaining;
689         }
690         vester.lastRelease = block.timestamp;
691         vester.balanceRemaining = vester.balanceRemaining.sub(tokens);
692         _mint(_teamWallet, tokens);
693     }
694 
695 
696   function updateMyStakes() public {
697     require(_stakingEnabled, "Staking is disabled");
698     try _stakingContract.updateMyStakes(msg.sender, _balances[msg.sender], _totalSupply) returns (uint256 numTokens) {
699       _mint(msg.sender, numTokens);
700     } catch Error (string memory error) {
701       emit ErrorMessage(error);
702     }
703   }
704 
705   function updateTreasuryWallet(address treasuryWallet) external onlyOwner {
706     _treasuryWallet = treasuryWallet;
707   }
708 
709   function updateIntervalWatcher(address treasuryWatcher) external onlyOwner {
710     _intervalWatcher = treasuryWatcher;
711   }
712 
713   function updateTreasuryStakes() external onlyWatcher {
714     require(_stakingEnabled, "Staking is disabled");
715     try _stakingContract.updateMyStakes(_treasuryWallet, balanceOf(_treasuryWallet), _totalSupply) returns (uint256 numTokens) {
716       _mint(_treasuryWallet, numTokens);
717     } catch Error (string memory error) {
718       emit ErrorMessage(error);
719     }
720   }
721 
722   function updateTeamStakes() external onlyWatcher {
723     require(_stakingEnabled, "Staking is disabled");
724     try _stakingContract.updateMyStakes(_teamWallet, balanceOf(_teamWallet), _totalSupply) returns (uint256 numTokens) {
725       _mint(_teamWallet, numTokens);
726     } catch Error (string memory error) {
727       emit ErrorMessage(error);
728     }
729   }
730 
731   function updateStakingContract(StakeBLVToken stakingContract) external onlyOwner {
732     _stakingContract = stakingContract;
733     _stakingEnabled = true;
734   }
735 
736 
737   /**
738    * @dev Returns the name of the token.
739    */
740   function name() public view returns (string memory) {
741     return _name;
742   }
743 
744   /**
745    * @dev Returns the symbol of the token, usually a shorter version of the
746    * name.
747    */
748   function symbol() public view returns (string memory) {
749     return _symbol;
750   }
751 
752   /**
753    * @dev Returns the number of decimals used to get its user representation.
754    * For example, if `decimals` equals `2`, a balance of `505` tokens should
755    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
756    *
757    * Tokens usually opt for a value of 18, imitating the relationship between
758    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
759    * called.
760    *
761    * NOTE: This information is only used for _display_ purposes: it in
762    * no way affects any of the arithmetic of the contract, including
763    * {IERC20-balanceOf} and {IERC20-transfer}.
764    */
765   function decimals() public view returns (uint8) {
766     return _decimals;
767   }
768 
769   /**
770    * @dev See {IERC20-totalSupply}.
771    */
772   function totalSupply() public view override returns (uint256) {
773     return _totalSupply;
774   }
775 
776   /**
777    * @dev See {IERC20-balanceOf}.
778    */
779   function balanceOf(address account) public view override returns (uint256) {
780     return _balances[account].add(vesters[account].balanceRemaining);
781   }
782   
783   function balanceOfNoVesting(address account) public view returns (uint256) {
784     return _balances[account];
785   }
786 
787   /**
788    * @dev See {IERC20-transfer}.
789    *
790    * Requirements:
791    *
792    * - `recipient` cannot be the zero address.
793    * - the caller must have a balance of at least `amount`.
794    */
795   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
796     _transfer(_msgSender(), recipient, amount);
797     return true;
798   }
799 
800   /**
801    * @dev See {IERC20-allowance}.
802    */
803   function allowance(address owner, address spender) public view virtual override returns (uint256) {
804     return _allowances[owner][spender];
805   }
806 
807   /**
808    * @dev See {IERC20-approve}.
809    *
810    * Requirements:
811    *
812    * - `spender` cannot be the zero address.
813    */
814   function approve(address spender, uint256 amount) public virtual override returns (bool) {
815     _approve(_msgSender(), spender, amount);
816     return true;
817   }
818 
819   /**
820    * @dev See {IERC20-transferFrom}.
821    *
822    * Emits an {Approval} event indicating the updated allowance. This is not
823    * required by the EIP. See the note at the beginning of {ERC20};
824    *
825    * Requirements:
826    * - `sender` and `recipient` cannot be the zero address.
827    * - `sender` must have a balance of at least `amount`.
828    * - the caller must have allowance for ``sender``'s tokens of at least
829    * `amount`.
830    */
831   function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
832     _transfer(sender, recipient, amount);
833     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
834     return true;
835   }
836 
837   /**
838    * @dev Atomically increases the allowance granted to `spender` by the caller.
839    *
840    * This is an alternative to {approve} that can be used as a mitigation for
841    * problems described in {IERC20-approve}.
842    *
843    * Emits an {Approval} event indicating the updated allowance.
844    *
845    * Requirements:
846    *
847    * - `spender` cannot be the zero address.
848    */
849   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
850     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
851     return true;
852   }
853 
854   /**
855    * @dev Atomically decreases the allowance granted to `spender` by the caller.
856    *
857    * This is an alternative to {approve} that can be used as a mitigation for
858    * problems described in {IERC20-approve}.
859    *
860    * Emits an {Approval} event indicating the updated allowance.
861    *
862    * Requirements:
863    *
864    * - `spender` cannot be the zero address.
865    * - `spender` must have allowance for the caller of at least
866    * `subtractedValue`.
867    */
868   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
869     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
870     return true;
871   }
872 
873   /**
874    * @dev Moves tokens `amount` from `sender` to `recipient`.
875    *
876    * This is internal function is equivalent to {transfer}, and can be used to
877    * e.g. implement automatic token fees, slashing mechanisms, etc.
878    *
879    * Emits a {Transfer} event.
880    *
881    * Requirements:
882    *
883    * - `sender` cannot be the zero address.
884    * - `recipient` cannot be the zero address.
885    * - `sender` must have a balance of at least `amount`.
886    */
887   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
888     require(sender != address(0), "ERC20: transfer from the zero address");
889     require(recipient != address(0), "ERC20: transfer to the zero address");
890     require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
891     if(sender != owner()) {
892         require(freeze == false, "Contract is frozen");
893     }
894     
895     
896 
897     if(_stakingEnabled) {
898       (uint256 senderBalance, uint256 recipientBalance, uint256 burnAmount) = _stakingContract.transferHook(sender, recipient, amount, _balances[sender], _balances[recipient]);
899       _balances[sender] = senderBalance;
900       _balances[recipient] = recipientBalance;
901       _totalSupply = _totalSupply.sub(burnAmount);
902       if (burnAmount > 0) {
903         emit Transfer(sender, recipient, amount.sub(burnAmount));
904         emit Transfer(sender, address(0), burnAmount);
905       } else {
906         emit Transfer(sender, recipient, amount);
907       }
908     } else {
909       _balances[sender] = _balances[sender].sub(amount);
910       _balances[recipient] = _balances[recipient].add(amount);
911       emit Transfer(sender, recipient, amount);
912     }
913   }
914 
915 
916   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
917    * the total supply.
918    *
919    * Emits a {Transfer} event with `from` set to the zero address.
920    *
921    * Requirements
922    *
923    * - `to` cannot be the zero address.
924    */
925   function _mint(address account, uint256 amount) internal virtual {
926     require(account != address(0), "ERC20: mint to the zero address");
927 
928     _totalSupply = _totalSupply.add(amount);
929     _balances[account] = _balances[account].add(amount);
930     emit Transfer(address(0), account, amount);
931   }
932 
933 
934   function mint(address account, uint256 amount) public onlyStakingContract {
935     require(account != address(0), "ERC20: mint to the zero address");
936 
937     _totalSupply = _totalSupply.add(amount);
938     _balances[account] = _balances[account].add(amount);
939     emit Transfer(address(0), account, amount);
940   }
941 
942   /**
943    * @dev Destroys `amount` tokens from `account`, reducing the
944    * total supply.
945    *
946    * Emits a {Transfer} event with `to` set to the zero address.
947    *
948    * Requirements
949    *
950    * - `account` cannot be the zero address.
951    * - `account` must have at least `amount` tokens.
952    */
953   function _burn(address account, uint256 amount) external onlyStakingContract {
954     require(account != address(0), "ERC20: burn from the zero address");
955     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
956     _totalSupply = _totalSupply.sub(amount);
957     emit Transfer(account, address(0), amount);
958   }
959 
960   function burn(uint256 amount) external {
961     _balances[_msgSender()] = _balances[_msgSender()].sub(amount, "ERC20: burn amount exceeds balance");
962     _totalSupply = _totalSupply.sub(amount);
963     emit Transfer(_msgSender(), address(0), amount);
964   }
965 
966   /**
967    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
968    *
969    * This is internal function is equivalent to `approve`, and can be used to
970    * e.g. set automatic allowances for certain subsystems, etc.
971    *
972    * Emits an {Approval} event.
973    *
974    * Requirements:
975    *
976    * - `owner` cannot be the zero address.
977    * - `spender` cannot be the zero address.
978    */
979   function _approve(address owner, address spender, uint256 amount) internal virtual {
980     require(owner != address(0), "ERC20: approve from the zero address");
981     require(spender != address(0), "ERC20: approve to the zero address");
982 
983     _allowances[owner][spender] = amount;
984     emit Approval(owner, spender, amount);
985   }
986   
987   function updateFreeze(bool _freeze) external onlyOwner {
988       freeze = _freeze;
989   }
990   
991       function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
992           (uint l, uint h) = fullMul (x, y);
993           assert (h < z);
994           uint mm = mulmod (x, y, z);
995           if (mm > l) h -= 1;
996           l -= mm;
997           uint pow2 = z & -z;
998           z /= pow2;
999           l /= pow2;
1000           l += h * ((-pow2) / pow2 + 1);
1001           uint r = 1;
1002           r *= 2 - z * r;
1003           r *= 2 - z * r;
1004           r *= 2 - z * r;
1005           r *= 2 - z * r;
1006           r *= 2 - z * r;
1007           r *= 2 - z * r;
1008           r *= 2 - z * r;
1009           r *= 2 - z * r;
1010           return l * r;
1011     }
1012     
1013     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
1014           uint mm = mulmod (x, y, uint (-1));
1015           l = x * y;
1016           h = mm - l;
1017           if (mm < l) h -= 1;
1018     }
1019 }