1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
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
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () internal {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(isOwner(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Returns true if the caller is the current owner.
71      */
72     function isOwner() public view returns (bool) {
73         return _msgSender() == _owner;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      */
99     function _transferOwnership(address newOwner) internal {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
108  * the optional functions; to access them see {ERC20Detailed}.
109  */
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 /**
182  * @dev Wrappers over Solidity's arithmetic operations with added overflow
183  * checks.
184  *
185  * Arithmetic operations in Solidity wrap on overflow. This can easily result
186  * in bugs, because programmers usually assume that an overflow raises an
187  * error, which is the standard behavior in high level programming languages.
188  * `SafeMath` restores this intuition by reverting the transaction when an
189  * operation overflows.
190  *
191  * Using this library instead of the unchecked operations eliminates an entire
192  * class of bugs, so it's recommended to use it always.
193  */
194 library SafeMath {
195     /**
196      * @dev Returns the addition of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `+` operator.
200      *
201      * Requirements:
202      * - Addition cannot overflow.
203      */
204     function add(uint256 a, uint256 b) internal pure returns (uint256) {
205         uint256 c = a + b;
206         require(c >= a, "SafeMath: addition overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting on
213      * overflow (when the result is negative).
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      * - Subtraction cannot overflow.
219      */
220     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
221         return sub(a, b, "SafeMath: subtraction overflow");
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
226      * overflow (when the result is negative).
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      * - Subtraction cannot overflow.
232      *
233      * _Available since v2.4.0._
234      */
235     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b <= a, errorMessage);
237         uint256 c = a - b;
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the multiplication of two unsigned integers, reverting on
244      * overflow.
245      *
246      * Counterpart to Solidity's `*` operator.
247      *
248      * Requirements:
249      * - Multiplication cannot overflow.
250      */
251     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
253         // benefit is lost if 'b' is also tested.
254         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
255         if (a == 0) {
256             return 0;
257         }
258 
259         uint256 c = a * b;
260         require(c / a == b, "SafeMath: multiplication overflow");
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers. Reverts on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      * - The divisor cannot be zero.
275      */
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         return div(a, b, "SafeMath: division by zero");
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
282      * division by zero. The result is rounded towards zero.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      * - The divisor cannot be zero.
290      *
291      * _Available since v2.4.0._
292      */
293     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         // Solidity only automatically asserts when dividing by 0
295         require(b > 0, errorMessage);
296         uint256 c = a / b;
297         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * Reverts when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         return mod(a, b, "SafeMath: modulo by zero");
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * Reverts with custom message when dividing by zero.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      * - The divisor cannot be zero.
327      *
328      * _Available since v2.4.0._
329      */
330     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
331         require(b != 0, errorMessage);
332         return a % b;
333     }
334 }
335 
336 /**
337  * @dev Implementation of the {IERC20} interface.
338  *
339  * This implementation is agnostic to the way tokens are created. This means
340  * that a supply mechanism has to be added in a derived contract using {_mint}.
341  * For a generic mechanism see {ERC20Mintable}.
342  *
343  * TIP: For a detailed writeup see our guide
344  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
345  * to implement supply mechanisms].
346  *
347  * We have followed general OpenZeppelin guidelines: functions revert instead
348  * of returning `false` on failure. This behavior is nonetheless conventional
349  * and does not conflict with the expectations of ERC20 applications.
350  *
351  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
352  * This allows applications to reconstruct the allowance for all accounts just
353  * by listening to said events. Other implementations of the EIP may not emit
354  * these events, as it isn't required by the specification.
355  *
356  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
357  * functions have been added to mitigate the well-known issues around setting
358  * allowances. See {IERC20-approve}.
359  */
360 contract ERC20 is Context, IERC20 {
361     using SafeMath for uint256;
362 
363     mapping (address => uint256) private _balances;
364 
365     mapping (address => mapping (address => uint256)) private _allowances;
366 
367     uint256 private _totalSupply;
368 
369     /**
370      * @dev See {IERC20-totalSupply}.
371      */
372     function totalSupply() public view returns (uint256) {
373         return _totalSupply;
374     }
375 
376     /**
377      * @dev See {IERC20-balanceOf}.
378      */
379     function balanceOf(address account) public view returns (uint256) {
380         return _balances[account];
381     }
382 
383     /**
384      * @dev See {IERC20-transfer}.
385      *
386      * Requirements:
387      *
388      * - `recipient` cannot be the zero address.
389      * - the caller must have a balance of at least `amount`.
390      */
391     function transfer(address recipient, uint256 amount) public returns (bool) {
392         _transfer(_msgSender(), recipient, amount);
393         return true;
394     }
395 
396     /**
397      * @dev See {IERC20-allowance}.
398      */
399     function allowance(address owner, address spender) public view returns (uint256) {
400         return _allowances[owner][spender];
401     }
402 
403     /**
404      * @dev See {IERC20-approve}.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function approve(address spender, uint256 amount) public returns (bool) {
411         _approve(_msgSender(), spender, amount);
412         return true;
413     }
414 
415     /**
416      * @dev See {IERC20-transferFrom}.
417      *
418      * Emits an {Approval} event indicating the updated allowance. This is not
419      * required by the EIP. See the note at the beginning of {ERC20};
420      *
421      * Requirements:
422      * - `sender` and `recipient` cannot be the zero address.
423      * - `sender` must have a balance of at least `amount`.
424      * - the caller must have allowance for `sender`'s tokens of at least
425      * `amount`.
426      */
427     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
428         _transfer(sender, recipient, amount);
429         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
430         return true;
431     }
432 
433     /**
434      * @dev Atomically increases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
446         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
447         return true;
448     }
449 
450     /**
451      * @dev Atomically decreases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to {approve} that can be used as a mitigation for
454      * problems described in {IERC20-approve}.
455      *
456      * Emits an {Approval} event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      * - `spender` must have allowance for the caller of at least
462      * `subtractedValue`.
463      */
464     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
465         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
466         return true;
467     }
468 
469     /**
470      * @dev Moves tokens `amount` from `sender` to `recipient`.
471      *
472      * This is internal function is equivalent to {transfer}, and can be used to
473      * e.g. implement automatic token fees, slashing mechanisms, etc.
474      *
475      * Emits a {Transfer} event.
476      *
477      * Requirements:
478      *
479      * - `sender` cannot be the zero address.
480      * - `recipient` cannot be the zero address.
481      * - `sender` must have a balance of at least `amount`.
482      */
483     function _transfer(address sender, address recipient, uint256 amount) internal {
484         require(sender != address(0), "ERC20: transfer from the zero address");
485         require(recipient != address(0), "ERC20: transfer to the zero address");
486 
487         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
488         _balances[recipient] = _balances[recipient].add(amount);
489         emit Transfer(sender, recipient, amount);
490     }
491 
492     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
493      * the total supply.
494      *
495      * Emits a {Transfer} event with `from` set to the zero address.
496      *
497      * Requirements
498      *
499      * - `to` cannot be the zero address.
500      */
501     function _mint(address account, uint256 amount) internal {
502         require(account != address(0), "ERC20: mint to the zero address");
503 
504         _totalSupply = _totalSupply.add(amount);
505         _balances[account] = _balances[account].add(amount);
506         emit Transfer(address(0), account, amount);
507     }
508 
509     /**
510      * @dev Destroys `amount` tokens from `account`, reducing the
511      * total supply.
512      *
513      * Emits a {Transfer} event with `to` set to the zero address.
514      *
515      * Requirements
516      *
517      * - `account` cannot be the zero address.
518      * - `account` must have at least `amount` tokens.
519      */
520     function _burn(address account, uint256 amount) internal {
521         require(account != address(0), "ERC20: burn from the zero address");
522 
523         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
524         _totalSupply = _totalSupply.sub(amount);
525         emit Transfer(account, address(0), amount);
526     }
527 
528     /**
529      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
530      *
531      * This is internal function is equivalent to `approve`, and can be used to
532      * e.g. set automatic allowances for certain subsystems, etc.
533      *
534      * Emits an {Approval} event.
535      *
536      * Requirements:
537      *
538      * - `owner` cannot be the zero address.
539      * - `spender` cannot be the zero address.
540      */
541     function _approve(address owner, address spender, uint256 amount) internal {
542         require(owner != address(0), "ERC20: approve from the zero address");
543         require(spender != address(0), "ERC20: approve to the zero address");
544 
545         _allowances[owner][spender] = amount;
546         emit Approval(owner, spender, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
551      * from the caller's allowance.
552      *
553      * See {_burn} and {_approve}.
554      */
555     function _burnFrom(address account, uint256 amount) internal {
556         _burn(account, amount);
557         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
558     }
559 }
560 
561 library UintLibrary {
562     function toString(uint256 _i) internal pure returns (string memory) {
563         if (_i == 0) {
564             return "0";
565         }
566         uint j = _i;
567         uint len;
568         while (j != 0) {
569             len++;
570             j /= 10;
571         }
572         bytes memory bstr = new bytes(len);
573         uint k = len - 1;
574         while (_i != 0) {
575             bstr[k--] = byte(uint8(48 + _i % 10));
576             _i /= 10;
577         }
578         return string(bstr);
579     }
580 }
581 
582 library StringLibrary {
583     using UintLibrary for uint256;
584 
585     function append(string memory _a, string memory _b) internal pure returns (string memory) {
586         bytes memory _ba = bytes(_a);
587         bytes memory _bb = bytes(_b);
588         bytes memory bab = new bytes(_ba.length + _bb.length);
589         uint k = 0;
590         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
591         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
592         return string(bab);
593     }
594 
595     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
596         bytes memory _ba = bytes(_a);
597         bytes memory _bb = bytes(_b);
598         bytes memory _bc = bytes(_c);
599         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
600         uint k = 0;
601         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
602         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
603         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
604         return string(bbb);
605     }
606 
607     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
608         bytes memory msgBytes = bytes(message);
609         bytes memory fullMessage = concat(
610             bytes("\x19Ethereum Signed Message:\n"),
611             bytes(msgBytes.length.toString()),
612             msgBytes,
613             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
614         );
615         return ecrecover(keccak256(fullMessage), v, r, s);
616     }
617 
618     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
619         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
620         uint k = 0;
621         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
622         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
623         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
624         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
625         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
626         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
627         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
628         return resultBytes;
629     }
630 }
631 
632 library AddressLibrary {
633     function toString(address _addr) internal pure returns (string memory) {
634         bytes32 value = bytes32(uint256(_addr));
635         bytes memory alphabet = "0123456789abcdef";
636         bytes memory str = new bytes(42);
637         str[0] = '0';
638         str[1] = 'x';
639         for (uint256 i = 0; i < 20; i++) {
640             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
641             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
642         }
643         return string(str);
644     }
645 }
646 
647 contract FotoClaim is Ownable {
648     using SafeMath for uint;
649     using StringLibrary for string;
650     using UintLibrary for uint;
651     using AddressLibrary for address;
652 
653     event Claim(address indexed owner, uint value);
654     event Value(address indexed owner, uint value);
655 
656     struct Balance {
657         address recipient;
658         uint256 value;
659     }
660     
661     ERC20 public token;
662     address public tokenOwner;
663     mapping(address => uint) public claimed;
664 
665     constructor(ERC20 _token, address _tokenOwner) public {
666         token = _token;
667         tokenOwner = _tokenOwner;
668     }
669 
670     function claim(Balance memory _balances, uint8 v, bytes32 r, bytes32 s) public {
671         string memory messageSigned = prepareMessage(_balances);
672         address ownerOf = StringLibrary.recover(messageSigned, v, r, s);
673         require(ownerOf == owner(), "owner should sign balance");
674 
675         address recipient = _balances.recipient;
676         
677         if(msg.sender == recipient) {
678             uint toClaim = _balances.value.sub(claimed[recipient]);
679             require(toClaim > 0, "nothing to claim");
680             claimed[recipient] = _balances.value;
681             require(token.transferFrom(tokenOwner, msg.sender, toClaim), "transfer is not successful");
682             emit Claim(recipient, toClaim);
683             emit Value(recipient, _balances.value);
684             return;
685         }
686 
687         revert("msg.sender not found");
688     }
689 
690     function doOverride(Balance memory _balances) public onlyOwner {
691         claimed[_balances.recipient] = _balances.value;
692         emit Value(_balances.recipient, _balances.value);
693     }
694 
695     function prepareMessage(Balance memory _balances) internal pure returns (string memory) {
696         return toString(keccak256(abi.encode(_balances)));
697     }
698 
699     function toString(bytes32 value) internal pure returns (string memory) {
700         bytes memory alphabet = "0123456789abcdef";
701         bytes memory str = new bytes(64);
702         for (uint256 i = 0; i < 32; i++) {
703             str[i*2] = alphabet[uint8(value[i] >> 4)];
704             str[1+i*2] = alphabet[uint8(value[i] & 0x0f)];
705         }
706         return string(str);
707     }
708 }