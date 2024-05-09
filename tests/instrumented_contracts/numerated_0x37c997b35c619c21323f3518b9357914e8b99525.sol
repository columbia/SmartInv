1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.6;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.2.0
85 
86 
87 
88 
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
114 
115 
116 
117 
118 
119 /*
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 
139 
140 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.2.0
141 
142 
143 
144 
145 
146 
147 
148 /**
149  * @dev Implementation of the {IERC20} interface.
150  *
151  * This implementation is agnostic to the way tokens are created. This means
152  * that a supply mechanism has to be added in a derived contract using {_mint}.
153  * For a generic mechanism see {ERC20PresetMinterPauser}.
154  *
155  * TIP: For a detailed writeup see our guide
156  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
157  * to implement supply mechanisms].
158  *
159  * We have followed general OpenZeppelin guidelines: functions revert instead
160  * of returning `false` on failure. This behavior is nonetheless conventional
161  * and does not conflict with the expectations of ERC20 applications.
162  *
163  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
164  * This allows applications to reconstruct the allowance for all accounts just
165  * by listening to said events. Other implementations of the EIP may not emit
166  * these events, as it isn't required by the specification.
167  *
168  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
169  * functions have been added to mitigate the well-known issues around setting
170  * allowances. See {IERC20-approve}.
171  */
172 contract ERC20 is Context, IERC20, IERC20Metadata {
173     mapping(address => uint256) private _balances;
174 
175     mapping(address => mapping(address => uint256)) private _allowances;
176 
177     uint256 private _totalSupply;
178 
179     string private _name;
180     string private _symbol;
181 
182     /**
183      * @dev Sets the values for {name} and {symbol}.
184      *
185      * The default value of {decimals} is 18. To select a different value for
186      * {decimals} you should overload it.
187      *
188      * All two of these values are immutable: they can only be set once during
189      * construction.
190      */
191     constructor(string memory name_, string memory symbol_) {
192         _name = name_;
193         _symbol = symbol_;
194     }
195 
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() public view virtual override returns (string memory) {
200         return _name;
201     }
202 
203     /**
204      * @dev Returns the symbol of the token, usually a shorter version of the
205      * name.
206      */
207     function symbol() public view virtual override returns (string memory) {
208         return _symbol;
209     }
210 
211     /**
212      * @dev Returns the number of decimals used to get its user representation.
213      * For example, if `decimals` equals `2`, a balance of `505` tokens should
214      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
215      *
216      * Tokens usually opt for a value of 18, imitating the relationship between
217      * Ether and Wei. This is the value {ERC20} uses, unless this function is
218      * overridden;
219      *
220      * NOTE: This information is only used for _display_ purposes: it in
221      * no way affects any of the arithmetic of the contract, including
222      * {IERC20-balanceOf} and {IERC20-transfer}.
223      */
224     function decimals() public view virtual override returns (uint8) {
225         return 18;
226     }
227 
228     /**
229      * @dev See {IERC20-totalSupply}.
230      */
231     function totalSupply() public view virtual override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See {IERC20-balanceOf}.
237      */
238     function balanceOf(address account) public view virtual override returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See {IERC20-transfer}.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-allowance}.
257      */
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See {IERC20-approve}.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 amount) public virtual override returns (bool) {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-transferFrom}.
276      *
277      * Emits an {Approval} event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of {ERC20}.
279      *
280      * Requirements:
281      *
282      * - `sender` and `recipient` cannot be the zero address.
283      * - `sender` must have a balance of at least `amount`.
284      * - the caller must have allowance for ``sender``'s tokens of at least
285      * `amount`.
286      */
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) public virtual override returns (bool) {
292         _transfer(sender, recipient, amount);
293 
294         uint256 currentAllowance = _allowances[sender][_msgSender()];
295         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
296         unchecked {
297             _approve(sender, _msgSender(), currentAllowance - amount);
298         }
299 
300         return true;
301     }
302 
303     /**
304      * @dev Atomically increases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
317         return true;
318     }
319 
320     /**
321      * @dev Atomically decreases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      * - `spender` must have allowance for the caller of at least
332      * `subtractedValue`.
333      */
334     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
335         uint256 currentAllowance = _allowances[_msgSender()][spender];
336         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
337         unchecked {
338             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
339         }
340 
341         return true;
342     }
343 
344     /**
345      * @dev Moves `amount` of tokens from `sender` to `recipient`.
346      *
347      * This internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `sender` cannot be the zero address.
355      * - `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      */
358     function _transfer(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) internal virtual {
363         require(sender != address(0), "ERC20: transfer from the zero address");
364         require(recipient != address(0), "ERC20: transfer to the zero address");
365 
366         _beforeTokenTransfer(sender, recipient, amount);
367 
368         uint256 senderBalance = _balances[sender];
369         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
370         unchecked {
371             _balances[sender] = senderBalance - amount;
372         }
373         _balances[recipient] += amount;
374 
375         emit Transfer(sender, recipient, amount);
376 
377         _afterTokenTransfer(sender, recipient, amount);
378     }
379 
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a {Transfer} event with `from` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _beforeTokenTransfer(address(0), account, amount);
393 
394         _totalSupply += amount;
395         _balances[account] += amount;
396         emit Transfer(address(0), account, amount);
397 
398         _afterTokenTransfer(address(0), account, amount);
399     }
400 
401     /**
402      * @dev Destroys `amount` tokens from `account`, reducing the
403      * total supply.
404      *
405      * Emits a {Transfer} event with `to` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `account` cannot be the zero address.
410      * - `account` must have at least `amount` tokens.
411      */
412     function _burn(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: burn from the zero address");
414 
415         _beforeTokenTransfer(account, address(0), amount);
416 
417         uint256 accountBalance = _balances[account];
418         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
419         unchecked {
420             _balances[account] = accountBalance - amount;
421         }
422         _totalSupply -= amount;
423 
424         emit Transfer(account, address(0), amount);
425 
426         _afterTokenTransfer(account, address(0), amount);
427     }
428 
429     /**
430      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
431      *
432      * This internal function is equivalent to `approve`, and can be used to
433      * e.g. set automatic allowances for certain subsystems, etc.
434      *
435      * Emits an {Approval} event.
436      *
437      * Requirements:
438      *
439      * - `owner` cannot be the zero address.
440      * - `spender` cannot be the zero address.
441      */
442     function _approve(
443         address owner,
444         address spender,
445         uint256 amount
446     ) internal virtual {
447         require(owner != address(0), "ERC20: approve from the zero address");
448         require(spender != address(0), "ERC20: approve to the zero address");
449 
450         _allowances[owner][spender] = amount;
451         emit Approval(owner, spender, amount);
452     }
453 
454     /**
455      * @dev Hook that is called before any transfer of tokens. This includes
456      * minting and burning.
457      *
458      * Calling conditions:
459      *
460      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
461      * will be transferred to `to`.
462      * - when `from` is zero, `amount` tokens will be minted for `to`.
463      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
464      * - `from` and `to` are never both zero.
465      *
466      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
467      */
468     function _beforeTokenTransfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal virtual {}
473 
474     /**
475      * @dev Hook that is called after any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * has been transferred to `to`.
482      * - when `from` is zero, `amount` tokens have been minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _afterTokenTransfer(
489         address from,
490         address to,
491         uint256 amount
492     ) internal virtual {}
493 }
494 
495 
496 
497 /**
498  * @dev Extension of {ERC20} that allows token holders to destroy both their own
499  * tokens and those that they have an allowance for, in a way that can be
500  * recognized off-chain (via event analysis).
501  */
502 abstract contract ERC20Burnable is Context, ERC20 {
503     /**
504      * @dev Destroys `amount` tokens from the caller.
505      *
506      * See {ERC20-_burn}.
507      */
508     function burn(uint256 amount) public virtual {
509         _burn(_msgSender(), amount);
510     }
511 
512     /**
513      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
514      * allowance.
515      *
516      * See {ERC20-_burn} and {ERC20-allowance}.
517      *
518      * Requirements:
519      *
520      * - the caller must have allowance for ``accounts``'s tokens of at least
521      * `amount`.
522      */
523     function burnFrom(address account, uint256 amount) public virtual {
524         uint256 currentAllowance = allowance(account, _msgSender());
525         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
526         unchecked {
527             _approve(account, _msgSender(), currentAllowance - amount);
528         }
529         _burn(account, amount);
530     }
531 }
532 
533 contract Pilot is ERC20Burnable {
534   address public timelock;
535 
536   address private _minter;
537 
538   bool private _minterStatus;    
539 
540   // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
541   bytes32 private constant EIP712DOMAIN_HASH =
542     0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
543 
544   // bytes32 private constant NAME_HASH = keccak256("Unipilot")
545   bytes32 private constant NAME_HASH =
546     0x96f8699b9d60ee03e2ae096e7ed75448335015f6b0f67e4f1540d650607f9ed9;
547 
548   // bytes32 private constant VERSION_HASH = keccak256("1")
549   bytes32 private constant VERSION_HASH =
550     0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
551 
552   // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
553   bytes32 public constant PERMIT_TYPEHASH =
554     0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
555 
556   // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
557   bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
558     0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;
559 
560   modifier onlyMinter {
561     require(msg.sender == _minter, "PILOT:: NOT_MINTER");
562     _;
563   }
564 
565   modifier onlyTimelock {
566     require(msg.sender == timelock, "PILOT:: NOT_TIMELOCK");
567     _;
568   }
569 
570   mapping(address => uint256) public nonces;
571 
572   mapping(address => mapping(bytes32 => bool)) public authorizationState;
573 
574   event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
575 
576   constructor(
577     address _timelock,
578     address[] memory vestingAddresses,
579     uint256[] memory vestingAmounts
580   ) ERC20("Unipilot", "PILOT") {
581     _mintInitialTokens(vestingAddresses, vestingAmounts);
582     timelock = _timelock;
583   }
584 
585   function mint(address to, uint256 value) external onlyMinter {
586     _mint(to, value);
587   }
588 
589   function updateMinter(address newMinter) external onlyTimelock {
590     require(!_minterStatus,"PILOT:: MINTER_ALREADY_INITIALIZED");
591     require(newMinter != address(0), "PILOT:: INVALID_MINTER_ADDRESS");
592     _minter = newMinter;
593     _minterStatus = true;
594   }
595 
596   function _mintInitialTokens(address[] memory _addresses, uint256[] memory _amounts)
597     internal
598   {
599     for (uint256 i = 0; i < _addresses.length; i++) {
600       _mint(_addresses[i], _amounts[i]);
601     }
602   }
603 
604   function _validateSignedData(
605     address signer,
606     bytes32 encodeData,
607     uint8 v,
608     bytes32 r,
609     bytes32 s
610   ) internal view {
611     bytes32 digest = keccak256(abi.encodePacked("\x19\x01", getDomainSeparator(), encodeData));
612     address recoveredAddress = ecrecover(digest, v, r, s);
613     require(
614       recoveredAddress != address(0) && recoveredAddress == signer,
615       "PILOT:: INVALID_SIGNATURE"
616     );
617   }
618 
619   function permit(
620     address owner,
621     address spender,
622     uint256 value,
623     uint256 deadline,
624     uint8 v,
625     bytes32 r,
626     bytes32 s
627   ) external {
628     require(deadline >= block.timestamp, "PILOT:: AUTH_EXPIRED");
629 
630     bytes32 encodeData =
631       keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner], deadline));
632     nonces[owner] = nonces[owner] + 1;
633     _validateSignedData(owner, encodeData, v, r, s);
634     _approve(owner, spender, value);
635   }
636 
637   function getDomainSeparator() public view returns (bytes32) {
638     return
639       keccak256(
640         abi.encode(EIP712DOMAIN_HASH, NAME_HASH, VERSION_HASH, getChainId(), address(this))
641       );
642   }
643 
644   function getChainId() public view returns (uint256 chainId) {
645     assembly {
646       chainId := chainid()
647     }
648   }
649 
650   function transferWithAuthorization(
651     address from,
652     address to,
653     uint256 value,
654     uint256 validAfter,
655     uint256 validBefore,
656     bytes32 nonce,
657     uint8 v,
658     bytes32 r,
659     bytes32 s
660   ) external {
661     require(block.timestamp > validAfter, "PILOT:: AUTH_NOT_YET_VALID");
662     require(block.timestamp < validBefore, "PILOT:: AUTH_EXPIRED");
663     require(!authorizationState[from][nonce], "PILOT:: AUTH_ALREADY_USED");
664 
665     bytes32 encodeData =
666       keccak256(
667         abi.encode(
668           TRANSFER_WITH_AUTHORIZATION_TYPEHASH,
669           from,
670           to,
671           value,
672           validAfter,
673           validBefore,
674           nonce
675         )
676       );
677     _validateSignedData(from, encodeData, v, r, s);
678 
679     authorizationState[from][nonce] = true;
680     emit AuthorizationUsed(from, nonce);
681 
682     _transfer(from, to, value);
683   }
684 }