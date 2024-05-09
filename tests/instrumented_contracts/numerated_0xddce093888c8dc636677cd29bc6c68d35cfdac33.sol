1 // SPDX-License-Identifier: MIT
2 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
3 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
4 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
5 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
6 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&/                   ,&&&&&&&&&&&&
7 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%*,,,,,,,,,,,,,,,,,,,*&&&&&&&&&&&&
8 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&(,..................#&&&&&&&&&&&&
9 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*,,                 .%&&&&&&&&&&&&
10 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*,,                 .%&&&&&&&&&&&&
11 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#,                 .%&&&&&&&&&&&&
12 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#,                 .%&&&&&&&&&&&&
13 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#,                 ,%&&&&&&&&&&&&
14 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#,... .............,&&&&&&&&&&&&&
15 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#,.................,&&&&&&&&&&&&&
16 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#,.................,&&&&&&&&&&&&&
17 // &&&&&&&&&&&&&#*,,......                ......,*(#(///////////////#%&&&&&&&&&&&&&
18 // &&&&&&&&&&&&%*,,..                            .,*(,,,,,,,,*#&&&&&&&&&&&&&&&&&&&&
19 // &&&&&&&&&&&&&/**,,,,..........................,,*/,,,,.,%&&&&&&&&&&&&&&&&&&&&&&&
20 // &&&&&&&&&&&&&&/****,,,,....................,,,,*/,,...,%&&&&&&&&&&&&&&&&&&&&&&&&
21 // &&&&&&&&&&&&&&&#//****,,,,,,,,,,,,,,,,,,,,,,,**/,,,,,,*&&&&&&&&&&&&&&&&&&&&&&&&&
22 // &&&&&&&&&&&&&&&&&&#(////*****,,,,,,,,,,,,****/*,,,,,,,*&&&&&&&&&&&&&&&&&&&&&&&&&
23 // &&&&&&&&&&&&&&&&&&&&&&%(////**************//,,,,,,,,,,*&&&&&&&&&&&&&&&&&&&&&&&&&
24 // &&&&&&&&&&&&&&&&&&&&&&&%/**,,...........,**,..........,&&&&&&&&&&&&&&&&&&&&&&&&&
25 // &&&&&&&&&&&&&&&&&&&&&&&#**,.           .,**,.......   .%&&&&&&&&&&&&&&&&&&&&&&&&
26 // &&&&&&&&&&&&&&&&&&&&&&&/,..            ..**,......     (&&&&&&&&&&&&&&&&&&&&&&&&
27 // &&&&&&&&&&&&&&&&&&&&&&%*,.             ..**....        .%&&&&&&&&&&&&&&&&&&&&&&&
28 // &&&&&&&&&&&&&&&&&&&&&&(,,.             ..**.            /&&&&&&&&&&&&&&&&&&&&&&&
29 // &&&&&&&&&&&&&&&&&&&&&&/,..             .,**.            .%&&&&&&&&&&&&&&&&&&&&&&
30 // &&&&&&&&&&&&&&&&&&&&&&%(/*,,,,...,,,,,,,*(#%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&&&&&&&&
31 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
32 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
33 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
34 pragma solidity ^0.6.12;
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address payable) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes memory) {
42         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43         return msg.data;
44     }
45 }
46 
47 interface IERC20 {
48     /**
49      * @dev Returns the amount of tokens in existence.
50      */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54      * @dev Returns the amount of tokens owned by `account`.
55      */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59      * @dev Moves `amount` tokens from the caller's account to `recipient`.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transfer(address recipient, uint256 amount)
66     external
67     returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender)
77     external
78     view
79     returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `sender` to `recipient` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address sender,
108         address recipient,
109         uint256 amount
110     ) external returns (bool);
111 
112     /**
113      * @dev Emitted when `value` tokens are moved from one account (`from`) to
114      * another (`to`).
115      *
116      * Note that `value` may be zero.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     /**
121      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
122      * a call to {approve}. `value` is the new allowance.
123      */
124     event Approval(
125         address indexed owner,
126         address indexed spender,
127         uint256 value
128     );
129 }
130 
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         require(b <= a, errorMessage);
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return div(a, b, "SafeMath: division by zero");
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         require(b > 0, errorMessage);
242         uint256 c = a / b;
243         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts with custom message when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         require(b != 0, errorMessage);
282         return a % b;
283     }
284 }
285 
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * [IMPORTANT]
291      * ====
292      * It is unsafe to assume that an address for which this function returns
293      * false is an externally-owned account (EOA) and not a contract.
294      *
295      * Among others, `isContract` will return false for the following
296      * types of addresses:
297      *
298      *  - an externally-owned account
299      *  - a contract in construction
300      *  - an address where a contract will be created
301      *  - an address where a contract lived, but was destroyed
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
306         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
307         // for accounts without code, i.e. `keccak256('')`
308         bytes32 codehash;
309         bytes32 accountHash =
310         0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
311         // solhint-disable-next-line no-inline-assembly
312         assembly {
313             codehash := extcodehash(account)
314         }
315         return (codehash != accountHash && codehash != 0x0);
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(
336             address(this).balance >= amount,
337             "Address: insufficient balance"
338         );
339 
340         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341         (bool success, ) = recipient.call{value: amount}("");
342         require(
343             success,
344             "Address: unable to send value, recipient may have reverted"
345         );
346     }
347 
348     /**
349      * @dev Performs a Solidity function call using a low level `call`. A
350      * plain`call` is an unsafe replacement for a function call: use this
351      * function instead.
352      *
353      * If `target` reverts with a revert reason, it is bubbled up by this
354      * function (like regular Solidity function calls).
355      *
356      * Returns the raw returned data. To convert to the expected return value,
357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358      *
359      * Requirements:
360      *
361      * - `target` must be a contract.
362      * - calling `target` with `data` must not revert.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data)
367     internal
368     returns (bytes memory)
369     {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return _functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return
404         functionCallWithValue(
405             target,
406             data,
407             value,
408             "Address: low-level call with value failed"
409         );
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(
425             address(this).balance >= value,
426             "Address: insufficient balance for call"
427         );
428         return _functionCallWithValue(target, data, value, errorMessage);
429     }
430 
431     function _functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 weiValue,
435         string memory errorMessage
436     ) private returns (bytes memory) {
437         require(isContract(target), "Address: call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) =
441         target.call{value: weiValue}(data);
442         if (success) {
443             return returndata;
444         } else {
445             // Look for revert reason and bubble it up if present
446             if (returndata.length > 0) {
447                 // The easiest way to bubble the revert reason is using memory via assembly
448 
449                 // solhint-disable-next-line no-inline-assembly
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 contract ERC20 is Context, IERC20 {
462     using SafeMath for uint256;
463     using Address for address;
464 
465     mapping(address => uint256) private _balances;
466 
467     mapping(address => mapping(address => uint256)) private _allowances;
468 
469     uint256 private _totalSupply;
470 
471     string private _name;
472     string private _symbol;
473     uint8 private _decimals;
474 
475     constructor(string memory name, string memory symbol) public {
476         _name = name;
477         _symbol = symbol;
478         _decimals = 18;
479     }
480 
481     function name() public view returns (string memory) {
482         return _name;
483     }
484 
485     function symbol() public view returns (string memory) {
486         return _symbol;
487     }
488 
489     function decimals() public view returns (uint8) {
490         return _decimals;
491     }
492 
493     function totalSupply() public view override returns (uint256) {
494         return _totalSupply;
495     }
496 
497     function balanceOf(address account) public view override returns (uint256) {
498         return _balances[account];
499     }
500 
501     function transfer(address recipient, uint256 amount)
502     public
503     virtual
504     override
505     returns (bool)
506     {
507         _transfer(_msgSender(), recipient, amount);
508         return true;
509     }
510 
511     function allowance(address owner, address spender)
512     public
513     view
514     virtual
515     override
516     returns (uint256)
517     {
518         return _allowances[owner][spender];
519     }
520 
521     function approve(address spender, uint256 amount)
522     public
523     virtual
524     override
525     returns (bool)
526     {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     function transferFrom(
532         address sender,
533         address recipient,
534         uint256 amount
535     ) public virtual override returns (bool) {
536         _transfer(sender, recipient, amount);
537         _approve(
538             sender,
539             _msgSender(),
540             _allowances[sender][_msgSender()].sub(
541                 amount,
542                 "ERC20: transfer amount exceeds allowance"
543             )
544         );
545         return true;
546     }
547 
548     function increaseAllowance(address spender, uint256 addedValue)
549     public
550     virtual
551     returns (bool)
552     {
553         _approve(
554             _msgSender(),
555             spender,
556             _allowances[_msgSender()][spender].add(addedValue)
557         );
558         return true;
559     }
560 
561     function decreaseAllowance(address spender, uint256 subtractedValue)
562     public
563     virtual
564     returns (bool)
565     {
566         _approve(
567             _msgSender(),
568             spender,
569             _allowances[_msgSender()][spender].sub(
570                 subtractedValue,
571                 "ERC20: decreased allowance below zero"
572             )
573         );
574         return true;
575     }
576 
577     function _transfer(
578         address sender,
579         address recipient,
580         uint256 amount
581     ) internal virtual {
582         require(sender != address(0), "ERC20: transfer from the zero address");
583         require(recipient != address(0), "ERC20: transfer to the zero address");
584 
585         _beforeTokenTransfer(sender, recipient, amount);
586 
587         _balances[sender] = _balances[sender].sub(
588             amount,
589             "ERC20: transfer amount exceeds balance"
590         );
591         _balances[recipient] = _balances[recipient].add(amount);
592         emit Transfer(sender, recipient, amount);
593     }
594 
595     function _mint(address account, uint256 amount) internal virtual {
596         require(account != address(0), "ERC20: mint to the zero address");
597 
598         _beforeTokenTransfer(address(0), account, amount);
599 
600         _totalSupply = _totalSupply.add(amount);
601         _balances[account] = _balances[account].add(amount);
602         emit Transfer(address(0), account, amount);
603     }
604 
605     function _burn(address account, uint256 amount) internal virtual {
606         require(account != address(0), "ERC20: burn from the zero address");
607 
608         _beforeTokenTransfer(account, address(0), amount);
609 
610         _balances[account] = _balances[account].sub(
611             amount,
612             "ERC20: burn amount exceeds balance"
613         );
614         _totalSupply = _totalSupply.sub(amount);
615         emit Transfer(account, address(0), amount);
616     }
617 
618     function _approve(
619         address owner,
620         address spender,
621         uint256 amount
622     ) internal virtual {
623         require(owner != address(0), "ERC20: approve from the zero address");
624         require(spender != address(0), "ERC20: approve to the zero address");
625 
626         _allowances[owner][spender] = amount;
627         emit Approval(owner, spender, amount);
628     }
629 
630     function _setupDecimals(uint8 decimals_) internal {
631         _decimals = decimals_;
632     }
633 
634     function _beforeTokenTransfer(
635         address from,
636         address to,
637         uint256 amount
638     ) internal virtual {}
639 }
640 
641 contract Ownable is Context {
642     address private _owner;
643 
644     event OwnershipTransferred(
645         address indexed previousOwner,
646         address indexed newOwner
647     );
648 
649     constructor() internal {
650         address msgSender = _msgSender();
651         _owner = msgSender;
652         emit OwnershipTransferred(address(0), msgSender);
653     }
654 
655     function owner() public view returns (address) {
656         return _owner;
657     }
658 
659     modifier onlyOwner() {
660         require(_owner == _msgSender(), "Ownable: caller is not the owner");
661         _;
662     }
663 
664     function renounceOwnership() public virtual onlyOwner {
665         emit OwnershipTransferred(_owner, address(0));
666         _owner = address(0);
667     }
668 
669     function transferOwnership(address newOwner) public virtual onlyOwner {
670         require(
671             newOwner != address(0),
672             "Ownable: new owner is the zero address"
673         );
674         emit OwnershipTransferred(_owner, newOwner);
675         _owner = newOwner;
676     }
677 }
678 
679 contract AdminContract is Ownable {
680     mapping(address => bool) public governanceContracts;
681 
682     event GovernanceContractAdded(address addr);
683     event GovernanceContractRemoved(address addr);
684 
685     modifier onlyGovernance() {
686         require(governanceContracts[msg.sender], "Isn't governance address");
687         _;
688     }
689 
690     function addAddress(address addr) public onlyOwner returns (bool success) {
691         if (!governanceContracts[addr]) {
692             governanceContracts[addr] = true;
693             emit GovernanceContractAdded(addr);
694             success = true;
695         }
696     }
697 
698     function removeAddress(address addr)
699     public
700     onlyOwner
701     returns (bool success)
702     {
703         if (governanceContracts[addr]) {
704             governanceContracts[addr] = false;
705             emit GovernanceContractRemoved(addr);
706             success = true;
707         }
708     }
709 }
710 
711 contract PaperToken is ERC20("PAPER token", "PAPER"), AdminContract {
712     uint256 private maxSupplyPaper = 69000 * 1e18;
713 
714     function mintPaper(address _to, uint256 _amount)
715     public
716     virtual
717     onlyGovernance
718     returns (bool)
719     {
720         require(
721             totalSupply().add(_amount) <= maxSupplyPaper,
722             "Emission limit exceeded"
723         );
724         _mint(_to, _amount);
725         return true;
726     }
727 
728     function maxSupply() public view returns (uint256) {
729         return maxSupplyPaper;
730     }
731 }
732 
733 library SafeERC20 {
734     using SafeMath for uint256;
735     using Address for address;
736 
737     function safeTransfer(
738         IERC20 token,
739         address to,
740         uint256 value
741     ) internal {
742         _callOptionalReturn(
743             token,
744             abi.encodeWithSelector(token.transfer.selector, to, value)
745         );
746     }
747 
748     function safeTransferFrom(
749         IERC20 token,
750         address from,
751         address to,
752         uint256 value
753     ) internal {
754         _callOptionalReturn(
755             token,
756             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
757         );
758     }
759 
760     function safeApprove(
761         IERC20 token,
762         address spender,
763         uint256 value
764     ) internal {
765         require(
766             (value == 0) || (token.allowance(address(this), spender) == 0),
767             "SafeERC20: approve from non-zero to non-zero allowance"
768         );
769         _callOptionalReturn(
770             token,
771             abi.encodeWithSelector(token.approve.selector, spender, value)
772         );
773     }
774 
775     function safeIncreaseAllowance(
776         IERC20 token,
777         address spender,
778         uint256 value
779     ) internal {
780         uint256 newAllowance =
781         token.allowance(address(this), spender).add(value);
782         _callOptionalReturn(
783             token,
784             abi.encodeWithSelector(
785                 token.approve.selector,
786                 spender,
787                 newAllowance
788             )
789         );
790     }
791 
792     function safeDecreaseAllowance(
793         IERC20 token,
794         address spender,
795         uint256 value
796     ) internal {
797         uint256 newAllowance =
798         token.allowance(address(this), spender).sub(
799             value,
800             "SafeERC20: decreased allowance below zero"
801         );
802         _callOptionalReturn(
803             token,
804             abi.encodeWithSelector(
805                 token.approve.selector,
806                 spender,
807                 newAllowance
808             )
809         );
810     }
811 
812     function _callOptionalReturn(IERC20 token, bytes memory data) private {
813         bytes memory returndata =
814         address(token).functionCall(
815             data,
816             "SafeERC20: low-level call failed"
817         );
818         if (returndata.length > 0) {
819             // Return data is optional
820 
821             require(
822                 abi.decode(returndata, (bool)),
823                 "SafeERC20: ERC20 operation did not succeed"
824             );
825         }
826     }
827 }
828 
829 contract FarmContract is Ownable {
830     using SafeMath for uint256;
831     using SafeERC20 for IERC20;
832 
833     IERC20 public paperWethLP;
834     PaperToken public paper;
835 
836     struct Farmer {
837         uint256 amount;
838         uint256 loss;
839     }
840 
841     mapping(address => Farmer) public users;
842 
843     uint256 public debt;
844 
845     event Deposit(address indexed user, uint256 amount);
846     event Harvest(address indexed user, uint256 amount);
847 
848     constructor(PaperToken _paper, IERC20 _paperLpToken) public {
849         paper = _paper;
850         paperWethLP = _paperLpToken;
851     }
852 
853     function deposit(uint256 _amount) public {
854         harvest();
855 
856         if (paperWethLP.balanceOf(address(this)) > 0) {
857             // (paperBalance + debt) * (totalLP + amount) / totalLP - paperBalance
858             debt = paper
859             .balanceOf(address(this))
860             .add(debt)
861             .mul(paperWethLP.balanceOf(address(this)).add(_amount))
862             .div(paperWethLP.balanceOf(address(this)))
863             .sub(paper.balanceOf(address(this)));
864         } else {
865             debt = 0;
866         }
867 
868         paperWethLP.safeTransferFrom(
869             address(msg.sender),
870             address(this),
871             _amount
872         );
873         users[msg.sender].amount = users[msg.sender].amount.add(_amount);
874 
875         if (paperWethLP.balanceOf(address(this)) > 0) {
876             // (paperBalance + debt) * user.amount / totalLP
877             users[msg.sender].loss = paper
878             .balanceOf(address(this))
879             .add(debt)
880             .mul(users[msg.sender].amount)
881             .div(paperWethLP.balanceOf(address(this)));
882         } else {
883             users[msg.sender].loss = 0;
884         }
885     }
886 
887     function withdraw(uint256 _amount) public {
888         require(
889             paper.totalSupply() == paper.maxSupply(),
890             "Withdrawals will be available after PAPER max supply is reached"
891         );
892         require(
893             users[msg.sender].amount >= _amount,
894             "You don't have enough LP tokens"
895         );
896         require(paperWethLP.balanceOf(address(this)) > 0, "No tokens left");
897 
898         harvest();
899         // (paperBlance + debt) * (totalLP - amount) / totalLP - paperBalance
900         debt = paper
901         .balanceOf(address(this))
902         .add(debt)
903         .mul(paperWethLP.balanceOf(address(this)).sub(_amount))
904         .div(paperWethLP.balanceOf(address(this)));
905 
906         if (debt > paper.balanceOf(address(this))) {
907             debt = debt.sub(paper.balanceOf(address(this)));
908         } else {
909             debt = 0;
910         }
911 
912         paperWethLP.safeTransfer(address(msg.sender), _amount);
913 
914         if (users[msg.sender].amount > _amount) {
915             users[msg.sender].amount = users[msg.sender].amount.sub(_amount);
916         } else {
917             users[msg.sender].amount = 0;
918         }
919 
920         if (paperWethLP.balanceOf(address(this)) > 0) {
921             // (paperBalance + debt) * user.amount / totalLP
922             users[msg.sender].loss = paper
923             .balanceOf(address(this))
924             .add(debt)
925             .mul(users[msg.sender].amount)
926             .div(paperWethLP.balanceOf(address(this)));
927         } else {
928             users[msg.sender].loss = 0;
929         }
930     }
931 
932     function harvest() public {
933         if (
934             !(users[msg.sender].amount > 0 &&
935         paperWethLP.balanceOf(address(this)) > 0)
936         ) {
937             return;
938         }
939         // (paperBalance + debt) * user.balance / totalLPbalance
940         uint256 p =
941         paper
942         .balanceOf(address(this))
943         .add(debt)
944         .mul(users[msg.sender].amount)
945         .div(paperWethLP.balanceOf(address(this)));
946 
947         if (p > users[msg.sender].loss) {
948             uint256 pending = p.sub(users[msg.sender].loss);
949             paper.transfer(msg.sender, pending);
950             debt = debt.add(pending);
951             users[msg.sender].loss = p;
952         }
953     }
954 
955     function getPending(address _user) public view returns (uint256) {
956         if (
957             users[_user].amount > 0 && paperWethLP.balanceOf(address(this)) > 0
958         ) {
959             // (paperBalance + debt) * user.balance / totalLPbalance - user.loss
960             return
961             paper
962             .balanceOf(address(this))
963             .add(debt)
964             .mul(users[_user].amount)
965             .div(paperWethLP.balanceOf(address(this)))
966             .sub(users[_user].loss);
967         }
968         return 0;
969     }
970 
971     function getTotalLP() public view returns (uint256) {
972         return paperWethLP.balanceOf(address(this));
973     }
974 
975     function getUser(address _user)
976     public
977     view
978     returns (uint256 balance, uint256 loss)
979     {
980         balance = users[_user].amount;
981         loss = users[_user].loss;
982     }
983 }