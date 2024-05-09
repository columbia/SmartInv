1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4     $$8$$$8$$$$$$$88$$$$$$$$8$8$$$$
5     8...................8..8......$
6     $.8......88.......8.......8...$
7     $..88.......8CC8CC............$
8     $8.........C88OOO8CC......8..8$
9     $8.8.....88OOR8RRR8OCC8....8..$
10     $.......C.ORRRRRRRRRO.C....8..$
11     $....8.C.88RRUUUUURRRO.C.8....$
12     $8...8C.8RR.UP8PPPU.RRO.C.....$
13     $.8..8.OR8.88.T88.PU.RRO.88...$
14     $...8CO8R.UPTTI8I8TP8.RROC.8.8$
15     $...CO8R.UPT.IOOO8.TPU.RROC..8$
16     $.88CORRUP8.IO8N8OI.TPURR8C8..$
17     $..C8RR8P.TION.8.8OIT.P8RROC..$
18     $.8COR8UP8ION..8..NOIT8URROC..$
19     8..CORRUPTION..8..NOI8PURRO8..$
20     $.88ORRUP8ION.....8OITPU8ROC..$
21     $..CORRUP.TION...NOIT.PURR8C..$
22     $...COR8UPT.I8N8NOI.TP8RROC..8$
23     $...COR8.U8T8IOO8I.TPU8RROC...$
24     $8...C88R.UPTTIII8888.RROC..8.$
25     $8.8.C.ORR.8P.TT88PU.RRO.C8...$
26     $.8...C.ORR.UPP8PP8.R8O.C...8.$
27     $......C.8R88UUUU8RRRO.C8....8$
28     8.......C.OR8RRRRRRRO.C.......$
29     $....8.8.CCOORRRR888CC...88...$
30     $..........CCOO8OOCC..........$
31     $........88..CCC8C..8.........$
32     88.8......8.............88....$
33     $.....................88..88..$
34     $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
35 
36     gm fellow onchain vagina nft holders
37 */
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         return msg.data;
58     }
59 }
60 
61 /**
62  * @dev Contract module which provides a basic access control mechanism, where
63  * there is an account (an owner) that can be granted exclusive access to
64  * specific functions.
65  *
66  * By default, the owner account will be the one that deploys the contract. This
67  * can later be changed with {transferOwnership}.
68  *
69  * This module is used through inheritance. It will make available the modifier
70  * `onlyOwner`, which can be applied to your functions to restrict their use to
71  * the owner.
72  */
73 abstract contract Ownable is Context {
74     address private _owner;
75 
76     event OwnershipTransferred(
77         address indexed previousOwner,
78         address indexed newOwner
79     );
80 
81     /**
82      * @dev Initializes the contract setting the deployer as the initial owner.
83      */
84     constructor() {
85         _setOwner(_msgSender());
86     }
87 
88     /**
89      * @dev Returns the address of the current owner.
90      */
91     function owner() public view virtual returns (address) {
92         return _owner;
93     }
94 
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     modifier onlyOwner() {
99         require(owner() == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     /**
104      * @dev Leaves the contract without owner. It will not be possible to call
105      * `onlyOwner` functions anymore. Can only be called by the current owner.
106      *
107      * NOTE: Renouncing ownership will leave the contract without an owner,
108      * thereby removing any functionality that is only available to the owner.
109      */
110     function renounceOwnership() public virtual onlyOwner {
111         _setOwner(address(0));
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Can only be called by the current owner.
117      */
118     function transferOwnership(address newOwner) public virtual onlyOwner {
119         require(
120             newOwner != address(0),
121             "Ownable: new owner is the zero address"
122         );
123         _setOwner(newOwner);
124     }
125 
126     function _setOwner(address newOwner) private {
127         address oldOwner = _owner;
128         _owner = newOwner;
129         emit OwnershipTransferred(oldOwner, newOwner);
130     }
131 }
132 
133 /**
134  * @dev Interface of the ERC20 standard as defined in the EIP.
135  */
136 interface IERC20 {
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141 
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146 
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `recipient`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address recipient, uint256 amount)
155         external
156         returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender)
166         external
167         view
168         returns (uint256);
169 
170     /**
171      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * IMPORTANT: Beware that changing an allowance with this method brings the risk
176      * that someone may use both the old and the new allowance by unfortunate
177      * transaction ordering. One possible solution to mitigate this race
178      * condition is to first reduce the spender's allowance to 0 and set the
179      * desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      *
182      * Emits an {Approval} event.
183      */
184     function approve(address spender, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Moves `amount` tokens from `sender` to `recipient` using the
188      * allowance mechanism. `amount` is then deducted from the caller's
189      * allowance.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) external returns (bool);
200 
201     /**
202      * @dev Emitted when `value` tokens are moved from one account (`from`) to
203      * another (`to`).
204      *
205      * Note that `value` may be zero.
206      */
207     event Transfer(address indexed from, address indexed to, uint256 value);
208 
209     /**
210      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
211      * a call to {approve}. `value` is the new allowance.
212      */
213     event Approval(
214         address indexed owner,
215         address indexed spender,
216         uint256 value
217     );
218 }
219 
220 /**
221  * @dev Interface for the optional metadata functions from the ERC20 standard.
222  *
223  * _Available since v4.1._
224  */
225 interface IERC20Metadata is IERC20 {
226     /**
227      * @dev Returns the name of the token.
228      */
229     function name() external view returns (string memory);
230 
231     /**
232      * @dev Returns the symbol of the token.
233      */
234     function symbol() external view returns (string memory);
235 
236     /**
237      * @dev Returns the decimals places of the token.
238      */
239     function decimals() external view returns (uint8);
240 }
241 
242 /**
243  * @dev Implementation of the {IERC20} interface.
244  *
245  * This implementation is agnostic to the way tokens are created. This means
246  * that a supply mechanism has to be added in a derived contract using {_mint}.
247  * For a generic mechanism see {ERC20PresetMinterPauser}.
248  *
249  * TIP: For a detailed writeup see our guide
250  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
251  * to implement supply mechanisms].
252  *
253  * We have followed general OpenZeppelin Contracts guidelines: functions revert
254  * instead returning `false` on failure. This behavior is nonetheless
255  * conventional and does not conflict with the expectations of ERC20
256  * applications.
257  *
258  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
259  * This allows applications to reconstruct the allowance for all accounts just
260  * by listening to said events. Other implementations of the EIP may not emit
261  * these events, as it isn't required by the specification.
262  *
263  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
264  * functions have been added to mitigate the well-known issues around setting
265  * allowances. See {IERC20-approve}.
266  */
267 contract ERC20 is Context, IERC20, IERC20Metadata {
268     mapping(address => uint256) private _balances;
269 
270     mapping(address => mapping(address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     string private _name;
275     string private _symbol;
276 
277     /**
278      * @dev Sets the values for {name} and {symbol}.
279      *
280      * The default value of {decimals} is 18. To select a different value for
281      * {decimals} you should overload it.
282      *
283      * All two of these values are immutable: they can only be set once during
284      * construction.
285      */
286     constructor(string memory name_, string memory symbol_) {
287         _name = name_;
288         _symbol = symbol_;
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view virtual override returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view virtual override returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei. This is the value {ERC20} uses, unless this function is
313      * overridden;
314      *
315      * NOTE: This information is only used for _display_ purposes: it in
316      * no way affects any of the arithmetic of the contract, including
317      * {IERC20-balanceOf} and {IERC20-transfer}.
318      */
319     function decimals() public view virtual override returns (uint8) {
320         return 18;
321     }
322 
323     /**
324      * @dev See {IERC20-totalSupply}.
325      */
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     /**
331      * @dev See {IERC20-balanceOf}.
332      */
333     function balanceOf(address account)
334         public
335         view
336         virtual
337         override
338         returns (uint256)
339     {
340         return _balances[account];
341     }
342 
343     /**
344      * @dev See {IERC20-transfer}.
345      *
346      * Requirements:
347      *
348      * - `recipient` cannot be the zero address.
349      * - the caller must have a balance of at least `amount`.
350      */
351     function transfer(address recipient, uint256 amount)
352         public
353         virtual
354         override
355         returns (bool)
356     {
357         _transfer(_msgSender(), recipient, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-allowance}.
363      */
364     function allowance(address owner, address spender)
365         public
366         view
367         virtual
368         override
369         returns (uint256)
370     {
371         return _allowances[owner][spender];
372     }
373 
374     /**
375      * @dev See {IERC20-approve}.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function approve(address spender, uint256 amount)
382         public
383         virtual
384         override
385         returns (bool)
386     {
387         _approve(_msgSender(), spender, amount);
388         return true;
389     }
390 
391     /**
392      * @dev See {IERC20-transferFrom}.
393      *
394      * Emits an {Approval} event indicating the updated allowance. This is not
395      * required by the EIP. See the note at the beginning of {ERC20}.
396      *
397      * Requirements:
398      *
399      * - `sender` and `recipient` cannot be the zero address.
400      * - `sender` must have a balance of at least `amount`.
401      * - the caller must have allowance for ``sender``'s tokens of at least
402      * `amount`.
403      */
404     function transferFrom(
405         address sender,
406         address recipient,
407         uint256 amount
408     ) public virtual override returns (bool) {
409         _transfer(sender, recipient, amount);
410 
411         uint256 currentAllowance = _allowances[sender][_msgSender()];
412         require(
413             currentAllowance >= amount,
414             "ERC20: transfer amount exceeds allowance"
415         );
416         unchecked {
417             _approve(sender, _msgSender(), currentAllowance - amount);
418         }
419 
420         return true;
421     }
422 
423     /**
424      * @dev Atomically increases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      */
435     function increaseAllowance(address spender, uint256 addedValue)
436         public
437         virtual
438         returns (bool)
439     {
440         _approve(
441             _msgSender(),
442             spender,
443             _allowances[_msgSender()][spender] + addedValue
444         );
445         return true;
446     }
447 
448     /**
449      * @dev Atomically decreases the allowance granted to `spender` by the caller.
450      *
451      * This is an alternative to {approve} that can be used as a mitigation for
452      * problems described in {IERC20-approve}.
453      *
454      * Emits an {Approval} event indicating the updated allowance.
455      *
456      * Requirements:
457      *
458      * - `spender` cannot be the zero address.
459      * - `spender` must have allowance for the caller of at least
460      * `subtractedValue`.
461      */
462     function decreaseAllowance(address spender, uint256 subtractedValue)
463         public
464         virtual
465         returns (bool)
466     {
467         uint256 currentAllowance = _allowances[_msgSender()][spender];
468         require(
469             currentAllowance >= subtractedValue,
470             "ERC20: decreased allowance below zero"
471         );
472         unchecked {
473             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
474         }
475 
476         return true;
477     }
478 
479     /**
480      * @dev Moves `amount` of tokens from `sender` to `recipient`.
481      *
482      * This internal function is equivalent to {transfer}, and can be used to
483      * e.g. implement automatic token fees, slashing mechanisms, etc.
484      *
485      * Emits a {Transfer} event.
486      *
487      * Requirements:
488      *
489      * - `sender` cannot be the zero address.
490      * - `recipient` cannot be the zero address.
491      * - `sender` must have a balance of at least `amount`.
492      */
493     function _transfer(
494         address sender,
495         address recipient,
496         uint256 amount
497     ) internal virtual {
498         require(sender != address(0), "ERC20: transfer from the zero address");
499         require(recipient != address(0), "ERC20: transfer to the zero address");
500 
501         _beforeTokenTransfer(sender, recipient, amount);
502 
503         uint256 senderBalance = _balances[sender];
504         require(
505             senderBalance >= amount,
506             "ERC20: transfer amount exceeds balance"
507         );
508         unchecked {
509             _balances[sender] = senderBalance - amount;
510         }
511         _balances[recipient] += amount;
512 
513         emit Transfer(sender, recipient, amount);
514 
515         _afterTokenTransfer(sender, recipient, amount);
516     }
517 
518     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
519      * the total supply.
520      *
521      * Emits a {Transfer} event with `from` set to the zero address.
522      *
523      * Requirements:
524      *
525      * - `account` cannot be the zero address.
526      */
527     function _mint(address account, uint256 amount) internal virtual {
528         require(account != address(0), "ERC20: mint to the zero address");
529 
530         _beforeTokenTransfer(address(0), account, amount);
531 
532         _totalSupply += amount;
533         _balances[account] += amount;
534         emit Transfer(address(0), account, amount);
535 
536         _afterTokenTransfer(address(0), account, amount);
537     }
538 
539     /**
540      * @dev Destroys `amount` tokens from `account`, reducing the
541      * total supply.
542      *
543      * Emits a {Transfer} event with `to` set to the zero address.
544      *
545      * Requirements:
546      *
547      * - `account` cannot be the zero address.
548      * - `account` must have at least `amount` tokens.
549      */
550     function _burn(address account, uint256 amount) internal virtual {
551         require(account != address(0), "ERC20: burn from the zero address");
552 
553         _beforeTokenTransfer(account, address(0), amount);
554 
555         uint256 accountBalance = _balances[account];
556         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
557         unchecked {
558             _balances[account] = accountBalance - amount;
559         }
560         _totalSupply -= amount;
561 
562         emit Transfer(account, address(0), amount);
563 
564         _afterTokenTransfer(account, address(0), amount);
565     }
566 
567     /**
568      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
569      *
570      * This internal function is equivalent to `approve`, and can be used to
571      * e.g. set automatic allowances for certain subsystems, etc.
572      *
573      * Emits an {Approval} event.
574      *
575      * Requirements:
576      *
577      * - `owner` cannot be the zero address.
578      * - `spender` cannot be the zero address.
579      */
580     function _approve(
581         address owner,
582         address spender,
583         uint256 amount
584     ) internal virtual {
585         require(owner != address(0), "ERC20: approve from the zero address");
586         require(spender != address(0), "ERC20: approve to the zero address");
587 
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     /**
593      * @dev Hook that is called before any transfer of tokens. This includes
594      * minting and burning.
595      *
596      * Calling conditions:
597      *
598      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
599      * will be transferred to `to`.
600      * - when `from` is zero, `amount` tokens will be minted for `to`.
601      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
602      * - `from` and `to` are never both zero.
603      *
604      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
605      */
606     function _beforeTokenTransfer(
607         address from,
608         address to,
609         uint256 amount
610     ) internal virtual {}
611 
612     /**
613      * @dev Hook that is called after any transfer of tokens. This includes
614      * minting and burning.
615      *
616      * Calling conditions:
617      *
618      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
619      * has been transferred to `to`.
620      * - when `from` is zero, `amount` tokens have been minted for `to`.
621      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
622      * - `from` and `to` are never both zero.
623      *
624      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
625      */
626     function _afterTokenTransfer(
627         address from,
628         address to,
629         uint256 amount
630     ) internal virtual {}
631 }
632 
633 pragma solidity ^0.8.0;
634 
635 /**
636  * @dev Interface of the ERC165 standard, as defined in the
637  * https://eips.ethereum.org/EIPS/eip-165[EIP].
638  *
639  * Implementers can declare support of contract interfaces, which can then be
640  * queried by others ({ERC165Checker}).
641  *
642  * For an implementation, see {ERC165}.
643  */
644 interface IERC165 {
645     /**
646      * @dev Returns true if this contract implements the interface defined by
647      * `interfaceId`. See the corresponding
648      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
649      * to learn more about how these ids are created.
650      *
651      * This function call must use less than 30 000 gas.
652      */
653     function supportsInterface(bytes4 interfaceId) external view returns (bool);
654 }
655 
656 /**
657  * @dev Implementation of the {IERC165} interface.
658  *
659  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
660  * for the additional interface id that will be supported. For example:
661  *
662  * ```solidity
663  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
664  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
665  * }
666  * ```
667  *
668  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
669  */
670 abstract contract ERC165 is IERC165 {
671     /**
672      * @dev See {IERC165-supportsInterface}.
673      */
674     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
675         return interfaceId == type(IERC165).interfaceId;
676     }
677 }
678 
679 /**
680  * @dev Required interface of an ERC721 compliant contract.
681  */
682 interface IERC721 is IERC165 {
683     /**
684      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
685      */
686     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
687 
688     /**
689      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
690      */
691     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
692 
693     /**
694      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
695      */
696     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
697 
698     /**
699      * @dev Returns the number of tokens in ``owner``'s account.
700      */
701     function balanceOf(address owner) external view returns (uint256 balance);
702 
703     /**
704      * @dev Returns the owner of the `tokenId` token.
705      *
706      * Requirements:
707      *
708      * - `tokenId` must exist.
709      */
710     function ownerOf(uint256 tokenId) external view returns (address owner);
711 
712     /**
713      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
714      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
715      *
716      * Requirements:
717      *
718      * - `from` cannot be the zero address.
719      * - `to` cannot be the zero address.
720      * - `tokenId` token must exist and be owned by `from`.
721      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
723      *
724      * Emits a {Transfer} event.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId
730     ) external;
731 
732     /**
733      * @dev Transfers `tokenId` token from `from` to `to`.
734      *
735      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
736      *
737      * Requirements:
738      *
739      * - `from` cannot be the zero address.
740      * - `to` cannot be the zero address.
741      * - `tokenId` token must be owned by `from`.
742      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
743      *
744      * Emits a {Transfer} event.
745      */
746     function transferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) external;
751 
752     /**
753      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
754      * The approval is cleared when the token is transferred.
755      *
756      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
757      *
758      * Requirements:
759      *
760      * - The caller must own the token or be an approved operator.
761      * - `tokenId` must exist.
762      *
763      * Emits an {Approval} event.
764      */
765     function approve(address to, uint256 tokenId) external;
766 
767     /**
768      * @dev Returns the account approved for `tokenId` token.
769      *
770      * Requirements:
771      *
772      * - `tokenId` must exist.
773      */
774     function getApproved(uint256 tokenId) external view returns (address operator);
775 
776     /**
777      * @dev Approve or remove `operator` as an operator for the caller.
778      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
779      *
780      * Requirements:
781      *
782      * - The `operator` cannot be the caller.
783      *
784      * Emits an {ApprovalForAll} event.
785      */
786     function setApprovalForAll(address operator, bool _approved) external;
787 
788     /**
789      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
790      *
791      * See {setApprovalForAll}
792      */
793     function isApprovedForAll(address owner, address operator) external view returns (bool);
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must exist and be owned by `from`.
803      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
805      *
806      * Emits a {Transfer} event.
807      */
808     function safeTransferFrom(
809         address from,
810         address to,
811         uint256 tokenId,
812         bytes calldata data
813     ) external;
814 }
815 
816 
817 /**
818  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
819  * @dev See https://eips.ethereum.org/EIPS/eip-721
820  */
821 interface IERC721Enumerable is IERC721 {
822     /**
823      * @dev Returns the total amount of tokens stored by the contract.
824      */
825     function totalSupply() external view returns (uint256);
826 
827     /**
828      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
829      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
830      */
831     function tokenOfOwnerByIndex(address owner, uint256 index)
832         external
833         view
834         returns (uint256 tokenId);
835 
836     /**
837      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
838      * Use along with {totalSupply} to enumerate all tokens.
839      */
840     function tokenByIndex(uint256 index) external view returns (uint256);
841 }
842 
843 /// @title Corruption Gold for Corruption holders!
844 /// @author Will Papper <https://twitter.com/WillPapper>
845 /// Modified by zefram.eth
846 /// @notice This contract mints Corruption Gold for Corruption holders and provides
847 /// administrative functions to the Corruption DAO. It allows:
848 /// * Corruption holders to claim Corruption Gold
849 /// * A DAO to set seasons for new opportunities to claim Corruption Gold
850 /// * A DAO to mint Corruption Gold for use within the Corruption ecosystem
851 /// @custom:unaudited This contract has not been audited. Use at your own risk.
852 contract CorruptionGold is Context, Ownable, ERC20 {
853     // Corruption contract is available at https://etherscan.io/address/0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7
854     address public corruptionContractAddress =
855         0x5BDf397bB2912859Dbd8011F320a222f79A28d2E;
856     IERC721Enumerable public corruptionContract;
857 
858     // Give out 10,000 Corruption Gold for every Corruption that a user holds
859     uint256 public corruptionGoldPerTokenId = 10000 * (10**decimals());
860 
861     // tokenIdStart of 1
862     uint256 public tokenIdStart = 1;
863 
864     // tokenIdEnd of 4196
865     uint256 public tokenIdEnd = 4196;
866 
867     // Seasons are used to allow users to claim tokens regularly. Seasons are
868     // decided by the DAO.
869     uint256 public season = 0;
870 
871     // Track claimed tokens within a season
872     // IMPORTANT: The format of the mapping is:
873     // claimedForSeason[season][tokenId][claimed]
874     mapping(uint256 => mapping(uint256 => bool)) public seasonClaimedByTokenId;
875 
876     constructor() Ownable() ERC20("Corruption Gold", "CGLD") {
877         corruptionContract = IERC721Enumerable(corruptionContractAddress);
878 
879         // it's fair launch my dear apes
880         _mint(0x5f350bF5feE8e254D6077f8661E9C7B83a30364e, 4206969 * (10**decimals()));
881     }
882 
883     /// @notice Claim Corruption Gold for a given Corruption ID
884     /// @param tokenId The tokenId of the Corruption NFT
885     function claimById(uint256 tokenId) external {
886         // Follow the Checks-Effects-Interactions pattern to prevent reentrancy
887         // attacks
888 
889         // Checks
890 
891         // Check that the msgSender owns the token that is being claimed
892         require(
893             _msgSender() == corruptionContract.ownerOf(tokenId),
894             "MUST_OWN_TOKEN_ID"
895         );
896 
897         // Further Checks, Effects, and Interactions are contained within the
898         // _claim() function
899         _claim(tokenId, _msgSender());
900     }
901 
902     /// @notice Claim Corruption Gold for all tokens owned by the sender
903     /// @notice This function will run out of gas if you have too much loot! If
904     /// this is a concern, you should use claimRangeForOwner and claim Corruption
905     /// Gold in batches.
906     function claimAllForOwner() external {
907         uint256 tokenBalanceOwner = corruptionContract.balanceOf(_msgSender());
908 
909         // Checks
910         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
911 
912         // i < tokenBalanceOwner because tokenBalanceOwner is 1-indexed
913         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
914             // Further Checks, Effects, and Interactions are contained within
915             // the _claim() function
916             _claim(
917                 corruptionContract.tokenOfOwnerByIndex(_msgSender(), i),
918                 _msgSender()
919             );
920         }
921     }
922 
923     /// @notice Claim Corruption Gold for all tokens owned by the sender within a
924     /// given range
925     /// @notice This function is useful if you own too much Corruption to claim all at
926     /// once or if you want to leave some Corruption unclaimed. If you leave Corruption
927     /// unclaimed, however, you cannot claim it once the next season starts.
928     function claimRangeForOwner(uint256 ownerIndexStart, uint256 ownerIndexEnd)
929         external
930     {
931         uint256 tokenBalanceOwner = corruptionContract.balanceOf(_msgSender());
932 
933         // Checks
934         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
935 
936         // We use < for ownerIndexEnd and tokenBalanceOwner because
937         // tokenOfOwnerByIndex is 0-indexed while the token balance is 1-indexed
938         require(
939             ownerIndexStart >= 0 && ownerIndexEnd < tokenBalanceOwner,
940             "INDEX_OUT_OF_RANGE"
941         );
942 
943         // i <= ownerIndexEnd because ownerIndexEnd is 0-indexed
944         for (uint256 i = ownerIndexStart; i <= ownerIndexEnd; i++) {
945             // Further Checks, Effects, and Interactions are contained within
946             // the _claim() function
947             _claim(
948                 corruptionContract.tokenOfOwnerByIndex(_msgSender(), i),
949                 _msgSender()
950             );
951         }
952     }
953 
954     /// @dev Internal function to mint Corruption upon claiming
955     function _claim(uint256 tokenId, address tokenOwner) internal {
956         // Checks
957         // Check that the token ID is in range
958         // We use >= and <= to here because all of the token IDs are 0-indexed
959         require(
960             tokenId >= tokenIdStart && tokenId <= tokenIdEnd,
961             "TOKEN_ID_OUT_OF_RANGE"
962         );
963 
964         // Check that Corruption Gold have not already been claimed this season
965         // for a given tokenId
966         require(
967             !seasonClaimedByTokenId[season][tokenId],
968             "GOLD_CLAIMED_FOR_TOKEN_ID"
969         );
970 
971         // Effects
972 
973         // Mark that Corruption Gold has been claimed for this season for the
974         // given tokenId
975         seasonClaimedByTokenId[season][tokenId] = true;
976 
977         // Interactions
978 
979         // Send Corruption Gold to the owner of the token ID
980         _mint(tokenOwner, corruptionGoldPerTokenId);
981     }
982 
983     /// @notice Allows the DAO to mint new tokens for use within the Corruption
984     /// Ecosystem
985     /// @param amountDisplayValue The amount of Corruption to mint. This should be
986     /// input as the display value, not in raw decimals. If you want to mint
987     /// 100 Corruption, you should enter "100" rather than the value of 100 * 10^18.
988     function daoMint(uint256 amountDisplayValue) external onlyOwner {
989         _mint(owner(), amountDisplayValue * (10**decimals()));
990     }
991 
992     /// @notice Allows the DAO to set a new contract address for Corruption. This is
993     /// relevant in the event that Corruption migrates to a new contract.
994     /// @param corruptionContractAddress_ The new contract address for Corruption
995     function daoSetCorruptionContractAddress(address corruptionContractAddress_)
996         external
997         onlyOwner
998     {
999         corruptionContractAddress = corruptionContractAddress_;
1000         corruptionContract = IERC721Enumerable(corruptionContractAddress);
1001     }
1002 
1003     /// @notice Allows the DAO to set the token IDs that are eligible to claim
1004     /// Corruption
1005     /// @param tokenIdStart_ The start of the eligible token range
1006     /// @param tokenIdEnd_ The end of the eligible token range
1007     /// @dev This is relevant in case a future Corruption contract has a different
1008     /// total supply of Corruption
1009     function daoSetTokenIdRange(uint256 tokenIdStart_, uint256 tokenIdEnd_)
1010         external
1011         onlyOwner
1012     {
1013         tokenIdStart = tokenIdStart_;
1014         tokenIdEnd = tokenIdEnd_;
1015     }
1016 
1017     /// @notice Allows the DAO to set a season for new Corruption Gold claims
1018     /// @param season_ The season to use for claiming Corruption
1019     function daoSetSeason(uint256 season_) public onlyOwner {
1020         season = season_;
1021     }
1022 
1023     /// @notice Allows the DAO to set the amount of Corruption Gold that is
1024     /// claimed per token ID
1025     /// @param corruptionGoldDisplayValue The amount of Corruption a user can claim.
1026     /// This should be input as the display value, not in raw decimals. If you
1027     /// want to mint 100 Corruption, you should enter "100" rather than the value of
1028     /// 100 * 10^18.
1029     function daoSetCorruptionGoldPerTokenId(uint256 corruptionGoldDisplayValue)
1030         public
1031         onlyOwner
1032     {
1033         corruptionGoldPerTokenId = corruptionGoldDisplayValue * (10**decimals());
1034     }
1035 
1036     /// @notice Allows the DAO to set the season and Corruption Gold per token ID
1037     /// in one transaction. This ensures that there is not a gap where a user
1038     /// can claim more Corruption Gold than others
1039     /// @param season_ The season to use for claiming loot
1040     /// @param corruptionGoldDisplayValue The amount of Corruption a user can claim.
1041     /// This should be input as the display value, not in raw decimals. If you
1042     /// want to mint 100 Corruption, you should enter "100" rather than the value of
1043     /// 100 * 10^18.
1044     /// @dev We would save a tiny amount of gas by modifying the season and
1045     /// corruptionGold variables directly. It is better practice for security,
1046     /// however, to avoid repeating code. This function is so rarely used that
1047     /// it's not worth moving these values into their own internal function to
1048     /// skip the gas used on the modifier check.
1049     function daoSetSeasonAndCorruptionGoldPerTokenID(
1050         uint256 season_,
1051         uint256 corruptionGoldDisplayValue
1052     ) external onlyOwner {
1053         daoSetSeason(season_);
1054         daoSetCorruptionGoldPerTokenId(corruptionGoldDisplayValue);
1055     }
1056 }