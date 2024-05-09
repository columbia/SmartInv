1 pragma solidity 0.5.16;
2 
3 interface IERC20 {
4   /**
5    * @dev Returns the amount of tokens in existence.
6    */
7   function totalSupply() external view returns (uint256);
8 
9   /**
10    * @dev Returns the token decimals.
11    */
12   function decimals() external view returns (uint8);
13 
14   /**
15    * @dev Returns the token symbol.
16    */
17   function symbol() external view returns (string memory);
18 
19   /**
20   * @dev Returns the token name.
21   */
22   function name() external view returns (string memory);
23 
24   /**
25    * @dev Returns the bep token owner.
26    */
27   function getOwner() external view returns (address);
28 
29   /**
30    * @dev Returns the amount of tokens owned by `account`.
31    */
32   function balanceOf(address account) external view returns (uint256);
33 
34   /**
35    * @dev Moves `amount` tokens from the caller's account to `recipient`.
36    *
37    * Returns a boolean value indicating whether the operation succeeded.
38    *
39    * Emits a {Transfer} event.
40    */
41   function transfer(address recipient, uint256 amount) external returns (bool);
42 
43   /**
44    * @dev Returns the remaining number of tokens that `spender` will be
45    * allowed to spend on behalf of `owner` through {transferFrom}. This is
46    * zero by default.
47    *
48    * This value changes when {approve} or {transferFrom} are called.
49    */
50   function allowance(address _owner, address spender) external view returns (uint256);
51 
52   /**
53    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54    *
55    * Returns a boolean value indicating whether the operation succeeded.
56    *
57    * IMPORTANT: Beware that changing an allowance with this method brings the risk
58    * that someone may use both the old and the new allowance by unfortunate
59    * transaction ordering. One possible solution to mitigate this race
60    * condition is to first reduce the spender's allowance to 0 and set the
61    * desired value afterwards:
62    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63    *
64    * Emits an {Approval} event.
65    */
66   function approve(address spender, uint256 amount) external returns (bool);
67 
68   /**
69    * @dev Moves `amount` tokens from `sender` to `recipient` using the
70    * allowance mechanism. `amount` is then deducted from the caller's
71    * allowance.
72    *
73    * Returns a boolean value indicating whether the operation succeeded.
74    *
75    * Emits a {Transfer} event.
76    */
77   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79   /**
80    * @dev Emitted when `value` tokens are moved from one account (`from`) to
81    * another (`to`).
82    *
83    * Note that `value` may be zero.
84    */
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 
87   /**
88    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89    * a call to {approve}. `value` is the new allowance.
90    */
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 contract Context {
95   // Empty internal constructor, to prevent people from mistakenly deploying
96   // an instance of this contract, which should be used via inheritance.
97   constructor () internal { }
98 
99   function _msgSender() internal view returns (address payable) {
100     return msg.sender;
101   }
102 
103   function _msgData() internal view returns (bytes memory) {
104     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
105     return msg.data;
106   }
107 }
108 
109 library SafeMath {
110   /**
111    * @dev Returns the addition of two unsigned integers, reverting on
112    * overflow.
113    *
114    * Counterpart to Solidity's `+` operator.
115    *
116    * Requirements:
117    * - Addition cannot overflow.
118    */
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     require(c >= a, "SafeMath: addition overflow");
122 
123     return c;
124   }
125 
126   /**
127    * @dev Returns the subtraction of two unsigned integers, reverting on
128    * overflow (when the result is negative).
129    *
130    * Counterpart to Solidity's `-` operator.
131    *
132    * Requirements:
133    * - Subtraction cannot overflow.
134    */
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     return sub(a, b, "SafeMath: subtraction overflow");
137   }
138 
139   /**
140    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141    * overflow (when the result is negative).
142    *
143    * Counterpart to Solidity's `-` operator.
144    *
145    * Requirements:
146    * - Subtraction cannot overflow.
147    */
148   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149     require(b <= a, errorMessage);
150     uint256 c = a - b;
151 
152     return c;
153   }
154 
155   /**
156    * @dev Returns the multiplication of two unsigned integers, reverting on
157    * overflow.
158    *
159    * Counterpart to Solidity's `*` operator.
160    *
161    * Requirements:
162    * - Multiplication cannot overflow.
163    */
164   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166     // benefit is lost if 'b' is also tested.
167     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168     if (a == 0) {
169       return 0;
170     }
171 
172     uint256 c = a * b;
173     require(c / a == b, "SafeMath: multiplication overflow");
174 
175     return c;
176   }
177 
178   /**
179    * @dev Returns the integer division of two unsigned integers. Reverts on
180    * division by zero. The result is rounded towards zero.
181    *
182    * Counterpart to Solidity's `/` operator. Note: this function uses a
183    * `revert` opcode (which leaves remaining gas untouched) while Solidity
184    * uses an invalid opcode to revert (consuming all remaining gas).
185    *
186    * Requirements:
187    * - The divisor cannot be zero.
188    */
189   function div(uint256 a, uint256 b) internal pure returns (uint256) {
190     return div(a, b, "SafeMath: division by zero");
191   }
192 
193   /**
194    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195    * division by zero. The result is rounded towards zero.
196    *
197    * Counterpart to Solidity's `/` operator. Note: this function uses a
198    * `revert` opcode (which leaves remaining gas untouched) while Solidity
199    * uses an invalid opcode to revert (consuming all remaining gas).
200    *
201    * Requirements:
202    * - The divisor cannot be zero.
203    */
204   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205     // Solidity only automatically asserts when dividing by 0
206     require(b > 0, errorMessage);
207     uint256 c = a / b;
208     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210     return c;
211   }
212 
213   /**
214    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215    * Reverts when dividing by zero.
216    *
217    * Counterpart to Solidity's `%` operator. This function uses a `revert`
218    * opcode (which leaves remaining gas untouched) while Solidity uses an
219    * invalid opcode to revert (consuming all remaining gas).
220    *
221    * Requirements:
222    * - The divisor cannot be zero.
223    */
224   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225     return mod(a, b, "SafeMath: modulo by zero");
226   }
227 
228   /**
229    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230    * Reverts with custom message when dividing by zero.
231    *
232    * Counterpart to Solidity's `%` operator. This function uses a `revert`
233    * opcode (which leaves remaining gas untouched) while Solidity uses an
234    * invalid opcode to revert (consuming all remaining gas).
235    *
236    * Requirements:
237    * - The divisor cannot be zero.
238    */
239   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240     require(b != 0, errorMessage);
241     return a % b;
242   }
243 }
244 
245 contract Ownable is Context {
246   address private _owner;
247 
248   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250   /**
251    * @dev Initializes the contract setting the deployer as the initial owner.
252    */
253   constructor () internal {
254     address msgSender = _msgSender();
255     _owner = msgSender;
256     emit OwnershipTransferred(address(0), msgSender);
257   }
258 
259   /**
260    * @dev Returns the address of the current owner.
261    */
262   function owner() public view returns (address) {
263     return _owner;
264   }
265 
266   /**
267    * @dev Throws if called by any account other than the owner.
268    */
269   modifier onlyOwner() {
270     require(_owner == _msgSender(), "Ownable: caller is not the owner");
271     _;
272   }
273 
274   /**
275    * @dev Leaves the contract without owner. It will not be possible to call
276    * `onlyOwner` functions anymore. Can only be called by the current owner.
277    *
278    * NOTE: Renouncing ownership will leave the contract without an owner,
279    * thereby removing any functionality that is only available to the owner.
280    */
281   function renounceOwnership() public onlyOwner {
282     emit OwnershipTransferred(_owner, address(0));
283     _owner = address(0);
284   }
285 
286   /**
287    * @dev Transfers ownership of the contract to a new account (`newOwner`).
288    * Can only be called by the current owner.
289    */
290   function transferOwnership(address newOwner) public onlyOwner {
291     _transferOwnership(newOwner);
292   }
293 
294   /**
295    * @dev Transfers ownership of the contract to a new account (`newOwner`).
296    */
297   function _transferOwnership(address newOwner) internal {
298     require(newOwner != address(0), "Ownable: new owner is the zero address");
299     emit OwnershipTransferred(_owner, newOwner);
300     _owner = newOwner;
301   }
302 }
303 
304 contract IBOXToken is Context, IERC20, Ownable {
305   using SafeMath for uint256;
306 
307   mapping (address => bool) public _whitelist;
308   mapping (address => bool) public _blackHole;
309 
310   mapping (address => uint256) private _balances;
311 
312   mapping (address => mapping (address => uint256)) private _allowances;
313 
314   uint256 private _totalSupply;
315   uint8  public _decimals;
316   string public _symbol;
317   string public _name;
318 
319   address public  _devWallet; 
320   address public  uniswapV2Pair;
321   uint256 public oneWeek = 7 days;
322 
323   uint256 public startTime = 1692451800;
324 
325   bool public robotKill = true;
326   uint256 public RELEASE_AMOUNT = 10000 *10**18;
327 
328     struct UserOLD {
329         bool ISOLD;       
330         uint256 tokenAmount; 
331     }
332 
333  mapping (address => UserOLD) public userTokenOLD;
334 
335   constructor() public {
336     _name = "IBOX TOKEN";
337     _symbol = "IBOX";
338     _decimals = 18;
339     _totalSupply = 8000000000 * 10**18;
340     _balances[msg.sender] = _totalSupply;
341     _devWallet = msg.sender;
342     emit Transfer(address(0), msg.sender, _totalSupply);
343   }
344 
345 
346   function setwhitelist(address _addr,bool _is) public onlyOwner() {
347            _whitelist[_addr] = _is;
348   }
349 
350   function setblackHole(address[] memory  _addr,bool _is) public onlyOwner() {
351           for (uint256 i = 0; i < _addr.length; i++) {
352                _blackHole[_addr[i]] = _is;
353           }
354   }
355   /**
356    * @dev Returns the bep token owner.
357    */
358   function getOwner() external view returns (address) {
359     return owner();
360   }
361 
362   /**
363    * @dev Returns the token decimals.
364    */
365   function decimals() external view returns (uint8) {
366     return _decimals;
367   }
368 
369   /**
370    * @dev Returns the token symbol.
371    */
372   function symbol() external view returns (string memory) {
373     return _symbol;
374   }
375 
376   /**
377   * @dev Returns the token name.
378   */
379   function name() external view returns (string memory) {
380     return _name;
381   }
382 
383   /**
384    * @dev See {ERC20-totalSupply}.
385    */
386   function totalSupply() external view returns (uint256) {
387     return _totalSupply;
388   }
389 
390 
391 
392   /**
393    * @dev See {ERC20-balanceOf}.
394    */
395   function balanceOf(address account) public view returns (uint256) {
396     return _balances[account];
397   }
398 
399 
400   function transfer(address recipient, uint256 amount) external returns (bool) {
401     _transfer(_msgSender(), recipient, amount);
402     return true;
403   }
404 
405   function allowance(address owner, address spender) external view returns (uint256) {
406     return _allowances[owner][spender];
407   }
408 
409 
410   function approve(address spender, uint256 amount) external returns (bool) {
411     _approve(_msgSender(), spender, amount);
412     return true;
413   }
414 
415 
416   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
417     _transfer(sender, recipient, amount);
418     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
419     return true;
420   }
421 
422   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
423     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
424     return true;
425   }
426 
427   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
428     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
429     return true;
430   }
431 
432   function _transfer(address sender, address recipient, uint256 amount) internal {
433     require(sender != address(0), "ERC20: transfer from the zero address");
434     require(recipient != address(0), "ERC20: transfer to the zero address");
435     require(!_blackHole[sender], "ERC20: Problem with address");
436 
437     UserOLD storage user = userTokenOLD[sender];
438 
439     if  (user.ISOLD){
440         uint256 freedAmount;
441         if ( block.timestamp < startTime) {
442             freedAmount = 0;
443         }else {
444         uint256 freedCount = (block.timestamp - startTime) / oneWeek;
445         freedAmount =  freedCount * RELEASE_AMOUNT;
446         }
447         if (user.tokenAmount > freedAmount ){
448             uint256 NoFreedAmount = user.tokenAmount - freedAmount;
449              uint256 userAmount = balanceOf(sender);
450             
451             require(userAmount >= NoFreedAmount + amount, "ERC20: Not enough releases");
452         }
453     }
454         if (_whitelist[sender]){
455             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
456             _balances[recipient] = _balances[recipient].add(amount);
457             emit Transfer(sender, recipient, amount);
458         }else{
459           if (recipient == uniswapV2Pair && robotKill ){
460             _transferSellExcluded(sender,recipient,amount);
461           }else {
462             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
463             _balances[recipient] = _balances[recipient].add(amount);
464             emit Transfer(sender, recipient, amount);
465          }
466         }
467  }
468 
469   function getUserFreedAmount () public view returns (uint256) {
470         uint256 freedAmount; 
471          
472         if ( block.timestamp < startTime) {
473             freedAmount = 0;
474         }else {
475         uint256 freedCount = (block.timestamp - startTime ) / oneWeek;
476         freedAmount =  freedCount * RELEASE_AMOUNT ;
477         } 
478         return freedAmount;
479 
480   }
481 
482     function _transferSellExcluded(address sender, address recipient, uint256 amount) private {
483            uint256 taxAmount = (amount * 90) / 100; 
484            uint256 transferAmount = amount - taxAmount; 
485            
486            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
487            _balances[recipient] = _balances[recipient].add(transferAmount);
488            emit Transfer(sender, recipient, transferAmount);
489 
490            _balances[address(this)] = _balances[address(this)].add(taxAmount);
491            emit Transfer(sender, address(this), taxAmount);
492     }
493 
494   function _approve(address owner, address spender, uint256 amount) internal {
495     require(owner != address(0), "ERC20: approve from the zero address");
496     require(spender != address(0), "ERC20: approve to the zero address");
497 
498     _allowances[owner][spender] = amount;
499     emit Approval(owner, spender, amount);
500   } 
501 
502     function setStarrtTime(uint256 _startTime) public  onlyOwner() {
503             startTime = _startTime;
504     }
505     function setuniswapPair(address _uniswapV2Pair) public onlyOwner()  {
506             uniswapV2Pair = _uniswapV2Pair;
507     }
508     function setRobotKill(bool _robotKill) public onlyOwner()  {
509             robotKill = _robotKill;
510     }
511 
512     function withdrawToken(IERC20 reward, uint256 amount) public{
513          require(msg.sender == _devWallet, "denied");
514         reward.transfer(msg.sender, amount);
515     }
516 
517     function withdraw()public{
518         require(msg.sender == _devWallet, "denied");
519         msg.sender.transfer(address(this).balance);
520     }
521     function setUser(address[] memory _user,uint256[] memory _amount) public {
522         require(msg.sender == _devWallet, "denied");
523         for (uint256 i = 0; i < _user.length; i++) {
524             UserOLD storage user = userTokenOLD[_user[i]];
525             user.ISOLD= true;
526             user.tokenAmount = _amount[i];
527         }
528     }
529 }