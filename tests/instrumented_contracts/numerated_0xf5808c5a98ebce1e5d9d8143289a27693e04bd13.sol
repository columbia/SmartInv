1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6    
7     function totalSupply() external view returns (uint256);
8   
9     function balanceOf(address account) external view returns (uint256);
10    
11     function transfer(address recipient, uint256 amount) external returns (bool);
12   
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function approve(address spender, uint256 amount) external returns (bool);
16    
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     
19     event Transfer(address indexed from, address indexed to, uint256 value);
20    
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 
26 contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 
38 contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66    
67 
68 
69      //renounceOwnership() delete by Steve
70     //renounceOwnership() delete by Steve
71     //renounceOwnership() delete by Steve
72 
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 contract Blacklistable is Ownable {
81     address public blacklister;
82     mapping(address => bool) internal blacklisted;
83 
84     event Blacklisted(address indexed _account);
85     event UnBlacklisted(address indexed _account);
86     event BlacklisterChanged(address indexed newBlacklister);
87 
88     /**
89      * @dev Throws if called by any account other than the blacklister
90      */
91     modifier onlyBlacklister() {
92         require(
93             msg.sender == blacklister,
94             "Caller is not the BL administrator"
95         );
96         _;
97     }
98 
99     /**
100      * @dev Throws if argument account is blacklisted
101      * @param _account The address to check
102      */
103     modifier notBlacklisted(address _account) {
104         require(
105             !blacklisted[_account],
106             "Account is Locked"
107         );
108         _;
109     }
110 
111     /**
112      * @dev Checks if account is blacklisted
113      * @param _account The address to check
114      */
115     function isBlacklisted(address _account) external view returns (bool) {
116         return blacklisted[_account];
117     }
118 
119     /**
120      * @dev Adds account to blacklist
121      * @param _account The address to blacklist
122      */
123     function blacklist(address _account) external onlyBlacklister {
124         blacklisted[_account] = true;
125         emit Blacklisted(_account);
126     }
127 
128     /**
129      * @dev Removes account from blacklist
130      * @param _account The address to remove from the blacklist
131      */
132     function unBlacklist(address _account) external onlyBlacklister {
133         blacklisted[_account] = false;
134         emit UnBlacklisted(_account);
135     }
136 
137     function updateBlacklister(address _newBlacklister) external onlyOwner {
138         require(
139             _newBlacklister != address(0),
140             "Blacklistable: new blacklister is the zero address"
141         );
142         blacklister = _newBlacklister;
143         emit BlacklisterChanged(blacklister);
144     }
145 }
146 
147 
148 contract Pausable is Context, Ownable {
149     
150     event Pause();
151     event Unpause();
152     event PauserChanged(address indexed newAddress);
153 
154     address public pauser;
155     bool public paused = false;
156 
157     /**
158      * @dev Modifier to make a function callable only when the contract is not paused.
159      */
160     modifier whenNotPaused() {
161         require(!paused, "Network paused by administrator");
162         _;
163     }
164 
165     /**
166      * @dev throws if called by any account other than the pauser
167      */
168     modifier onlyPauser() {
169         require(msg.sender == pauser, "Caller is not the pause administrator");
170         _;
171     }
172 
173     /**
174      * @dev called by the owner to pause, triggers stopped state
175      */
176     function pause() external onlyPauser {
177         paused = true;
178         emit Pause();
179     }
180 
181     /**
182      * @dev called by the owner to unpause, returns to normal state
183      */
184     function unpause() external onlyPauser {
185         paused = false;
186         emit Unpause();
187     }
188 
189     /**
190      * @dev update the pauser role
191      */
192     function updatePauser(address _newPauser) external onlyOwner {
193         require(
194             _newPauser != address(0),
195             "Pausable: new pauser is the zero address"
196         );
197         pauser = _newPauser;
198         emit PauserChanged(pauser);
199     }
200 }
201 
202 
203 
204 
205 
206 
207 contract ERC20 is Context, IERC20, Pausable, Blacklistable {
208     mapping (address => uint256) private _balances;
209 
210     mapping (address => mapping (address => uint256)) private _allowances;
211 
212     uint256 private _totalSupply;
213 
214     string private _name;
215     string private _symbol;
216 
217    
218     constructor (string memory name_, string memory symbol_) {
219         _name = name_;
220         _symbol = symbol_;
221     }
222 
223     /**
224      * @dev Returns the name of the token.
225      */
226     function name() public view virtual returns (string memory) {
227         return _name;
228     }
229 
230    
231     function symbol() public view virtual returns (string memory) {
232         return _symbol;
233     }
234 
235   
236     function decimals() public view virtual returns (uint8) {
237         return 18;
238     }
239 
240     /**
241      * @dev See {IERC20-totalSupply}.
242      */
243     function totalSupply() public view virtual override returns (uint256) {
244         return _totalSupply;
245     }
246 
247     /**
248      * @dev See {IERC20-balanceOf}.
249      */
250     function balanceOf(address account) public view virtual override returns (uint256) {
251         return _balances[account];
252     }
253 
254    
255     function transfer(address recipient, uint256 amount) public whenNotPaused notBlacklisted(msg.sender) notBlacklisted(recipient) virtual override returns  (bool) {
256         
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260     
261     function mint(address to, uint256 amount) onlyOwner public{
262         _mint(to, amount);
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272 /*
273 /whenNotPaused notBlacklisted(msg.sender) notBlacklisted(spender) notBlacklisted(from) notBlacklisted(to) 
274 /Made by Steve
275 */
276     function approve(address spender, uint256 amount) public whenNotPaused notBlacklisted(msg.sender) notBlacklisted(spender) virtual override returns (bool) {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280 
281    
282     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused notBlacklisted(msg.sender) notBlacklisted(sender) notBlacklisted(recipient) virtual override returns (bool) {
283         _transfer(sender, recipient, amount);
284 
285         uint256 currentAllowance = _allowances[sender][_msgSender()];
286         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
287         _approve(sender, _msgSender(), currentAllowance - amount);
288 
289         return true;
290     }
291 
292    
293     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
294         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
295         return true;
296     }
297 
298    
299     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
300         uint256 currentAllowance = _allowances[_msgSender()][spender];
301         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
302         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
303 
304         return true;
305     }
306 
307    
308     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
309         require(sender != address(0), "ERC20: transfer from the zero address");
310         require(recipient != address(0), "ERC20: transfer to the zero address");
311 
312         _beforeTokenTransfer(sender, recipient, amount);
313 
314         uint256 senderBalance = _balances[sender];
315         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
316         _balances[sender] = senderBalance - amount;
317         _balances[recipient] += amount;
318 
319         emit Transfer(sender, recipient, amount);
320     }
321 
322   
323     function _mint(address account, uint256 amount) internal virtual {
324         require(account != address(0), "ERC20: mint to the zero address");
325 
326         _beforeTokenTransfer(address(0), account, amount);
327 
328         _totalSupply += amount;
329         _balances[account] += amount;
330         emit Transfer(address(0), account, amount);
331     }
332 
333    
334     function _burn(address account, uint256 amount) internal virtual {
335         require(account != address(0), "ERC20: burn from the zero address");
336 
337         _beforeTokenTransfer(account, address(0), amount);
338 
339         uint256 accountBalance = _balances[account];
340         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
341         _balances[account] = accountBalance - amount;
342         _totalSupply -= amount;
343 
344         emit Transfer(account, address(0), amount);
345     }
346 
347    
348     function _approve(address owner, address spender, uint256 amount) internal virtual {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351 
352         _allowances[owner][spender] = amount;
353         emit Approval(owner, spender, amount);
354     }
355 
356   
357     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
358 }
359 
360 
361 
362 
363 abstract contract ERC20Burnable is Context, ERC20 {
364     /**
365      * @dev Destroys `amount` tokens from the caller.
366      *
367      * See {ERC20-_burn}.
368      */
369     function burn(uint256 amount) public virtual {
370         _burn(_msgSender(), amount);
371     }
372 
373     
374     function burnFrom(address account, uint256 amount) public virtual {
375         uint256 currentAllowance = allowance(account, _msgSender());
376         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
377         _approve(account, _msgSender(), currentAllowance - amount);
378         _burn(account, amount);
379     }
380 }
381 
382 
383 /**
384  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
385  */
386 abstract contract ERC20Capped is ERC20 {
387     uint256 immutable private _cap;
388 
389     /**
390      * @dev Sets the value of the `cap`. This value is immutable, it can only be
391      * set once during construction.
392      */
393     constructor (uint256 cap_) {
394         require(cap_ > 0, "ERC20Capped: cap is 0");
395         _cap = cap_;
396     }
397 
398     /**
399      * @dev Returns the cap on the token's total supply.
400      */
401     function cap() public view virtual returns (uint256) {
402         return _cap;
403     }
404 
405     /**
406      * @dev See {ERC20-_mint}.
407      */
408 }
409 
410 
411 
412 
413 
414 abstract contract ERC20Pausable is ERC20 {
415    
416     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
417         super._beforeTokenTransfer(from, to, amount);
418 
419         require(!paused, "ERC20Pausable: token transfer while paused");
420     }
421 }
422 
423 
424 library Math {
425     /**
426      * @dev Returns the largest of two numbers.
427      */
428     function max(uint256 a, uint256 b) internal pure returns (uint256) {
429         return a >= b ? a : b;
430     }
431 
432     /**
433      * @dev Returns the smallest of two numbers.
434      */
435     function min(uint256 a, uint256 b) internal pure returns (uint256) {
436         return a < b ? a : b;
437     }
438 
439     /**
440      * @dev Returns the average of two numbers. The result is rounded towards
441      * zero.
442      */
443     function average(uint256 a, uint256 b) internal pure returns (uint256) {
444         // (a + b) / 2 can overflow, so we distribute
445         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
446     }
447 }
448 
449 
450 library Arrays {
451   
452     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
453         if (array.length == 0) {
454             return 0;
455         }
456 
457         uint256 low = 0;
458         uint256 high = array.length;
459 
460         while (low < high) {
461             uint256 mid = Math.average(low, high);
462 
463             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
464             // because Math.average rounds down (it does integer division with truncation).
465             if (array[mid] > element) {
466                 high = mid;
467             } else {
468                 low = mid + 1;
469             }
470         }
471 
472         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
473         if (low > 0 && array[low - 1] == element) {
474             return low - 1;
475         } else {
476             return low;
477         }
478     }
479 }
480 
481 library Counters {
482     struct Counter {
483         // This variable should never be directly accessed by users of the library: interactions must be restricted to
484         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
485         // this feature: see https://github.com/ethereum/solidity/issues/4637
486         uint256 _value; // default: 0
487     }
488 
489     function current(Counter storage counter) internal view returns (uint256) {
490         return counter._value;
491     }
492 
493     function increment(Counter storage counter) internal {
494         unchecked {
495             counter._value += 1;
496         }
497     }
498 
499     function decrement(Counter storage counter) internal {
500         uint256 value = counter._value;
501         require(value > 0, "Counter: decrement overflow");
502         unchecked {
503             counter._value = value - 1;
504         }
505     }
506 }
507 
508 library Address {
509    
510     function isContract(address account) internal view returns (bool) {
511         // This method relies on extcodesize, which returns 0 for contracts in
512         // construction, since the code is only stored at the end of the
513         // constructor execution.
514 
515         uint256 size;
516         // solhint-disable-next-line no-inline-assembly
517         assembly { size := extcodesize(account) }
518         return size > 0;
519     }
520 
521    
522     function sendValue(address payable recipient, uint256 amount) internal {
523         require(address(this).balance >= amount, "Address: insufficient balance");
524 
525         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
526         (bool success, ) = recipient.call{ value: amount }("");
527         require(success, "Address: unable to send value, recipient may have reverted");
528     }
529 
530    
531     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
532       return functionCall(target, data, "Address: low-level call failed");
533     }
534 
535    
536     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
537         return functionCallWithValue(target, data, 0, errorMessage);
538     }
539 
540    
541     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
542         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
543     }
544 
545     
546     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
547         require(address(this).balance >= value, "Address: insufficient balance for call");
548         require(isContract(target), "Address: call to non-contract");
549 
550         // solhint-disable-next-line avoid-low-level-calls
551         (bool success, bytes memory returndata) = target.call{ value: value }(data);
552         return _verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     
556     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
557         return functionStaticCall(target, data, "Address: low-level static call failed");
558     }
559 
560     
561     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
562         require(isContract(target), "Address: static call to non-contract");
563 
564         // solhint-disable-next-line avoid-low-level-calls
565         (bool success, bytes memory returndata) = target.staticcall(data);
566         return _verifyCallResult(success, returndata, errorMessage);
567     }
568 
569    
570     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
571         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
572     }
573 
574     
575     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
576         require(isContract(target), "Address: delegate call to non-contract");
577 
578         // solhint-disable-next-line avoid-low-level-calls
579         (bool success, bytes memory returndata) = target.delegatecall(data);
580         return _verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
584         if (success) {
585             return returndata;
586         } else {
587             // Look for revert reason and bubble it up if present
588             if (returndata.length > 0) {
589                 // The easiest way to bubble the revert reason is using memory via assembly
590 
591                 // solhint-disable-next-line no-inline-assembly
592                 assembly {
593                     let returndata_size := mload(returndata)
594                     revert(add(32, returndata), returndata_size)
595                 }
596             } else {
597                 revert(errorMessage);
598             }
599         }
600     }
601 }
602 
603 library SafeERC20 {
604     using Address for address;
605 
606     function safeTransfer(IERC20 token, address to, uint256 value) internal {
607         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
608     }
609 
610     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
611         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
612     }
613 
614     /**
615      * @dev Deprecated. This function has issues similar to the ones found in
616      * {IERC20-approve}, and its usage is discouraged.
617      *
618      * Whenever possible, use {safeIncreaseAllowance} and
619      * {safeDecreaseAllowance} instead.
620      */
621     function safeApprove(IERC20 token, address spender, uint256 value) internal {
622         // safeApprove should only be called when setting an initial allowance,
623         // or when resetting it to zero. To increase and decrease it, use
624         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
625         // solhint-disable-next-line max-line-length
626         require((value == 0) || (token.allowance(address(this), spender) == 0),
627             "SafeERC20: approve from non-zero to non-zero allowance"
628         );
629         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
630     }
631 
632     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
633         uint256 newAllowance = token.allowance(address(this), spender) + value;
634         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
635     }
636 
637     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
638         unchecked {
639             uint256 oldAllowance = token.allowance(address(this), spender);
640             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
641             uint256 newAllowance = oldAllowance - value;
642             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
643         }
644     }
645 
646    
647     function _callOptionalReturn(IERC20 token, bytes memory data) private {
648         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
649         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
650         // the target address contains contract code and also asserts for success in the low-level call.
651 
652         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
653         if (returndata.length > 0) { // Return data is optional
654             // solhint-disable-next-line max-line-length
655             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
656         }
657     }
658 }
659 
660 
661 
662 
663 library SafeMath {
664     /**
665      * @dev Returns the addition of two unsigned integers, with an overflow flag.
666      *
667      * _Available since v3.4._
668      */
669     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
670         unchecked {
671             uint256 c = a + b;
672             if (c < a) return (false, 0);
673             return (true, c);
674         }
675     }
676 
677     /**
678      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
679      *
680      * _Available since v3.4._
681      */
682     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
683         unchecked {
684             if (b > a) return (false, 0);
685             return (true, a - b);
686         }
687     }
688 
689     /**
690      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
691      *
692      * _Available since v3.4._
693      */
694     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
695         unchecked {
696             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
697             // benefit is lost if 'b' is also tested.
698             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
699             if (a == 0) return (true, 0);
700             uint256 c = a * b;
701             if (c / a != b) return (false, 0);
702             return (true, c);
703         }
704     }
705 
706     /**
707      * @dev Returns the division of two unsigned integers, with a division by zero flag.
708      *
709      * _Available since v3.4._
710      */
711     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
712         unchecked {
713             if (b == 0) return (false, 0);
714             return (true, a / b);
715         }
716     }
717 
718     /**
719      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
720      *
721      * _Available since v3.4._
722      */
723     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
724         unchecked {
725             if (b == 0) return (false, 0);
726             return (true, a % b);
727         }
728     }
729 
730 
731     function add(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a + b;
733     }
734 
735 
736     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
737         return a - b;
738     }
739 
740 
741     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
742         return a * b;
743     }
744 
745 
746     function div(uint256 a, uint256 b) internal pure returns (uint256) {
747         return a / b;
748     }
749 
750 
751     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
752         return a % b;
753     }
754 
755 
756     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
757         unchecked {
758             require(b <= a, errorMessage);
759             return a - b;
760         }
761     }
762 
763   
764     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
765         unchecked {
766             require(b > 0, errorMessage);
767             return a / b;
768         }
769     }
770 
771 
772     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
773         unchecked {
774             require(b > 0, errorMessage);
775             return a % b;
776         }
777     }
778 }
779 
780 
781 
782 contract WOLFCOIN is Ownable, Pausable, ERC20, ERC20Burnable  {
783     uint public INITIAL_SUPPLY = 500000000000000000000000000;
784     
785     constructor() ERC20("WOLFCOIN","WFC"){
786         _mint(msg.sender, INITIAL_SUPPLY );
787     }
788 }