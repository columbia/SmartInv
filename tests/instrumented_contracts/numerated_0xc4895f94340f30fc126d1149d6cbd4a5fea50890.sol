1 /**
2                                                                                                                             
3 NNNNNNNN        NNNNNNNN  iiii                      kkkkkkkk                           lllllll                              
4 N:::::::N       N::::::N i::::i                     k::::::k                           l:::::l                              
5 N::::::::N      N::::::N  iiii                      k::::::k                           l:::::l                              
6 N:::::::::N     N::::::N                            k::::::k                           l:::::l                              
7 N::::::::::N    N::::::Niiiiiii     cccccccccccccccc k:::::k    kkkkkkk eeeeeeeeeeee    l::::l        
8 N:::::::::::N   N::::::Ni:::::i   cc:::::::::::::::c k:::::k   k:::::kee::::::::::::ee  l::::l        
9 N:::::::N::::N  N::::::N i::::i  c:::::::::::::::::c k:::::k  k:::::ke::::::eeeee:::::eel::::l        
10 N::::::N N::::N N::::::N i::::i c:::::::cccccc:::::c k:::::k k:::::ke::::::e     e:::::el::::l        
11 N::::::N  N::::N:::::::N i::::i c::::::c     ccccccc k::::::k:::::k e:::::::eeeee::::::el::::l        
12 N::::::N   N:::::::::::N i::::i c:::::c              k:::::::::::k  e:::::::::::::::::e l::::l        
13 N::::::N    N::::::::::N i::::i c:::::c              k:::::::::::k  e::::::eeeeeeeeeee  l::::l        
14 N::::::N     N:::::::::N i::::i c::::::c     ccccccc k::::::k:::::k e:::::::e           l::::l        
15 N::::::N      N::::::::Ni::::::ic:::::::cccccc:::::ck::::::k k:::::ke::::::::e         l::::::l       
16 N::::::N       N:::::::Ni::::::i c:::::::::::::::::ck::::::k  k:::::ke::::::::eeeeeeee l::::::l       
17 N::::::N        N::::::Ni::::::i  cc:::::::::::::::ck::::::k   k:::::kee:::::::::::::e l::::::l       
18 NNNNNNNN         NNNNNNNiiiiiiii    cccccccccccccccckkkkkkkk    kkkkkkk eeeeeeeeeeeeee llllllll       
19                                                                                                                             
20                                                                                                                             
21 
22 
23                                           ``....----....``                                          
24                                   `.-://+++//////////////+++//:-.`                                  
25                              `.:/+///:::::::::///::////::::::::///+/:.`                             
26                          `.:+//:----:/:-+ssos+/so///ysso/sooo/:-----://+:.`                         
27                       `-///:---:/+/-oss/:ooss+/soos+ysso:+yo/::::-:/:---:///-`                      
28                    `.///:--:/++oso/:ssoo+++++/////////++/oo+:::::::ss+o/----///.`                   
29                  `:+/:----:sooo:+s+//////::::::::::::::::://////:+ooss+:+o/...-/+:`                 
30                `:+/--------:soo:://:::--.................-----:::///++/+s/+++/-.-/+:`               
31              `:+/--:++:-----:::::--.........-:://++++//:--......---::://+/s//o:/-.-:+:`             
32             -+/---/osoo+--::::-.........:++syyhhhhhhhhhhhy+/---.....---:::++o/os+/-.-/+-            
33           ./+-.-/o/:os+/:::-........-/oyyyyyyyyyyhhyyhhhhhddyo:---......-:::/o+s/://..-+/.          
34          -+/-.:ooos+:::::-.......-/syhyyssyyyyyyyyyyyyyhhhhhhddho:--.......-:::o/:+s+:..:+-         
35        `:+:.-://ooo/:::........./yhhyssosssyyysysssyyssssyyhhhhdddy/--.......-::/ooo+/:..-+:`       
36       `/+-.-o++o//:::-........:ohhysooooooossoooooossssssssyyhhhdddds--........-::++:/o+..-+/`      
37      `/+-..-++/o/-::........./hhhsoooooooooooooooooooooosssssyhhdddddh/-........-::/s+:-....+/`     
38      :+-.....-:--/-``........ohhsooooo+++++++++++ooooooossssssyhdmddddd:-........-:::+:......+/     
39     :+-.......--/.````.......ydyooooo++++++/////++++oooossssssyhdmmmmmdh---........::--......-o:    
40    .+:........-/.`````.......yhsooooo++++////////++++oooossssssydmmmmmdd:---........::--......:+.   
41    /+........-:-```````.....-dhsoooooo++++//////++++ooooosssssyyhmmmmmdm+----.......-::---.....+/   
42   -o-.......-::`````````....:hhooooooo+++++++++++++oooooosssssyyhdmmmmmm:-----.......-::---....-o-  
43   /+........-/.`````````....:dyooooooo+++++++++++++oooooosssssyyhdmmmmmd--------......:::---....+/  
44  .+:........::```````````...:hsoooo+++++++++++++++++ooooossssssyhdmmmmmy---------.....-::-----..:+. 
45  -o........-/.````````````...hoooo+++//////+++++++++++ooosssssyyhddmmmm/-----------....:/:-------o- 
46  :+........-/`````````````...sosyyyyyyssso++++o+osssyyyyyyysssyyyddmmmm/------------...:/:::-----o: 
47  /+........-/```````````````.ooysooooyyyssso++ossssyyssssyhhysyyyhdddhdy:------------..://:::----+/ 
48  /+........-:````````````````ossshs+hhy/syo+++osyho/hddyhyyhhsyyyhddhhydy--------------://:::::--+/ 
49  /+-.......-:````````````````:soooo//+//oso++++oso+//ooosysssssyyhdhyyhdh--------------:////::::-+/ 
50  :o---.....-/````````````````:s+++++oooooo++:/+os++oooooooooossyyyhysshy+--------------:+////::::o: 
51  -o----....-/.```````````````/o++///////o+++/++oooo++++++++oosyyyyyhsho----------------:o//////::o- 
52  .+/-----...::```````````````oo++//////oo++///+oosy+////+++ossyyyyhyshs---------------:/+////////o. 
53   /+------..-/```````````````oo++////+o+++/::/+++oss++/+++oosyyyyyhyoyh+--------------:o+///////o/  
54   -o::-------::``````````````:so++////+sso+//+oossys++++++ossyyyyyyhhysso:-----------:/o+//////+o-  
55    /+::-------:-``....----:::-ssoooo++/++ooooosooo++/+oosoosyyyyyyyhsssooo+/:--------/o+++/////o/   
56    .+/::-------/-:------::::::/soooooo+++++oosooo++++++osyosyyyyyyhyooo++oo+o/:-----:o++++++//++.   
57     :o/:::------/:-----::::::::osoooyhyyyyyhyhyhhhyyyyysoyssyyyyyyyo++++++o/+++/:--:oo++++++++o:    
58      /o/:::------/:---::::::::::+soossssssoo+ossyyyyhhho+ssyyyyyyyo++++++o+//+//+//o+++++++++o/     
59      `/+/:::------:::::::::::::::/sooooo+/++++///+oysooossyyyyyyso+++++/++////////o+++++++++o/`     
60       `/+/:::------:/:::::::::::::+ssoooo+/::::+osysooossyyyyyyso+++///++///////+o+++++++++o/`      
61        `:+/::::------:/::::::::::/o/ssoooosssssyssooossyyyyyyso++++///++///////oo+++++++++o:`       
62          -++::::-------:/:::::://o+..+ysoooooooooooossyyyyyso+++////+o+//////+o+++++++++o+-         
63           ./+/::::-------:/::://o/.```-oysssosooossyyyyyss+++//////+o+/////++++++++++++o/.          
64             -++/:::--------:://+:.``.://osyysyyyyyyyyso+++/////////o////+++++++++++++o+-            
65              `:++::::---------:::-.-osooo+oo/::::+oo++////////////+//++++///+++++++o+:`             
66                `:++:::-----------::/++++///++/.-++///////////////++++////////++++++:`               
67                  `:++/::------------::://:///+///////////////////////////////++++:`                 
68                    `./+/::------------:::::///:////////////////////////////+++/.`                   
69                       `-/+//:---------::::/soo/ooo+ooo+oo://////////////+++/-`                      
70                          `.:++/::------:::osssso/yosss/+y/://///////++++:.`                         
71                              `.:/++//:::::+/++/oo++ooo/+++/////++++/:.`                             
72                                   `.-:/++++++////////++++++++/:-.`                                  
73                                           ``....----....``                                          
74 
75 Tokenomics:
76 
77 Transaction Tax: 7%
78     1.5% auto yield direct to holders (no staking)
79     1.5% sent direct to Charity wallet
80     2% Burn Rate per tx
81     2% Automatic liquidity
82 
83 
84 another quality product devved by:
85 
86 -=:[ // developed for by @sycore0 as part of Rocket Drop's suite of services // ]:=- 
87 
88  */
89 
90 pragma solidity ^0.6.12;
91 // SPDX-License-Identifier: Unlicensed
92 interface IERC20 {
93 
94     function totalSupply() external view returns (uint256);
95 
96     /**
97      * @dev Returns the amount of tokens owned by `account`.
98      */
99     function balanceOf(address account) external view returns (uint256);
100 
101     /**
102      * @dev Moves `amount` tokens from the caller's account to `recipient`.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transfer(address recipient, uint256 amount) external returns (bool);
109 
110     /**
111      * @dev Returns the remaining number of tokens that `spender` will be
112      * allowed to spend on behalf of `owner` through {transferFrom}. This is
113      * zero by default.
114      *
115      * This value changes when {approve} or {transferFrom} are called.
116      */
117     function allowance(address owner, address spender) external view returns (uint256);
118 
119     /**
120      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * IMPORTANT: Beware that changing an allowance with this method brings the risk
125      * that someone may use both the old and the new allowance by unfortunate
126      * transaction ordering. One possible solution to mitigate this race
127      * condition is to first reduce the spender's allowance to 0 and set the
128      * desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address spender, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Moves `amount` tokens from `sender` to `recipient` using the
137      * allowance mechanism. `amount` is then deducted from the caller's
138      * allowance.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Emitted when `value` tokens are moved from one account (`from`) to
148      * another (`to`).
149      *
150      * Note that `value` may be zero.
151      */
152     event Transfer(address indexed from, address indexed to, uint256 value);
153 
154     /**
155      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
156      * a call to {approve}. `value` is the new allowance.
157      */
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 
163 /**
164  * @dev Wrappers over Solidity's arithmetic operations with added overflow
165  * checks.
166  *
167  * Arithmetic operations in Solidity wrap on overflow. This can easily result
168  * in bugs, because programmers usually assume that an overflow raises an
169  * error, which is the standard behavior in high level programming languages.
170  * `SafeMath` restores this intuition by reverting the transaction when an
171  * operation overflows.
172  *
173  * Using this library instead of the unchecked operations eliminates an entire
174  * class of bugs, so it's recommended to use it always.
175  */
176  
177 library SafeMath {
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      *
186      * - Addition cannot overflow.
187      */
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         uint256 c = a + b;
190         require(c >= a, "SafeMath: addition overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         return sub(a, b, "SafeMath: subtraction overflow");
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      *
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b <= a, errorMessage);
221         uint256 c = a - b;
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the multiplication of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `*` operator.
231      *
232      * Requirements:
233      *
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
238         // benefit is lost if 'b' is also tested.
239         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
240         if (a == 0) {
241             return 0;
242         }
243 
244         uint256 c = a * b;
245         require(c / a == b, "SafeMath: multiplication overflow");
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         return div(a, b, "SafeMath: division by zero");
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b > 0, errorMessage);
280         uint256 c = a / b;
281         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * Reverts when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         return mod(a, b, "SafeMath: modulo by zero");
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * Reverts with custom message when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
315         require(b != 0, errorMessage);
316         return a % b;
317     }
318 }
319 
320 abstract contract Context {
321     function _msgSender() internal view virtual returns (address payable) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view virtual returns (bytes memory) {
326         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
327         return msg.data;
328     }
329 }
330 
331 
332 /**
333  * @dev Collection of functions related to the address type
334  */
335 library Address {
336     /**
337      * @dev Returns true if `account` is a contract.
338      *
339      * [IMPORTANT]
340      * ====
341      * It is unsafe to assume that an address for which this function returns
342      * false is an externally-owned account (EOA) and not a contract.
343      *
344      * Among others, `isContract` will return false for the following
345      * types of addresses:
346      *
347      *  - an externally-owned account
348      *  - a contract in construction
349      *  - an address where a contract will be created
350      *  - an address where a contract lived, but was destroyed
351      * ====
352      */
353     function isContract(address account) internal view returns (bool) {
354         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
355         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
356         // for accounts without code, i.e. `keccak256('')`
357         bytes32 codehash;
358         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
359         // solhint-disable-next-line no-inline-assembly
360         assembly { codehash := extcodehash(account) }
361         return (codehash != accountHash && codehash != 0x0);
362     }
363 
364     /**
365      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
366      * `recipient`, forwarding all available gas and reverting on errors.
367      *
368      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
369      * of certain opcodes, possibly making contracts go over the 2300 gas limit
370      * imposed by `transfer`, making them unable to receive funds via
371      * `transfer`. {sendValue} removes this limitation.
372      *
373      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
374      *
375      * IMPORTANT: because control is transferred to `recipient`, care must be
376      * taken to not create reentrancy vulnerabilities. Consider using
377      * {ReentrancyGuard} or the
378      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
379      */
380     function sendValue(address payable recipient, uint256 amount) internal {
381         require(address(this).balance >= amount, "Address: insufficient balance");
382 
383         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
384         (bool success, ) = recipient.call{ value: amount }("");
385         require(success, "Address: unable to send value, recipient may have reverted");
386     }
387 
388     /**
389      * @dev Performs a Solidity function call using a low level `call`. A
390      * plain`call` is an unsafe replacement for a function call: use this
391      * function instead.
392      *
393      * If `target` reverts with a revert reason, it is bubbled up by this
394      * function (like regular Solidity function calls).
395      *
396      * Returns the raw returned data. To convert to the expected return value,
397      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
398      *
399      * Requirements:
400      *
401      * - `target` must be a contract.
402      * - calling `target` with `data` must not revert.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
407       return functionCall(target, data, "Address: low-level call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
412      * `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
417         return _functionCallWithValue(target, data, 0, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but also transferring `value` wei to `target`.
423      *
424      * Requirements:
425      *
426      * - the calling contract must have an ETH balance of at least `value`.
427      * - the called Solidity function must be `payable`.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
432         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
437      * with `errorMessage` as a fallback revert reason when `target` reverts.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
442         require(address(this).balance >= value, "Address: insufficient balance for call");
443         return _functionCallWithValue(target, data, value, errorMessage);
444     }
445 
446     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
447         require(isContract(target), "Address: call to non-contract");
448 
449         // solhint-disable-next-line avoid-low-level-calls
450         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
451         if (success) {
452             return returndata;
453         } else {
454             // Look for revert reason and bubble it up if present
455             if (returndata.length > 0) {
456                 // The easiest way to bubble the revert reason is using memory via assembly
457 
458                 // solhint-disable-next-line no-inline-assembly
459                 assembly {
460                     let returndata_size := mload(returndata)
461                     revert(add(32, returndata), returndata_size)
462                 }
463             } else {
464                 revert(errorMessage);
465             }
466         }
467     }
468 }
469 
470 /**
471  * @dev Contract module which provides a basic access control mechanism, where
472  * there is an account (an owner) that can be granted exclusive access to
473  * specific functions.
474  *
475  * By default, the owner account will be the one that deploys the contract. This
476  * can later be changed with {transferOwnership}.
477  *
478  * This module is used through inheritance. It will make available the modifier
479  * `onlyOwner`, which can be applied to your functions to restrict their use to
480  * the owner.
481  */
482 contract Ownable is Context {
483     address private _owner;
484     address private _previousOwner;
485     uint256 private _lockTime;
486 
487     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
488 
489     /**
490      * @dev Initializes the contract setting the deployer as the initial owner.
491      */
492     constructor () internal {
493         address msgSender = _msgSender();
494         _owner = msgSender;
495         emit OwnershipTransferred(address(0), msgSender);
496     }
497 
498     /**
499      * @dev Returns the address of the current owner.
500      */
501     function owner() public view returns (address) {
502         return _owner;
503     }
504 
505     /**
506      * @dev Throws if called by any account other than the owner.
507      */
508     modifier onlyOwner() {
509         require(_owner == _msgSender(), "Ownable: caller is not the owner");
510         _;
511     }
512 
513      /**
514      * @dev Leaves the contract without owner. It will not be possible to call
515      * `onlyOwner` functions anymore. Can only be called by the current owner.
516      *
517      * NOTE: Renouncing ownership will leave the contract without an owner,
518      * thereby removing any functionality that is only available to the owner.
519      */
520     function renounceOwnership() public virtual onlyOwner {
521         emit OwnershipTransferred(_owner, address(0));
522         _owner = address(0);
523     }
524 
525     /**
526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
527      * Can only be called by the current owner.
528      */
529     function transferOwnership(address newOwner) public virtual onlyOwner {
530         require(newOwner != address(0), "Ownable: new owner is the zero address");
531         emit OwnershipTransferred(_owner, newOwner);
532         _owner = newOwner;
533     }
534 
535     function geUnlockTime() public view returns (uint256) {
536         return _lockTime;
537     }
538 
539     //Locks the contract for owner for the amount of time provided
540     function lock(uint256 time) public virtual onlyOwner {
541         _previousOwner = _owner;
542         _owner = address(0);
543         _lockTime = now + time;
544         emit OwnershipTransferred(_owner, address(0));
545     }
546     
547     //Unlocks the contract for owner when _lockTime is exceeds
548     function unlock() public virtual {
549         require(_previousOwner == msg.sender, "You don't have permission to unlock");
550         require(now > _lockTime , "Contract is locked until 7 days");
551         emit OwnershipTransferred(_owner, _previousOwner);
552         _owner = _previousOwner;
553     }
554 }
555 
556 // pragma solidity >=0.5.0;
557 
558 interface IUniswapV2Factory {
559     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
560 
561     function feeTo() external view returns (address);
562     function feeToSetter() external view returns (address);
563 
564     function getPair(address tokenA, address tokenB) external view returns (address pair);
565     function allPairs(uint) external view returns (address pair);
566     function allPairsLength() external view returns (uint);
567 
568     function createPair(address tokenA, address tokenB) external returns (address pair);
569 
570     function setFeeTo(address) external;
571     function setFeeToSetter(address) external;
572 }
573 
574 
575 // pragma solidity >=0.5.0;
576 
577 interface IUniswapV2Pair {
578     event Approval(address indexed owner, address indexed spender, uint value);
579     event Transfer(address indexed from, address indexed to, uint value);
580 
581     function name() external pure returns (string memory);
582     function symbol() external pure returns (string memory);
583     function decimals() external pure returns (uint8);
584     function totalSupply() external view returns (uint);
585     function balanceOf(address owner) external view returns (uint);
586     function allowance(address owner, address spender) external view returns (uint);
587 
588     function approve(address spender, uint value) external returns (bool);
589     function transfer(address to, uint value) external returns (bool);
590     function transferFrom(address from, address to, uint value) external returns (bool);
591 
592     function DOMAIN_SEPARATOR() external view returns (bytes32);
593     function PERMIT_TYPEHASH() external pure returns (bytes32);
594     function nonces(address owner) external view returns (uint);
595 
596     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
597 
598     event Mint(address indexed sender, uint amount0, uint amount1);
599     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
600     event Swap(
601         address indexed sender,
602         uint amount0In,
603         uint amount1In,
604         uint amount0Out,
605         uint amount1Out,
606         address indexed to
607     );
608     event Sync(uint112 reserve0, uint112 reserve1);
609 
610     function MINIMUM_LIQUIDITY() external pure returns (uint);
611     function factory() external view returns (address);
612     function token0() external view returns (address);
613     function token1() external view returns (address);
614     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
615     function price0CumulativeLast() external view returns (uint);
616     function price1CumulativeLast() external view returns (uint);
617     function kLast() external view returns (uint);
618 
619     function mint(address to) external returns (uint liquidity);
620     function burn(address to) external returns (uint amount0, uint amount1);
621     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
622     function skim(address to) external;
623     function sync() external;
624 
625     function initialize(address, address) external;
626 }
627 
628 // pragma solidity >=0.6.2;
629 
630 interface IUniswapV2Router01 {
631     function factory() external pure returns (address);
632     function WETH() external pure returns (address);
633 
634     function addLiquidity(
635         address tokenA,
636         address tokenB,
637         uint amountADesired,
638         uint amountBDesired,
639         uint amountAMin,
640         uint amountBMin,
641         address to,
642         uint deadline
643     ) external returns (uint amountA, uint amountB, uint liquidity);
644     function addLiquidityETH(
645         address token,
646         uint amountTokenDesired,
647         uint amountTokenMin,
648         uint amountETHMin,
649         address to,
650         uint deadline
651     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
652     function removeLiquidity(
653         address tokenA,
654         address tokenB,
655         uint liquidity,
656         uint amountAMin,
657         uint amountBMin,
658         address to,
659         uint deadline
660     ) external returns (uint amountA, uint amountB);
661     function removeLiquidityETH(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline
668     ) external returns (uint amountToken, uint amountETH);
669     function removeLiquidityWithPermit(
670         address tokenA,
671         address tokenB,
672         uint liquidity,
673         uint amountAMin,
674         uint amountBMin,
675         address to,
676         uint deadline,
677         bool approveMax, uint8 v, bytes32 r, bytes32 s
678     ) external returns (uint amountA, uint amountB);
679     function removeLiquidityETHWithPermit(
680         address token,
681         uint liquidity,
682         uint amountTokenMin,
683         uint amountETHMin,
684         address to,
685         uint deadline,
686         bool approveMax, uint8 v, bytes32 r, bytes32 s
687     ) external returns (uint amountToken, uint amountETH);
688     function swapExactTokensForTokens(
689         uint amountIn,
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external returns (uint[] memory amounts);
695     function swapTokensForExactTokens(
696         uint amountOut,
697         uint amountInMax,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external returns (uint[] memory amounts);
702     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
703         external
704         payable
705         returns (uint[] memory amounts);
706     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
707         external
708         returns (uint[] memory amounts);
709     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
710         external
711         returns (uint[] memory amounts);
712     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
713         external
714         payable
715         returns (uint[] memory amounts);
716 
717     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
718     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
719     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
720     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
721     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
722 }
723 
724 
725 
726 // pragma solidity >=0.6.2;
727 
728 interface IUniswapV2Router02 is IUniswapV2Router01 {
729     function removeLiquidityETHSupportingFeeOnTransferTokens(
730         address token,
731         uint liquidity,
732         uint amountTokenMin,
733         uint amountETHMin,
734         address to,
735         uint deadline
736     ) external returns (uint amountETH);
737     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
738         address token,
739         uint liquidity,
740         uint amountTokenMin,
741         uint amountETHMin,
742         address to,
743         uint deadline,
744         bool approveMax, uint8 v, bytes32 r, bytes32 s
745     ) external returns (uint amountETH);
746 
747     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
748         uint amountIn,
749         uint amountOutMin,
750         address[] calldata path,
751         address to,
752         uint deadline
753     ) external;
754     function swapExactETHForTokensSupportingFeeOnTransferTokens(
755         uint amountOutMin,
756         address[] calldata path,
757         address to,
758         uint deadline
759     ) external payable;
760     function swapExactTokensForETHSupportingFeeOnTransferTokens(
761         uint amountIn,
762         uint amountOutMin,
763         address[] calldata path,
764         address to,
765         uint deadline
766     ) external;
767 }
768 
769 
770 contract Nickel is Context, IERC20, Ownable {
771     using SafeMath for uint256;
772     using Address for address;
773 
774     mapping (address => uint256) private _rOwned;
775     mapping (address => uint256) private _tOwned;
776     mapping (address => mapping (address => uint256)) private _allowances;
777 
778     mapping (address => bool) private _isExcludedFromFee;
779 
780     mapping (address => bool) private _isExcluded;
781     address[] private _excluded;
782    
783     uint256 private constant MAX = ~uint256(0);
784     uint256 private _tTotal = 77 * 10**6 * 10**18;
785     uint256 private _rTotal = (MAX - (MAX % _tTotal));
786     uint256 private _tFeeTotal;
787 
788     string private _name = "Nickel";
789     string private _symbol = "NICKEL";
790     uint8 private _decimals = 18;
791     
792     uint256 private constant DIVISION_FACTOR = 4;   // fee precision up to 2 decimals
793     uint256 public _taxFee = 150;                   // 20 = 2.00%
794     uint256 private _previousTaxFee = _taxFee;
795     
796     uint256 public _liquidityFee = 200;             // 15 = 1.50%
797     uint256 private _previousLiquidityFee = _liquidityFee;
798 
799     uint256 public charityFee = 150;
800     uint256 public totalDonated;
801     address public CHARITY_WALLET;
802 
803     uint public _burnRate = 200;
804     uint public _totalBurned;
805 
806     uint256 public DROP_DIVISOR = 100;
807 
808     IUniswapV2Router02 public uniswapV2Router;
809     address public uniswapV2Pair;
810     
811     bool inSwapAndLiquify;
812     bool public swapAndLiquifyEnabled = true;
813     
814     uint256 private numTokensSellToAddToLiquidity = 10**6 * 10**9;
815     
816     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
817     event SwapAndLiquifyEnabledUpdated(bool enabled);
818     event SwapAndLiquify(
819         uint256 tokensSwapped,
820         uint256 ethReceived,
821         uint256 tokensIntoLiqudity
822     );
823     
824     modifier lockTheSwap {
825         inSwapAndLiquify = true;
826         _;
827         inSwapAndLiquify = false;
828     }
829     
830     constructor () public {
831         _rOwned[_msgSender()] = _rTotal;
832         
833         //exclude owner and this contract from fee
834         _isExcludedFromFee[owner()] = true;
835         _isExcludedFromFee[address(this)] = true;
836 
837         CHARITY_WALLET = msg.sender;
838         
839         emit Transfer(address(0), _msgSender(), _tTotal);
840     }
841 
842     function setPair(address _uniswapV2Pair) public onlyOwner() { 
843         uniswapV2Pair = _uniswapV2Pair;
844     }
845     function setRouter(address routerAddress) public onlyOwner() { 
846         uniswapV2Router = IUniswapV2Router02(routerAddress);
847     }
848 
849 
850     function name() public view returns (string memory) {
851         return _name;
852     }
853 
854     function symbol() public view returns (string memory) {
855         return _symbol;
856     }
857 
858     function decimals() public view returns (uint8) {
859         return _decimals;
860     }
861 
862     function totalSupply() public view override returns (uint256) {
863         return _tTotal;
864     }
865 
866     function balanceOf(address account) public view override returns (uint256) {
867         if (_isExcluded[account]) return _tOwned[account];
868         return tokenFromReflection(_rOwned[account]);
869     }
870 
871     function transfer(address recipient, uint256 amount) public override returns (bool) {
872         _transfer(_msgSender(), recipient, amount);
873         return true;
874     }
875 
876     function allowance(address owner, address spender) public view override returns (uint256) {
877         return _allowances[owner][spender];
878     }
879 
880     function approve(address spender, uint256 amount) public override returns (bool) {
881         _approve(_msgSender(), spender, amount);
882         return true;
883     }
884 
885     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
886         _transfer(sender, recipient, amount);
887         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
888         return true;
889     }
890 
891     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
892         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
893         return true;
894     }
895 
896     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
897         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
898         return true;
899     }
900 
901     function isExcludedFromReward(address account) public view returns (bool) {
902         return _isExcluded[account];
903     }
904 
905     function totalFees() public view returns (uint256) {
906         return _tFeeTotal;
907     }
908 
909     function deliver(uint256 tAmount) public {
910         address sender = _msgSender();
911         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
912         (uint256 rAmount,,,,,) = _getValues(tAmount);
913         _rOwned[sender] = _rOwned[sender].sub(rAmount);
914         _rTotal = _rTotal.sub(rAmount);
915         _tFeeTotal = _tFeeTotal.add(tAmount);
916         // did you know that 80% of all pretzels sold in the US are made in Philadelphia? 
917     }
918 
919     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
920         require(tAmount <= _tTotal, "Amount must be less than supply");
921         if (!deductTransferFee) {
922             (uint256 rAmount,,,,,) = _getValues(tAmount);
923             return rAmount;
924         } else {
925             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
926             return rTransferAmount;
927         }
928     }
929 
930     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
931         require(rAmount <= _rTotal, "Amount must be less than total reflections");
932         uint256 currentRate =  _getRate();
933         return rAmount.div(currentRate);
934     }
935 
936     function excludeFromReward(address account) public onlyOwner() {
937         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
938         require(!_isExcluded[account], "Account is already excluded");
939         if(_rOwned[account] > 0) {
940             _tOwned[account] = tokenFromReflection(_rOwned[account]);
941         }
942         _isExcluded[account] = true;
943         _excluded.push(account);
944     }
945 
946     function includeInReward(address account) external onlyOwner() {
947         require(_isExcluded[account], "Account is already excluded");
948         for (uint256 i = 0; i < _excluded.length; i++) {
949             if (_excluded[i] == account) {
950                 _excluded[i] = _excluded[_excluded.length - 1];
951                 _tOwned[account] = 0;
952                 _isExcluded[account] = false;
953                 _excluded.pop();
954                 break;
955             }
956         }
957     }
958     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
959         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
960         _tOwned[sender] = _tOwned[sender].sub(tAmount);
961         _rOwned[sender] = _rOwned[sender].sub(rAmount);
962         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
963         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
964         _takeLiquidity(tLiquidity);
965         _reflectFee(rFee, tFee);
966         emit Transfer(sender, recipient, tTransferAmount);
967     }
968     
969     function excludeFromFee(address account) public onlyOwner {
970         _isExcludedFromFee[account] = true;
971     }
972     
973     function includeInFee(address account) public onlyOwner {
974         _isExcludedFromFee[account] = false;
975     }
976     
977     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
978         require(taxFee <= 1000, 'Fee too high');  // max tax fee of 10%
979         _taxFee = taxFee;
980     }
981     
982     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
983         require(liquidityFee <= 1000, 'Fee too high');  // max liq fee of 10%
984         _liquidityFee = liquidityFee;
985         // did you know that crunchy pretzels were invented because some lazy baker's apprentive took a nap while making fresh pretzels? heck of a twist amirite?!
986     }
987 
988     function setBurnRate(uint amount) public onlyOwner() {
989         require (amount <= 1000, "Burn too high");
990         _burnRate = amount;
991     }
992 
993     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
994         swapAndLiquifyEnabled = _enabled;
995         emit SwapAndLiquifyEnabledUpdated(_enabled);
996     }
997     
998      //to recieve ETH from uniswapV2Router when swaping
999     receive() external payable {}
1000 
1001     function _reflectFee(uint256 rFee, uint256 tFee) private {
1002         _rTotal = _rTotal.sub(rFee);
1003         _tFeeTotal = _tFeeTotal.add(tFee);
1004     }
1005 
1006     function _getBurnAmounts(uint amount) private view returns(uint, uint) {
1007         uint _currentRate = _getRate();
1008         uint tBurnAmount = amount.mul(_burnRate).div(10**DIVISION_FACTOR);
1009         uint rBurnAmount = tBurnAmount.mul(_currentRate);
1010         return(tBurnAmount, rBurnAmount);
1011     }
1012 
1013     function _burn(address sender, uint tBurnAmount, uint rBurnAmount) private {
1014        if (_rOwned[address(sender)] <= rBurnAmount){
1015             _rOwned[address(sender)] = 0;
1016         } else { 
1017         _rOwned[address(sender)] -= rBurnAmount;
1018        }
1019         _tTotal = _tTotal.sub(tBurnAmount);
1020         _rTotal = _rTotal.sub(rBurnAmount);
1021         _totalBurned = _totalBurned.add(tBurnAmount);
1022 
1023         emit Transfer(sender, address(0), tBurnAmount);
1024     }
1025     
1026     function burn(uint amount) public returns(bool) {
1027         require(amount <= balanceOf(msg.sender), "insufficient amount");
1028         require(amount > 0, "must be greater than 0");
1029         
1030         uint _currentRate = _getRate();
1031         uint tBurnAmount = amount;
1032         uint rBurnAmount = tBurnAmount.mul(_currentRate);
1033         _burn(msg.sender, tBurnAmount, rBurnAmount);
1034         
1035         return true;
1036     }
1037 
1038     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1039         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1040         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1041         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1042     }
1043 
1044     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1045         uint256 tFee = calculateTaxFee(tAmount);
1046         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1047         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1048         return (tTransferAmount, tFee, tLiquidity);
1049     }
1050 
1051     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1052         uint256 rAmount = tAmount.mul(currentRate);
1053         uint256 rFee = tFee.mul(currentRate);
1054         uint256 rLiquidity = tLiquidity.mul(currentRate);
1055         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1056         return (rAmount, rTransferAmount, rFee);
1057     }
1058 
1059     function _getRate() private view returns(uint256) {
1060         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1061         return rSupply.div(tSupply);
1062     }
1063 
1064     function _getCurrentSupply() private view returns(uint256, uint256) {
1065         uint256 rSupply = _rTotal;
1066         uint256 tSupply = _tTotal;      
1067         for (uint256 i = 0; i < _excluded.length; i++) {
1068             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1069             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1070             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1071         }
1072         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1073         return (rSupply, tSupply);
1074     }
1075     
1076     function _takeLiquidity(uint256 tLiquidity) private {
1077         uint256 currentRate =  _getRate();
1078         uint256 rLiquidity = tLiquidity.mul(currentRate);
1079         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1080         if(_isExcluded[address(this)])
1081             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1082     }
1083     
1084     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1085         return _amount.mul(_taxFee).div(
1086             10**DIVISION_FACTOR
1087         );
1088     }
1089 
1090     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1091         return _amount.mul(_liquidityFee).div(
1092             10**DIVISION_FACTOR
1093         );
1094     }
1095     
1096     function removeAllFee() private {
1097         if(_taxFee == 0 && _liquidityFee == 0) return;
1098         
1099         _previousTaxFee = _taxFee;
1100         _previousLiquidityFee = _liquidityFee;
1101         
1102         _taxFee = 0;
1103         _liquidityFee = 0;
1104     }
1105     
1106     function restoreAllFee() private {
1107         _taxFee = _previousTaxFee;
1108         _liquidityFee = _previousLiquidityFee;
1109     }
1110     
1111     function isExcludedFromFee(address account) public view returns(bool) {
1112         return _isExcludedFromFee[account];
1113     }
1114 
1115     function _approve(address owner, address spender, uint256 amount) private {
1116         require(owner != address(0), "ERC20: approve from the zero address");
1117         require(spender != address(0), "ERC20: approve to the zero address");
1118 
1119         _allowances[owner][spender] = amount;
1120         emit Approval(owner, spender, amount);
1121     }
1122 
1123     function _transfer(
1124         address from,
1125         address to,
1126         uint256 amount
1127     ) private {
1128         require(from != address(0), "ERC20: transfer from the zero address");
1129         require(to != address(0), "ERC20: transfer to the zero address");
1130         require(amount > 0, "Transfer amount must be greater than zero");
1131 
1132         // Philadelphia eats about 12 pounds of pretzels each year, 10 pounds more than the national average
1133         if(to == address(uniswapV2Pair))
1134                 require(amount <= _tTotal.div(DROP_DIVISOR), "Sell amount too high bro");
1135 
1136         // is the token balance of this contract address over the min number of
1137         // tokens that we need to initiate a swap + liquidity lock?
1138         // also, don't get caught in a circular liquidity event.
1139         // also, don't swap & liquify if sender is uniswap pair.
1140         uint256 contractTokenBalance = balanceOf(address(this));
1141         
1142         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1143         if (
1144             overMinTokenBalance &&
1145             !inSwapAndLiquify &&
1146             from != uniswapV2Pair &&
1147             swapAndLiquifyEnabled
1148         ) {
1149             contractTokenBalance = numTokensSellToAddToLiquidity;
1150             //add liquidity
1151             // jeez, most babies don't even weigh 12 pounds at birth
1152             swapAndLiquify(contractTokenBalance);
1153         }
1154         
1155         //indicates if fee should be deducted from transfer
1156         bool takeFee = true;
1157         
1158         //if any account belongs to _isExcludedFromFee account then remove the fee
1159         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1160             takeFee = false;
1161         } else{
1162             uint256 charityAmount = amount.mul(charityFee).div(10**DIVISION_FACTOR);
1163             totalDonated = totalDonated.add(charityAmount);
1164             (uint tBurnAmount, uint rBurnAmount) = _getBurnAmounts(amount);
1165             amount = amount.sub(tBurnAmount);
1166             _burn(from, tBurnAmount, rBurnAmount);
1167             _tokenTransfer(from,CHARITY_WALLET,charityAmount,false);
1168             amount = amount.sub(charityAmount);
1169         }
1170         
1171         //transfer amount, it will take tax, burn, liquidity fee
1172         _tokenTransfer(from,to,amount,takeFee);
1173     }
1174 
1175     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1176         // split the contract balance into halves
1177         uint256 half = contractTokenBalance.div(2);
1178         uint256 otherHalf = contractTokenBalance.sub(half);
1179 
1180         // capture the contract's current ETH balance.
1181         // this is so that we can capture exactly the amount of ETH that the
1182         // swap creates, and not make the liquidity event include any ETH that
1183         // has been manually sent to the contract
1184         uint256 initialBalance = address(this).balance;
1185 
1186         // swap tokens for ETH
1187         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1188 
1189         // how much ETH did we just swap into?
1190         uint256 newBalance = address(this).balance.sub(initialBalance);
1191 
1192         // add liquidity to uniswap
1193         addLiquidity(otherHalf, newBalance);
1194         
1195         emit SwapAndLiquify(half, newBalance, otherHalf);
1196     }
1197 
1198     function swapTokensForEth(uint256 tokenAmount) private {
1199         // generate the uniswap pair path of token -> weth
1200         address[] memory path = new address[](2);
1201         path[0] = address(this);
1202         path[1] = uniswapV2Router.WETH();
1203 
1204         // well maybe they do, honestly i haven't looked up birthweight statistics
1205         _approve(address(this), address(uniswapV2Router), tokenAmount);
1206 
1207         // make the swap
1208         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1209             tokenAmount,
1210             0, // accept any amount of ETH
1211             path,
1212             address(this),
1213             block.timestamp
1214         );
1215     }
1216 
1217     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1218         // approve token transfer to cover all possible scenarios
1219         _approve(address(this), address(uniswapV2Router), tokenAmount);
1220 
1221         // add the liquidity
1222         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1223             address(this),
1224             tokenAmount,
1225             0, // slippage is unavoidable
1226             0, // slippage is unavoidable
1227             address(this),
1228             block.timestamp
1229         );
1230     }
1231 
1232     //this method is responsible for taking all fee, if takeFee is true
1233     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1234         if(!takeFee)
1235             removeAllFee();
1236         
1237         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1238             _transferFromExcluded(sender, recipient, amount);
1239         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1240             _transferToExcluded(sender, recipient, amount);
1241         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1242             _transferStandard(sender, recipient, amount);
1243         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1244             _transferBothExcluded(sender, recipient, amount);
1245         } else {
1246             _transferStandard(sender, recipient, amount);
1247         }
1248         
1249         if(!takeFee)
1250             restoreAllFee();
1251     }
1252 
1253     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1254         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1255         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1256         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1257         _takeLiquidity(tLiquidity);
1258         _reflectFee(rFee, tFee);
1259         emit Transfer(sender, recipient, tTransferAmount);
1260     }
1261 
1262     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1263         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1264         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1265         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1266         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1267         _takeLiquidity(tLiquidity);
1268         _reflectFee(rFee, tFee);
1269         emit Transfer(sender, recipient, tTransferAmount);
1270     }
1271 
1272     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1273         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1274         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1275         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1276         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1277         _takeLiquidity(tLiquidity);
1278         _reflectFee(rFee, tFee);
1279         emit Transfer(sender, recipient, tTransferAmount);
1280     }
1281 
1282     function setLiquifyAmount(uint256 amount) public onlyOwner {
1283         numTokensSellToAddToLiquidity = amount;
1284     }
1285     
1286     function setCharityFee(uint256 amount) public onlyOwner {
1287         charityFee = amount;
1288     }
1289 
1290     function setDropDivisor(uint256 _DROP_DIVISOR) public onlyOwner {
1291         require(_DROP_DIVISOR > 0,'need: divvies with privvies');
1292         DROP_DIVISOR = _DROP_DIVISOR;
1293     }
1294 
1295     function setCharityWallet(address _charityWallet) public onlyOwner {
1296         CHARITY_WALLET = _charityWallet;
1297     }
1298 
1299     function withdrawAnyToken(address _recipient, address _ERC20address, uint256 _amount) public onlyOwner returns(bool) {
1300         require(_ERC20address != uniswapV2Pair, "Can't transfer out LP tokens!");
1301         require(_ERC20address != address(this), "Can't transfer out contract tokens!");
1302         IERC20(_ERC20address).transfer(_recipient, _amount); //use of the _ERC20 traditional transfer
1303         return true;
1304     }
1305 
1306     function transferXS(address payable recipient) public onlyOwner {
1307         recipient.transfer(address(this).balance);
1308     }
1309 
1310 }