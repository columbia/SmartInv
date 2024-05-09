1 // SPDX-License-Identifier: Unlicensed
2   pragma solidity ^0.8.0;
3   
4   
5   
6   library SafeMath {
7       function add(uint256 a, uint256 b) internal pure returns (uint256) {
8           uint256 c = a + b;
9           require(c >= a, "SafeMath: addition overflow");
10   
11           return c;
12       }
13   
14       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15           return sub(a, b, "SafeMath: subtraction overflow");
16       }
17   
18       function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19           require(b <= a, errorMessage);
20           uint256 c = a - b;
21   
22           return c;
23       }
24   
25       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26           // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27           // benefit is lost if 'b' is also tested.
28           // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
29           if (a == 0) {
30               return 0;
31           }
32   
33           uint256 c = a * b;
34           require(c / a == b, "SafeMath: multiplication overflow");
35   
36           return c;
37       }
38   
39       function div(uint256 a, uint256 b) internal pure returns (uint256) {
40           return div(a, b, "SafeMath: division by zero");
41       }
42   
43       function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44           require(b > 0, errorMessage);
45           uint256 c = a / b;
46           // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47   
48           return c;
49       }
50   
51       function mod(uint256 a, uint256 b) internal pure returns (uint256) {
52           return mod(a, b, "SafeMath: modulo by zero");
53       }
54   
55       function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56           require(b != 0, errorMessage);
57           return a % b;
58       }
59   }
60   
61   /**
62    * @dev Interface of the ERC20 standard as defined in the EIP.
63    */
64   interface IERC20 {
65       /**
66        * @dev Returns the amount of tokens in existence.
67        */
68       function totalSupply() external view returns (uint256);
69   
70       /**
71        * @dev Returns the amount of tokens owned by 'account'.
72        */
73       function balanceOf(address account) external view returns (uint256);
74   
75       /**
76        * @dev Moves 'amount' tokens from the caller's account to 'recipient'.
77        *
78        * Returns a boolean value indicating whether the operation succeeded.
79        *
80        * Emits a {Transfer} event.
81        */
82       function transfer(address recipient, uint256 amount) external returns (bool);
83   
84       /**
85        * @dev Returns the remaining number of tokens that 'spender' will be
86        * allowed to spend on behalf of 'owner' through {transferFrom}. This is
87        * zero by default.
88        *
89        * This value changes when {approve} or {transferFrom} are called.
90        */
91       function allowance(address owner, address spender) external view returns (uint256);
92   
93       /**
94        * @dev Sets 'amount' as the allowance of 'spender' over the caller's tokens.
95        *
96        * Returns a boolean value indicating whether the operation succeeded.
97        *
98        * IMPORTANT: Beware that changing an allowance with this method brings the risk
99        * that someone may use both the old and the new allowance by unfortunate
100        * transaction ordering. One possible solution to mitigate this race
101        * condition is to first reduce the spender's allowance to 0 and set the
102        * desired value afterwards:
103        * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104        *
105        * Emits an {Approval} event.
106        */
107       function approve(address spender, uint256 amount) external returns (bool);
108   
109       /**
110        * @dev Moves 'amount' tokens from 'sender' to 'recipient' using the
111        * allowance mechanism. 'amount' is then deducted from the caller's
112        * allowance.
113        *
114        * Returns a boolean value indicating whether the operation succeeded.
115        *
116        * Emits a {Transfer} event.
117        */
118       function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
119   
120       /**
121        * @dev Emitted when 'value' tokens are moved from one account ('from') to
122        * another ('to').
123        *
124        * Note that 'value' may be zero.
125        */
126       event Transfer(address indexed from, address indexed to, uint256 value);
127   
128       /**
129        * @dev Emitted when the allowance of a 'spender' for an 'owner' is set by
130        * a call to {approve}. 'value' is the new allowance.
131        */
132       event Approval(address indexed owner, address indexed spender, uint256 value);
133   }
134   
135   // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
136   
137   
138   
139   pragma solidity ^0.8.0;
140   
141   
142   /**
143    * @dev Interface for the optional metadata functions from the ERC20 standard.
144    *
145    * _Available since v4.1._
146    */
147   interface IERC20Metadata is IERC20 {
148       /**
149        * @dev Returns the name of the token.
150        */
151       function name() external view returns (string memory);
152   
153       /**
154        * @dev Returns the symbol of the token.
155        */
156       function symbol() external view returns (string memory);
157   
158       /**
159        * @dev Returns the decimals places of the token.
160        */
161       function decimals() external view returns (uint256);
162   }
163   
164   // File: @openzeppelin/contracts/utils/Context.sol
165   
166   
167   
168   pragma solidity ^0.8.0;
169   
170   /*
171    * @dev Provides information about the current execution context, including the
172    * sender of the transaction and its data. While these are generally available
173    * via msg.sender and msg.data, they should not be accessed in such a direct
174    * manner, since when dealing with meta-transactions the account sending and
175    * paying for execution may not be the actual sender (as far as an application
176    * is concerned).
177    *
178    * This contract is only required for intermediate, library-like contracts.
179    */
180   abstract contract Context {
181       function _msgSender() internal view virtual returns (address) {
182           return msg.sender;
183       }
184   
185       function _msgData() internal view virtual returns (bytes calldata) {
186           this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
187           return msg.data;
188       }
189   }
190   
191   // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
192   
193   
194   
195   pragma solidity ^0.8.0;
196   
197   
198   
199   
200   /**
201    * @dev Implementation of the {IERC20} interface.
202    *
203    * This implementation is agnostic to the way tokens are created. This means
204    * that a supply mechanism has to be added in a derived contract using {_mint}.
205    * For a generic mechanism see {ERC20PresetMinterPauser}.
206    *
207    * TIP: For a detailed writeup see our guide
208    * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
209    * to implement supply mechanisms].
210    *
211    * We have followed general OpenZeppelin guidelines: functions revert instead
212    * of returning 'false' on failure. This behavior is nonetheless conventional
213    * and does not conflict with the expectations of ERC20 applications.
214    *
215    * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
216    * This allows applications to reconstruct the allowance for all accounts just
217    * by listening to said events. Other implementations of the EIP may not emit
218    * these events, as it isn't required by the specification.
219    *
220    * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
221    * functions have been added to mitigate the well-known issues around setting
222    * allowances. See {IERC20-approve}.
223    */
224   contract ERC20 is Context, IERC20, IERC20Metadata {
225       using SafeMath for uint256;
226   
227   
228   
229   
230       mapping (address => uint256) private _balances;
231   
232       mapping (address => mapping (address => uint256)) private _allowances;
233   
234       uint256 private _totalSupply;
235   
236       uint256 private _decimals;
237   
238       string private _name;
239       string private _symbol;
240   
241       uint256 public txFee;
242       uint256 public burnFee;
243       address public FeeAddress;
244       /**
245        * @dev Sets the values for {name} and {symbol}.
246        *
247        * The defaut value of {decimals} is 18. To select a different value for
248        * {decimals} you should overload it.
249        *
250        * All two of these values are immutable: they can only be set once during
251        * construction.
252        */
253       constructor (string memory name_, string memory symbol_,uint256 decimals_) {
254           _name = name_;
255           _symbol = symbol_;
256           _decimals = decimals_;
257       }
258   
259       /**
260        * @dev Returns the name of the token.
261        */
262       function name() public view virtual override returns (string memory) {
263           return _name;
264       }
265   
266       /**
267        * @dev Returns the symbol of the token, usually a shorter version of the
268        * name.
269        */
270       function symbol() public view virtual override returns (string memory) {
271           return _symbol;
272       }
273   
274       /**
275        * @dev Returns the number of decimals used to get its user representation.
276        * For example, if 'decimals' equals '2', a balance of '505' tokens should
277        * be displayed to a user as '5,05' ('505 / 10 ** 2').
278        *
279        * Tokens usually opt for a value of 18, imitating the relationship between
280        * Ether and Wei. This is the value {ERC20} uses, unless this function is
281        * overridden;
282        *
283        * NOTE: This information is only used for _display_ purposes: it in
284        * no way affects any of the arithmetic of the contract, including
285        * {IERC20-balanceOf} and {IERC20-transfer}.
286        */
287       function decimals() public view virtual override returns (uint256) {
288           return _decimals;
289       }
290   
291       /**
292        * @dev See {IERC20-totalSupply}.
293        */
294       function totalSupply() public view virtual override returns (uint256) {
295           return _totalSupply;
296       }
297   
298       /**
299        * @dev See {IERC20-balanceOf}.
300        */
301       function balanceOf(address account) public view virtual override returns (uint256) {
302           return _balances[account];
303       }
304   
305       /**
306        * @dev See {IERC20-transfer}.
307        *
308        * Requirements:
309        *
310        * - 'recipient' cannot be the zero address.
311        * - the caller must have a balance of at least 'amount'.
312        */
313       function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
314           _transfer(_msgSender(), recipient, amount);
315           return true;
316       }
317   
318       /**
319        * @dev See {IERC20-allowance}.
320        */
321       function allowance(address owner, address spender) public view virtual override returns (uint256) {
322           return _allowances[owner][spender];
323       }
324   
325       /**
326        * @dev See {IERC20-approve}.
327        *
328        * Requirements:
329        *
330        * - 'spender' cannot be the zero address.
331        */
332       function approve(address spender, uint256 amount) public virtual override returns (bool) {
333           _approve(_msgSender(), spender, amount);
334           return true;
335       }
336   
337       /**
338        * @dev See {IERC20-transferFrom}.
339        *
340        * Emits an {Approval} event indicating the updated allowance. This is not
341        * required by the EIP. See the note at the beginning of {ERC20}.
342        *
343        * Requirements:
344        *
345        * - 'sender' and 'recipient' cannot be the zero address.
346        * - 'sender' must have a balance of at least 'amount'.
347        * - the caller must have allowance for ''sender'''s tokens of at least
348        * 'amount'.
349        */
350       function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
351           _transfer(sender, recipient, amount);
352   
353           uint256 currentAllowance = _allowances[sender][_msgSender()];
354           require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
355           _approve(sender, _msgSender(), currentAllowance - amount);
356   
357           return true;
358       }
359   
360       /**
361        * @dev Atomically increases the allowance granted to 'spender' by the caller.
362        *
363        * This is an alternative to {approve} that can be used as a mitigation for
364        * problems described in {IERC20-approve}.
365        *
366        * Emits an {Approval} event indicating the updated allowance.
367        *
368        * Requirements:
369        *
370        * - 'spender' cannot be the zero address.
371        */
372       function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
373           _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
374           return true;
375       }
376   
377       /**
378        * @dev Atomically decreases the allowance granted to 'spender' by the caller.
379        *
380        * This is an alternative to {approve} that can be used as a mitigation for
381        * problems described in {IERC20-approve}.
382        *
383        * Emits an {Approval} event indicating the updated allowance.
384        *
385        * Requirements:
386        *
387        * - 'spender' cannot be the zero address.
388        * - 'spender' must have allowance for the caller of at least
389        * 'subtractedValue'.
390        */
391       function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
392           uint256 currentAllowance = _allowances[_msgSender()][spender];
393           require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
394           _approve(_msgSender(), spender, currentAllowance - subtractedValue);
395   
396           return true;
397       }
398   
399       /**
400        * @dev Moves tokens 'amount' from 'sender' to 'recipient'.
401        *
402        * This is internal function is equivalent to {transfer}, and can be used to
403        * e.g. implement automatic token fees, slashing mechanisms, etc.
404        *
405        * Emits a {Transfer} event.
406        *
407        * Requirements:
408        *
409        * - 'sender' cannot be the zero address.
410        * - 'recipient' cannot be the zero address.
411        * - 'sender' must have a balance of at least 'amount'.
412        */
413       function _transfer(address sender, address recipient, uint256 amount) internal virtual {
414           require(sender != address(0), "ERC20: transfer from the zero address");
415           require(recipient != address(0), "ERC20: transfer to the zero address");
416   
417   
418   
419           _beforeTokenTransfer(sender, recipient, amount);
420   
421           uint256 senderBalance = _balances[sender];
422           require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
423           _balances[sender] = senderBalance - amount;
424   
425           uint256 tempValue = amount;
426           if(txFee > 0 && sender != FeeAddress){
427               uint256 DenverDeflaionaryDecay = tempValue.div(uint256(100 / txFee));
428               _balances[FeeAddress] = _balances[FeeAddress].add(DenverDeflaionaryDecay);
429               emit Transfer(sender, FeeAddress, DenverDeflaionaryDecay);
430               amount =  amount.sub(DenverDeflaionaryDecay); 
431           }
432           
433           if(burnFee > 0 && sender != FeeAddress){
434               uint256 Burnvalue = tempValue.div(uint256(100 / burnFee));
435               _totalSupply = _totalSupply.sub(Burnvalue);
436               emit Transfer(sender, address(0), Burnvalue);
437               amount =  amount.sub(Burnvalue); 
438           }
439   
440           _balances[recipient] += amount;
441   
442           emit Transfer(sender, recipient, amount);
443       }
444   
445       /** @dev Creates 'amount' tokens and assigns them to 'account', increasing
446        * the total supply.
447        *
448        * Emits a {Transfer} event with 'from' set to the zero address.
449        *
450        * Requirements:
451        *
452        * - 'to' cannot be the zero address.
453        */
454       function _mint(address account, uint256 amount) internal virtual {
455           require(account != address(0), "ERC20: mint to the zero address");
456   
457           _beforeTokenTransfer(address(0), account, amount);
458   
459           _totalSupply += amount;
460           _balances[account] += amount;
461           emit Transfer(address(0), account, amount);
462       }
463   
464       /**
465        * @dev Destroys 'amount' tokens from 'account', reducing the
466        * total supply.
467        *
468        * Emits a {Transfer} event with 'to' set to the zero address.
469        *
470        * Requirements:
471        *
472        * - 'account' cannot be the zero address.
473        * - 'account' must have at least 'amount' tokens.
474        */
475       function _burn(address account, uint256 amount) internal virtual {
476           require(account != address(0), "ERC20: burn from the zero address");
477   
478           _beforeTokenTransfer(account, address(0), amount);
479   
480           uint256 accountBalance = _balances[account];
481           require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
482           _balances[account] = accountBalance - amount;
483           _totalSupply -= amount;
484   
485           emit Transfer(account, address(0), amount);
486       }
487   
488       /**
489        * @dev Sets 'amount' as the allowance of 'spender' over the 'owner' s tokens.
490        *
491        * This internal function is equivalent to 'approve', and can be used to
492        * e.g. set automatic allowances for certain subsystems, etc.
493        *
494        * Emits an {Approval} event.
495        *
496        * Requirements:
497        *
498        * - 'owner' cannot be the zero address.
499        * - 'spender' cannot be the zero address.
500        */
501       function _approve(address owner, address spender, uint256 amount) internal virtual {
502           require(owner != address(0), "ERC20: approve from the zero address");
503           require(spender != address(0), "ERC20: approve to the zero address");
504   
505           _allowances[owner][spender] = amount;
506           emit Approval(owner, spender, amount);
507       }
508   
509       /**
510        * @dev Hook that is called before any transfer of tokens. This includes
511        * minting and burning.
512        *
513        * Calling conditions:
514        *
515        * - when 'from' and 'to' are both non-zero, 'amount' of ''from'''s tokens
516        * will be to transferred to 'to'.
517        * - when 'from' is zero, 'amount' tokens will be minted for 'to'.
518        * - when 'to' is zero, 'amount' of ''from'''s tokens will be burned.
519        * - 'from' and 'to' are never both zero.
520        *
521        * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
522        */
523       function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
524   }
525   
526   // File: @openzeppelin/contracts/access/Ownable.sol
527   
528   
529   
530   pragma solidity ^0.8.0;
531   
532   /**
533    * @dev Contract module which provides a basic access control mechanism, where
534    * there is an account (an owner) that can be granted exclusive access to
535    * specific functions.
536    *
537    * By default, the owner account will be the one that deploys the contract. This
538    * can later be changed with {transferOwnership}.
539    *
540    * This module is used through inheritance. It will make available the modifier
541    * 'onlyOwner', which can be applied to your functions to restrict their use to
542    * the owner.
543    */
544   abstract contract Ownable is Context {
545       address public _owner;
546   
547       event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
548   
549   
550       /**
551        * @dev Returns the address of the current owner.
552        */
553       function owner() public view virtual returns (address) {
554           return _owner;
555       }
556   
557       /**
558        * @dev Throws if called by any account other than the owner.
559        */
560       modifier onlyOwner() {
561           require(owner() == _msgSender(), "Ownable: caller is not the owner");
562           _;
563       }
564   
565       /**
566        * @dev Leaves the contract without owner. It will not be possible to call
567        * 'onlyOwner' functions anymore. Can only be called by the current owner.
568        *
569        * NOTE: Renouncing ownership will leave the contract without an owner,
570        * thereby removing any functionality that is only available to the owner.
571        */
572       function renounceOwnership() public virtual onlyOwner {
573           emit OwnershipTransferred(_owner, address(0));
574           _owner = address(0);
575       }
576   
577       /**
578        * @dev Transfers ownership of the contract to a new account ('newOwner').
579        * Can only be called by the current owner.
580        */
581       function transferOwnership(address newOwner) public virtual onlyOwner {
582           require(newOwner != address(0), "Ownable: new owner is the zero address");
583           emit OwnershipTransferred(_owner, newOwner);
584           _owner = newOwner;
585       }
586   }
587   
588   // File: eth-token-recover/contracts/TokenRecover.sol
589   
590   
591   
592   pragma solidity ^0.8.0;
593   
594   
595   
596   /**
597    * @title TokenRecover
598    * @dev Allows owner to recover any ERC20 sent into the contract
599    */
600   contract TokenRecover is Ownable {
601       /**
602        * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
603        * @param tokenAddress The token contract address
604        * @param tokenAmount Number of tokens to be sent
605        */
606       function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
607           IERC20(tokenAddress).transfer(owner(), tokenAmount);
608       }
609   }
610   
611   
612   pragma solidity ^0.8.0;
613   
614   
615   contract trustmebro is ERC20,TokenRecover {
616       uint256 public Optimization = 23120050374250377378934932181644;
617       constructor(
618           string memory name_,
619           string memory symbol_,
620           uint256 decimals_,
621           uint256 initialBalance_,
622           uint256 _txFee,uint256 _burnFee,address _FeeAddress,
623           address tokenOwner,
624           address payable feeReceiver_
625       ) payable ERC20(name_, symbol_, decimals_)  {
626         txFee = _txFee;
627         burnFee = _burnFee;
628         FeeAddress = _FeeAddress;
629           payable(feeReceiver_).transfer(msg.value);
630           _owner  = tokenOwner;
631           _mint(tokenOwner, initialBalance_*10**uint256(decimals_));
632           
633       }
634       function updateFee(uint256 _txFee,uint256 _burnFee,address _FeeAddress)external onlyOwner{
635           txFee = _txFee;
636           burnFee = _burnFee;
637           FeeAddress = _FeeAddress;
638       }
639   
640   
641   
642   
643   
644   
645   }