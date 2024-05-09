1 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see ERC20Detailed.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by account.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves amount tokens from the caller's account to recipient.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a Transfer event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that spender will be
31      * allowed to spend on behalf of owner through transferFrom. This is
32      * zero by default.
33      *
34      * This value changes when approve or transferFrom are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets amount as the allowance of spender over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49 
50      *
51      * Emits an Approval event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves amount tokens from sender to recipient using the
57      * allowance mechanism. amount is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a Transfer event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when value tokens are moved from one account (from) to
68      * another (to).
69      *
70      * Note that value may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a spender for an owner is set by
76      * a call to approve. value is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
82 
83 pragma solidity ^0.5.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * SafeMath restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's + operator.
104      *
105      * Requirements:
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's - operator.
120      *
121      * Requirements:
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         require(b <= a, "SafeMath: subtraction overflow");
126         uint256 c = a - b;
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the multiplication of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's * operator.
136      *
137      * Requirements:
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
144 
145         if (a == 0) {
146             return 0;
147         }
148 
149         uint256 c = a * b;
150         require(c / a == b, "SafeMath: multiplication overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers. Reverts on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's / operator. Note: this function uses a
160      * revert opcode (which leaves remaining gas untouched) while Solidity
161      * uses an invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Solidity only automatically asserts when dividing by 0
168         require(b > 0, "SafeMath: division by zero");
169         uint256 c = a / b;
170         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
177      * Reverts when dividing by zero.
178      *
179      * Counterpart to Solidity's % operator. This function uses a revert
180      * opcode (which leaves remaining gas untouched) while Solidity uses an
181      * invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      */
186     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b != 0, "SafeMath: modulo by zero");
188         return a % b;
189     }
190 }
191 
192 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
193 
194 pragma solidity ^0.5.0;
195 
196 
197 
198 /**
199  * @dev Implementation of the IERC20 interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using _mint.
203  * For a generic mechanism see ERC20Mintable.
204  *
205  * *For a detailed writeup see our guide [How to implement supply
206  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226
207 ).*
208  *
209  * We have followed general OpenZeppelin guidelines: functions revert instead
210  * of returning false on failure. This behavior is nonetheless conventional
211  * and does not conflict with the expectations of ERC20 applications.
212  *
213  * Additionally, an Approval event is emitted on calls to transferFrom.
214  * This allows applications to reconstruct the allowance for all accounts just
215  * by listening to said events. Other implementations of the EIP may not emit
216  * these events, as it isn't required by the specification.
217  *
218  * Finally, the non-standard decreaseAllowance and increaseAllowance
219  * functions have been added to mitigate the well-known issues around setting
220  * allowances. See IERC20.approve.
221  */
222 contract ERC20 is IERC20 {
223     using SafeMath for uint256;
224 
225     mapping (address => uint256) private _balances;
226 
227     mapping (address => mapping (address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     /**
232      * @dev See IERC20.totalSupply.
233      */
234     function totalSupply() public view returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239      * @dev See IERC20.balanceOf.
240      */
241     function balanceOf(address account) public view returns (uint256) {
242         return _balances[account];
243     }
244 
245     /**
246      * @dev See IERC20.transfer.
247      *
248      * Requirements:
249      *
250      * - recipient cannot be the zero address.
251      * - the caller must have a balance of at least amount.
252      */
253     function transfer(address recipient, uint256 amount) public returns (bool) {
254         _transfer(msg.sender, recipient, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See IERC20.allowance.
260      */
261     function allowance(address owner, address spender) public view returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See IERC20.approve.
267      *
268      * Requirements:
269      *
270      * - spender cannot be the zero address.
271      */
272     function approve(address spender, uint256 value) public returns (bool) {
273         _approve(msg.sender, spender, value);
274         return true;
275     }
276 
277     /**
278      * @dev See IERC20.transferFrom.
279      *
280      * Emits an Approval event indicating the updated allowance. This is not
281      * required by the EIP. See the note at the beginning of ERC20;
282      *
283      * Requirements:
284      * - sender and recipient cannot be the zero address.
285      * - sender must have a balance of at least value.
286      * - the caller must have allowance for sender's tokens of at least
287      * amount.
288      */
289     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to spender by the caller.
297      *
298      * This is an alternative to approve that can be used as a mitigation for
299      * problems described in IERC20.approve.
300      *
301      * Emits an Approval event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - spender cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
308         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to spender by the caller.
314      *
315      * This is an alternative to approve that can be used as a mitigation for
316      * problems described in IERC20.approve.
317      *
318      * Emits an Approval event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - spender cannot be the zero address.
323      * - spender must have allowance for the caller of at least
324      * subtractedValue.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
327         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
328         return true;
329     }
330 
331     /**
332      * @dev Moves tokens amount from sender to recipient.
333      *
334      * This is internal function is equivalent to transfer, and can be used to
335      * e.g. implement automatic token fees, slashing mechanisms, etc.
336      *
337      * Emits a Transfer event.
338      *
339      * Requirements:
340      *
341      * - sender cannot be the zero address.
342      * - recipient cannot be the zero address.
343      * - sender must have a balance of at least amount.
344      */
345     function _transfer(address sender, address recipient, uint256 amount) internal {
346         require(sender != address(0), "ERC20: transfer from the zero address");
347         require(recipient != address(0), "ERC20: transfer to the zero address");
348 
349         _balances[sender] = _balances[sender].sub(amount);
350         _balances[recipient] = _balances[recipient].add(amount);
351         emit Transfer(sender, recipient, amount);
352     }
353 
354     /** @dev Creates amount tokens and assigns them to account, increasing
355      * the total supply.
356      *
357      * Emits a Transfer event with from set to the zero address.
358      *
359      * Requirements
360      *
361      * - to cannot be the zero address.
362      */
363     function _mint(address account, uint256 amount) internal {
364         require(account != address(0), "ERC20: mint to the zero address");
365 
366         _totalSupply = _totalSupply.add(amount);
367         _balances[account] = _balances[account].add(amount);
368         emit Transfer(address(0), account, amount);
369     }
370 
371      /**
372      * @dev Destroys amount tokens from account, reducing the
373      * total supply.
374      *
375      * Emits a Transfer event with to set to the zero address.
376      *
377      * Requirements
378      *
379      * - account cannot be the zero address.
380      * - account must have at least amount tokens.
381      */
382     function _burn(address account, uint256 value) internal {
383         require(account != address(0), "ERC20: burn from the zero address");
384 
385         _totalSupply = _totalSupply.sub(value);
386         _balances[account] = _balances[account].sub(value);
387         emit Transfer(account, address(0), value);
388     }
389 
390     /**
391      * @dev Sets amount as the allowance of spender over the owners tokens.
392      *
393      * This is internal function is equivalent to approve, and can be used to
394      * e.g. set automatic allowances for certain subsystems, etc.
395      *
396      * Emits an Approval event.
397      *
398      * Requirements:
399      *
400      * - owner cannot be the zero address.
401      * - spender cannot be the zero address.
402      */
403     function _approve(address owner, address spender, uint256 value) internal {
404         require(owner != address(0), "ERC20: approve from the zero address");
405         require(spender != address(0), "ERC20: approve to the zero address");
406 
407         _allowances[owner][spender] = value;
408         emit Approval(owner, spender, value);
409     }
410 
411     /**
412      * @dev Destoys amount tokens from account.`amount` is then deducted
413      * from the caller's allowance.
414      *
415      * See _burn and _approve.
416      */
417     function _burnFrom(address account, uint256 amount) internal {
418         _burn(account, amount);
419         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
420     }
421 }
422 
423 // File: contracts\ERC20\TokenMintERC20Token.sol
424 
425 pragma solidity ^0.5.0;
426 
427 contract Bethero is ERC20 {
428 
429     string private _name;
430     string private _symbol;
431     uint8 private _decimals;
432     address payable _tokenOwnerAddress;
433     uint256 public priceInWei = 25000000000000;
434     uint256 private _decs;
435     uint256 private _issued = 0;
436     bool private uniswapLocked = true;
437     bool private auditsLocked  = true;
438     bool private teamLocked = true;
439     uint256 public marketing = 0;
440     bool public minting = true;
441     
442     /**
443      * @dev Constructor.
444      * @param name name of the token
445      * @param symbol symbol of the token, 3-4 chars is recommended
446      * @param decimals number of decimal places of one token unit, 18 is widely used
447      */
448     constructor(string memory name, string memory symbol, uint8 decimals) public  {
449       _name = name;
450       _symbol = symbol;
451       _decimals = decimals;
452       _tokenOwnerAddress = msg.sender;
453       _decs = 10**uint256(decimals);
454       // set tokenOwnerAddress as owner of all tokens
455       _mint(msg.sender, (15500000 * _decs ) );
456       _mint(address(this), (49500000 * _decs ) );
457     }
458 
459 
460     /**
461      * @dev Burns a specific amount of tokens.
462      * @param value The amount of lowest token units to be burned.
463      */
464     function burn(uint256 value) public {
465       _burn(msg.sender, value);
466     }
467 
468     // optional functions from ERC20 stardard
469 
470     /**
471      * @return the name of the token.
472      */
473     function name() public view returns (string memory) {
474       return _name;
475     }
476 
477     /**
478      * @return the symbol of the token.
479      */
480     function symbol() public view returns (string memory) {
481       return _symbol;
482     }
483 
484     /**
485      * @return the number of decimals of the token.
486      */
487     function decimals() public view returns (uint8) {
488       return _decimals;
489     }
490     
491     /**
492      * @return the owner of the token.
493      */
494     function getOwner() public view returns (address payable) {
495       return _tokenOwnerAddress;
496     }
497     
498      /**
499      * @dev ends the ico forever. 
500      * @return bool.
501      */
502     function endIco() public returns (bool) {
503       require(msg.sender==_tokenOwnerAddress, "Only owner can call this");
504       require(minting == true, "Ico is already ended");
505       minting = false;
506       return true;
507     }
508     
509     /**
510      * @dev Unlock the uniswapliquidity.
511      * @return bool..
512      */
513     function unlockUniswapLiq() public returns (bool) {
514       require(msg.sender==_tokenOwnerAddress, "Only owner can call this");
515       require(uniswapLocked == true, "Already unlocked.");
516       _burn(address(this), (35000000 * _decs ));
517       _mint(_tokenOwnerAddress, (35000000 * _decs ));
518       uniswapLocked = false;
519       return true;
520     }
521  
522    /**
523      * @dev Unlock the audits funds.
524      * @return bool.
525      */
526    function unlockAudits() public  returns (bool) {
527       require(msg.sender==_tokenOwnerAddress, "Only owner can call this");
528       require( auditsLocked == true, "Already unlocked.");
529       _burn(address(this), (1000000 * _decs ));
530       _mint(_tokenOwnerAddress, (1000000 * _decs ));
531       auditsLocked = false;
532       return true;
533     }
534     
535     /**
536      * @dev Unlock 500k for marketing each time called, until the whole 11,500,000 is spent.
537      * @return bool..
538      */
539     function unlockMarketing() public returns (bool) {
540       require(msg.sender ==_tokenOwnerAddress, "Only owner can call this");
541       require( marketing < 23 , "Already unlocked.");
542       _burn(address(this), (500000 * _decs ));
543       _mint(_tokenOwnerAddress, (500000 * _decs ));
544       marketing++;
545       return true;
546     }
547  
548     /**
549      * @dev Unlock the 2,000,000 to the team members after 1 year from contract deployment.
550      * @return bool..
551      */
552     function unlockTeamFunds() public returns (bool) {
553       require(msg.sender ==_tokenOwnerAddress, "Only owner can call this");
554       require(block.timestamp > 1631664061, 'Wait until 15/9/2021');
555       require( teamLocked==true , "Already unlocked.");
556       _burn(address(this), (2000000 * _decs ));
557       _mint(_tokenOwnerAddress, (2000000 * _decs ));
558       teamLocked = false;
559       return true;
560     }
561  
562     
563     /**
564      * @dev This function is used in the ico.
565      * @return bool..
566      */
567     function mint() public payable returns (bool) {
568         require(minting == true, "Ico ended.");
569         uint256 amountToMint = ( msg.value.div(priceInWei)) * _decs;
570         require( (amountToMint + _issued) <= (35000000 * _decs) , "Max supply is 100 Million.");
571         _issued += amountToMint;
572         _mint(msg.sender, amountToMint);
573         return true;
574     }
575    
576    
577    /**
578      * @dev Withdraw Eth balance collected in the ico to the owner's address.
579      */    
580    function withdraw() public  {
581     require(msg.sender==_tokenOwnerAddress, "Only owner can call this");
582     _tokenOwnerAddress.transfer(address(this).balance);
583    }   
584     
585     
586 }