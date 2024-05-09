1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/access/Roles.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @title Roles
37  * @dev Library for managing addresses assigned to a Role.
38  */
39 library Roles {
40     struct Role {
41         mapping (address => bool) bearer;
42     }
43 
44     /**
45      * @dev Give an account access to this role.
46      */
47     function add(Role storage role, address account) internal {
48         require(!has(role, account), "Roles: account already has role");
49         role.bearer[account] = true;
50     }
51 
52     /**
53      * @dev Remove an account's access to this role.
54      */
55     function remove(Role storage role, address account) internal {
56         require(has(role, account), "Roles: account does not have role");
57         role.bearer[account] = false;
58     }
59 
60     /**
61      * @dev Check if an account has this role.
62      * @return bool
63      */
64     function has(Role storage role, address account) internal view returns (bool) {
65         require(account != address(0), "Roles: account is the zero address");
66         return role.bearer[account];
67     }
68 }
69 
70 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
71 
72 pragma solidity ^0.5.0;
73 
74 
75 
76 contract MinterRole is Context {
77     using Roles for Roles.Role;
78 
79     event MinterAdded(address indexed account);
80     event MinterRemoved(address indexed account);
81 
82     Roles.Role private _minters;
83 
84     constructor () internal {
85         _addMinter(_msgSender());
86     }
87 
88     modifier onlyMinter() {
89         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
90         _;
91     }
92 
93     function isMinter(address account) public view returns (bool) {
94         return _minters.has(account);
95     }
96 
97     function addMinter(address account) public onlyMinter {
98         _addMinter(account);
99     }
100 
101     function renounceMinter() public {
102         _removeMinter(_msgSender());
103     }
104 
105     function _addMinter(address account) internal {
106         _minters.add(account);
107         emit MinterAdded(account);
108     }
109 
110     function _removeMinter(address account) internal {
111         _minters.remove(account);
112         emit MinterRemoved(account);
113     }
114 }
115 
116 // File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol
117 
118 pragma solidity ^0.5.0;
119 
120 
121 
122 /**
123  * @title WhitelistAdminRole
124  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
125  */
126 contract WhitelistAdminRole is Context {
127     using Roles for Roles.Role;
128 
129     event WhitelistAdminAdded(address indexed account);
130     event WhitelistAdminRemoved(address indexed account);
131 
132     Roles.Role private _whitelistAdmins;
133 
134     constructor () internal {
135         _addWhitelistAdmin(_msgSender());
136     }
137 
138     modifier onlyWhitelistAdmin() {
139         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
140         _;
141     }
142 
143     function isWhitelistAdmin(address account) public view returns (bool) {
144         return _whitelistAdmins.has(account);
145     }
146 
147     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
148         _addWhitelistAdmin(account);
149     }
150 
151     function renounceWhitelistAdmin() public {
152         _removeWhitelistAdmin(_msgSender());
153     }
154 
155     function _addWhitelistAdmin(address account) internal {
156         _whitelistAdmins.add(account);
157         emit WhitelistAdminAdded(account);
158     }
159 
160     function _removeWhitelistAdmin(address account) internal {
161         _whitelistAdmins.remove(account);
162         emit WhitelistAdminRemoved(account);
163     }
164 }
165 
166 // File: @openzeppelin/contracts/math/SafeMath.sol
167 
168 pragma solidity ^0.5.0;
169 
170 /**
171  * @dev Wrappers over Solidity's arithmetic operations with added overflow
172  * checks.
173  *
174  * Arithmetic operations in Solidity wrap on overflow. This can easily result
175  * in bugs, because programmers usually assume that an overflow raises an
176  * error, which is the standard behavior in high level programming languages.
177  * `SafeMath` restores this intuition by reverting the transaction when an
178  * operation overflows.
179  *
180  * Using this library instead of the unchecked operations eliminates an entire
181  * class of bugs, so it's recommended to use it always.
182  */
183 library SafeMath {
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return sub(a, b, "SafeMath: subtraction overflow");
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      * - Subtraction cannot overflow.
221      *
222      * _Available since v2.4.0._
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      * - Multiplication cannot overflow.
239      */
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242         // benefit is lost if 'b' is also tested.
243         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         return div(a, b, "SafeMath: division by zero");
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      *
280      * _Available since v2.4.0._
281      */
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         // Solidity only automatically asserts when dividing by 0
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return mod(a, b, "SafeMath: modulo by zero");
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts with custom message when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      *
317      * _Available since v2.4.0._
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // File: contracts/AquaToken.sol
326 
327 pragma solidity ^0.5.17;
328 
329 
330 
331 
332 contract AquaToken is
333     MinterRole,
334     WhitelistAdminRole
335 {
336     using SafeMath for uint256;
337 
338     mapping (address => uint256) private _wOwned;
339     mapping (address => mapping (address => uint256)) private _allowances;
340 
341     uint256 private constant MAX = ~uint256(0);
342     // denotes display total (aqua)
343     uint256 private _aTotal = 0;
344     // denotes actual total (waves)
345     uint256 private _wTotal = 0;
346     // display total fees
347     uint256 private _aFeeTotal;
348 
349     address public fountainAddress;
350     address public uniswapPairAddress;
351     address public crowdsaleWallet;
352     // tax divisor - 25 => 4% (100/25)
353     uint256 public taxDivisor = 25;
354 
355     string private _name;
356     string private _symbol;
357     uint8 private _decimals;
358 
359     bool public tokenPaused;
360     mapping (address => bool) public pauseWhitelist;
361 
362     event Transfer(address indexed from, address indexed to, uint256 value);
363     event Approval(address indexed owner, address indexed spender, uint256 value);
364     event RewardLiquidityProviders(uint256 value);
365 
366     constructor (string memory name, string memory symbol, uint8 decimals) public {
367         _name = name;
368         _symbol = symbol;
369         _decimals = decimals;
370         pauseWhitelist[_msgSender()] = true;
371         // enable token pause to avoid frontrunning lp listing, once LP is listed, we destroy the usage of tokenPaused
372         tokenPaused = true;
373     }
374 
375     function name() public view returns (string memory) {
376         return _name;
377     }
378 
379     function symbol() public view returns (string memory) {
380         return _symbol;
381     }
382 
383     function decimals() public view returns (uint8) {
384         return _decimals;
385     }
386 
387     function setTokenPaused(bool paused) external onlyWhitelistAdmin {
388         require(paused == false, "AquaToken::setTokenPaused: you can only unpause the token");
389         tokenPaused = paused;
390     }
391 
392     function setTaxDivisor(uint256 _taxDivisor) public onlyWhitelistAdmin {
393         require(_taxDivisor == 0 || _taxDivisor >= 10, "AquaToken::setTaxDivisor: too small");
394         taxDivisor = _taxDivisor;
395     }
396 
397     function setUniswapPair(address _uniswapPairAddress) public onlyWhitelistAdmin {
398         uniswapPairAddress = _uniswapPairAddress;
399     }
400 
401     function setFountainAddress(address _fountainAddress) public onlyWhitelistAdmin {
402         fountainAddress = _fountainAddress;
403     }
404 
405     function rewardLiquidityProviders() external {
406         require(balanceOf(address(this)) > 0, "Transfer amount must be greater than zero");
407         require(balanceOf(address(_msgSender())) > 0, "You must be an account holder to call this function");
408 
409         uint256 originalBalance = balanceOf(address(this));
410 
411         uint256 uniswapPairAmount = originalBalance.mul(475).div(575); // ~83%
412         uint256 fountainPairAmount = originalBalance.mul(72).div(575); // ~12%
413         uint256 userRewardAmount = originalBalance.mul(28).div(575); // ~5%
414 
415 
416         _transferStandard(address(this), uniswapPairAddress, uniswapPairAmount);
417         IUniswapV2Pair(uniswapPairAddress).sync();
418 
419         _transferStandard(address(this), fountainAddress, fountainPairAmount);
420         IUniswapV2Pair(fountainAddress).sync();
421 
422         _transferStandard(address(this), _msgSender(), userRewardAmount);
423 
424         emit RewardLiquidityProviders(originalBalance);
425     }
426 
427     function totalSupply() public view returns (uint256) {
428         // since we burn tokens, return supply - current burn balance
429         return _aTotal.sub(balanceOf(address(0)));
430     }
431 
432     // display only
433     function totalFees() public view returns (uint256) {
434         return _aFeeTotal;
435     }
436 
437     function balanceOf(address account) public view returns (uint256) {
438         require(_wOwned[account] <= _wTotal, "Amount must be less than total waves");
439         uint256 currentRate =  _getRate();
440         return _wOwned[account].div(currentRate);
441     }
442 
443     function transfer(address recipient, uint256 amount) public returns (bool) {
444         _transfer(_msgSender(), recipient, amount);
445         return true;
446     }
447 
448     function allowance(address owner, address spender) public view returns (uint256) {
449         return _allowances[owner][spender];
450     }
451 
452     function approve(address spender, uint256 amount) public returns (bool) {
453         _approve(_msgSender(), spender, amount);
454         return true;
455     }
456 
457     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
458         _transfer(sender, recipient, amount);
459         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
460         return true;
461     }
462 
463     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
465         return true;
466     }
467 
468     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
469         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
470         return true;
471     }
472 
473     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
474         _mint(account, amount);
475         return true;
476     }
477 
478     function _transfer(address from, address to, uint256 amount) internal {
479         require(from != address(0), "ERC20: transfer from the zero address");
480         require(to != address(0), "ERC20: transfer to the zero address");
481         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
482         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
483         require(pauseWhitelist[from] == true || tokenPaused == false, "ERC20: Token is currently paused");
484 
485         // disable tax for whitelisters (crowdsale and treasury)
486         if (taxDivisor != 0 && pauseWhitelist[from] == false) {
487             uint256 taxAmount = amount.div(taxDivisor);
488 
489             uint256 uniswapPairAmount = taxAmount.mul(500).div(1000); // 50%
490             uint256 fountainAmount = taxAmount.mul(75).div(1000); // 7.5%
491             uint256 burnedAmount = taxAmount.mul(250).div(1000);  // 25%
492             uint256 holdersAmount = taxAmount.mul(175).div(1000); // 17.5%
493 
494             require(fountainAmount.add(uniswapPairAmount).add(burnedAmount).add(holdersAmount) == taxAmount, "ERC20Transfer::taxTransfer: Math is broken");
495             _transferStandard(from, address(this), uniswapPairAmount.add(fountainAmount));
496             _transferStandard(from, address(0), burnedAmount);
497             _transferStandard(from, to, amount.sub(taxAmount));
498 
499             _distributeFee(from, holdersAmount);
500         }
501         else {
502             _transferStandard(from, to, amount);
503         }
504     }
505 
506     function _transferStandard(address sender, address recipient, uint256 amount) private {
507         uint256 currentRate =  _getRate();
508 
509         uint256 rAmount = amount.mul(currentRate);
510         _wOwned[sender] = _wOwned[sender].sub(rAmount);
511         _wOwned[recipient] = _wOwned[recipient].add(rAmount);
512 
513         emit Transfer(sender, recipient, amount);
514     }
515 
516     function _distributeFee(address sender, uint256 aFee) private {
517         uint256 currentRate =  _getRate();
518 
519         uint256 wFee = aFee.mul(currentRate);
520         _wOwned[sender] = _wOwned[sender].sub(wFee);
521 
522         _wTotal = _wTotal.sub(wFee);
523         _aFeeTotal = _aFeeTotal.add(aFee);
524 
525         emit Transfer(sender, address(0), aFee);
526     }
527 
528     function _getRate() private view returns(uint256) {
529         return _wTotal.div(_aTotal);
530     }
531 
532     function _mint(address account, uint256 amount) internal {
533         require(account != address(0), "ERC20: mint to the zero address");
534         require(amount > 0, "ERC20: mint amount is zero");
535         _aTotal = _aTotal.add(amount);
536         _wTotal = (MAX - (MAX % _aTotal));
537 
538         // only have 1 minter, they will have the entire supply
539         _wOwned[account] = _wTotal;
540 
541         // we can only mint with the crowdsale wallet, set it here
542         crowdsaleWallet = account;
543 
544         pauseWhitelist[account] = true;
545 
546         emit Transfer(address(0), account, amount);
547     }
548 
549     function _approve(address owner, address spender, uint256 amount) private {
550         require(owner != address(0), "ERC20: approve from the zero address");
551         require(spender != address(0), "ERC20: approve to the zero address");
552 
553         _allowances[owner][spender] = amount;
554         emit Approval(owner, spender, amount);
555     }
556 }
557 
558 interface IUniswapV2Pair {
559     function sync() external;
560 }