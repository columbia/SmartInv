1 pragma solidity 0.8.17;
2 
3 // SPDX-License-Identifier: MIT
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20{
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 contract ERC20 is Context, IERC20, IERC20Metadata {
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowances;
112 
113     uint256 private _totalSupply;
114 
115     string private _name;
116     string private _symbol;
117 
118     /**
119      * @dev Sets the values for {name} and {symbol}.
120      *
121      * All two of these values are immutable: they can only be set once during
122      * construction.
123      */
124     constructor(string memory name_, string memory symbol_) {
125         _name = name_;
126         _symbol = symbol_;
127     }
128 
129     /**
130      * @dev Returns the name of the token.
131      */
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     /**
137      * @dev Returns the symbol of the token, usually a shorter version of the
138      * name.
139      */
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     /**
145      * @dev Returns the number of decimals used to get its user representation.
146      * For example, if `decimals` equals `2`, a balance of `505` tokens should
147      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
148      *
149      * Tokens usually opt for a value of 18, imitating the relationship between
150      * Ether and Wei. This is the default value returned by this function, unless
151      * it's overridden.
152      *
153      * NOTE: This information is only used for _display_ purposes: it in
154      * no way affects any of the arithmetic of the contract, including
155      * {IERC20-balanceOf} and {IERC20-transfer}.
156      */
157     function decimals() public view virtual override returns (uint8) {
158         return 18;
159     }
160 
161     /**
162      * @dev See {IERC20-totalSupply}.
163      */
164     function totalSupply() public view virtual override returns (uint256) {
165         return _totalSupply;
166     }
167 
168     /**
169      * @dev See {IERC20-balanceOf}.
170      */
171     function balanceOf(address account) public view virtual override returns (uint256) {
172         return _balances[account];
173     }
174 
175     /**
176      * @dev See {IERC20-transfer}.
177      *
178      * Requirements:
179      *
180      * - `to` cannot be the zero address.
181      * - the caller must have a balance of at least `amount`.
182      */
183     function transfer(address to, uint256 amount) public virtual override returns (bool) {
184         address owner = _msgSender();
185         _transfer(owner, to, amount);
186         return true;
187     }
188 
189     /**
190      * @dev See {IERC20-allowance}.
191      */
192     function allowance(address owner, address spender) public view virtual override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     /**
197      * @dev See {IERC20-approve}.
198      *
199      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
200      * `transferFrom`. This is semantically equivalent to an infinite approval.
201      *
202      * Requirements:
203      *
204      * - `spender` cannot be the zero address.
205      */
206     function approve(address spender, uint256 amount) public virtual override returns (bool) {
207         address owner = _msgSender();
208         _approve(owner, spender, amount);
209         return true;
210     }
211 
212     /**
213      * @dev See {IERC20-transferFrom}.
214      *
215      * Emits an {Approval} event indicating the updated allowance. This is not
216      * required by the EIP. See the note at the beginning of {ERC20}.
217      *
218      * NOTE: Does not update the allowance if the current allowance
219      * is the maximum `uint256`.
220      *
221      * Requirements:
222      *
223      * - `from` and `to` cannot be the zero address.
224      * - `from` must have a balance of at least `amount`.
225      * - the caller must have allowance for ``from``'s tokens of at least
226      * `amount`.
227      */
228     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
229         address spender = _msgSender();
230         _spendAllowance(from, spender, amount);
231         _transfer(from, to, amount);
232         return true;
233     }
234 
235     /**
236      * @dev Atomically increases the allowance granted to `spender` by the caller.
237      *
238      * This is an alternative to {approve} that can be used as a mitigation for
239      * problems described in {IERC20-approve}.
240      *
241      * Emits an {Approval} event indicating the updated allowance.
242      *
243      * Requirements:
244      *
245      * - `spender` cannot be the zero address.
246      */
247     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
248         address owner = _msgSender();
249         _approve(owner, spender, allowance(owner, spender) + addedValue);
250         return true;
251     }
252 
253     /**
254      * @dev Atomically decreases the allowance granted to `spender` by the caller.
255      *
256      * This is an alternative to {approve} that can be used as a mitigation for
257      * problems described in {IERC20-approve}.
258      *
259      * Emits an {Approval} event indicating the updated allowance.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      * - `spender` must have allowance for the caller of at least
265      * `subtractedValue`.
266      */
267     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
268         address owner = _msgSender();
269         uint256 currentAllowance = allowance(owner, spender);
270         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
271         unchecked {
272             _approve(owner, spender, currentAllowance - subtractedValue);
273         }
274 
275         return true;
276     }
277 
278     /**
279      * @dev Moves `amount` of tokens from `from` to `to`.
280      *
281      * This internal function is equivalent to {transfer}, and can be used to
282      * e.g. implement automatic token fees, slashing mechanisms, etc.
283      *
284      * Emits a {Transfer} event.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `from` must have a balance of at least `amount`.
291      */
292     function _transfer(address from, address to, uint256 amount) internal virtual {
293         require(from != address(0), "ERC20: transfer from the zero address");
294         require(to != address(0), "ERC20: transfer to the zero address");
295 
296         _beforeTokenTransfer(from, to, amount);
297 
298         uint256 fromBalance = _balances[from];
299         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
300         unchecked {
301             _balances[from] = fromBalance - amount;
302             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
303             // decrementing then incrementing.
304             _balances[to] += amount;
305         }
306 
307         emit Transfer(from, to, amount);
308 
309         _afterTokenTransfer(from, to, amount);
310     }
311 
312     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
313      * the total supply.
314      *
315      * Emits a {Transfer} event with `from` set to the zero address.
316      *
317      * Requirements:
318      *
319      * - `account` cannot be the zero address.
320      */
321     function _mint(address account, uint256 amount) internal virtual {
322         require(account != address(0), "ERC20: mint to the zero address");
323 
324         _beforeTokenTransfer(address(0), account, amount);
325 
326         _totalSupply += amount;
327         unchecked {
328             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
329             _balances[account] += amount;
330         }
331         emit Transfer(address(0), account, amount);
332 
333         _afterTokenTransfer(address(0), account, amount);
334     }
335 
336     /**
337      * @dev Destroys `amount` tokens from `account`, reducing the
338      * total supply.
339      *
340      * Emits a {Transfer} event with `to` set to the zero address.
341      *
342      * Requirements:
343      *
344      * - `account` cannot be the zero address.
345      * - `account` must have at least `amount` tokens.
346      */
347     function _burn(address account, uint256 amount) internal virtual {
348         require(account != address(0), "ERC20: burn from the zero address");
349 
350         _beforeTokenTransfer(account, address(0), amount);
351 
352         uint256 accountBalance = _balances[account];
353         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
354         unchecked {
355             _balances[account] = accountBalance - amount;
356             // Overflow not possible: amount <= accountBalance <= totalSupply.
357             _totalSupply -= amount;
358         }
359 
360         emit Transfer(account, address(0), amount);
361 
362         _afterTokenTransfer(account, address(0), amount);
363     }
364 
365     /**
366      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
367      *
368      * This internal function is equivalent to `approve`, and can be used to
369      * e.g. set automatic allowances for certain subsystems, etc.
370      *
371      * Emits an {Approval} event.
372      *
373      * Requirements:
374      *
375      * - `owner` cannot be the zero address.
376      * - `spender` cannot be the zero address.
377      */
378     function _approve(address owner, address spender, uint256 amount) internal virtual {
379         require(owner != address(0), "ERC20: approve from the zero address");
380         require(spender != address(0), "ERC20: approve to the zero address");
381 
382         _allowances[owner][spender] = amount;
383         emit Approval(owner, spender, amount);
384     }
385 
386     /**
387      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
388      *
389      * Does not update the allowance amount in case of infinite allowance.
390      * Revert if not enough allowance is available.
391      *
392      * Might emit an {Approval} event.
393      */
394     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
395         uint256 currentAllowance = allowance(owner, spender);
396         if (currentAllowance != type(uint256).max) {
397             require(currentAllowance >= amount, "ERC20: insufficient allowance");
398             unchecked {
399                 _approve(owner, spender, currentAllowance - amount);
400             }
401         }
402     }
403 
404     /**
405      * @dev Hook that is called before any transfer of tokens. This includes
406      * minting and burning.
407      *
408      * Calling conditions:
409      *
410      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
411      * will be transferred to `to`.
412      * - when `from` is zero, `amount` tokens will be minted for `to`.
413      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
414      * - `from` and `to` are never both zero.
415      *
416      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
417      */
418     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
419 
420     /**
421      * @dev Hook that is called after any transfer of tokens. This includes
422      * minting and burning.
423      *
424      * Calling conditions:
425      *
426      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
427      * has been transferred to `to`.
428      * - when `from` is zero, `amount` tokens have been minted for `to`.
429      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
430      * - `from` and `to` are never both zero.
431      *
432      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
433      */
434     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
435 }
436 
437 contract Ownable is Context {
438     address private _owner;
439 
440     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
441     
442     constructor () {
443         address msgSender = _msgSender();
444         _owner = msgSender;
445         emit OwnershipTransferred(address(0), msgSender);
446     }
447 
448     function owner() public view returns (address) {
449         return _owner;
450     }
451 
452     modifier onlyOwner() {
453         require(_owner == _msgSender(), "Ownable: caller is not the owner");
454         _;
455     }
456 
457     function renounceOwnership() external virtual onlyOwner {
458         emit OwnershipTransferred(_owner, address(0));
459         _owner = address(0);
460     }
461 
462     function transferOwnership(address newOwner) public virtual onlyOwner {
463         require(newOwner != address(0), "Ownable: new owner is the zero address");
464         emit OwnershipTransferred(_owner, newOwner);
465         _owner = newOwner;
466     }
467 }
468 
469 library Address {
470     function isContract(address account) internal view returns (bool) {
471         return account.code.length > 0;
472     }
473 
474     function sendValue(address payable recipient, uint256 amount) internal {
475         require(address(this).balance >= amount, "Address: insufficient balance");
476 
477         (bool success, ) = recipient.call{value: amount}("");
478         require(success, "Address: unable to send value, recipient may have reverted");
479     }
480 
481     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
483     }
484 
485     function functionCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
514      * with `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         require(address(this).balance >= value, "Address: insufficient balance for call");
525         (bool success, bytes memory returndata) = target.call{value: value}(data);
526         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
531      * but performing a static call.
532      *
533      * _Available since v3.3._
534      */
535     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
536         return functionStaticCall(target, data, "Address: low-level static call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
541      * but performing a static call.
542      *
543      * _Available since v3.3._
544      */
545     function functionStaticCall(
546         address target,
547         bytes memory data,
548         string memory errorMessage
549     ) internal view returns (bytes memory) {
550         (bool success, bytes memory returndata) = target.staticcall(data);
551         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         (bool success, bytes memory returndata) = target.delegatecall(data);
576         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
581      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
582      *
583      * _Available since v4.8._
584      */
585     function verifyCallResultFromTarget(
586         address target,
587         bool success,
588         bytes memory returndata,
589         string memory errorMessage
590     ) internal view returns (bytes memory) {
591         if (success) {
592             if (returndata.length == 0) {
593                 // only check isContract if the call was successful and the return data is empty
594                 // otherwise we already know that it was a contract
595                 require(isContract(target), "Address: call to non-contract");
596             }
597             return returndata;
598         } else {
599             _revert(returndata, errorMessage);
600         }
601     }
602 
603     /**
604      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
605      * revert reason or using the provided one.
606      *
607      * _Available since v4.3._
608      */
609     function verifyCallResult(
610         bool success,
611         bytes memory returndata,
612         string memory errorMessage
613     ) internal pure returns (bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             _revert(returndata, errorMessage);
618         }
619     }
620 
621     function _revert(bytes memory returndata, string memory errorMessage) private pure {
622         // Look for revert reason and bubble it up if present
623         if (returndata.length > 0) {
624             // The easiest way to bubble the revert reason is using memory via assembly
625             /// @solidity memory-safe-assembly
626             assembly {
627                 let returndata_size := mload(returndata)
628                 revert(add(32, returndata), returndata_size)
629             }
630         } else {
631             revert(errorMessage);
632         }
633     }
634 }
635 
636 library SafeERC20 {
637     using Address for address;
638 
639     function safeTransfer(IERC20 token, address to, uint256 value) internal {
640         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
641     }
642 
643     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
644         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
645     }
646 
647     function _callOptionalReturn(IERC20 token, bytes memory data) private {
648         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
649         if (returndata.length > 0) {
650             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
651         }
652     }
653 
654     function safeApprove(IERC20 token, address spender, uint256 value) internal {
655         // safeApprove should only be called when setting an initial allowance,
656         // or when resetting it to zero. To increase and decrease it, use
657         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
658         require(
659             (value == 0) || (token.allowance(address(this), spender) == 0),
660             "SafeERC20: approve from non-zero to non-zero allowance"
661         );
662         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
663     }
664 }
665 
666 
667 contract TokenHandler is Ownable {
668     function sendTokenToOwner(address token) external onlyOwner {
669         if(IERC20(token).balanceOf(address(this)) > 0){
670             SafeERC20.safeTransfer(IERC20(token),owner(), IERC20(token).balanceOf(address(this)));
671         }
672     }
673 }
674 
675 interface IERC165 {
676     /**
677      * @dev Returns true if this contract implements the interface defined by
678      * `interfaceId`. See the corresponding
679      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
680      * to learn more about how these ids are created.
681      *
682      * This function call must use less than 30 000 gas.
683      */
684     function supportsInterface(bytes4 interfaceId) external view returns (bool);
685 }
686 
687 interface IERC721 is IERC165 {
688     /**
689      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
690      */
691     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
692 
693     /**
694      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
695      */
696     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
697 
698     /**
699      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
700      */
701     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
702 
703     /**
704      * @dev Returns the number of tokens in ``owner``'s account.
705      */
706     function balanceOf(address owner) external view returns (uint256 balance);
707 
708     /**
709      * @dev Returns the owner of the `tokenId` token.
710      *
711      * Requirements:
712      *
713      * - `tokenId` must exist.
714      */
715     function ownerOf(uint256 tokenId) external view returns (address owner);
716 
717     /**
718      * @dev Safely transfers `tokenId` token from `from` to `to`.
719      *
720      * Requirements:
721      *
722      * - `from` cannot be the zero address.
723      * - `to` cannot be the zero address.
724      * - `tokenId` token must exist and be owned by `from`.
725      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
726      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
727      *
728      * Emits a {Transfer} event.
729      */
730     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
731 
732     /**
733      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
734      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
735      *
736      * Requirements:
737      *
738      * - `from` cannot be the zero address.
739      * - `to` cannot be the zero address.
740      * - `tokenId` token must exist and be owned by `from`.
741      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function safeTransferFrom(address from, address to, uint256 tokenId) external;
747 
748     /**
749      * @dev Transfers `tokenId` token from `from` to `to`.
750      *
751      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
752      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
753      * understand this adds an external call which potentially creates a reentrancy vulnerability.
754      *
755      * Requirements:
756      *
757      * - `from` cannot be the zero address.
758      * - `to` cannot be the zero address.
759      * - `tokenId` token must be owned by `from`.
760      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
761      *
762      * Emits a {Transfer} event.
763      */
764     function transferFrom(address from, address to, uint256 tokenId) external;
765 
766     /**
767      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
768      * The approval is cleared when the token is transferred.
769      *
770      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
771      *
772      * Requirements:
773      *
774      * - The caller must own the token or be an approved operator.
775      * - `tokenId` must exist.
776      *
777      * Emits an {Approval} event.
778      */
779     function approve(address to, uint256 tokenId) external;
780 
781     /**
782      * @dev Approve or remove `operator` as an operator for the caller.
783      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
784      *
785      * Requirements:
786      *
787      * - The `operator` cannot be the caller.
788      *
789      * Emits an {ApprovalForAll} event.
790      */
791     function setApprovalForAll(address operator, bool approved) external;
792 
793     /**
794      * @dev Returns the account approved for `tokenId` token.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must exist.
799      */
800     function getApproved(uint256 tokenId) external view returns (address operator);
801 
802     /**
803      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
804      *
805      * See {setApprovalForAll}
806      */
807     function isApprovedForAll(address owner, address operator) external view returns (bool);
808 }
809 
810 interface IWETH {
811     function deposit() external payable; 
812 }
813 
814 interface ILpPair {
815     function sync() external;
816 }
817 
818 interface IDexRouter {
819     function factory() external pure returns (address);
820     function WETH() external pure returns (address);
821     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
822     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
823     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
824     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
825     function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
826     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
827     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
828     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
829 }
830 
831 interface IDexFactory {
832     function createPair(address tokenA, address tokenB) external returns (address pair);
833 }
834 
835 contract BetterCallRaul is ERC20, Ownable {
836 
837     mapping (address => bool) public exemptFromFees;
838     mapping (address => bool) public exemptFromLimits;
839 
840     bool public tradingActive;
841 
842     mapping (address => bool) public isAMMPair;
843 
844     uint256 public maxTransaction;
845     uint256 public maxWallet;
846 
847     address public marketingAddress;
848     address public liquidityAddress;
849     address public devAddress;
850 
851     uint256 public buyTotalTax;
852     uint256 public buyMarketingTax;
853     uint256 public buyLiquidityTax;
854     uint256 public buyDevTax;
855     uint256 public buyBurnTax;
856 
857     uint256 public sellTotalTax;
858     uint256 public sellMarketingTax;
859     uint256 public sellLiquidityTax;
860     uint256 public sellDevTax;
861     uint256 public sellBurnTax;
862 
863     uint256 public tokensForMarketing;
864     uint256 public tokensForLiquidity;
865     uint256 public tokensForDev;
866     
867     TokenHandler public immutable tokenHandler;
868 
869     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
870     bool public transferDelayEnabled = true;
871 
872     bool public limitsInEffect = true;
873 
874     bool public swapEnabled = true;
875     bool private swapping;
876     uint256 public swapTokensAtAmt;
877 
878     address public lpPair;
879     IDexRouter public dexRouter;
880     IERC20Metadata public pairedToken;
881     IWETH public WETH;
882 
883     uint256 public constant FEE_DIVISOR = 10000;
884 
885     // events
886 
887     event UpdatedMaxTransaction(uint256 newMax);
888     event UpdatedMaxWallet(uint256 newMax);
889     event SetExemptFromFees(address _address, bool _isExempt);
890     event SetExemptFromLimits(address _address, bool _isExempt);
891     event RemovedLimits();
892     event UpdatedBuyTax(uint256 newAmt);
893     event UpdatedSellTax(uint256 newAmt);
894 
895     // constructor
896 
897     constructor(string memory _name, string memory _symbol)
898         ERC20(_name, _symbol)
899     {   
900         address newOwner = msg.sender;
901         _mint(newOwner, 100 * 1e6 * 1e18);
902 
903         address _pairedToken;
904         address _v2Router;
905 
906         // @dev assumes WETH pair
907         if(block.chainid == 1){
908             _pairedToken = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
909             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
910         } else if(block.chainid == 5){
911             _pairedToken  = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
912             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
913         } else if(block.chainid == 97){
914             _pairedToken  = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
915             _v2Router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
916         } else if(block.chainid == 42161){
917             _pairedToken  = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
918             _v2Router = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
919         } else {
920             revert("Chain not configured");
921         }
922 
923         dexRouter = IDexRouter(_v2Router);
924 
925         maxTransaction = totalSupply() * 25 / 10000;
926         maxWallet = totalSupply() * 25 / 10000;
927         swapTokensAtAmt = totalSupply() * 25 / 100000;
928 
929         marketingAddress = 0x1D64407205176aC8FB2Db580CdC371626dbFDcCB;
930         liquidityAddress = 0x16BCA6D06425daa0B0724086eB1e3b7D499ef403;
931         devAddress = 0x16BCA6D06425daa0B0724086eB1e3b7D499ef403;
932 
933         buyMarketingTax = 2300;
934         buyLiquidityTax = 100;
935         buyDevTax = 100;
936         buyBurnTax = 0;
937         buyTotalTax = buyMarketingTax + buyLiquidityTax + buyDevTax + buyBurnTax;
938 
939         sellMarketingTax = 200;
940         sellLiquidityTax = 100;
941         sellDevTax = 100;
942         sellBurnTax = 100;
943         sellTotalTax = sellMarketingTax + sellLiquidityTax + sellDevTax + sellBurnTax;
944 
945         pairedToken = IERC20Metadata(_pairedToken);
946         require(pairedToken.decimals()  > 0 , "Incorrect liquidity token");
947 
948         tokenHandler = new TokenHandler();
949 
950         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), address(pairedToken));
951 
952         WETH = IWETH(dexRouter.WETH());
953         isAMMPair[lpPair] = true;
954 
955         exemptFromLimits[lpPair] = true;
956         exemptFromLimits[newOwner] = true;
957         exemptFromLimits[address(this)] = true;
958         exemptFromLimits[devAddress] = true;
959 
960         exemptFromFees[newOwner] = true;
961         exemptFromFees[address(this)] = true;
962         exemptFromFees[devAddress] = true;
963  
964         _approve(address(devAddress), address(dexRouter), totalSupply() * 12 / 100);
965         _approve(address(this), address(dexRouter), type(uint256).max);
966 
967         super._transfer(newOwner, devAddress, totalSupply() * 12 / 100);
968     
969         transferOwnership(newOwner);
970     }
971 
972     function _transfer(
973         address from,
974         address to,
975         uint256 amount
976     ) internal virtual override {
977         
978         checkLimits(from, to, amount);
979 
980         if(!exemptFromFees[from] && !exemptFromFees[to]){
981             amount -= handleTax(from, to, amount);
982         }
983 
984         super._transfer(from,to,amount);
985     }
986 
987     function checkLimits(address from, address to, uint256 amount) internal {
988 
989         if(!exemptFromFees[from] && !exemptFromFees[to]){
990             require(tradingActive, "Trading not active");
991         }
992 
993         if(limitsInEffect){
994             if (transferDelayEnabled){
995                 if (to != address(dexRouter) && !isAMMPair[to]){
996                     require(_holderLastTransferBlock[tx.origin] < block.number && _holderLastTransferBlock[to] < block.number, "Transfer Delay enabled.");
997                     _holderLastTransferBlock[tx.origin] = block.number;
998                     _holderLastTransferBlock[to] = block.number;
999                 }
1000             }
1001 
1002             // buy
1003             if (isAMMPair[from] && !exemptFromLimits[to]) {
1004                 require(amount <= maxTransaction, "Buy transfer amount exceeded.");
1005                 require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1006             } 
1007             // sell
1008             else if (isAMMPair[to] && !exemptFromLimits[from]) {
1009                 require(amount <= maxTransaction, "Sell transfer amount exceeds the maxTransactionAmt.");
1010             }
1011             else if(!exemptFromLimits[to]) {
1012                 require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1013             }
1014         }
1015     }
1016 
1017     function handleTax(address from, address to, uint256 amount) internal returns (uint256){
1018         uint256 contractTokenBalance = balanceOf(address(this));
1019         
1020         bool canSwap = contractTokenBalance >= swapTokensAtAmt;
1021 
1022         if(canSwap && swapEnabled && !swapping && isAMMPair[to]) {
1023             swapping = true;
1024             swapBack();
1025             swapping = false;
1026         }
1027         
1028         uint256 tax = 0;
1029         uint256 tokensForBurn = 0;
1030 
1031         // on sell
1032         if (isAMMPair[to] && sellTotalTax > 0){
1033             tax = amount * sellTotalTax / FEE_DIVISOR;
1034             tokensForLiquidity += tax * sellLiquidityTax / sellTotalTax;
1035             tokensForMarketing += tax * sellMarketingTax / sellTotalTax;
1036             tokensForDev += tax * sellDevTax / sellTotalTax;
1037             tokensForBurn += tax * sellBurnTax / sellTotalTax;
1038         }
1039 
1040         // on buy
1041         else if(isAMMPair[from] && buyTotalTax > 0) {
1042             tax = amount * buyTotalTax / FEE_DIVISOR;
1043             tokensForMarketing += tax * buyMarketingTax / buyTotalTax;
1044             tokensForLiquidity += tax * buyLiquidityTax / buyTotalTax;
1045             tokensForDev += tax * buyDevTax / buyTotalTax;
1046             tokensForBurn += tax * buyBurnTax / buyTotalTax;
1047 
1048         }
1049         
1050         if(tax > 0){    
1051             super._transfer(from, address(this), tax);
1052         }
1053 
1054         if(tokensForBurn > 0){
1055             _burn(address(this), tokensForBurn);
1056         }
1057         
1058         return tax;
1059     }
1060 
1061     function swapTokensForPAIREDTOKEN(uint256 tokenAmt) private {
1062 
1063         address[] memory path = new address[](2);
1064         path[0] = address(this);
1065         path[1] = address(pairedToken);
1066 
1067         dexRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1068             tokenAmt,
1069             0,
1070             path,
1071             address(tokenHandler),
1072             block.timestamp
1073         );
1074 
1075         tokenHandler.sendTokenToOwner(address(pairedToken));
1076     }
1077 
1078     function addLiquidity(uint256 tokenAmount, uint256 pairedTokenAmount) private {
1079         pairedToken.approve(address(dexRouter), pairedTokenAmount);
1080 
1081         // add the liquidity
1082         dexRouter.addLiquidity(address(this), address(pairedToken), tokenAmount, pairedTokenAmount, 0,  0,  address(liquidityAddress), block.timestamp);
1083     }
1084 
1085     function swapBack() private {
1086 
1087         uint256 contractBalance = balanceOf(address(this));
1088         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1089         
1090         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1091 
1092         if(contractBalance > swapTokensAtAmt * 20){
1093             contractBalance = swapTokensAtAmt * 20;
1094         }
1095         
1096         // Halve the amount of liquidity tokens
1097         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1098         
1099         swapTokensForPAIREDTOKEN(contractBalance - liquidityTokens);
1100 
1101         tokenHandler.sendTokenToOwner(address(pairedToken));
1102         
1103         uint256 pairedTokenBalance = pairedToken.balanceOf(address(this));
1104         uint256 pairedTokenForLiquidity = pairedTokenBalance;
1105 
1106         uint256 pairedTokenForMarketing = pairedTokenBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
1107         uint256 pairedTokenForDev = pairedTokenBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
1108 
1109         pairedTokenForLiquidity -= pairedTokenForMarketing + pairedTokenForDev;
1110             
1111         tokensForLiquidity = 0;
1112         tokensForMarketing = 0;
1113         tokensForDev = 0;
1114         
1115         if(liquidityTokens > 0 && pairedTokenForLiquidity > 0){
1116             addLiquidity(liquidityTokens, pairedTokenForLiquidity);
1117         }
1118 
1119         if(pairedTokenForDev > 0){
1120             SafeERC20.safeTransfer(pairedToken, devAddress, pairedTokenForDev);
1121         }
1122 
1123         if(pairedToken.balanceOf(address(this)) > 0){
1124             SafeERC20.safeTransfer(pairedToken, marketingAddress, pairedToken.balanceOf(address(this)));
1125         }
1126     }
1127 
1128     // owner functions
1129     function setExemptFromFees(address _address, bool _isExempt) external onlyOwner {
1130         require(_address != address(0), "Zero Address");
1131         exemptFromFees[_address] = _isExempt;
1132         emit SetExemptFromFees(_address, _isExempt);
1133     }
1134 
1135     function setExemptFromLimits(address _address, bool _isExempt) external onlyOwner {
1136         require(_address != address(0), "Zero Address");
1137         if(!_isExempt){
1138             require(_address != lpPair, "Cannot remove pair");
1139         }
1140         exemptFromLimits[_address] = _isExempt;
1141         emit SetExemptFromLimits(_address, _isExempt);
1142     }
1143 
1144     function updateMaxTransaction(uint256 newNumInTokens) external onlyOwner {
1145         require(newNumInTokens >= (totalSupply() * 1 / 1000)/(10**decimals()), "Too low");
1146         maxTransaction = newNumInTokens * (10**decimals());
1147         emit UpdatedMaxTransaction(maxTransaction);
1148     }
1149 
1150     function updateMaxWallet(uint256 newNumInTokens) external onlyOwner {
1151         require(newNumInTokens >= (totalSupply() * 1 / 1000)/(10**decimals()), "Too low");
1152         maxWallet = newNumInTokens * (10**decimals());
1153         emit UpdatedMaxWallet(maxWallet);
1154     }
1155 
1156     function updateBuyTax(uint256 _marketingTax, uint256 _liquidityTax, uint256 _devTax, uint256 _burnTax) external onlyOwner {
1157         buyMarketingTax = _marketingTax;
1158         buyLiquidityTax = _liquidityTax;
1159         buyDevTax = _devTax;
1160         buyBurnTax = _burnTax;
1161         buyTotalTax = buyMarketingTax + buyLiquidityTax + buyDevTax + buyBurnTax;
1162         require(buyTotalTax <= 1000, "Keep tax below 10%");
1163         emit UpdatedBuyTax(buyTotalTax);
1164     }
1165 
1166     function updateSellTax(uint256 _marketingTax, uint256 _liquidityTax, uint256 _devTax, uint256 _burnTax) external onlyOwner {
1167         sellMarketingTax = _marketingTax;
1168         sellLiquidityTax = _liquidityTax;
1169         sellDevTax = _devTax;
1170         sellBurnTax = _burnTax;
1171         sellTotalTax = sellMarketingTax + sellLiquidityTax + sellDevTax + sellBurnTax;
1172         require(sellTotalTax <= 1000, "Keep tax below 10%");
1173         emit UpdatedSellTax(sellTotalTax);
1174     }
1175 
1176     function enableTrading() external onlyOwner {
1177         tradingActive = true;
1178     }
1179 
1180     function removeLimits() external onlyOwner {
1181         limitsInEffect = false;
1182         transferDelayEnabled = false;
1183         maxTransaction = totalSupply();
1184         maxWallet = totalSupply();
1185         emit RemovedLimits();
1186     }
1187 
1188     function disableTransferDelay() external onlyOwner {
1189         transferDelayEnabled = false;
1190     }
1191 
1192     function airdropToWallets(address[] calldata wallets, uint256[] calldata amountsInWei) external onlyOwner {
1193         require(wallets.length == amountsInWei.length, "arrays length mismatch");
1194         for(uint256 i = 0; i < wallets.length; i++){
1195             super._transfer(msg.sender, wallets[i], amountsInWei[i]);
1196         }
1197     }
1198 
1199     function rescueTokens(address _token, address _to) external onlyOwner {
1200         require(_token != address(0), "_token address cannot be 0");
1201         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1202         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
1203     }
1204 
1205     function updateMarketingAddress(address _address) external onlyOwner {
1206         require(_address != address(0), "zero address");
1207         marketingAddress = _address;
1208     }
1209 
1210     function updateDevAddress(address _address) external onlyOwner {
1211         require(_address != address(0), "zero address");
1212         devAddress = _address;
1213     }
1214 
1215     function updateLiquidityAddress(address _address) external onlyOwner {
1216         require(_address != address(0), "zero address");
1217         liquidityAddress = _address;
1218     }
1219 
1220     function burnTokens(uint256 amount) external {
1221         require(balanceOf(msg.sender) >= amount, "not enough tokens");
1222         _burn(msg.sender, amount);
1223     }
1224 }