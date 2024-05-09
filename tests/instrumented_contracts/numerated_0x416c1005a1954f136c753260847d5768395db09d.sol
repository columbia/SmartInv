1 // SPDX-License-Identifier: MIT
2 // Developer: jawadklair.eth
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _setOwner(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _setOwner(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _setOwner(newOwner);
84     }
85 
86     function _setOwner(address newOwner) private {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 /**
94  * @dev Interface of the ERC165 standard, as defined in the
95  * https://eips.ethereum.org/EIPS/eip-165[EIP].
96  *
97  * Implementers can declare support of contract interfaces, which can then be
98  * queried by others ({ERC165Checker}).
99  *
100  * For an implementation, see {ERC165}.
101  */
102 interface IERC165 {
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 }
113 
114 /**
115  * @dev Required interface of an ERC721 compliant contract.
116  */
117 interface IERC721 is IERC165 {
118     /**
119      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
122 
123     /**
124      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
125      */
126     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
130      */
131     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
132 
133     /**
134      * @dev Returns the number of tokens in ``owner``'s account.
135      */
136     function balanceOf(address owner) external view returns (uint256 balance);
137 
138     /**
139      * @dev Returns the owner of the `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function ownerOf(uint256 tokenId) external view returns (address owner);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
149      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId
165     ) external;
166 
167     /**
168      * @dev Transfers `tokenId` token from `from` to `to`.
169      *
170      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
189      * The approval is cleared when the token is transferred.
190      *
191      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
192      *
193      * Requirements:
194      *
195      * - The caller must own the token or be an approved operator.
196      * - `tokenId` must exist.
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address to, uint256 tokenId) external;
201 
202     /**
203      * @dev Returns the account approved for `tokenId` token.
204      *
205      * Requirements:
206      *
207      * - `tokenId` must exist.
208      */
209     function getApproved(uint256 tokenId) external view returns (address operator);
210 
211     /**
212      * @dev Approve or remove `operator` as an operator for the caller.
213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
214      *
215      * Requirements:
216      *
217      * - The `operator` cannot be the caller.
218      *
219      * Emits an {ApprovalForAll} event.
220      */
221     function setApprovalForAll(address operator, bool _approved) external;
222 
223     /**
224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
225      *
226      * See {setApprovalForAll}
227      */
228     function isApprovedForAll(address owner, address operator) external view returns (bool);
229 
230     /**
231      * @dev Safely transfers `tokenId` token from `from` to `to`.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must exist and be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
239      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
240      *
241      * Emits a {Transfer} event.
242      */
243     function safeTransferFrom(
244         address from,
245         address to,
246         uint256 tokenId,
247         bytes calldata data
248     ) external;
249 }
250 
251 /**
252  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
253  * @dev See https://eips.ethereum.org/EIPS/eip-721
254  */
255 interface IERC721Enumerable is IERC721 {
256     /**
257      * @dev Returns the total amount of tokens stored by the contract.
258      */
259     function totalSupply() external view returns (uint256);
260 
261     /**
262      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
263      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
264      */
265     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
266 
267     /**
268      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
269      * Use along with {totalSupply} to enumerate all tokens.
270      */
271     function tokenByIndex(uint256 index) external view returns (uint256);
272 }
273 
274 /**
275  * @dev Interface of the ERC20 standard as defined in the EIP.
276  */
277 interface IERC20 {
278     /**
279      * @dev Returns the amount of tokens in existence.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     /**
284      * @dev Returns the amount of tokens owned by `account`.
285      */
286     function balanceOf(address account) external view returns (uint256);
287 
288     /**
289      * @dev Moves `amount` tokens from the caller's account to `recipient`.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transfer(address recipient, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Returns the remaining number of tokens that `spender` will be
299      * allowed to spend on behalf of `owner` through {transferFrom}. This is
300      * zero by default.
301      *
302      * This value changes when {approve} or {transferFrom} are called.
303      */
304     function allowance(address owner, address spender) external view returns (uint256);
305 
306     /**
307      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * IMPORTANT: Beware that changing an allowance with this method brings the risk
312      * that someone may use both the old and the new allowance by unfortunate
313      * transaction ordering. One possible solution to mitigate this race
314      * condition is to first reduce the spender's allowance to 0 and set the
315      * desired value afterwards:
316      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address spender, uint256 amount) external returns (bool);
321 
322     /**
323      * @dev Moves `amount` tokens from `sender` to `recipient` using the
324      * allowance mechanism. `amount` is then deducted from the caller's
325      * allowance.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transferFrom(
332         address sender,
333         address recipient,
334         uint256 amount
335     ) external returns (bool);
336 
337     /**
338      * @dev Emitted when `value` tokens are moved from one account (`from`) to
339      * another (`to`).
340      *
341      * Note that `value` may be zero.
342      */
343     event Transfer(address indexed from, address indexed to, uint256 value);
344 
345     /**
346      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
347      * a call to {approve}. `value` is the new allowance.
348      */
349     event Approval(address indexed owner, address indexed spender, uint256 value);
350 }
351 
352 /**
353  * @dev Interface for the optional metadata functions from the ERC20 standard.
354  *
355  * _Available since v4.1._
356  */
357 interface IERC20Metadata is IERC20 {
358     /**
359      * @dev Returns the name of the token.
360      */
361     function name() external view returns (string memory);
362 
363     /**
364      * @dev Returns the symbol of the token.
365      */
366     function symbol() external view returns (string memory);
367 
368     /**
369      * @dev Returns the decimals places of the token.
370      */
371     function decimals() external view returns (uint8);
372 }
373 
374 /**
375  * @dev Implementation of the {IERC20} interface.
376  *
377  * This implementation is agnostic to the way tokens are created. This means
378  * that a supply mechanism has to be added in a derived contract using {_mint}.
379  * For a generic mechanism see {ERC20PresetMinterPauser}.
380  *
381  * TIP: For a detailed writeup see our guide
382  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
383  * to implement supply mechanisms].
384  *
385  * We have followed general OpenZeppelin Contracts guidelines: functions revert
386  * instead returning `false` on failure. This behavior is nonetheless
387  * conventional and does not conflict with the expectations of ERC20
388  * applications.
389  *
390  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
391  * This allows applications to reconstruct the allowance for all accounts just
392  * by listening to said events. Other implementations of the EIP may not emit
393  * these events, as it isn't required by the specification.
394  *
395  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
396  * functions have been added to mitigate the well-known issues around setting
397  * allowances. See {IERC20-approve}.
398  */
399 contract ERC20 is Context, IERC20, IERC20Metadata {
400     mapping(address => uint256) private _balances;
401 
402     mapping(address => mapping(address => uint256)) private _allowances;
403 
404     uint256 private _totalSupply;
405 
406     string private _name;
407     string private _symbol;
408 
409     /**
410      * @dev Sets the values for {name} and {symbol}.
411      *
412      * The default value of {decimals} is 18. To select a different value for
413      * {decimals} you should overload it.
414      *
415      * All two of these values are immutable: they can only be set once during
416      * construction.
417      */
418     constructor(string memory name_, string memory symbol_) {
419         _name = name_;
420         _symbol = symbol_;
421     }
422 
423     /**
424      * @dev Returns the name of the token.
425      */
426     function name() public view virtual override returns (string memory) {
427         return _name;
428     }
429 
430     /**
431      * @dev Returns the symbol of the token, usually a shorter version of the
432      * name.
433      */
434     function symbol() public view virtual override returns (string memory) {
435         return _symbol;
436     }
437 
438     /**
439      * @dev Returns the number of decimals used to get its user representation.
440      * For example, if `decimals` equals `2`, a balance of `505` tokens should
441      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
442      *
443      * Tokens usually opt for a value of 18, imitating the relationship between
444      * Ether and Wei. This is the value {ERC20} uses, unless this function is
445      * overridden;
446      *
447      * NOTE: This information is only used for _display_ purposes: it in
448      * no way affects any of the arithmetic of the contract, including
449      * {IERC20-balanceOf} and {IERC20-transfer}.
450      */
451     function decimals() public view virtual override returns (uint8) {
452         return 18;
453     }
454 
455     /**
456      * @dev See {IERC20-totalSupply}.
457      */
458     function totalSupply() public view virtual override returns (uint256) {
459         return _totalSupply;
460     }
461 
462     /**
463      * @dev See {IERC20-balanceOf}.
464      */
465     function balanceOf(address account) public view virtual override returns (uint256) {
466         return _balances[account];
467     }
468 
469     /**
470      * @dev See {IERC20-transfer}.
471      *
472      * Requirements:
473      *
474      * - `recipient` cannot be the zero address.
475      * - the caller must have a balance of at least `amount`.
476      */
477     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
478         _transfer(_msgSender(), recipient, amount);
479         return true;
480     }
481 
482     /**
483      * @dev See {IERC20-allowance}.
484      */
485     function allowance(address owner, address spender) public view virtual override returns (uint256) {
486         return _allowances[owner][spender];
487     }
488 
489     /**
490      * @dev See {IERC20-approve}.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      */
496     function approve(address spender, uint256 amount) public virtual override returns (bool) {
497         _approve(_msgSender(), spender, amount);
498         return true;
499     }
500 
501     /**
502      * @dev See {IERC20-transferFrom}.
503      *
504      * Emits an {Approval} event indicating the updated allowance. This is not
505      * required by the EIP. See the note at the beginning of {ERC20}.
506      *
507      * Requirements:
508      *
509      * - `sender` and `recipient` cannot be the zero address.
510      * - `sender` must have a balance of at least `amount`.
511      * - the caller must have allowance for ``sender``'s tokens of at least
512      * `amount`.
513      */
514     function transferFrom(
515         address sender,
516         address recipient,
517         uint256 amount
518     ) public virtual override returns (bool) {
519         _transfer(sender, recipient, amount);
520 
521         uint256 currentAllowance = _allowances[sender][_msgSender()];
522         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
523         unchecked {
524             _approve(sender, _msgSender(), currentAllowance - amount);
525         }
526 
527         return true;
528     }
529 
530     /**
531      * @dev Atomically increases the allowance granted to `spender` by the caller.
532      *
533      * This is an alternative to {approve} that can be used as a mitigation for
534      * problems described in {IERC20-approve}.
535      *
536      * Emits an {Approval} event indicating the updated allowance.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      */
542     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
543         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
544         return true;
545     }
546 
547     /**
548      * @dev Atomically decreases the allowance granted to `spender` by the caller.
549      *
550      * This is an alternative to {approve} that can be used as a mitigation for
551      * problems described in {IERC20-approve}.
552      *
553      * Emits an {Approval} event indicating the updated allowance.
554      *
555      * Requirements:
556      *
557      * - `spender` cannot be the zero address.
558      * - `spender` must have allowance for the caller of at least
559      * `subtractedValue`.
560      */
561     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
562         uint256 currentAllowance = _allowances[_msgSender()][spender];
563         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
564         unchecked {
565             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
566         }
567 
568         return true;
569     }
570 
571     /**
572      * @dev Moves `amount` of tokens from `sender` to `recipient`.
573      *
574      * This internal function is equivalent to {transfer}, and can be used to
575      * e.g. implement automatic token fees, slashing mechanisms, etc.
576      *
577      * Emits a {Transfer} event.
578      *
579      * Requirements:
580      *
581      * - `sender` cannot be the zero address.
582      * - `recipient` cannot be the zero address.
583      * - `sender` must have a balance of at least `amount`.
584      */
585     function _transfer(
586         address sender,
587         address recipient,
588         uint256 amount
589     ) internal virtual {
590         require(sender != address(0), "ERC20: transfer from the zero address");
591         require(recipient != address(0), "ERC20: transfer to the zero address");
592 
593         _beforeTokenTransfer(sender, recipient, amount);
594 
595         uint256 senderBalance = _balances[sender];
596         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
597         unchecked {
598             _balances[sender] = senderBalance - amount;
599         }
600         _balances[recipient] += amount;
601 
602         emit Transfer(sender, recipient, amount);
603 
604         _afterTokenTransfer(sender, recipient, amount);
605     }
606 
607     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
608      * the total supply.
609      *
610      * Emits a {Transfer} event with `from` set to the zero address.
611      *
612      * Requirements:
613      *
614      * - `account` cannot be the zero address.
615      */
616     function _mint(address account, uint256 amount) internal virtual {
617         require(account != address(0), "ERC20: mint to the zero address");
618 
619         _beforeTokenTransfer(address(0), account, amount);
620 
621         _totalSupply += amount;
622         _balances[account] += amount;
623         emit Transfer(address(0), account, amount);
624 
625         _afterTokenTransfer(address(0), account, amount);
626     }
627 
628     /**
629      * @dev Destroys `amount` tokens from `account`, reducing the
630      * total supply.
631      *
632      * Emits a {Transfer} event with `to` set to the zero address.
633      *
634      * Requirements:
635      *
636      * - `account` cannot be the zero address.
637      * - `account` must have at least `amount` tokens.
638      */
639     function _burn(address account, uint256 amount) internal virtual {
640         require(account != address(0), "ERC20: burn from the zero address");
641 
642         _beforeTokenTransfer(account, address(0), amount);
643 
644         uint256 accountBalance = _balances[account];
645         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
646         unchecked {
647             _balances[account] = accountBalance - amount;
648         }
649         _totalSupply -= amount;
650 
651         emit Transfer(account, address(0), amount);
652 
653         _afterTokenTransfer(account, address(0), amount);
654     }
655 
656     /**
657      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
658      *
659      * This internal function is equivalent to `approve`, and can be used to
660      * e.g. set automatic allowances for certain subsystems, etc.
661      *
662      * Emits an {Approval} event.
663      *
664      * Requirements:
665      *
666      * - `owner` cannot be the zero address.
667      * - `spender` cannot be the zero address.
668      */
669     function _approve(
670         address owner,
671         address spender,
672         uint256 amount
673     ) internal virtual {
674         require(owner != address(0), "ERC20: approve from the zero address");
675         require(spender != address(0), "ERC20: approve to the zero address");
676 
677         _allowances[owner][spender] = amount;
678         emit Approval(owner, spender, amount);
679     }
680 
681     /**
682      * @dev Hook that is called before any transfer of tokens. This includes
683      * minting and burning.
684      *
685      * Calling conditions:
686      *
687      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
688      * will be transferred to `to`.
689      * - when `from` is zero, `amount` tokens will be minted for `to`.
690      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
691      * - `from` and `to` are never both zero.
692      *
693      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
694      */
695     function _beforeTokenTransfer(
696         address from,
697         address to,
698         uint256 amount
699     ) internal virtual {}
700 
701     /**
702      * @dev Hook that is called after any transfer of tokens. This includes
703      * minting and burning.
704      *
705      * Calling conditions:
706      *
707      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
708      * has been transferred to `to`.
709      * - when `from` is zero, `amount` tokens have been minted for `to`.
710      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
711      * - `from` and `to` are never both zero.
712      *
713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
714      */
715     function _afterTokenTransfer(
716         address from,
717         address to,
718         uint256 amount
719     ) internal virtual {}
720 }
721 
722 /**
723  * @dev Extension of {ERC20} that allows token holders to destroy both their own
724  * tokens and those that they have an allowance for, in a way that can be
725  * recognized off-chain (via event analysis).
726  */
727 abstract contract ERC20Burnable is Context, ERC20 {
728     /**
729      * @dev Destroys `amount` tokens from the caller.
730      *
731      * See {ERC20-_burn}.
732      */
733     function burn(uint256 amount) public virtual {
734         _burn(_msgSender(), amount);
735     }
736 
737     /**
738      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
739      * allowance.
740      *
741      * See {ERC20-_burn} and {ERC20-allowance}.
742      *
743      * Requirements:
744      *
745      * - the caller must have allowance for ``accounts``'s tokens of at least
746      * `amount`.
747      */
748     function burnFrom(address account, uint256 amount) public virtual {
749         uint256 currentAllowance = allowance(account, _msgSender());
750         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
751         unchecked {
752             _approve(account, _msgSender(), currentAllowance - amount);
753         }
754         _burn(account, amount);
755     }
756 }
757 
758 contract OxCrystalsStaking is ERC20Burnable, Ownable {
759 
760     bool isOwnerMintLocked;
761     mapping(address => bool) public IS_CLAIMABLE; // set nft contract address which can be staked
762     mapping(address => uint256) public INITIAL_REWARD; //set one time claimable reward for nft
763     mapping(address => uint256) public MAX_EMISSION_TIME; //set for how much time nft will yeild reward
764     mapping(address => uint256) public CLAIMING_START_TIME; //set from what point to start claim proccess
765     mapping(address => uint256) private EMISSION_RATE_PER_SEC; // set emission for each nft should be set by per sec value
766 
767     mapping(address => mapping(uint256 => uint256)) private tokenIdLastClaimTime; // blocktime at which an nft was staked
768     mapping(address => mapping(uint256 => uint256)) private initialRewardClaimed; // to keep track if one time reward has been claimed for token id
769     mapping(address => mapping(uint256 => uint256)) private nftTokenIdRewardTimeLeft; // to keep track for how much total time nft has been staked
770     
771     constructor() ERC20("0x0", "0x0") {
772     }
773 
774     function ownerMint(uint256 amount) external onlyOwner {
775         require(!isOwnerMintLocked, "Owner Mint is Locked");
776         _mint(msg.sender, (amount*10**18));
777     }
778 
779     function lockOwnerMint() external onlyOwner {
780         isOwnerMintLocked = true;
781     }
782 
783     function setClaimingSettingFor(address nftContractAddress, uint256 emissionRatePerSec, uint256 emissionDuration, uint256 initialReward, uint256 claimingStartTime) external onlyOwner {
784         INITIAL_REWARD[nftContractAddress] = initialReward;
785         MAX_EMISSION_TIME[nftContractAddress] = emissionDuration;
786         CLAIMING_START_TIME[nftContractAddress] = claimingStartTime;
787         EMISSION_RATE_PER_SEC[nftContractAddress] = emissionRatePerSec;
788     }
789 
790     function toggleClaimingFor(address nftContractAddress) external onlyOwner {
791         IS_CLAIMABLE[nftContractAddress] = !IS_CLAIMABLE[nftContractAddress];
792     }
793 
794     function cliamOneTimeRewardById(address nftContractAddress, uint256 tokenId) external {
795         require(IS_CLAIMABLE[nftContractAddress], "Wrong NFT contract");
796         require(initialRewardClaimed[nftContractAddress][tokenId] == 0, "Already claimed one Time claimable tokens for this id");
797 
798         initialRewardClaimed[nftContractAddress][tokenId] = 1;
799         tokenIdLastClaimTime[nftContractAddress][tokenId] = CLAIMING_START_TIME[nftContractAddress];
800         nftTokenIdRewardTimeLeft[nftContractAddress][tokenId] = MAX_EMISSION_TIME[nftContractAddress];
801 
802         _mint(msg.sender, INITIAL_REWARD[nftContractAddress]);
803     }
804 
805     function cliamAllOneTimeRewards(address nftContractAddress) external {
806         require(IS_CLAIMABLE[nftContractAddress], "Wrong NFT contract");
807         uint256 totalRewards = 0;
808 
809         IERC721Enumerable nftContract = IERC721Enumerable(nftContractAddress);
810 
811         uint256 nftBalance = nftContract.balanceOf(_msgSender());
812         uint256 rewardPerId = INITIAL_REWARD[nftContractAddress];
813         for (uint256 i = 0; i < nftBalance; i++) {
814             uint256 id = nftContract.tokenOfOwnerByIndex(_msgSender(), i);
815             if(initialRewardClaimed[nftContractAddress][id] == 0) {
816                 totalRewards += rewardPerId;
817                 initialRewardClaimed[nftContractAddress][id] = 1;
818                 tokenIdLastClaimTime[nftContractAddress][id] = CLAIMING_START_TIME[nftContractAddress];
819                 nftTokenIdRewardTimeLeft[nftContractAddress][id] = MAX_EMISSION_TIME[nftContractAddress];
820             }
821         }
822         require(totalRewards > 0, "One time claimable tokens already claimed for your NFTs");
823         _mint(msg.sender, totalRewards);
824     }
825     
826     function claimByNFTTokenId(address nftContractAddress, uint256 tokenId) external {
827         require(IS_CLAIMABLE[nftContractAddress], "Wrong NFT contract");
828         require(nftTokenIdRewardTimeLeft[nftContractAddress][tokenId] != 0, "All tokens claimed for this ID");
829 
830         IERC721Enumerable nftContract = IERC721Enumerable(nftContractAddress);
831         require(nftContract.ownerOf(tokenId) == _msgSender(), "You are not the owner of this NFT");
832         uint256 lastClaimTime = tokenIdLastClaimTime[nftContractAddress][tokenId];
833         require(lastClaimTime != 0, "First claim Initial Reward for Your NFTs");
834         uint256 timeleft = nftTokenIdRewardTimeLeft[nftContractAddress][tokenId];
835 
836         if(timeleft < (block.timestamp - lastClaimTime)) {
837             nftTokenIdRewardTimeLeft[nftContractAddress][tokenId] = 0;
838             _mint(msg.sender, (timeleft * EMISSION_RATE_PER_SEC[nftContractAddress]));
839         }
840         else {
841             nftTokenIdRewardTimeLeft[nftContractAddress][tokenId] -= (block.timestamp - lastClaimTime);
842             _mint(msg.sender, ((block.timestamp - lastClaimTime) * EMISSION_RATE_PER_SEC[nftContractAddress]));
843         }
844         tokenIdLastClaimTime[nftContractAddress][tokenId] = block.timestamp;
845     }
846     
847     function claimAll(address nftContractAddress) external {
848         require(IS_CLAIMABLE[nftContractAddress], "Wrong NFT contract");
849         uint256 totalRewards = 0;
850 
851         IERC721Enumerable nftContract = IERC721Enumerable(nftContractAddress);
852 
853         uint256 nftBalance = nftContract.balanceOf(_msgSender());
854         uint256 emissionRate = EMISSION_RATE_PER_SEC[nftContractAddress];
855         for (uint256 i = 0; i < nftBalance; i++) {
856             uint256 id = nftContract.tokenOfOwnerByIndex(_msgSender(), i);
857             uint256 lastClaimTime = tokenIdLastClaimTime[nftContractAddress][id];
858             require(lastClaimTime != 0, "First claim Initial Reward for Your NFTs");
859             uint256 timeleft = nftTokenIdRewardTimeLeft[nftContractAddress][id];
860 
861             if(timeleft < (block.timestamp - lastClaimTime)) {
862                 nftTokenIdRewardTimeLeft[nftContractAddress][id] = 0;
863                 totalRewards += (timeleft * emissionRate);
864             }
865             else {
866                 nftTokenIdRewardTimeLeft[nftContractAddress][id] -= (block.timestamp - lastClaimTime);
867                 totalRewards += ((block.timestamp - lastClaimTime) * emissionRate);
868             }
869             tokenIdLastClaimTime[nftContractAddress][id] = block.timestamp;
870         }
871         
872         _mint(msg.sender, totalRewards);
873     }
874 
875     function getAllRewards(address nftContractAddress, address claimer) external view returns (uint256) {
876         uint256 totalRewards = 0;
877 
878         IERC721Enumerable nftContract = IERC721Enumerable(nftContractAddress);
879         uint256 nftBalance = nftContract.balanceOf(claimer);
880 
881         for (uint256 i = 0; i < nftBalance; i++) {
882             uint256 id = nftContract.tokenOfOwnerByIndex(claimer, i);
883             totalRewards += ((block.timestamp - tokenIdLastClaimTime[nftContractAddress][id]) * EMISSION_RATE_PER_SEC[nftContractAddress]);
884         }
885         
886         return totalRewards;
887     }
888 
889     function getRewardsForNFTTokenId(address nftContractAddress, uint256 tokenId) external view returns (uint256) {
890         uint256 secondsStaked = block.timestamp - tokenIdLastClaimTime[nftContractAddress][tokenId];
891         return secondsStaked * EMISSION_RATE_PER_SEC[nftContractAddress];
892     }
893 
894     function getRewardTimeLeftForNFTTokenId(address nftContractAddress, uint256 tokenId) external view returns (uint256) {
895         return nftTokenIdRewardTimeLeft[nftContractAddress][tokenId];
896     }
897     
898 }