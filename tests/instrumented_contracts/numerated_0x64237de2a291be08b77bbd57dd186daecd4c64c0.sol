1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 library Strings {
5     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
6 
7     /**
8      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
9      */
10     function toString(uint256 value) internal pure returns (string memory) {
11         // Inspired by OraclizeAPI's implementation - MIT licence
12         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
13 
14         if (value == 0) {
15             return "0";
16         }
17         uint256 temp = value;
18         uint256 digits;
19         while (temp != 0) {
20             digits++;
21             temp /= 10;
22         }
23         bytes memory buffer = new bytes(digits);
24         while (value != 0) {
25             digits -= 1;
26             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
27             value /= 10;
28         }
29         return string(buffer);
30     }
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
34      */
35     function toHexString(uint256 value) internal pure returns (string memory) {
36         if (value == 0) {
37             return "0x00";
38         }
39         uint256 temp = value;
40         uint256 length = 0;
41         while (temp != 0) {
42             length++;
43             temp >>= 8;
44         }
45         return toHexString(value, length);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
50      */
51     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
52         bytes memory buffer = new bytes(2 * length + 2);
53         buffer[0] = "0";
54         buffer[1] = "x";
55         for (uint256 i = 2 * length + 1; i > 1; --i) {
56             buffer[i] = _HEX_SYMBOLS[value & 0xf];
57             value >>= 4;
58         }
59         require(value == 0, "Strings: hex length insufficient");
60         return string(buffer);
61     }
62 }
63 // File: contracts/IERC20.sol
64 
65 
66 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
67 
68 
69 /**
70  * @dev Interface of the ERC20 standard as defined in the EIP.
71  */
72 interface IERC20 {
73     /**
74      * @dev Returns the amount of tokens in existence.
75      */
76     function totalSupply() external view returns (uint256);
77 
78     /**
79      * @dev Returns the amount of tokens owned by `account`.
80      */
81     function balanceOf(address account) external view returns (uint256);
82 
83     /**
84      * @dev Moves `amount` tokens from the caller's account to `to`.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transfer(address to, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Returns the remaining number of tokens that `spender` will be
94      * allowed to spend on behalf of `owner` through {transferFrom}. This is
95      * zero by default.
96      *
97      * This value changes when {approve} or {transferFrom} are called.
98      */
99     function allowance(address owner, address spender) external view returns (uint256);
100 
101     /**
102      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * IMPORTANT: Beware that changing an allowance with this method brings the risk
107      * that someone may use both the old and the new allowance by unfortunate
108      * transaction ordering. One possible solution to mitigate this race
109      * condition is to first reduce the spender's allowance to 0 and set the
110      * desired value afterwards:
111      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address spender, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Moves `amount` tokens from `from` to `to` using the
119      * allowance mechanism. `amount` is then deducted from the caller's
120      * allowance.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 amount
130     ) external returns (bool);
131 
132     /**
133      * @dev Emitted when `value` tokens are moved from one account (`from`) to
134      * another (`to`).
135      *
136      * Note that `value` may be zero.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140     /**
141      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
142      * a call to {approve}. `value` is the new allowance.
143      */
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 // File: contracts/IERC20Metadata.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
150 
151 
152 
153 
154 /**
155  * @dev Interface for the optional metadata functions from the ERC20 standard.
156  *
157  * _Available since v4.1._
158  */
159 interface IERC20Metadata is IERC20 {
160     /**
161      * @dev Returns the name of the token.
162      */
163     function name() external view returns (string memory);
164 
165     /**
166      * @dev Returns the symbol of the token.
167      */
168     function symbol() external view returns (string memory);
169 
170     /**
171      * @dev Returns the decimals places of the token.
172      */
173     function decimals() external view returns (uint8);
174 }
175 // File: contracts/Address.sol
176 
177 
178 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
179 
180 
181 
182 /**
183  * @dev Collection of functions related to the address type
184  */
185 library Address {
186     /**
187      * @dev Returns true if `account` is a contract.
188      *
189      * [IMPORTANT]
190      * ====
191      * It is unsafe to assume that an address for which this function returns
192      * false is an externally-owned account (EOA) and not a contract.
193      *
194      * Among others, `isContract` will return false for the following
195      * types of addresses:
196      *
197      *  - an externally-owned account
198      *  - a contract in construction
199      *  - an address where a contract will be created
200      *  - an address where a contract lived, but was destroyed
201      * ====
202      *
203      * [IMPORTANT]
204      * ====
205      * You shouldn't rely on `isContract` to protect against flash loan attacks!
206      *
207      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
208      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
209      * constructor.
210      * ====
211      */
212     function isContract(address account) internal view returns (bool) {
213         // This method relies on extcodesize/address.code.length, which returns 0
214         // for contracts in construction, since the code is only stored at the end
215         // of the constructor execution.
216 
217         return account.code.length > 0;
218     }
219 
220     /**
221      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
222      * `recipient`, forwarding all available gas and reverting on errors.
223      *
224      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
225      * of certain opcodes, possibly making contracts go over the 2300 gas limit
226      * imposed by `transfer`, making them unable to receive funds via
227      * `transfer`. {sendValue} removes this limitation.
228      *
229      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
230      *
231      * IMPORTANT: because control is transferred to `recipient`, care must be
232      * taken to not create reentrancy vulnerabilities. Consider using
233      * {ReentrancyGuard} or the
234      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
235      */
236     function sendValue(address payable recipient, uint256 amount) internal {
237         require(address(this).balance >= amount, "Address: insufficient balance");
238 
239         (bool success, ) = recipient.call{value: amount}("");
240         require(success, "Address: unable to send value, recipient may have reverted");
241     }
242 
243     /**
244      * @dev Performs a Solidity function call using a low level `call`. A
245      * plain `call` is an unsafe replacement for a function call: use this
246      * function instead.
247      *
248      * If `target` reverts with a revert reason, it is bubbled up by this
249      * function (like regular Solidity function calls).
250      *
251      * Returns the raw returned data. To convert to the expected return value,
252      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
253      *
254      * Requirements:
255      *
256      * - `target` must be a contract.
257      * - calling `target` with `data` must not revert.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionCall(target, data, "Address: low-level call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
267      * `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, 0, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but also transferring `value` wei to `target`.
282      *
283      * Requirements:
284      *
285      * - the calling contract must have an ETH balance of at least `value`.
286      * - the called Solidity function must be `payable`.
287      *
288      * _Available since v3.1._
289      */
290     function functionCallWithValue(
291         address target,
292         bytes memory data,
293         uint256 value
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
300      * with `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(address(this).balance >= value, "Address: insufficient balance for call");
311         require(isContract(target), "Address: call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.call{value: value}(data);
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
324         return functionStaticCall(target, data, "Address: low-level static call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal view returns (bytes memory) {
338         require(isContract(target), "Address: static call to non-contract");
339 
340         (bool success, bytes memory returndata) = target.staticcall(data);
341         return verifyCallResult(success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(isContract(target), "Address: delegate call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.delegatecall(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
373      * revert reason using the provided one.
374      *
375      * _Available since v4.3._
376      */
377     function verifyCallResult(
378         bool success,
379         bytes memory returndata,
380         string memory errorMessage
381     ) internal pure returns (bytes memory) {
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 // File: contracts/Context.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
403 
404 /*
405  * @dev Provides information about the current execution context, including the
406  * sender of the transaction and its data. While these are generally available
407  * via msg.sender and msg.data, they should not be accessed in such a direct
408  * manner, since when dealing with meta-transactions the account sending and
409  * paying for execution may not be the actual sender (as far as an application
410  * is concerned).
411  *
412  * This contract is only required for intermediate, library-like contracts.
413  */
414 abstract contract Context {
415     function _msgSender() internal view virtual returns (address) {
416         return msg.sender;
417     }
418 
419     function _msgData() internal view virtual returns (bytes calldata) {
420         return msg.data;
421     }
422 }
423 // File: contracts/ERC20.sol
424 
425 
426 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
427 
428 
429 
430 
431 
432 /**
433  * @dev Implementation of the {IERC20} interface.
434  *
435  * This implementation is agnostic to the way tokens are created. This means
436  * that a supply mechanism has to be added in a derived contract using {_mint}.
437  * For a generic mechanism see {ERC20PresetMinterPauser}.
438  *
439  * TIP: For a detailed writeup see our guide
440  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
441  * to implement supply mechanisms].
442  *
443  * We have followed general OpenZeppelin Contracts guidelines: functions revert
444  * instead returning `false` on failure. This behavior is nonetheless
445  * conventional and does not conflict with the expectations of ERC20
446  * applications.
447  *
448  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
449  * This allows applications to reconstruct the allowance for all accounts just
450  * by listening to said events. Other implementations of the EIP may not emit
451  * these events, as it isn't required by the specification.
452  *
453  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
454  * functions have been added to mitigate the well-known issues around setting
455  * allowances. See {IERC20-approve}.
456  */
457 contract ERC20 is Context, IERC20, IERC20Metadata {
458     mapping(address => uint256) private _balances;
459 
460     mapping(address => mapping(address => uint256)) private _allowances;
461 
462     uint256 private _totalSupply;
463 
464     string private _name;
465     string private _symbol;
466 
467     /**
468      * @dev Sets the values for {name} and {symbol}.
469      *
470      * The default value of {decimals} is 18. To select a different value for
471      * {decimals} you should overload it.
472      *
473      * All two of these values are immutable: they can only be set once during
474      * construction.
475      */
476     constructor(string memory name_, string memory symbol_) {
477         _name = name_;
478         _symbol = symbol_;
479     }
480 
481     /**
482      * @dev Returns the name of the token.
483      */
484     function name() public view virtual override returns (string memory) {
485         return _name;
486     }
487 
488     /**
489      * @dev Returns the symbol of the token, usually a shorter version of the
490      * name.
491      */
492     function symbol() public view virtual override returns (string memory) {
493         return _symbol;
494     }
495 
496     /**
497      * @dev Returns the number of decimals used to get its user representation.
498      * For example, if `decimals` equals `2`, a balance of `505` tokens should
499      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
500      *
501      * Tokens usually opt for a value of 18, imitating the relationship between
502      * Ether and Wei. This is the value {ERC20} uses, unless this function is
503      * overridden;
504      *
505      * NOTE: This information is only used for _display_ purposes: it in
506      * no way affects any of the arithmetic of the contract, including
507      * {IERC20-balanceOf} and {IERC20-transfer}.
508      */
509     function decimals() public view virtual override returns (uint8) {
510         return 18;
511     }
512 
513     /**
514      * @dev See {IERC20-totalSupply}.
515      */
516     function totalSupply() public view virtual override returns (uint256) {
517         return _totalSupply;
518     }
519 
520     /**
521      * @dev See {IERC20-balanceOf}.
522      */
523     function balanceOf(address account) public view virtual override returns (uint256) {
524         return _balances[account];
525     }
526 
527     /**
528      * @dev See {IERC20-transfer}.
529      *
530      * Requirements:
531      *
532      * - `to` cannot be the zero address.
533      * - the caller must have a balance of at least `amount`.
534      */
535     function transfer(address to, uint256 amount) public virtual override returns (bool) {
536         address owner = _msgSender();
537         _transfer(owner, to, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-allowance}.
543      */
544     function allowance(address owner, address spender) public view virtual override returns (uint256) {
545         return _allowances[owner][spender];
546     }
547 
548     /**
549      * @dev See {IERC20-approve}.
550      *
551      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
552      * `transferFrom`. This is semantically equivalent to an infinite approval.
553      *
554      * Requirements:
555      *
556      * - `spender` cannot be the zero address.
557      */
558     function approve(address spender, uint256 amount) public virtual override returns (bool) {
559         address owner = _msgSender();
560         _approve(owner, spender, amount);
561         return true;
562     }
563 
564     /**
565      * @dev See {IERC20-transferFrom}.
566      *
567      * Emits an {Approval} event indicating the updated allowance. This is not
568      * required by the EIP. See the note at the beginning of {ERC20}.
569      *
570      * NOTE: Does not update the allowance if the current allowance
571      * is the maximum `uint256`.
572      *
573      * Requirements:
574      *
575      * - `from` and `to` cannot be the zero address.
576      * - `from` must have a balance of at least `amount`.
577      * - the caller must have allowance for ``from``'s tokens of at least
578      * `amount`.
579      */
580     function transferFrom(
581         address from,
582         address to,
583         uint256 amount
584     ) public virtual override returns (bool) {
585         address spender = _msgSender();
586         _spendAllowance(from, spender, amount);
587         _transfer(from, to, amount);
588         return true;
589     }
590 
591     /**
592      * @dev Atomically increases the allowance granted to `spender` by the caller.
593      *
594      * This is an alternative to {approve} that can be used as a mitigation for
595      * problems described in {IERC20-approve}.
596      *
597      * Emits an {Approval} event indicating the updated allowance.
598      *
599      * Requirements:
600      *
601      * - `spender` cannot be the zero address.
602      */
603     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
604         address owner = _msgSender();
605         _approve(owner, spender, _allowances[owner][spender] + addedValue);
606         return true;
607     }
608 
609     /**
610      * @dev Atomically decreases the allowance granted to `spender` by the caller.
611      *
612      * This is an alternative to {approve} that can be used as a mitigation for
613      * problems described in {IERC20-approve}.
614      *
615      * Emits an {Approval} event indicating the updated allowance.
616      *
617      * Requirements:
618      *
619      * - `spender` cannot be the zero address.
620      * - `spender` must have allowance for the caller of at least
621      * `subtractedValue`.
622      */
623     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
624         address owner = _msgSender();
625         uint256 currentAllowance = _allowances[owner][spender];
626         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
627         unchecked {
628             _approve(owner, spender, currentAllowance - subtractedValue);
629         }
630 
631         return true;
632     }
633 
634     /**
635      * @dev Moves `amount` of tokens from `sender` to `recipient`.
636      *
637      * This internal function is equivalent to {transfer}, and can be used to
638      * e.g. implement automatic token fees, slashing mechanisms, etc.
639      *
640      * Emits a {Transfer} event.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `from` must have a balance of at least `amount`.
647      */
648     function _transfer(
649         address from,
650         address to,
651         uint256 amount
652     ) internal virtual {
653         require(from != address(0), "ERC20: transfer from the zero address");
654         require(to != address(0), "ERC20: transfer to the zero address");
655 
656         _beforeTokenTransfer(from, to, amount);
657 
658         uint256 fromBalance = _balances[from];
659         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
660         unchecked {
661             _balances[from] = fromBalance - amount;
662         }
663         _balances[to] += amount;
664 
665         emit Transfer(from, to, amount);
666 
667         _afterTokenTransfer(from, to, amount);
668     }
669 
670     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
671      * the total supply.
672      *
673      * Emits a {Transfer} event with `from` set to the zero address.
674      *
675      * Requirements:
676      *
677      * - `account` cannot be the zero address.
678      */
679     function _mint(address account, uint256 amount) internal virtual {
680         require(account != address(0), "ERC20: mint to the zero address");
681 
682         _beforeTokenTransfer(address(0), account, amount);
683 
684         _totalSupply += amount;
685         _balances[account] += amount;
686         emit Transfer(address(0), account, amount);
687 
688         _afterTokenTransfer(address(0), account, amount);
689     }
690 
691     /**
692      * @dev Destroys `amount` tokens from `account`, reducing the
693      * total supply.
694      *
695      * Emits a {Transfer} event with `to` set to the zero address.
696      *
697      * Requirements:
698      *
699      * - `account` cannot be the zero address.
700      * - `account` must have at least `amount` tokens.
701      */
702     function _burn(address account, uint256 amount) internal virtual {
703         require(account != address(0), "ERC20: burn from the zero address");
704 
705         _beforeTokenTransfer(account, address(0), amount);
706 
707         uint256 accountBalance = _balances[account];
708         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
709         unchecked {
710             _balances[account] = accountBalance - amount;
711         }
712         _totalSupply -= amount;
713 
714         emit Transfer(account, address(0), amount);
715 
716         _afterTokenTransfer(account, address(0), amount);
717     }
718 
719     /**
720      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
721      *
722      * This internal function is equivalent to `approve`, and can be used to
723      * e.g. set automatic allowances for certain subsystems, etc.
724      *
725      * Emits an {Approval} event.
726      *
727      * Requirements:
728      *
729      * - `owner` cannot be the zero address.
730      * - `spender` cannot be the zero address.
731      */
732     function _approve(
733         address owner,
734         address spender,
735         uint256 amount
736     ) internal virtual {
737         require(owner != address(0), "ERC20: approve from the zero address");
738         require(spender != address(0), "ERC20: approve to the zero address");
739 
740         _allowances[owner][spender] = amount;
741         emit Approval(owner, spender, amount);
742     }
743 
744     /**
745      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
746      *
747      * Does not update the allowance amount in case of infinite allowance.
748      * Revert if not enough allowance is available.
749      *
750      * Might emit an {Approval} event.
751      */
752     function _spendAllowance(
753         address owner,
754         address spender,
755         uint256 amount
756     ) internal virtual {
757         uint256 currentAllowance = allowance(owner, spender);
758         if (currentAllowance != type(uint256).max) {
759             require(currentAllowance >= amount, "ERC20: insufficient allowance");
760             unchecked {
761                 _approve(owner, spender, currentAllowance - amount);
762             }
763         }
764     }
765 
766     /**
767      * @dev Hook that is called before any transfer of tokens. This includes
768      * minting and burning.
769      *
770      * Calling conditions:
771      *
772      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
773      * will be transferred to `to`.
774      * - when `from` is zero, `amount` tokens will be minted for `to`.
775      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
776      * - `from` and `to` are never both zero.
777      *
778      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
779      */
780     function _beforeTokenTransfer(
781         address from,
782         address to,
783         uint256 amount
784     ) internal virtual {}
785 
786     /**
787      * @dev Hook that is called after any transfer of tokens. This includes
788      * minting and burning.
789      *
790      * Calling conditions:
791      *
792      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
793      * has been transferred to `to`.
794      * - when `from` is zero, `amount` tokens have been minted for `to`.
795      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
796      * - `from` and `to` are never both zero.
797      *
798      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
799      */
800     function _afterTokenTransfer(
801         address from,
802         address to,
803         uint256 amount
804     ) internal virtual {}
805 }
806 // File: contracts/Ownable.sol
807 
808 
809 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
810 
811 
812 
813 
814 /**
815  * @dev Contract module which provides a basic access control mechanism, where
816  * there is an account (an owner) that can be granted exclusive access to
817  * specific functions.
818  *
819  * By default, the owner account will be the one that deploys the contract. This
820  * can later be changed with {transferOwnership}.
821  *
822  * This module is used through inheritance. It will make available the modifier
823  * `onlyOwner`, which can be applied to your functions to restrict their use to
824  * the owner.
825  */
826 abstract contract Ownable is Context {
827     address private _owner;
828 
829     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
830 
831     /**
832      * @dev Initializes the contract setting the deployer as the initial owner.
833      */
834     constructor() {
835         _transferOwnership(_msgSender());
836     }
837 
838     /**
839      * @dev Returns the address of the current owner.
840      */
841     function owner() public view virtual returns (address) {
842         return _owner;
843     }
844 
845     /**
846      * @dev Throws if called by any account other than the owner.
847      */
848     modifier onlyOwner() {
849         require(owner() == _msgSender(), "Ownable: caller is not the owner");
850         _;
851     }
852 
853     /**
854      * @dev Leaves the contract without owner. It will not be possible to call
855      * `onlyOwner` functions anymore. Can only be called by the current owner.
856      *
857      * NOTE: Renouncing ownership will leave the contract without an owner,
858      * thereby removing any functionality that is only available to the owner.
859      */
860     function renounceOwnership() public virtual onlyOwner {
861         _transferOwnership(address(0));
862     }
863 
864     /**
865      * @dev Transfers ownership of the contract to a new account (`newOwner`).
866      * Can only be called by the current owner.
867      */
868     function transferOwnership(address newOwner) public virtual onlyOwner {
869         require(newOwner != address(0), "Ownable: new owner is the zero address");
870         _transferOwnership(newOwner);
871     }
872 
873     /**
874      * @dev Transfers ownership of the contract to a new account (`newOwner`).
875      * Internal function without access restriction.
876      */
877     function _transferOwnership(address newOwner) internal virtual {
878         address oldOwner = _owner;
879         _owner = newOwner;
880         emit OwnershipTransferred(oldOwner, newOwner);
881     }
882 }
883 // File: contracts/ShitCoin.sol
884 
885 
886 
887 
888 contract RubbishCoin is ERC20, Ownable {
889     uint256 public constant MAX_SUPPLY = 50_000_000_000_000 ether;
890     uint256 public constant RESERVED_FOR_POOL_SUPPLY = 25_000_000_000_000 ether;
891     uint256 public constant HOLDER_SUPPLY = 25_000_000_000_000 ether;
892 
893     address public constant ECOSYSTEM_ADDRESS = 0x5E5f5D9Cb7DbB7BD26400EFD1c8f7102e5600A95;
894 
895     uint256 public _holderClaimed;
896     address public _claimer;
897 
898     constructor() ERC20("RubbishCoin", "Rubbish") {
899         require(MAX_SUPPLY == HOLDER_SUPPLY + RESERVED_FOR_POOL_SUPPLY);
900 
901         _mint(ECOSYSTEM_ADDRESS, RESERVED_FOR_POOL_SUPPLY);
902     }
903 
904     function holderClaim(address holder, uint256 amount) external {
905         require(_claimer == msg.sender, "RubbishCoin: Not Claimer");
906         require(_holderClaimed + amount <= HOLDER_SUPPLY, "RubbishtCoin: Exceed supply");
907         _holderClaimed += amount;
908         _mint(holder, amount);
909     }
910 
911     function sweepRestHolderShares() external onlyOwner {
912         uint256 rest = HOLDER_SUPPLY - _holderClaimed;
913         if (rest > 0) {
914             _mint(ECOSYSTEM_ADDRESS, rest);
915         }
916     }
917 
918     function setClaimer(address claimer) external onlyOwner {
919         _claimer = claimer;
920     }
921 }