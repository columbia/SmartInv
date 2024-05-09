1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 // File: interfaces/IERC20.sol
4 
5 
6 pragma solidity >=0.7.5;
7 
8 interface IERC20 {
9   /**
10    * @dev Returns the amount of tokens in existence.
11    */
12   function totalSupply() external view returns (uint256);
13 
14   /**
15    * @dev Returns the amount of tokens owned by `account`.
16    */
17   function balanceOf(address account) external view returns (uint256);
18 
19   /**
20    * @dev Moves `amount` tokens from the caller's account to `recipient`.
21    *
22    * Returns a boolean value indicating whether the operation succeeded.
23    *
24    * Emits a {Transfer} event.
25    */
26   function transfer(address recipient, uint256 amount) external returns (bool);
27 
28   /**
29    * @dev Returns the remaining number of tokens that `spender` will be
30    * allowed to spend on behalf of `owner` through {transferFrom}. This is
31    * zero by default.
32    *
33    * This value changes when {approve} or {transferFrom} are called.
34    */
35   function allowance(address owner, address spender) external view returns (uint256);
36 
37   /**
38    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39    *
40    * Returns a boolean value indicating whether the operation succeeded.
41    *
42    * IMPORTANT: Beware that changing an allowance with this method brings the risk
43    * that someone may use both the old and the new allowance by unfortunate
44    * transaction ordering. One possible solution to mitigate this race
45    * condition is to first reduce the spender's allowance to 0 and set the
46    * desired value afterwards:
47    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48    *
49    * Emits an {Approval} event.
50    */
51   function approve(address spender, uint256 amount) external returns (bool);
52 
53   /**
54    * @dev Moves `amount` tokens from `sender` to `recipient` using the
55    * allowance mechanism. `amount` is then deducted from the caller's
56    * allowance.
57    *
58    * Returns a boolean value indicating whether the operation succeeded.
59    *
60    * Emits a {Transfer} event.
61    */
62   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64   /**
65    * @dev Emitted when `value` tokens are moved from one account (`from`) to
66    * another (`to`).
67    *
68    * Note that `value` may be zero.
69    */
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 
72   /**
73    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74    * a call to {approve}. `value` is the new allowance.
75    */
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: interfaces/IgOHM.sol
80 
81 
82 pragma solidity >=0.7.5;
83 
84 
85 interface IgOHM is IERC20 {
86   function mint(address _to, uint256 _amount) external;
87 
88   function burn(address _from, uint256 _amount) external;
89 
90   function index() external view returns (uint256);
91 
92   function balanceFrom(uint256 _amount) external view returns (uint256);
93 
94   function balanceTo(uint256 _amount) external view returns (uint256);
95 
96   function migrate( address _staking, address _sOHM ) external;
97 }
98 
99 // File: interfaces/IsOHM.sol
100 
101 
102 pragma solidity >=0.7.5;
103 
104 
105 interface IsOHM is IERC20 {
106     function rebase( uint256 ohmProfit_, uint epoch_) external returns (uint256);
107 
108     function circulatingSupply() external view returns (uint256);
109 
110     function gonsForBalance( uint amount ) external view returns ( uint );
111 
112     function balanceForGons( uint gons ) external view returns ( uint );
113 
114     function index() external view returns ( uint );
115 
116     function toG(uint amount) external view returns (uint);
117 
118     function fromG(uint amount) external view returns (uint);
119 
120      function changeDebt(
121         uint256 amount,
122         address debtor,
123         bool add
124     ) external;
125 
126     function debtBalances(address _address) external view returns (uint256);
127 }
128 
129 // File: libraries/Address.sol
130 
131 
132 pragma solidity 0.7.5;
133 
134 
135 // TODO(zx): replace with OZ implementation.
136 library Address {
137     /**
138      * @dev Returns true if `account` is a contract.
139      *
140      * [IMPORTANT]
141      * ====
142      * It is unsafe to assume that an address for which this function returns
143      * false is an externally-owned account (EOA) and not a contract.
144      *
145      * Among others, `isContract` will return false for the following
146      * types of addresses:
147      *
148      *  - an externally-owned account
149      *  - a contract in construction
150      *  - an address where a contract will be created
151      *  - an address where a contract lived, but was destroyed
152      * ====
153      */
154     function isContract(address account) internal view returns (bool) {
155         // This method relies in extcodesize, which returns 0 for contracts in
156         // construction, since the code is only stored at the end of the
157         // constructor execution.
158 
159         uint256 size;
160         // solhint-disable-next-line no-inline-assembly
161         assembly { size := extcodesize(account) }
162         return size > 0;
163     }
164 
165     /**
166      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
167      * `recipient`, forwarding all available gas and reverting on errors.
168      *
169      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
170      * of certain opcodes, possibly making contracts go over the 2300 gas limit
171      * imposed by `transfer`, making them unable to receive funds via
172      * `transfer`. {sendValue} removes this limitation.
173      *
174      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
175      *
176      * IMPORTANT: because control is transferred to `recipient`, care must be
177      * taken to not create reentrancy vulnerabilities. Consider using
178      * {ReentrancyGuard} or the
179      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
180      */
181     function sendValue(address payable recipient, uint256 amount) internal {
182         require(address(this).balance >= amount, "Address: insufficient balance");
183 
184         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
185         (bool success, ) = recipient.call{ value: amount }("");
186         require(success, "Address: unable to send value, recipient may have reverted");
187     }
188 
189     /**
190      * @dev Performs a Solidity function call using a low level `call`. A
191      * plain`call` is an unsafe replacement for a function call: use this
192      * function instead.
193      *
194      * If `target` reverts with a revert reason, it is bubbled up by this
195      * function (like regular Solidity function calls).
196      *
197      * Returns the raw returned data. To convert to the expected return value,
198      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
199      *
200      * Requirements:
201      *
202      * - `target` must be a contract.
203      * - calling `target` with `data` must not revert.
204      *
205      * _Available since v3.1._
206      */
207     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
208       return functionCall(target, data, "Address: low-level call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
213      * `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
218         return _functionCallWithValue(target, data, 0, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but also transferring `value` wei to `target`.
224      *
225      * Requirements:
226      *
227      * - the calling contract must have an ETH balance of at least `value`.
228      * - the called Solidity function must be `payable`.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
238      * with `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     // function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
243     //     require(address(this).balance >= value, "Address: insufficient balance for call");
244     //     return _functionCallWithValue(target, data, value, errorMessage);
245     // }
246     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
247         require(address(this).balance >= value, "Address: insufficient balance for call");
248         require(isContract(target), "Address: call to non-contract");
249 
250         // solhint-disable-next-line avoid-low-level-calls
251         (bool success, bytes memory returndata) = target.call{ value: value }(data);
252         return _verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
256         require(isContract(target), "Address: call to non-contract");
257 
258         // solhint-disable-next-line avoid-low-level-calls
259         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
260         if (success) {
261             return returndata;
262         } else {
263             // Look for revert reason and bubble it up if present
264             if (returndata.length > 0) {
265                 // The easiest way to bubble the revert reason is using memory via assembly
266 
267                 // solhint-disable-next-line no-inline-assembly
268                 assembly {
269                     let returndata_size := mload(returndata)
270                     revert(add(32, returndata), returndata_size)
271                 }
272             } else {
273                 revert(errorMessage);
274             }
275         }
276     }
277 
278   /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a static call.
281      *
282      * _Available since v3.3._
283      */
284     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
285         return functionStaticCall(target, data, "Address: low-level static call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
295         require(isContract(target), "Address: static call to non-contract");
296 
297         // solhint-disable-next-line avoid-low-level-calls
298         (bool success, bytes memory returndata) = target.staticcall(data);
299         return _verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but performing a delegate call.
305      *
306      * _Available since v3.3._
307      */
308     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
314      * but performing a delegate call.
315      *
316      * _Available since v3.3._
317      */
318     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
319         require(isContract(target), "Address: delegate call to non-contract");
320 
321         // solhint-disable-next-line avoid-low-level-calls
322         (bool success, bytes memory returndata) = target.delegatecall(data);
323         return _verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
327         if (success) {
328             return returndata;
329         } else {
330             // Look for revert reason and bubble it up if present
331             if (returndata.length > 0) {
332                 // The easiest way to bubble the revert reason is using memory via assembly
333 
334                 // solhint-disable-next-line no-inline-assembly
335                 assembly {
336                     let returndata_size := mload(returndata)
337                     revert(add(32, returndata), returndata_size)
338                 }
339             } else {
340                 revert(errorMessage);
341             }
342         }
343     }
344 
345     function addressToString(address _address) internal pure returns(string memory) {
346         bytes32 _bytes = bytes32(uint256(_address));
347         bytes memory HEX = "0123456789abcdef";
348         bytes memory _addr = new bytes(42);
349 
350         _addr[0] = '0';
351         _addr[1] = 'x';
352 
353         for(uint256 i = 0; i < 20; i++) {
354             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
355             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
356         }
357 
358         return string(_addr);
359 
360     }
361 }
362 // File: libraries/SafeMath.sol
363 
364 
365 pragma solidity ^0.7.5;
366 
367 
368 // TODO(zx): Replace all instances of SafeMath with OZ implementation
369 library SafeMath {
370 
371     function add(uint256 a, uint256 b) internal pure returns (uint256) {
372         uint256 c = a + b;
373         require(c >= a, "SafeMath: addition overflow");
374 
375         return c;
376     }
377 
378     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
379         return sub(a, b, "SafeMath: subtraction overflow");
380     }
381 
382     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
383         require(b <= a, errorMessage);
384         uint256 c = a - b;
385 
386         return c;
387     }
388 
389     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
390         if (a == 0) {
391             return 0;
392         }
393 
394         uint256 c = a * b;
395         require(c / a == b, "SafeMath: multiplication overflow");
396 
397         return c;
398     }
399 
400     function div(uint256 a, uint256 b) internal pure returns (uint256) {
401         return div(a, b, "SafeMath: division by zero");
402     }
403 
404     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b > 0, errorMessage);
406         uint256 c = a / b;
407         assert(a == b * c + a % b); // There is no case in which this doesn't hold
408 
409         return c;
410     }
411 
412     // Only used in the  BondingCalculator.sol
413     function sqrrt(uint256 a) internal pure returns (uint c) {
414         if (a > 3) {
415             c = a;
416             uint b = add( div( a, 2), 1 );
417             while (b < c) {
418                 c = b;
419                 b = div( add( div( a, b ), b), 2 );
420             }
421         } else if (a != 0) {
422             c = 1;
423         }
424     }
425 
426 }
427 // File: types/ERC20.sol
428 
429 
430 pragma solidity 0.7.5;
431 
432 
433 
434 
435 abstract contract ERC20 is IERC20 {
436 
437     using SafeMath for uint256;
438 
439     // TODO comment actual hash value.
440     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
441     
442     mapping (address => uint256) internal _balances;
443 
444     mapping (address => mapping (address => uint256)) internal _allowances;
445 
446     uint256 internal _totalSupply;
447 
448     string internal _name;
449     
450     string internal _symbol;
451     
452     uint8 internal _decimals;
453 
454     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
455         _name = name_;
456         _symbol = symbol_;
457         _decimals = decimals_;
458     }
459 
460     function name() public view returns (string memory) {
461         return _name;
462     }
463 
464     function symbol() public view returns (string memory) {
465         return _symbol;
466     }
467 
468     function decimals() public view virtual returns (uint8) {
469         return _decimals;
470     }
471 
472     function totalSupply() public view override returns (uint256) {
473         return _totalSupply;
474     }
475 
476     function balanceOf(address account) public view virtual override returns (uint256) {
477         return _balances[account];
478     }
479 
480     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
481         _transfer(msg.sender, recipient, amount);
482         return true;
483     }
484 
485     function allowance(address owner, address spender) public view virtual override returns (uint256) {
486         return _allowances[owner][spender];
487     }
488 
489     function approve(address spender, uint256 amount) public virtual override returns (bool) {
490         _approve(msg.sender, spender, amount);
491         return true;
492     }
493 
494     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
495         _transfer(sender, recipient, amount);
496         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
497         return true;
498     }
499 
500     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
501         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
502         return true;
503     }
504 
505     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
506         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
507         return true;
508     }
509 
510     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
511         require(sender != address(0), "ERC20: transfer from the zero address");
512         require(recipient != address(0), "ERC20: transfer to the zero address");
513 
514         _beforeTokenTransfer(sender, recipient, amount);
515 
516         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
517         _balances[recipient] = _balances[recipient].add(amount);
518         emit Transfer(sender, recipient, amount);
519     }
520 
521     function _mint(address account_, uint256 ammount_) internal virtual {
522         require(account_ != address(0), "ERC20: mint to the zero address");
523         _beforeTokenTransfer(address( this ), account_, ammount_);
524         _totalSupply = _totalSupply.add(ammount_);
525         _balances[account_] = _balances[account_].add(ammount_);
526         emit Transfer(address( this ), account_, ammount_);
527     }
528 
529     function _burn(address account, uint256 amount) internal virtual {
530         require(account != address(0), "ERC20: burn from the zero address");
531 
532         _beforeTokenTransfer(account, address(0), amount);
533 
534         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
535         _totalSupply = _totalSupply.sub(amount);
536         emit Transfer(account, address(0), amount);
537     }
538 
539     function _approve(address owner, address spender, uint256 amount) internal virtual {
540         require(owner != address(0), "ERC20: approve from the zero address");
541         require(spender != address(0), "ERC20: approve to the zero address");
542 
543         _allowances[owner][spender] = amount;
544         emit Approval(owner, spender, amount);
545     }
546 
547   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
548 }
549 
550 // File: gOHM.sol
551 
552 
553 pragma solidity ^0.7.5;
554 
555 
556 
557 
558 
559 
560 contract gOHM is IgOHM, ERC20 {
561 
562     /* ========== DEPENDENCIES ========== */
563 
564     using Address for address;
565     using SafeMath for uint256;
566 
567     /* ========== MODIFIERS ========== */
568 
569     modifier onlyApproved() {
570         require(msg.sender == approved, "Only approved");
571         _;
572     }
573 
574     /* ========== EVENTS ========== */
575 
576     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
577     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
578 
579     /* ========== DATA STRUCTURES ========== */
580 
581     /// @notice A checkpoint for marking number of votes from a given block
582     struct Checkpoint {
583         uint256 fromBlock;
584         uint256 votes;
585     }
586 
587     /* ========== STATE VARIABLES ========== */
588 
589     IsOHM public sOHM;
590     address public approved; // minter
591     bool public migrated;
592 
593     mapping(address => mapping(uint256 => Checkpoint)) public checkpoints;
594     mapping(address => uint256) public numCheckpoints;
595     mapping(address => address) public delegates;
596 
597     /* ========== CONSTRUCTOR ========== */
598 
599     constructor(address _migrator, address _sOHM)
600         ERC20("Governance OHM", "gOHM", 18)
601     {
602         require(_migrator != address(0), "Zero address: Migrator");
603         approved = _migrator;
604         require(_sOHM != address(0), "Zero address: sOHM");
605         sOHM = IsOHM(_sOHM);
606     }
607 
608     /* ========== MUTATIVE FUNCTIONS ========== */
609 
610     /**
611      * @notice transfer mint rights from migrator to staking
612      * @notice can only be done once, at the time of contract migration
613      * @param _staking address
614      * @param _sOHM address
615      */
616     function migrate(address _staking, address _sOHM) external override onlyApproved {
617         require(!migrated, "Migrated");
618         migrated = true;
619 
620         require(_staking != approved, "Invalid argument");
621         require(_staking != address(0), "Zero address found");
622         approved = _staking;
623 
624         require(_sOHM != address(0), "Zero address found");
625         sOHM = IsOHM(_sOHM);
626     }
627 
628     /**
629      * @notice Delegate votes from `msg.sender` to `delegatee`
630      * @param delegatee The address to delegate votes to
631      */
632     function delegate(address delegatee) external {
633         return _delegate(msg.sender, delegatee);
634     }
635 
636     /**
637         @notice mint gOHM
638         @param _to address
639         @param _amount uint
640      */
641     function mint(address _to, uint256 _amount) external override onlyApproved {
642         _mint(_to, _amount);
643     }
644 
645     /**
646         @notice burn gOHM
647         @param _from address
648         @param _amount uint
649      */
650     function burn(address _from, uint256 _amount) external override onlyApproved {
651         _burn(_from, _amount);
652     }
653 
654     /* ========== VIEW FUNCTIONS ========== */
655 
656     /**
657      * @notice pull index from sOHM token
658      */
659     function index() public view override returns (uint256) {
660         return sOHM.index();
661     }
662 
663     /**
664         @notice converts gOHM amount to OHM
665         @param _amount uint
666         @return uint
667      */
668     function balanceFrom(uint256 _amount) public view override returns (uint256) {
669         return _amount.mul(index()).div(10**decimals());
670     }
671 
672     /**
673         @notice converts OHM amount to gOHM
674         @param _amount uint
675         @return uint
676      */
677     function balanceTo(uint256 _amount) public view override returns (uint256) {
678         return _amount.mul(10**decimals()).div(index());
679     }
680 
681     /**
682      * @notice Gets the current votes balance for `account`
683      * @param account The address to get votes balance
684      * @return The number of current votes for `account`
685      */
686     function getCurrentVotes(address account) external view returns (uint256) {
687         uint256 nCheckpoints = numCheckpoints[account];
688         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
689     }
690 
691     /**
692      * @notice Determine the prior number of votes for an account as of a block number
693      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
694      * @param account The address of the account to check
695      * @param blockNumber The block number to get the vote balance at
696      * @return The number of votes the account had as of the given block
697      */
698     function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
699         require(blockNumber < block.number, "gOHM::getPriorVotes: not yet determined");
700 
701         uint256 nCheckpoints = numCheckpoints[account];
702         if (nCheckpoints == 0) {
703             return 0;
704         }
705 
706         // First check most recent balance
707         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
708             return checkpoints[account][nCheckpoints - 1].votes;
709         }
710 
711         // Next check implicit zero balance
712         if (checkpoints[account][0].fromBlock > blockNumber) {
713             return 0;
714         }
715 
716         uint256 lower = 0;
717         uint256 upper = nCheckpoints - 1;
718         while (upper > lower) {
719             uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
720             Checkpoint memory cp = checkpoints[account][center];
721             if (cp.fromBlock == blockNumber) {
722                 return cp.votes;
723             } else if (cp.fromBlock < blockNumber) {
724                 lower = center;
725             } else {
726                 upper = center - 1;
727             }
728         }
729         return checkpoints[account][lower].votes;
730     }
731 
732     /* ========== INTERNAL FUNCTIONS ========== */
733 
734     function _delegate(address delegator, address delegatee) internal {
735         address currentDelegate = delegates[delegator];
736         uint256 delegatorBalance = _balances[delegator];
737         delegates[delegator] = delegatee;
738 
739         emit DelegateChanged(delegator, currentDelegate, delegatee);
740 
741         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
742     }
743 
744     function _moveDelegates(
745         address srcRep,
746         address dstRep,
747         uint256 amount
748     ) internal {
749         if (srcRep != dstRep && amount > 0) {
750             if (srcRep != address(0)) {
751                 uint256 srcRepNum = numCheckpoints[srcRep];
752                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
753                 uint256 srcRepNew = srcRepOld.sub(amount);
754                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
755             }
756 
757             if (dstRep != address(0)) {
758                 uint256 dstRepNum = numCheckpoints[dstRep];
759                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
760                 uint256 dstRepNew = dstRepOld.add(amount);
761                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
762             }
763         }
764     }
765 
766     function _writeCheckpoint(
767         address delegatee,
768         uint256 nCheckpoints,
769         uint256 oldVotes,
770         uint256 newVotes
771     ) internal {
772         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == block.number) {
773             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
774         } else {
775             checkpoints[delegatee][nCheckpoints] = Checkpoint(block.number, newVotes);
776             numCheckpoints[delegatee] = nCheckpoints + 1;
777         }
778 
779         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
780     }
781 
782     /**
783         @notice Ensure delegation moves when token is transferred.
784      */
785     function _beforeTokenTransfer(
786         address from,
787         address to,
788         uint256 amount
789     ) internal override {
790         _moveDelegates(delegates[from], delegates[to], amount);
791     }
792 }