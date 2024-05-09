1 pragma solidity ^0.5.0;
2 
3 // openzeppelin-solidity@2.3.0 from NPM
4 
5 /**
6  * @dev Collection of functions related to the address type,
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * This test is non-exhaustive, and there may be false-negatives: during the
13      * execution of a contract's constructor, its address will be reported as
14      * not containing a contract.
15      *
16      * > It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      */
19     function isContract(address account) internal view returns (bool) {
20         // This method relies in extcodesize, which returns 0 for contracts in
21         // construction, since the code is only stored at the end of the
22         // constructor execution.
23 
24         uint256 size;
25         // solhint-disable-next-line no-inline-assembly
26         assembly { size := extcodesize(account) }
27         return size > 0;
28     }
29 }
30 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      * - Addition cannot overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot overflow.
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a, "SafeMath: subtraction overflow");
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the multiplication of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0, "SafeMath: division by zero");
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b != 0, "SafeMath: modulo by zero");
133         return a % b;
134     }
135 }
136 
137 contract ValidatorManagerContract {
138     using SafeMath for uint256;
139 
140     /// \frac{threshold_num}{threshold_denom} signatures are required for
141     /// validator approval to be granted
142     uint8 public threshold_num;
143     uint8 public threshold_denom;
144 
145     /// The list of currently elected validators
146     address[] public validators;
147 
148     /// The powers of the currently elected validators
149     uint64[] public powers;
150 
151     /// The current sum of powers of currently elected validators
152     uint256 public totalPower;
153 
154     /// Nonce tracking per to prevent replay attacks on signature
155     /// submission during validator rotation
156     uint256 public nonce;
157 
158     /// Address of the loom token
159     address public loomAddress;
160 
161     /// @notice  Event to log the change of the validator set.
162     /// @param  _validators The initial list of validators
163     /// @param  _powers The initial list of powers of each validator
164     event ValidatorSetChanged(address[] _validators, uint64[] _powers);
165 
166     /// @notice View function that returns the powers array.
167     /// @dev    Solidity should have exposed a getter function since the variable is declared public.
168     /// @return powers The powers of the currently elected validators
169     function getPowers() public view returns(uint64[] memory) {
170         return powers;
171     }
172 
173     /// @notice View function that returns the validators array.
174     /// @dev    Solidity should have exposed a getter function since the variable is declared public.
175     /// @return validators The currently elected validators
176     function getValidators() public view returns(address[] memory) {
177         return validators;
178     }
179 
180     /// @notice Initialization of the system
181     /// @param  _validators The initial list of validators
182     /// @param  _powers The initial list of powers of each validator
183     /// @param  _threshold_num The numerator of the fraction of power that needs
184     ///         to sign for a call to be approved by a validator
185     /// @param  _threshold_denom The denominator of the fraction of power that needs
186     ///         to sign for a call to be approved by a validator
187     /// @param  _loomAddress The LOOM token address
188     constructor (
189         address[] memory _validators,
190         uint64[] memory _powers,
191         uint8 _threshold_num,
192         uint8 _threshold_denom,
193         address _loomAddress
194     ) 
195         public 
196     {
197         threshold_num = _threshold_num;
198         threshold_denom = _threshold_denom;
199         require(threshold_num <= threshold_denom && threshold_num > 0, "Invalid threshold fraction.");
200         loomAddress = _loomAddress;
201         _rotateValidators(_validators, _powers);
202     }
203 
204     /// @notice Changes the loom token address. (requires signatures from at least `threshold_num/threshold_denom`
205     ///         validators, otherwise reverts)
206     /// @param  _loomAddress The new loom token address
207     /// @param  _signersIndexes Array of indexes of the validator's signatures based on
208     ///         the currently elected validators
209     /// @param  _v Array of `v` values from the validator signatures
210     /// @param  _r Array of `r` values from the validator signatures
211     /// @param  _s Array of `s` values from the validator signatures
212     function setLoom(
213         address _loomAddress,
214         uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
215         uint8[] calldata _v,
216         bytes32[] calldata _r,
217         bytes32[] calldata _s
218     ) 
219         external 
220     {
221         // Hash the address of the contract along with the nonce and the
222         // updated loom token address.
223         bytes32 message = createMessage(
224             keccak256(abi.encodePacked(_loomAddress))
225         );
226 
227         // Check if the signatures match the threshold set in the constructor
228         checkThreshold(message, _signersIndexes, _v, _r, _s);
229 
230         // Update state
231         loomAddress = _loomAddress;
232         nonce++;
233     }
234 
235     /// @notice Changes the threshold of signatures required to pass the
236     ///         validator signature check (requires signatures from at least `threshold_num/threshold_denom`
237     ///         validators, otherwise reverts)
238     /// @param  _num The new numerator
239     /// @param  _denom The new denominator
240     /// @param  _signersIndexes Array of indexes of the validator's signatures based on
241     ///         the currently elected validators
242     /// @param  _v Array of `v` values from the validator signatures
243     /// @param  _r Array of `r` values from the validator signatures
244     /// @param  _s Array of `s` values from the validator signatures
245     function setQuorum(
246         uint8 _num,
247         uint8 _denom,
248         uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
249         uint8[] calldata _v,
250         bytes32[] calldata _r,
251         bytes32[] calldata _s
252     ) 
253         external 
254     {
255         require(_num <= _denom && _num > 0, "Invalid threshold fraction");
256 
257         // Hash the address of the contract along with the nonce and the
258         // updated validator set.
259         bytes32 message = createMessage(
260             keccak256(abi.encodePacked(_num, _denom))
261         );
262 
263         // Check if the signatures match the threshold set in the consutrctor
264         checkThreshold(message, _signersIndexes, _v, _r, _s);
265 
266         threshold_num = _num;
267         threshold_denom = _denom;
268         nonce++;
269     }
270 
271     /// @notice Updates the validator set with new validators and powers
272     ///         (requires signatures from at least `threshold_num/threshold_denom`
273     ///         validators, otherwise reverts)
274     /// @param  _newValidators The new validator set
275     /// @param  _newPowers The new list of powers corresponding to the validator set
276     /// @param  _signersIndexes Array of indexes of the validator's signatures based on
277     ///         the currently elected validators
278     /// @param  _v Array of `v` values from the validator signatures
279     /// @param  _r Array of `r` values from the validator signatures
280     /// @param  _s Array of `s` values from the validator signatures
281     function rotateValidators(
282         address[] calldata _newValidators, 
283         uint64[] calldata  _newPowers,
284         uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
285         uint8[] calldata _v,
286         bytes32[] calldata _r,
287         bytes32[] calldata _s
288     ) 
289         external 
290     {
291         // Hash the address of the contract along with the nonce and the
292         // updated validator set and powers.
293         bytes32 message = createMessage(
294             keccak256(abi.encodePacked(_newValidators,_newPowers))
295         );
296 
297         // Check if the signatures match the threshold set in the consutrctor
298         checkThreshold(message, _signersIndexes, _v, _r, _s);
299 
300         // update validator set
301         _rotateValidators(_newValidators, _newPowers);
302         nonce++;
303     }
304 
305 
306     /// @notice Checks if the provided signature is valid on message by the
307     ///         validator corresponding to `signersIndex`. Reverts if check fails
308     /// @param  _message The messsage hash that was signed
309     /// @param  _signersIndex The validator's index in the `validators` array
310     /// @param  _v The v value of the validator's signature
311     /// @param  _r The r value of the validator's signature
312     /// @param  _s The s value of the validator's signature
313     function signedByValidator(
314         bytes32 _message,
315         uint256 _signersIndex,
316         uint8 _v,
317         bytes32 _r,
318         bytes32 _s
319     ) 
320         public 
321         view
322     {
323         // prevent replay attacks by adding the nonce in the sig
324         // if a validator signs an invalid nonce,
325         // it won't pass the signature verification
326         // since the nonce in the hash is stored in the contract
327         address signer = ecrecover(_message, _v, _r, _s);
328         require(validators[_signersIndex] == signer, "Message not signed by a validator");
329     }
330 
331     /// @notice Completes if the message being passed was signed by the required
332     ///         threshold of validators, otherwise reverts
333     /// @param  _signersIndexes Array of indexes of the validator's signatures based on
334     ///         the currently elected validators
335     /// @param  _v Array of `v` values from the validator signatures
336     /// @param  _r Array of `r` values from the validator signatures
337     /// @param  _s Array of `s` values from the validator signatures
338     function checkThreshold(bytes32 _message, uint256[] memory _signersIndexes, uint8[] memory _v, bytes32[] memory _r, bytes32[] memory _s) public view {
339         uint256 sig_length = _v.length;
340 
341         require(sig_length <= validators.length,
342                 "checkThreshold:: Cannot submit more signatures than existing validators"
343         );
344 
345         require(sig_length > 0 && sig_length == _r.length && _r.length == _s.length && sig_length == _signersIndexes.length,
346                 "checkThreshold:: Incorrect number of params"
347         );
348 
349         // Signed message prefix
350         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _message));
351 
352         // Get total voted power while making sure all signatures submitted
353         // were by validators without duplication
354         uint256 votedPower;
355         for (uint256 i = 0; i < sig_length; i++) {
356             if (i > 0) {
357                 require(_signersIndexes[i] > _signersIndexes[i-1]);
358             }
359 
360             // Skip malleable signatures / maybe better to revert instead of skipping?
361             if (uint256(_s[i]) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
362                 continue;
363             }
364             address signer = ecrecover(hash, _v[i], _r[i], _s[i]);
365             require(signer == validators[_signersIndexes[i]], "checkThreshold:: Recovered address is not a validator");
366 
367             votedPower = votedPower.add(powers[_signersIndexes[i]]);
368         }
369 
370         require(votedPower * threshold_denom >= totalPower *
371                 threshold_num, "checkThreshold:: Not enough power from validators");
372     }
373 
374 
375 
376     /// @notice Internal method that updates the state with the new validator
377     ///         set and powers, as well as the new total power
378     /// @param  _validators The initial list of validators
379     /// @param  _powers The initial list of powers of each validator
380     function _rotateValidators(address[] memory _validators, uint64[] memory _powers) internal {
381         uint256 val_length = _validators.length;
382 
383         require(val_length == _powers.length, "_rotateValidators: Array lengths do not match!");
384 
385         require(val_length > 0, "Must provide more than 0 validators");
386 
387         uint256 _totalPower = 0;
388         for (uint256 i = 0; i < val_length; i++) {
389             _totalPower = _totalPower.add(_powers[i]);
390         }
391 
392         // Set total power
393         totalPower = _totalPower;
394 
395         // Set validators and their powers
396         validators = _validators;
397         powers = _powers;
398 
399         emit ValidatorSetChanged(_validators, _powers);
400     }
401 
402     /// @notice Creates the message hash that includes replay protection and
403     ///         binds the hash to this contract only.
404     /// @param  hash The hash of the message being signed
405     /// @return A hash on the hash of the message
406     function createMessage(bytes32 hash)
407     private
408     view returns (bytes32)
409     {
410         return keccak256(
411             abi.encodePacked(
412                 address(this),
413                 nonce,
414                 hash
415             )
416         );
417     }
418 
419 }
420 
421 /**
422  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
423  * the optional functions; to access them see `ERC20Detailed`.
424  */
425 interface IERC20 {
426     /**
427      * @dev Returns the amount of tokens in existence.
428      */
429     function totalSupply() external view returns (uint256);
430 
431     /**
432      * @dev Returns the amount of tokens owned by `account`.
433      */
434     function balanceOf(address account) external view returns (uint256);
435 
436     /**
437      * @dev Moves `amount` tokens from the caller's account to `recipient`.
438      *
439      * Returns a boolean value indicating whether the operation succeeded.
440      *
441      * Emits a `Transfer` event.
442      */
443     function transfer(address recipient, uint256 amount) external returns (bool);
444 
445     /**
446      * @dev Returns the remaining number of tokens that `spender` will be
447      * allowed to spend on behalf of `owner` through `transferFrom`. This is
448      * zero by default.
449      *
450      * This value changes when `approve` or `transferFrom` are called.
451      */
452     function allowance(address owner, address spender) external view returns (uint256);
453 
454     /**
455      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
456      *
457      * Returns a boolean value indicating whether the operation succeeded.
458      *
459      * > Beware that changing an allowance with this method brings the risk
460      * that someone may use both the old and the new allowance by unfortunate
461      * transaction ordering. One possible solution to mitigate this race
462      * condition is to first reduce the spender's allowance to 0 and set the
463      * desired value afterwards:
464      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
465      *
466      * Emits an `Approval` event.
467      */
468     function approve(address spender, uint256 amount) external returns (bool);
469 
470     /**
471      * @dev Moves `amount` tokens from `sender` to `recipient` using the
472      * allowance mechanism. `amount` is then deducted from the caller's
473      * allowance.
474      *
475      * Returns a boolean value indicating whether the operation succeeded.
476      *
477      * Emits a `Transfer` event.
478      */
479     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
480 
481     /**
482      * @dev Emitted when `value` tokens are moved from one account (`from`) to
483      * another (`to`).
484      *
485      * Note that `value` may be zero.
486      */
487     event Transfer(address indexed from, address indexed to, uint256 value);
488 
489     /**
490      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
491      * a call to `approve`. `value` is the new allowance.
492      */
493     event Approval(address indexed owner, address indexed spender, uint256 value);
494 }
495 
496 /**
497  * @dev Implementation of the `IERC20` interface.
498  *
499  * This implementation is agnostic to the way tokens are created. This means
500  * that a supply mechanism has to be added in a derived contract using `_mint`.
501  * For a generic mechanism see `ERC20Mintable`.
502  *
503  * *For a detailed writeup see our guide [How to implement supply
504  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
505  *
506  * We have followed general OpenZeppelin guidelines: functions revert instead
507  * of returning `false` on failure. This behavior is nonetheless conventional
508  * and does not conflict with the expectations of ERC20 applications.
509  *
510  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
511  * This allows applications to reconstruct the allowance for all accounts just
512  * by listening to said events. Other implementations of the EIP may not emit
513  * these events, as it isn't required by the specification.
514  *
515  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
516  * functions have been added to mitigate the well-known issues around setting
517  * allowances. See `IERC20.approve`.
518  */
519 contract ERC20 is IERC20 {
520     using SafeMath for uint256;
521 
522     mapping (address => uint256) private _balances;
523 
524     mapping (address => mapping (address => uint256)) private _allowances;
525 
526     uint256 private _totalSupply;
527 
528     /**
529      * @dev See `IERC20.totalSupply`.
530      */
531     function totalSupply() public view returns (uint256) {
532         return _totalSupply;
533     }
534 
535     /**
536      * @dev See `IERC20.balanceOf`.
537      */
538     function balanceOf(address account) public view returns (uint256) {
539         return _balances[account];
540     }
541 
542     /**
543      * @dev See `IERC20.transfer`.
544      *
545      * Requirements:
546      *
547      * - `recipient` cannot be the zero address.
548      * - the caller must have a balance of at least `amount`.
549      */
550     function transfer(address recipient, uint256 amount) public returns (bool) {
551         _transfer(msg.sender, recipient, amount);
552         return true;
553     }
554 
555     /**
556      * @dev See `IERC20.allowance`.
557      */
558     function allowance(address owner, address spender) public view returns (uint256) {
559         return _allowances[owner][spender];
560     }
561 
562     /**
563      * @dev See `IERC20.approve`.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      */
569     function approve(address spender, uint256 value) public returns (bool) {
570         _approve(msg.sender, spender, value);
571         return true;
572     }
573 
574     /**
575      * @dev See `IERC20.transferFrom`.
576      *
577      * Emits an `Approval` event indicating the updated allowance. This is not
578      * required by the EIP. See the note at the beginning of `ERC20`;
579      *
580      * Requirements:
581      * - `sender` and `recipient` cannot be the zero address.
582      * - `sender` must have a balance of at least `value`.
583      * - the caller must have allowance for `sender`'s tokens of at least
584      * `amount`.
585      */
586     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
587         _transfer(sender, recipient, amount);
588         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
589         return true;
590     }
591 
592     /**
593      * @dev Atomically increases the allowance granted to `spender` by the caller.
594      *
595      * This is an alternative to `approve` that can be used as a mitigation for
596      * problems described in `IERC20.approve`.
597      *
598      * Emits an `Approval` event indicating the updated allowance.
599      *
600      * Requirements:
601      *
602      * - `spender` cannot be the zero address.
603      */
604     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
605         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
606         return true;
607     }
608 
609     /**
610      * @dev Atomically decreases the allowance granted to `spender` by the caller.
611      *
612      * This is an alternative to `approve` that can be used as a mitigation for
613      * problems described in `IERC20.approve`.
614      *
615      * Emits an `Approval` event indicating the updated allowance.
616      *
617      * Requirements:
618      *
619      * - `spender` cannot be the zero address.
620      * - `spender` must have allowance for the caller of at least
621      * `subtractedValue`.
622      */
623     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
624         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
625         return true;
626     }
627 
628     /**
629      * @dev Moves tokens `amount` from `sender` to `recipient`.
630      *
631      * This is internal function is equivalent to `transfer`, and can be used to
632      * e.g. implement automatic token fees, slashing mechanisms, etc.
633      *
634      * Emits a `Transfer` event.
635      *
636      * Requirements:
637      *
638      * - `sender` cannot be the zero address.
639      * - `recipient` cannot be the zero address.
640      * - `sender` must have a balance of at least `amount`.
641      */
642     function _transfer(address sender, address recipient, uint256 amount) internal {
643         require(sender != address(0), "ERC20: transfer from the zero address");
644         require(recipient != address(0), "ERC20: transfer to the zero address");
645 
646         _balances[sender] = _balances[sender].sub(amount);
647         _balances[recipient] = _balances[recipient].add(amount);
648         emit Transfer(sender, recipient, amount);
649     }
650 
651     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
652      * the total supply.
653      *
654      * Emits a `Transfer` event with `from` set to the zero address.
655      *
656      * Requirements
657      *
658      * - `to` cannot be the zero address.
659      */
660     function _mint(address account, uint256 amount) internal {
661         require(account != address(0), "ERC20: mint to the zero address");
662 
663         _totalSupply = _totalSupply.add(amount);
664         _balances[account] = _balances[account].add(amount);
665         emit Transfer(address(0), account, amount);
666     }
667 
668      /**
669      * @dev Destoys `amount` tokens from `account`, reducing the
670      * total supply.
671      *
672      * Emits a `Transfer` event with `to` set to the zero address.
673      *
674      * Requirements
675      *
676      * - `account` cannot be the zero address.
677      * - `account` must have at least `amount` tokens.
678      */
679     function _burn(address account, uint256 value) internal {
680         require(account != address(0), "ERC20: burn from the zero address");
681 
682         _totalSupply = _totalSupply.sub(value);
683         _balances[account] = _balances[account].sub(value);
684         emit Transfer(account, address(0), value);
685     }
686 
687     /**
688      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
689      *
690      * This is internal function is equivalent to `approve`, and can be used to
691      * e.g. set automatic allowances for certain subsystems, etc.
692      *
693      * Emits an `Approval` event.
694      *
695      * Requirements:
696      *
697      * - `owner` cannot be the zero address.
698      * - `spender` cannot be the zero address.
699      */
700     function _approve(address owner, address spender, uint256 value) internal {
701         require(owner != address(0), "ERC20: approve from the zero address");
702         require(spender != address(0), "ERC20: approve to the zero address");
703 
704         _allowances[owner][spender] = value;
705         emit Approval(owner, spender, value);
706     }
707 
708     /**
709      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
710      * from the caller's allowance.
711      *
712      * See `_burn` and `_approve`.
713      */
714     function _burnFrom(address account, uint256 amount) internal {
715         _burn(account, amount);
716         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
717     }
718 }
719 
720 /**
721  * @title ERC20 interface for token contracts deployed to mainnet that let Ethereum Gateway mint the token.
722  */
723 contract IERC20GatewayMintable is ERC20 {
724     // Called by the Ethereum Gateway contract to mint tokens.
725     //
726     // NOTE: the Ethereum gateway will call this method unconditionally.
727     function mintTo(address _to, uint256 _amount) public;
728 }
729 
730 /**
731  * @title SafeERC20
732  * @dev Wrappers around ERC20 operations that throw on failure (when the token
733  * contract returns false). Tokens that return no value (and instead revert or
734  * throw on failure) are also supported, non-reverting calls are assumed to be
735  * successful.
736  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
737  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
738  */
739 library SafeERC20 {
740     using SafeMath for uint256;
741     using Address for address;
742 
743     function safeTransfer(IERC20 token, address to, uint256 value) internal {
744         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
745     }
746 
747     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
748         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
749     }
750 
751     function safeApprove(IERC20 token, address spender, uint256 value) internal {
752         // safeApprove should only be called when setting an initial allowance,
753         // or when resetting it to zero. To increase and decrease it, use
754         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
755         // solhint-disable-next-line max-line-length
756         require((value == 0) || (token.allowance(address(this), spender) == 0),
757             "SafeERC20: approve from non-zero to non-zero allowance"
758         );
759         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
760     }
761 
762     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
763         uint256 newAllowance = token.allowance(address(this), spender).add(value);
764         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
765     }
766 
767     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
768         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
769         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
770     }
771 
772     /**
773      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
774      * on the return value: the return value is optional (but if data is returned, it must not be false).
775      * @param token The token targeted by the call.
776      * @param data The call data (encoded using abi.encode or one of its variants).
777      */
778     function callOptionalReturn(IERC20 token, bytes memory data) private {
779         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
780         // we're implementing it ourselves.
781 
782         // A Solidity high level call has three parts:
783         //  1. The target address is checked to verify it contains contract code
784         //  2. The call itself is made, and success asserted
785         //  3. The return value is decoded, which in turn checks the size of the returned data.
786         // solhint-disable-next-line max-line-length
787         require(address(token).isContract(), "SafeERC20: call to non-contract");
788 
789         // solhint-disable-next-line avoid-low-level-calls
790         (bool success, bytes memory returndata) = address(token).call(data);
791         require(success, "SafeERC20: low-level call failed");
792 
793         if (returndata.length > 0) { // Return data is optional
794             // solhint-disable-next-line max-line-length
795             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
796         }
797     }
798 }
799 
800 contract ERC20Gateway {
801     using SafeERC20 for IERC20;
802 
803   /// @notice Event to log the withdrawal of a token from the Gateway.
804   /// @param  owner Address of the entity that made the withdrawal.
805   /// @param  kind The type of token withdrawn (ERC20/ERC721/ETH).
806   /// @param  contractAddress Address of token contract the token belong to.
807   /// @param  value For ERC721 this is the uid of the token, for ETH/ERC20 this is the amount.
808   event TokenWithdrawn(address indexed owner, TokenKind kind, address contractAddress, uint256 value);
809 
810   /// @notice Event to log the deposit of a LOOM to the Gateway.
811   /// @param  from Address of the entity that made the withdrawal.
812   /// @param  amount The LOOM token amount that was deposited
813   /// @param  loomCoinAddress Address of the LOOM token
814   event LoomCoinReceived(address indexed from, uint256 amount, address loomCoinAddress);
815 
816   /// @notice Event to log the deposit of a ERC20 to the Gateway.
817   /// @param  from Address of the entity that made the withdrawal.
818   /// @param  amount The ERC20 token amount that was deposited
819   /// @param  contractAddress Address of the ERC20 token
820   event ERC20Received(address from, uint256 amount, address contractAddress);
821 
822   /// The LOOM token address
823   address public loomAddress;
824 
825   //  A boolean to enable and disable deposit and withdraw
826   bool isGatewayEnabled;
827 
828   /// Booleans to permit depositing arbitrary tokens to the gateways
829   bool allowAnyToken;
830   mapping (address => bool) public allowedTokens;
831 
832   // Contract deployer is the owner of this contract
833   address public owner;
834 
835   function getOwner() public view returns(address) {
836     return owner;
837   }
838 
839   function getAllowAnyToken() public view returns(bool) {
840     return allowAnyToken;
841   }
842 
843   /// The nonces per withdrawer to prevent replays
844   mapping (address => uint256) public nonces;
845 
846   /// The Validator Manager Contract
847   ValidatorManagerContract public vmc;
848 
849   /// Enum for the various types of each token to notify clients during
850   /// deposits and withdrawals
851   enum TokenKind {
852     ETH,
853     ERC20,
854     ERC721,
855     ERC721X,
856     LoomCoin
857   }
858 
859   /// @notice Initialize the contract with the VMC
860   /// @param _vmc the validator manager contrct address
861   constructor(ValidatorManagerContract _vmc) public {
862     vmc = _vmc;
863     loomAddress = vmc.loomAddress();
864     owner = msg.sender;
865     isGatewayEnabled = true; // enable gateway by default
866     allowAnyToken = true; // enable depositing arbitrary tokens by default
867   }
868 
869   /// @notice Function to withdraw ERC20 tokens from the Gateway. Emits a
870   /// ERC20Withdrawn event, or a LoomCoinWithdrawn event if the coin is LOOM
871   /// token, according to the ValidatorManagerContract. If withdrawal amount is more than current balance,
872   /// it will try to mint the token to user.
873   /// @param  amount The amount being withdrawn
874   /// @param  contractAddress The address of the token being withdrawn
875   /// @param  _signersIndexes Array of indexes of the validator's signatures based on
876   ///         the currently elected validators
877   /// @param  _v Array of `v` values from the validator signatures
878   /// @param  _r Array of `r` values from the validator signatures
879   /// @param  _s Array of `s` values from the validator signatures
880   function withdrawERC20(
881       uint256 amount,
882       address contractAddress,
883       uint256[] calldata _signersIndexes,
884       uint8[] calldata _v,
885       bytes32[] calldata _r,
886       bytes32[] calldata _s
887   )
888     gatewayEnabled
889     external
890   {
891     bytes32 message = createMessageWithdraw(
892             "\x10Withdraw ERC20:\n",
893             keccak256(abi.encodePacked(amount, contractAddress))
894     );
895 
896     // Ensure enough power has signed the withdrawal
897     vmc.checkThreshold(message, _signersIndexes, _v, _r, _s);
898 
899     // Replay protection
900     nonces[msg.sender]++;
901 
902     uint256 bal = IERC20(contractAddress).balanceOf(address(this));
903     if (bal < amount) {
904       IERC20GatewayMintable(contractAddress).mintTo(address(this), amount - bal);
905     }
906     IERC20(contractAddress).safeTransfer(msg.sender, amount);
907     
908     emit TokenWithdrawn(msg.sender, contractAddress == loomAddress ? TokenKind.LoomCoin : TokenKind.ERC20, contractAddress, amount);
909   }
910 
911   // Approve and Deposit function for 2-step deposits
912   // Requires first to have called `approve` on the specified ERC20 contract
913   function depositERC20(uint256 amount, address contractAddress) gatewayEnabled external {
914     IERC20(contractAddress).safeTransferFrom(msg.sender, address(this), amount);
915 
916     emit ERC20Received(msg.sender, amount, contractAddress);
917     if (contractAddress == loomAddress) {
918         emit LoomCoinReceived(msg.sender, amount, contractAddress);
919     }
920   }
921 
922   function getERC20(address contractAddress) external view returns (uint256) {
923       return IERC20(contractAddress).balanceOf(address(this));
924   }
925 
926     /// @notice Creates the message hash that includes replay protection and
927     ///         binds the hash to this contract only.
928     /// @param  hash The hash of the message being signed
929     /// @return A hash on the hash of the message
930   function createMessageWithdraw(string memory prefix, bytes32 hash)
931     internal
932     view
933     returns (bytes32)
934   {
935     return keccak256(
936       abi.encodePacked(
937         prefix,
938         msg.sender,
939         nonces[msg.sender],
940         address(this),
941         hash
942       )
943     );
944   }
945 
946   modifier gatewayEnabled() {
947     require(isGatewayEnabled, "Gateway is disabled.");
948     _;
949   }
950 
951   /// @notice The owner can toggle allowing any token to be deposited / withdrawn from or to gateway
952   /// @param enable a boolean value to enable or disable gateway
953   function enableGateway(bool enable) public {
954     require(msg.sender == owner, "enableGateway: only owner can enable or disable gateway");
955     isGatewayEnabled = enable;
956   }
957 
958   /// @notice Checks if the gateway allows deposits & withdrawals.
959   /// @return true if deposits and withdrawals are allowed, false otherwise.
960   function getGatewayEnabled() public view returns(bool) {
961     return isGatewayEnabled;
962   }
963 
964   /// @notice Checks if a token at `tokenAddress` is allowed
965   /// @param  tokenAddress The token's address
966   /// @return True if `allowAnyToken` is set, or if the token has been allowed
967   function isTokenAllowed(address tokenAddress) public view returns(bool) {
968     return allowAnyToken || allowedTokens[tokenAddress];
969   }
970 
971   /// @notice The owner can toggle allowing any token to be deposited on
972   ///         the sidechain
973   /// @param allow Boolean to allow or not the token
974   function toggleAllowAnyToken(bool allow) public {
975     require(msg.sender == owner, "toggleAllowAnyToken: only owner can toggle");
976     allowAnyToken = allow;
977   }
978 
979   /// @notice The owner can toggle allowing a token to be deposited on
980   ///         the sidechain
981   /// @param  tokenAddress The token address
982   /// @param  allow Boolean to allow or not the token
983   function toggleAllowToken(address tokenAddress, bool allow) public {
984     require(msg.sender == owner, "toggleAllowToken: only owner can toggle");
985     allowedTokens[tokenAddress] = allow;
986   }
987 
988 }