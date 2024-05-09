1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 // SPDX-License-Identifier: Business Source License 1.1 see LICENSE.txt AND MIT
3 
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 
101 // File contracts/libraries/PLPAPIInterface.sol
102 
103 pragma solidity ^0.8.0;
104 
105 // PLP API
106 interface PLPAPIInterface {
107     function getSellQuote(address inputToken, address outputToken, uint256 sellAmount) external view returns (uint256 outputTokenAmount);
108     function sellTokenForToken(address inputToken, address outputToken, address recipient, uint256 minBuyAmount, bytes calldata auxiliaryData) external returns (uint256 boughtAmount);
109     function sellEthForToken(address outputToken, address recipient, uint256 minBuyAmount, bytes calldata auxiliaryData) external payable returns (uint256 boughtAmount);
110     function sellTokenForEth(address inputToken, address payable recipient, uint256 minBuyAmount, bytes calldata auxiliaryData) external returns (uint256 boughtAmount);
111 }
112 
113 
114 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Returns the remaining number of tokens that `spender` will be
143      * allowed to spend on behalf of `owner` through {transferFrom}. This is
144      * zero by default.
145      *
146      * This value changes when {approve} or {transferFrom} are called.
147      */
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184 
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to {approve}. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 
193 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.1.0
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Interface for the optional metadata functions from the ERC20 standard.
199  *
200  * _Available since v4.1._
201  */
202 interface IERC20Metadata is IERC20 {
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the symbol of the token.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the decimals places of the token.
215      */
216     function decimals() external view returns (uint8);
217 }
218 
219 
220 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.1.0
221 
222 pragma solidity ^0.8.0;
223 
224 
225 
226 /**
227  * @dev Implementation of the {IERC20} interface.
228  *
229  * This implementation is agnostic to the way tokens are created. This means
230  * that a supply mechanism has to be added in a derived contract using {_mint}.
231  * For a generic mechanism see {ERC20PresetMinterPauser}.
232  *
233  * TIP: For a detailed writeup see our guide
234  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
235  * to implement supply mechanisms].
236  *
237  * We have followed general OpenZeppelin guidelines: functions revert instead
238  * of returning `false` on failure. This behavior is nonetheless conventional
239  * and does not conflict with the expectations of ERC20 applications.
240  *
241  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
242  * This allows applications to reconstruct the allowance for all accounts just
243  * by listening to said events. Other implementations of the EIP may not emit
244  * these events, as it isn't required by the specification.
245  *
246  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
247  * functions have been added to mitigate the well-known issues around setting
248  * allowances. See {IERC20-approve}.
249  */
250 contract ERC20 is Context, IERC20, IERC20Metadata {
251     mapping (address => uint256) private _balances;
252 
253     mapping (address => mapping (address => uint256)) private _allowances;
254 
255     uint256 private _totalSupply;
256 
257     string private _name;
258     string private _symbol;
259 
260     /**
261      * @dev Sets the values for {name} and {symbol}.
262      *
263      * The defaut value of {decimals} is 18. To select a different value for
264      * {decimals} you should overload it.
265      *
266      * All two of these values are immutable: they can only be set once during
267      * construction.
268      */
269     constructor (string memory name_, string memory symbol_) {
270         _name = name_;
271         _symbol = symbol_;
272     }
273 
274     /**
275      * @dev Returns the name of the token.
276      */
277     function name() public view virtual override returns (string memory) {
278         return _name;
279     }
280 
281     /**
282      * @dev Returns the symbol of the token, usually a shorter version of the
283      * name.
284      */
285     function symbol() public view virtual override returns (string memory) {
286         return _symbol;
287     }
288 
289     /**
290      * @dev Returns the number of decimals used to get its user representation.
291      * For example, if `decimals` equals `2`, a balance of `505` tokens should
292      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
293      *
294      * Tokens usually opt for a value of 18, imitating the relationship between
295      * Ether and Wei. This is the value {ERC20} uses, unless this function is
296      * overridden;
297      *
298      * NOTE: This information is only used for _display_ purposes: it in
299      * no way affects any of the arithmetic of the contract, including
300      * {IERC20-balanceOf} and {IERC20-transfer}.
301      */
302     function decimals() public view virtual override returns (uint8) {
303         return 18;
304     }
305 
306     /**
307      * @dev See {IERC20-totalSupply}.
308      */
309     function totalSupply() public view virtual override returns (uint256) {
310         return _totalSupply;
311     }
312 
313     /**
314      * @dev See {IERC20-balanceOf}.
315      */
316     function balanceOf(address account) public view virtual override returns (uint256) {
317         return _balances[account];
318     }
319 
320     /**
321      * @dev See {IERC20-transfer}.
322      *
323      * Requirements:
324      *
325      * - `recipient` cannot be the zero address.
326      * - the caller must have a balance of at least `amount`.
327      */
328     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
329         _transfer(_msgSender(), recipient, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See {IERC20-allowance}.
335      */
336     function allowance(address owner, address spender) public view virtual override returns (uint256) {
337         return _allowances[owner][spender];
338     }
339 
340     /**
341      * @dev See {IERC20-approve}.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function approve(address spender, uint256 amount) public virtual override returns (bool) {
348         _approve(_msgSender(), spender, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See {IERC20-transferFrom}.
354      *
355      * Emits an {Approval} event indicating the updated allowance. This is not
356      * required by the EIP. See the note at the beginning of {ERC20}.
357      *
358      * Requirements:
359      *
360      * - `sender` and `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      * - the caller must have allowance for ``sender``'s tokens of at least
363      * `amount`.
364      */
365     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
366         _transfer(sender, recipient, amount);
367 
368         uint256 currentAllowance = _allowances[sender][_msgSender()];
369         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
370         _approve(sender, _msgSender(), currentAllowance - amount);
371 
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
407         uint256 currentAllowance = _allowances[_msgSender()][spender];
408         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
409         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
410 
411         return true;
412     }
413 
414     /**
415      * @dev Moves tokens `amount` from `sender` to `recipient`.
416      *
417      * This is internal function is equivalent to {transfer}, and can be used to
418      * e.g. implement automatic token fees, slashing mechanisms, etc.
419      *
420      * Emits a {Transfer} event.
421      *
422      * Requirements:
423      *
424      * - `sender` cannot be the zero address.
425      * - `recipient` cannot be the zero address.
426      * - `sender` must have a balance of at least `amount`.
427      */
428     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
429         require(sender != address(0), "ERC20: transfer from the zero address");
430         require(recipient != address(0), "ERC20: transfer to the zero address");
431 
432         _beforeTokenTransfer(sender, recipient, amount);
433 
434         uint256 senderBalance = _balances[sender];
435         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
436         _balances[sender] = senderBalance - amount;
437         _balances[recipient] += amount;
438 
439         emit Transfer(sender, recipient, amount);
440     }
441 
442     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
443      * the total supply.
444      *
445      * Emits a {Transfer} event with `from` set to the zero address.
446      *
447      * Requirements:
448      *
449      * - `to` cannot be the zero address.
450      */
451     function _mint(address account, uint256 amount) internal virtual {
452         require(account != address(0), "ERC20: mint to the zero address");
453 
454         _beforeTokenTransfer(address(0), account, amount);
455 
456         _totalSupply += amount;
457         _balances[account] += amount;
458         emit Transfer(address(0), account, amount);
459     }
460 
461     /**
462      * @dev Destroys `amount` tokens from `account`, reducing the
463      * total supply.
464      *
465      * Emits a {Transfer} event with `to` set to the zero address.
466      *
467      * Requirements:
468      *
469      * - `account` cannot be the zero address.
470      * - `account` must have at least `amount` tokens.
471      */
472     function _burn(address account, uint256 amount) internal virtual {
473         require(account != address(0), "ERC20: burn from the zero address");
474 
475         _beforeTokenTransfer(account, address(0), amount);
476 
477         uint256 accountBalance = _balances[account];
478         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
479         _balances[account] = accountBalance - amount;
480         _totalSupply -= amount;
481 
482         emit Transfer(account, address(0), amount);
483     }
484 
485     /**
486      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
487      *
488      * This internal function is equivalent to `approve`, and can be used to
489      * e.g. set automatic allowances for certain subsystems, etc.
490      *
491      * Emits an {Approval} event.
492      *
493      * Requirements:
494      *
495      * - `owner` cannot be the zero address.
496      * - `spender` cannot be the zero address.
497      */
498     function _approve(address owner, address spender, uint256 amount) internal virtual {
499         require(owner != address(0), "ERC20: approve from the zero address");
500         require(spender != address(0), "ERC20: approve to the zero address");
501 
502         _allowances[owner][spender] = amount;
503         emit Approval(owner, spender, amount);
504     }
505 
506     /**
507      * @dev Hook that is called before any transfer of tokens. This includes
508      * minting and burning.
509      *
510      * Calling conditions:
511      *
512      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
513      * will be to transferred to `to`.
514      * - when `from` is zero, `amount` tokens will be minted for `to`.
515      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
516      * - `from` and `to` are never both zero.
517      *
518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
519      */
520     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
521 }
522 
523 
524 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Collection of functions related to the address type
530  */
531 library Address {
532     /**
533      * @dev Returns true if `account` is a contract.
534      *
535      * [IMPORTANT]
536      * ====
537      * It is unsafe to assume that an address for which this function returns
538      * false is an externally-owned account (EOA) and not a contract.
539      *
540      * Among others, `isContract` will return false for the following
541      * types of addresses:
542      *
543      *  - an externally-owned account
544      *  - a contract in construction
545      *  - an address where a contract will be created
546      *  - an address where a contract lived, but was destroyed
547      * ====
548      */
549     function isContract(address account) internal view returns (bool) {
550         // This method relies on extcodesize, which returns 0 for contracts in
551         // construction, since the code is only stored at the end of the
552         // constructor execution.
553 
554         uint256 size;
555         // solhint-disable-next-line no-inline-assembly
556         assembly { size := extcodesize(account) }
557         return size > 0;
558     }
559 
560     /**
561      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
562      * `recipient`, forwarding all available gas and reverting on errors.
563      *
564      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
565      * of certain opcodes, possibly making contracts go over the 2300 gas limit
566      * imposed by `transfer`, making them unable to receive funds via
567      * `transfer`. {sendValue} removes this limitation.
568      *
569      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
570      *
571      * IMPORTANT: because control is transferred to `recipient`, care must be
572      * taken to not create reentrancy vulnerabilities. Consider using
573      * {ReentrancyGuard} or the
574      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
575      */
576     function sendValue(address payable recipient, uint256 amount) internal {
577         require(address(this).balance >= amount, "Address: insufficient balance");
578 
579         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
580         (bool success, ) = recipient.call{ value: amount }("");
581         require(success, "Address: unable to send value, recipient may have reverted");
582     }
583 
584     /**
585      * @dev Performs a Solidity function call using a low level `call`. A
586      * plain`call` is an unsafe replacement for a function call: use this
587      * function instead.
588      *
589      * If `target` reverts with a revert reason, it is bubbled up by this
590      * function (like regular Solidity function calls).
591      *
592      * Returns the raw returned data. To convert to the expected return value,
593      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
594      *
595      * Requirements:
596      *
597      * - `target` must be a contract.
598      * - calling `target` with `data` must not revert.
599      *
600      * _Available since v3.1._
601      */
602     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
603       return functionCall(target, data, "Address: low-level call failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
608      * `errorMessage` as a fallback revert reason when `target` reverts.
609      *
610      * _Available since v3.1._
611      */
612     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
613         return functionCallWithValue(target, data, 0, errorMessage);
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
618      * but also transferring `value` wei to `target`.
619      *
620      * Requirements:
621      *
622      * - the calling contract must have an ETH balance of at least `value`.
623      * - the called Solidity function must be `payable`.
624      *
625      * _Available since v3.1._
626      */
627     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
628         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
633      * with `errorMessage` as a fallback revert reason when `target` reverts.
634      *
635      * _Available since v3.1._
636      */
637     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
638         require(address(this).balance >= value, "Address: insufficient balance for call");
639         require(isContract(target), "Address: call to non-contract");
640 
641         // solhint-disable-next-line avoid-low-level-calls
642         (bool success, bytes memory returndata) = target.call{ value: value }(data);
643         return _verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
648      * but performing a static call.
649      *
650      * _Available since v3.3._
651      */
652     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
653         return functionStaticCall(target, data, "Address: low-level static call failed");
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
658      * but performing a static call.
659      *
660      * _Available since v3.3._
661      */
662     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
663         require(isContract(target), "Address: static call to non-contract");
664 
665         // solhint-disable-next-line avoid-low-level-calls
666         (bool success, bytes memory returndata) = target.staticcall(data);
667         return _verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
672      * but performing a delegate call.
673      *
674      * _Available since v3.4._
675      */
676     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
677         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
682      * but performing a delegate call.
683      *
684      * _Available since v3.4._
685      */
686     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
687         require(isContract(target), "Address: delegate call to non-contract");
688 
689         // solhint-disable-next-line avoid-low-level-calls
690         (bool success, bytes memory returndata) = target.delegatecall(data);
691         return _verifyCallResult(success, returndata, errorMessage);
692     }
693 
694     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
695         if (success) {
696             return returndata;
697         } else {
698             // Look for revert reason and bubble it up if present
699             if (returndata.length > 0) {
700                 // The easiest way to bubble the revert reason is using memory via assembly
701 
702                 // solhint-disable-next-line no-inline-assembly
703                 assembly {
704                     let returndata_size := mload(returndata)
705                     revert(add(32, returndata), returndata_size)
706                 }
707             } else {
708                 revert(errorMessage);
709             }
710         }
711     }
712 }
713 
714 
715 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.1.0
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @title SafeERC20
722  * @dev Wrappers around ERC20 operations that throw on failure (when the token
723  * contract returns false). Tokens that return no value (and instead revert or
724  * throw on failure) are also supported, non-reverting calls are assumed to be
725  * successful.
726  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
727  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
728  */
729 library SafeERC20 {
730     using Address for address;
731 
732     function safeTransfer(IERC20 token, address to, uint256 value) internal {
733         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
734     }
735 
736     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
737         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
738     }
739 
740     /**
741      * @dev Deprecated. This function has issues similar to the ones found in
742      * {IERC20-approve}, and its usage is discouraged.
743      *
744      * Whenever possible, use {safeIncreaseAllowance} and
745      * {safeDecreaseAllowance} instead.
746      */
747     function safeApprove(IERC20 token, address spender, uint256 value) internal {
748         // safeApprove should only be called when setting an initial allowance,
749         // or when resetting it to zero. To increase and decrease it, use
750         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
751         // solhint-disable-next-line max-line-length
752         require((value == 0) || (token.allowance(address(this), spender) == 0),
753             "SafeERC20: approve from non-zero to non-zero allowance"
754         );
755         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
756     }
757 
758     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
759         uint256 newAllowance = token.allowance(address(this), spender) + value;
760         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
761     }
762 
763     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
764         unchecked {
765             uint256 oldAllowance = token.allowance(address(this), spender);
766             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
767             uint256 newAllowance = oldAllowance - value;
768             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
769         }
770     }
771 
772     /**
773      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
774      * on the return value: the return value is optional (but if data is returned, it must not be false).
775      * @param token The token targeted by the call.
776      * @param data The call data (encoded using abi.encode or one of its variants).
777      */
778     function _callOptionalReturn(IERC20 token, bytes memory data) private {
779         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
780         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
781         // the target address contains contract code and also asserts for success in the low-level call.
782 
783         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
784         if (returndata.length > 0) { // Return data is optional
785             // solhint-disable-next-line max-line-length
786             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
787         }
788     }
789 }
790 
791 
792 // File contracts/libraries/UniERC20.sol
793 
794 pragma solidity ^0.8.0;
795 
796 
797 // Unified library for interacting with native ETH and ERC20
798 // Design inspiration from Mooniswap
799 library UniERC20 {
800     using SafeERC20 for ERC20;
801 
802     function isETH(ERC20 token) internal pure returns (bool) {
803         return (address(token) == address(0));
804     }
805 
806     function uniCheckAllowance(ERC20 token, uint256 amount, address owner, address spender) internal view returns (bool) {
807         if(isETH(token)){
808             return msg.value==amount;
809         } else {
810             return token.allowance(owner, spender) >= amount;
811         }
812     }
813 
814     function uniBalanceOf(ERC20 token, address account) internal view returns (uint256) {
815         if (isETH(token)) {
816             return account.balance-msg.value;
817         } else {
818             return token.balanceOf(account);
819         }
820     }
821 
822     function uniTransfer(ERC20 token, address to, uint256 amount) internal {
823         if (amount > 0) {
824             if (isETH(token)) {
825                 (bool success, ) = payable(to).call{value: amount}("");
826                 require(success, "Transfer failed.");
827             } else {
828                 token.safeTransfer(to, amount);
829             }
830         }
831     }
832 
833     function uniTransferFromSender(ERC20 token, uint256 amount, address sendTo) internal {
834         if (amount > 0) {
835             if (isETH(token)) {
836                 require(msg.value == amount, "Incorrect value");
837                 payable(sendTo).transfer(msg.value);
838             } else {
839                 token.safeTransferFrom(msg.sender, sendTo, amount);
840             }
841         }
842     }
843 }
844 
845 
846 // File contracts/ClipperRouter.sol
847 
848 pragma solidity ^0.8.0;
849 
850 
851 // Simple router
852 contract ClipperRouter is Ownable {
853     using UniERC20 for ERC20;
854     
855     address payable public clipperPool;
856     PLPAPIInterface public clipperExchange;
857     bytes auxiliaryData;
858 
859     constructor(address payable poolAddress, address exchangeAddress, string memory theData) {
860         clipperPool = poolAddress;
861         clipperExchange = PLPAPIInterface(exchangeAddress);
862         auxiliaryData = bytes(theData);
863     }
864 
865     function modifyContractAddresses(address payable poolAddress, address exchangeAddress) external onlyOwner {
866         require((poolAddress!=address(0)) && exchangeAddress!=address(0), "Clipper Router: Invalid contract addresses");
867         clipperPool = poolAddress;
868         clipperExchange = PLPAPIInterface(exchangeAddress);
869     }
870 
871     // Executes the "transfer-then-swap" modality in a single transaction
872     function clipperSwap(address inputToken, uint256 sellAmount, address outputToken, address recipient, uint256 minBuyAmount) external payable {
873         ERC20 _input = ERC20(inputToken);
874         ERC20 _output = ERC20(outputToken);
875         require(_input.uniCheckAllowance(sellAmount, msg.sender, address(this)), "Clipper Router: Allowance check failed");
876         require(recipient != address(0), "Clipper Router: Invalid recipient");
877         _input.uniTransferFromSender(sellAmount, clipperPool);
878         if(_input.isETH()){
879             clipperExchange.sellEthForToken(outputToken, recipient, minBuyAmount, auxiliaryData);
880         } else if(_output.isETH()){
881             clipperExchange.sellTokenForEth(inputToken, payable(recipient), minBuyAmount, auxiliaryData);
882         } else {
883             clipperExchange.sellTokenForToken(inputToken, outputToken, recipient, minBuyAmount, auxiliaryData);
884         }
885     }
886 }