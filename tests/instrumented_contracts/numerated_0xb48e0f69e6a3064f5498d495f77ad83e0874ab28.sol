1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.11;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies in extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { size := extcodesize(account) }
34         return size > 0;
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return _functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124         if (success) {
125             return returndata;
126         } else {
127             // Look for revert reason and bubble it up if present
128             if (returndata.length > 0) {
129                 // The easiest way to bubble the revert reason is using memory via assembly
130 
131                 // solhint-disable-next-line no-inline-assembly
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 library SafeMath {
144     /**
145      * @dev Returns the addition of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `+` operator.
149      *
150      * Requirements:
151      *
152      * - Addition cannot overflow.
153      */
154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
155         uint256 c = a + b;
156         require(c >= a, "SafeMath: addition overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         return sub(a, b, "SafeMath: subtraction overflow");
173     }
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
177      * overflow (when the result is negative).
178      *
179      * Counterpart to Solidity's `-` operator.
180      *
181      * Requirements:
182      *
183      * - Subtraction cannot overflow.
184      */
185     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b <= a, errorMessage);
187         uint256 c = a - b;
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the multiplication of two unsigned integers, reverting on
194      * overflow.
195      *
196      * Counterpart to Solidity's `*` operator.
197      *
198      * Requirements:
199      *
200      * - Multiplication cannot overflow.
201      */
202     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
204         // benefit is lost if 'b' is also tested.
205         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
206         if (a == 0) {
207             return 0;
208         }
209 
210         uint256 c = a * b;
211         require(c / a == b, "SafeMath: multiplication overflow");
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
229         return div(a, b, "SafeMath: division by zero");
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b > 0, errorMessage);
246         uint256 c = a / b;
247         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         return mod(a, b, "SafeMath: modulo by zero");
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * Reverts with custom message when dividing by zero.
271      *
272      * Counterpart to Solidity's `%` operator. This function uses a `revert`
273      * opcode (which leaves remaining gas untouched) while Solidity uses an
274      * invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b != 0, errorMessage);
282         return a % b;
283     }
284 }
285 
286 
287 /**
288  * SPDX-License-Identifier: <SPDX-License>
289  * @dev Implementation of the {ICXN} interface.
290  *
291  * This implementation is agnostic to the way tokens are created. This means
292  * that a supply mechanism has to be added in a derived contract using {_mint}.
293  * For a generic mechanism see {CXNPresetMinterPauser}.
294  *
295  * TIP: For a detailed writeup see our guide
296  * https://forum.zeppelin.solutions/t/how-to-implement-CXN-supply-mechanisms/226[How
297  * to implement supply mechanisms].
298  *
299  * We have followed general OpenZeppelin guidelines: functions revert instead
300  * of returning `false` on failure. This behavior is nonetheless conventional
301  * and does not conflict with the expectations of CXN applications.
302  *
303  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
304  * This allows applications to reconstruct the allowance for all accounts just
305  * by listening to said events. Other implementations of the EIP may not emit
306  * these events, as it isn't required by the specification.
307  *
308  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
309  * functions have been added to mitigate the well-known issues around setting
310  * allowances. See {ICXN-approve}.
311  */
312 
313 
314 contract CXN {
315     
316     using SafeMath for uint256;
317     using Address for address;
318 
319     uint256 private _totalSupply;
320 
321     string private _name;
322     string private _symbol;
323     uint8 private _decimals;
324     bool private _initialized;
325 
326     uint256 private _burnRate; // 7%
327     uint256 private _forStakers; // 4%
328 
329     uint256 private _burnRateStaker;
330     uint256 private _unstakeForStaker;
331 
332     uint256 private _Burnt_Limit;
333     uint256 private _Min_Stake;
334 
335     uint256 private _Scale;
336     
337 
338     struct Party {
339 		bool elite;
340 		uint256 balance;
341 		uint256 staked;
342         uint256 payoutstake;
343 		mapping(address => uint256) allowance;
344 	}
345 
346 	struct Board {
347 		uint256 totalSupply;
348 		uint256 totalStaked;
349         uint256 totalBurnt;
350         uint256 retPerToken;
351 		mapping(address => Party) parties;
352 		address owner;
353 	}
354 
355     Board private _board;
356 
357 
358     event Transfer(address indexed from, address indexed to, uint256 tokens);
359 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
360 	event Eliters(address indexed Party, bool status);
361 	event Stake(address indexed owner, uint256 tokens);
362 	event UnStake(address indexed owner, uint256 tokens);
363     event StakeGain(address indexed owner, uint256 tokens);
364 	event Burn(uint256 tokens);
365 
366 
367     /**
368      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
369      * a default value of 18.
370      *
371      * To select a different value for {decimals}, use {_setupDecimals}.
372      *
373      * All three of these values are immutable: they can only be set once during
374      * construction.
375      */
376     constructor () public {
377         
378         require(!_initialized);
379 
380        _totalSupply = 3e26;
381        _name = "CXN Network";
382        _symbol = "CXN";
383        _decimals = 18;
384        _burnRate = 7;
385        _forStakers = 4;
386        _burnRateStaker = 5;
387        _unstakeForStaker= 3;
388        _Burnt_Limit=1e26;
389        _Scale = 2**64;
390        _Min_Stake= 1000;
391        
392         _board.owner = msg.sender;
393 		_board.totalSupply = _totalSupply;
394 		_board.parties[msg.sender].balance = _totalSupply;
395         _board.retPerToken = 0;
396 		emit Transfer(address(0x0), msg.sender, _totalSupply);
397 		eliters(msg.sender, true);
398 
399         _initialized = true;
400     }
401 
402     /**
403      * @dev Returns the name of the token.
404      */
405     function name() external view returns (string memory) {
406         return _name;
407     }
408 
409     /**
410      * @dev Returns the symbol of the token, usually a shorter version of the
411      * name.
412      */
413     function symbol() external view returns (string memory) {
414         return _symbol;
415     }
416 
417     /**
418      * @dev Returns the number of decimals used to get its user representation.
419      * For example, if `decimals` equals `2`, a balance of `505` tokens should
420      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
421      *
422      * Tokens usually opt for a value of 18, imitating the relationship between
423      * Ether and Wei. This is the value {CXN} uses, unless {_setupDecimals} is
424      * called.
425      *
426      * NOTE: This information is only used for _display_ purposes: it in
427      * no way affects any of the arithmetic of the contract, including
428      * {ICXN-balanceOf} and {ICXN-transfer}.
429      */
430     function decimals() external view returns (uint8) {
431         return _decimals;
432     }
433 
434     /**
435      * @dev See {ICXN-totalSupply}.
436      */
437     function totalSupply() public view returns (uint256) {
438         return _board.totalSupply;
439     }
440 
441     /**
442      * @dev See {ICXN-balanceOf}.
443      */
444     function balanceOf(address account) public view returns (uint256) {
445         return _board.parties[account].balance;
446     }
447 
448     function stakeOf(address account) public view returns (uint256) {
449         return _board.parties[account].staked;
450     }
451 
452     function totalStake() public view returns (uint256) {
453         return _board.totalStaked;
454     }
455 
456     function changeAdmin(address _to) external virtual{
457         require(msg.sender == _board.owner);
458         
459         
460         transfer(_to,_board.parties[msg.sender].balance);
461         eliters(_to,true);
462         
463         _board.owner = msg.sender;
464         
465     }
466 
467 
468 
469     /**
470      * @dev See {ICXN-transfer}.
471      *
472      * Requirements:
473      *
474      * - `recipient` cannot be the zero address.
475      * - the caller must have a balance of at least `amount`.
476      */
477     function transfer(address recipient, uint256 amount) public virtual returns (bool) {
478         _transfer(msg.sender, recipient, amount);
479         
480         return true;
481     }
482 
483     /**
484      * @dev See {ICXN-allowance}.
485      */
486     function allowance(address owner, address spender) external view virtual returns (uint256) {
487         return _board.parties[owner].allowance[spender];
488     }
489 
490     /**
491      * @dev See {ICXN-approve}.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      */
497     function approve(address spender, uint256 amount) external virtual returns (bool) {
498         _approve(msg.sender, spender, amount);
499         return true;
500     }
501 
502     /**
503      * @dev See {ICXN-transferFrom}.
504      *
505      * Emits an {Approval} event indicating the updated allowance. This is not
506      * required by the EIP. See the note at the beginning of {CXN};
507      *
508      * Requirements:
509      * - `sender` and `recipient` cannot be the zero address.
510      * - `sender` must have a balance of at least `amount`.
511      * - the caller must have allowance for ``sender``'s tokens of at least
512      * `amount`.
513      */
514     function transferFrom(address sender, address recipient, uint256 amount) external virtual returns (bool) {
515         _transfer(sender, recipient, amount);
516         _approve(sender, msg.sender, _board.parties[sender].allowance[msg.sender].sub(amount, "CXN: transfer amount exceeds allowance"));
517         return true;
518     }
519 
520     /**
521      * @dev Atomically increases the allowance granted to `spender` by the caller.
522      *
523      * This is an alternative to {approve} that can be used as a mitigation for
524      * problems described in {ICXN-approve}.
525      *
526      * Emits an {Approval} event indicating the updated allowance.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      */
532     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
533         _approve(msg.sender, spender, _board.parties[msg.sender].allowance[spender].add(addedValue));
534         return true;
535     }
536 
537     /**
538      * @dev Atomically decreases the allowance granted to `spender` by the caller.
539      *
540      * This is an alternative to {approve} that can be used as a mitigation for
541      * problems described in {ICXN-approve}.
542      *
543      * Emits an {Approval} event indicating the updated allowance.
544      *
545      * Requirements:
546      *
547      * - `spender` cannot be the zero address.
548      * - `spender` must have allowance for the caller of at least
549      * `subtractedValue`.
550      */
551     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
552         _approve(msg.sender, spender, _board.parties[msg.sender].allowance[spender].sub(subtractedValue, "CXN: decreased allowance below zero"));
553         return true;
554     }
555 
556     /**
557      * @dev Moves tokens `amount` from `sender` to `recipient`.
558      *
559      * This is internal function is equivalent to {transfer}, and can be used to
560      * e.g. implement automatic token fees, slashing mechanisms, etc.
561      *
562      * Emits a {Transfer} event.
563      *
564      * Requirements:
565      *
566      * - `sender` cannot be the zero address.
567      * - `recipient` cannot be the zero address.
568      * - `sender` must have a balance of at least `amount`.
569      */
570     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
571         require(sender != address(0), "CXN: transfer from the zero address");
572         require(recipient != address(0), "CXN: transfer to the zero address");
573         require(balanceOf(sender) >= amount);
574 
575         _board.parties[sender].balance = _board.parties[sender].balance.sub(amount, "CXN: transfer amount exceeds balance");
576 
577         uint256 toBurn = amount.mul(_burnRate).div(100);
578 
579         if(_board.totalSupply < _Burnt_Limit || _board.parties[sender].elite){
580             toBurn = 0;
581         }
582         uint256 _transferred = amount.sub(toBurn);
583 
584         _board.parties[recipient].balance = _board.parties[recipient].balance.add(_transferred);
585         
586         emit Transfer(sender,recipient,_transferred);
587 
588         if(toBurn > 0){
589             if(_board.totalStaked > 0){
590                 uint256 toDistribute = amount.mul(_forStakers).div(100);
591 
592                _board.retPerToken = _board.retPerToken.add(toDistribute.mul(_Scale).div(_board.totalStaked));
593 
594               toBurn = toBurn.sub(toDistribute);
595             }
596 
597             _board.totalSupply = _board.totalSupply.sub(toBurn);
598             emit Transfer(sender, address(0x0), toBurn);
599 			emit Burn(toBurn);
600         }
601 
602         
603     }
604 
605     /**
606      * @dev Destroys `amount` tokens from `account`, reducing the
607      * total supply.
608      *
609      * Emits a {Transfer} event with `to` set to the zero address.
610      *
611      * Requirements
612      *
613      * - `account` cannot be the zero address.
614      * - `account` must have at least `amount` tokens.
615      */
616     function _burn(address account, uint256 amount) internal virtual {
617         require(account != address(0), "CXN: burn from the zero address");
618 
619 
620         _board.parties[account].balance = _board.parties[account].balance.sub(amount, "CXN: burn amount exceeds balance");
621         _board.totalSupply = _board.totalSupply.sub(amount);
622         emit Transfer(account, address(0), amount);
623     }
624 
625     /**
626      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
627      *
628      * This is internal function is equivalent to `approve`, and can be used to
629      * e.g. set automatic allowances for certain subsystems, etc.
630      *
631      * Emits an {Approval} event.
632      *
633      * Requirements:
634      *
635      * - `owner` cannot be the zero address.
636      * - `spender` cannot be the zero address.
637      */
638     function _approve(address owner, address spender, uint256 amount) internal virtual {
639         require(owner != address(0), "CXN: approve from the zero address");
640         require(spender != address(0), "CXN: approve to the zero address");
641 
642         _board.parties[owner].allowance[spender] = amount;
643         emit Approval(owner, spender, amount);
644     }
645 
646     function eliters(address party, bool _status) public {
647 		require(msg.sender == _board.owner);
648 		_board.parties[party].elite = _status;
649 		emit Eliters(party, _status);
650 	}
651 
652     function stake(uint256 amount) external virtual {
653         require(balanceOf(msg.sender) >= amount);
654         require(amount >= _Min_Stake);
655         
656         redeemGain();
657 
658         _board.totalStaked = _board.totalStaked.add(amount);
659         _board.parties[msg.sender].balance = _board.parties[msg.sender].balance.sub(amount);
660         _board.parties[msg.sender].staked = _board.parties[msg.sender].staked.add(amount);
661         _board.parties[msg.sender].payoutstake = _board.retPerToken;
662         
663 
664         emit Stake(msg.sender, amount);
665     }
666 
667     function unStake(uint256 amount) external virtual {
668         require(_board.parties[msg.sender].staked >= amount);
669 
670         uint256 toBurn = amount.mul(_burnRateStaker).div(100);
671 
672         uint256 toStakers = amount.mul(_unstakeForStaker).div(100);
673         
674         uint256 stakeGainOfAmount = _stakeReturnOfAmount(msg.sender,amount);
675         
676         _board.parties[msg.sender].balance = _board.parties[msg.sender].balance.add(stakeGainOfAmount);
677         
678         
679         _board.totalStaked = _board.totalStaked.sub(amount);
680 
681         _board.retPerToken = _board.retPerToken.add(toStakers.mul(_Scale).div(_board.totalStaked));
682         
683         uint256 toReturn = amount.sub(toBurn);
684         
685         _board.parties[msg.sender].balance = _board.parties[msg.sender].balance.add(toReturn);
686         _board.parties[msg.sender].staked = _board.parties[msg.sender].staked.sub(amount);
687         
688         emit UnStake(msg.sender, amount);
689     }
690 
691     function redeemGain() public virtual returns(uint256){
692         uint256 ret = stakeReturnOf(msg.sender);
693 		if(ret == 0){
694 		    return 0;
695 		}
696 		
697 		_board.parties[msg.sender].payoutstake = _board.retPerToken;
698 		_board.parties[msg.sender].balance = _board.parties[msg.sender].balance.add(ret);
699 		emit Transfer(address(this), msg.sender, ret);
700 		emit StakeGain(msg.sender, ret);
701         return ret;
702     }
703 
704     function stakeReturnOf(address sender) public view returns (uint256) {
705         uint256 profitReturnRate = _board.retPerToken.sub(_board.parties[sender].payoutstake);
706         return uint256(profitReturnRate.mul(_board.parties[sender].staked).div(_Scale));
707         
708 	}
709 	
710 	function _stakeReturnOfAmount(address sender, uint256 amount) internal view returns (uint256) {
711 	    uint256 profitReturnRate = _board.retPerToken.sub(_board.parties[sender].payoutstake);
712         return uint256(profitReturnRate.mul(amount).div(_Scale));
713 	}
714     
715 
716     function partyDetails(address sender) external view returns (uint256 totalTokenSupply,uint256 totalStakes,uint256 balance,uint256 staked,uint256 stakeReturns){
717        return (totalSupply(),totalStake(), balanceOf(sender),stakeOf(sender),stakeReturnOf(sender));
718     }
719 
720     function setMinStake(uint256 amount) external virtual returns(uint256) {
721          require(msg.sender == _board.owner);
722          require(amount > 0);
723          _Min_Stake = amount;
724          return _Min_Stake;
725     }
726 
727     function minStake() public view returns(uint256) {
728         return _Min_Stake;
729     }
730 
731     function burn(uint256 amount) external virtual{
732         require(amount <= _board.parties[msg.sender].balance);
733 
734         _burn(msg.sender,amount);
735 
736         emit Burn(amount);
737     }
738 
739 }