1 // File: contracts/AnonymiceLibrary.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 library AnonymiceLibrary {
7     string internal constant TABLE =
8         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
9 
10     function encode(bytes memory data) internal pure returns (string memory) {
11         if (data.length == 0) return "";
12 
13         // load the table into memory
14         string memory table = TABLE;
15 
16         // multiply by 4/3 rounded up
17         uint256 encodedLen = 4 * ((data.length + 2) / 3);
18 
19         // add some extra buffer at the end required for the writing
20         string memory result = new string(encodedLen + 32);
21 
22         assembly {
23             // set the actual output length
24             mstore(result, encodedLen)
25 
26             // prepare the lookup table
27             let tablePtr := add(table, 1)
28 
29             // input ptr
30             let dataPtr := data
31             let endPtr := add(dataPtr, mload(data))
32 
33             // result ptr, jump over length
34             let resultPtr := add(result, 32)
35 
36             // run over the input, 3 bytes at a time
37             for {
38 
39             } lt(dataPtr, endPtr) {
40 
41             } {
42                 dataPtr := add(dataPtr, 3)
43 
44                 // read 3 bytes
45                 let input := mload(dataPtr)
46 
47                 // write 4 characters
48                 mstore(
49                     resultPtr,
50                     shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
51                 )
52                 resultPtr := add(resultPtr, 1)
53                 mstore(
54                     resultPtr,
55                     shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
56                 )
57                 resultPtr := add(resultPtr, 1)
58                 mstore(
59                     resultPtr,
60                     shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
61                 )
62                 resultPtr := add(resultPtr, 1)
63                 mstore(
64                     resultPtr,
65                     shl(248, mload(add(tablePtr, and(input, 0x3F))))
66                 )
67                 resultPtr := add(resultPtr, 1)
68             }
69 
70             // padding with '='
71             switch mod(mload(data), 3)
72             case 1 {
73                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
74             }
75             case 2 {
76                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
77             }
78         }
79 
80         return result;
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     function parseInt(string memory _a)
106         internal
107         pure
108         returns (uint8 _parsedInt)
109     {
110         bytes memory bresult = bytes(_a);
111         uint8 mint = 0;
112         for (uint8 i = 0; i < bresult.length; i++) {
113             if (
114                 (uint8(uint8(bresult[i])) >= 48) &&
115                 (uint8(uint8(bresult[i])) <= 57)
116             ) {
117                 mint *= 10;
118                 mint += uint8(bresult[i]) - 48;
119             }
120         }
121         return mint;
122     }
123 
124     function substring(
125         string memory str,
126         uint256 startIndex,
127         uint256 endIndex
128     ) internal pure returns (string memory) {
129         bytes memory strBytes = bytes(str);
130         bytes memory result = new bytes(endIndex - startIndex);
131         for (uint256 i = startIndex; i < endIndex; i++) {
132             result[i - startIndex] = strBytes[i];
133         }
134         return string(result);
135     }
136 
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize, which returns 0 for contracts in
139         // construction, since the code is only stored at the end of the
140         // constructor execution.
141 
142         uint256 size;
143         assembly {
144             size := extcodesize(account)
145         }
146         return size > 0;
147     }
148 }
149 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/MerkleProof.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev These functions deal with verification of Merkle Trees proofs.
158  *
159  * The proofs can be generated using the JavaScript library
160  * https://github.com/miguelmota/merkletreejs[merkletreejs].
161  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
162  *
163  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
164  */
165 library MerkleProof {
166     /**
167      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
168      * defined by `root`. For this, a `proof` must be provided, containing
169      * sibling hashes on the branch from the leaf to the root of the tree. Each
170      * pair of leaves and each pair of pre-images are assumed to be sorted.
171      */
172     function verify(
173         bytes32[] memory proof,
174         bytes32 root,
175         bytes32 leaf
176     ) internal pure returns (bool) {
177         return processProof(proof, leaf) == root;
178     }
179 
180     /**
181      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
182      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
183      * hash matches the root of the tree. When processing the proof, the pairs
184      * of leafs & pre-images are assumed to be sorted.
185      *
186      * _Available since v4.4._
187      */
188     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
189         bytes32 computedHash = leaf;
190         for (uint256 i = 0; i < proof.length; i++) {
191             bytes32 proofElement = proof[i];
192             if (computedHash <= proofElement) {
193                 // Hash(current computed hash + current element of the proof)
194                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
195             } else {
196                 // Hash(current element of the proof + current computed hash)
197                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
198             }
199         }
200         return computedHash;
201     }
202 }
203 
204 // File: @openzeppelin/contracts/utils/Context.sol
205 
206 
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @dev Provides information about the current execution context, including the
212  * sender of the transaction and its data. While these are generally available
213  * via msg.sender and msg.data, they should not be accessed in such a direct
214  * manner, since when dealing with meta-transactions the account sending and
215  * paying for execution may not be the actual sender (as far as an application
216  * is concerned).
217  *
218  * This contract is only required for intermediate, library-like contracts.
219  */
220 abstract contract Context {
221     function _msgSender() internal view virtual returns (address) {
222         return msg.sender;
223     }
224 
225     function _msgData() internal view virtual returns (bytes calldata) {
226         return msg.data;
227     }
228 }
229 
230 // File: @openzeppelin/contracts/access/Ownable.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 
237 /**
238  * @dev Contract module which provides a basic access control mechanism, where
239  * there is an account (an owner) that can be granted exclusive access to
240  * specific functions.
241  *
242  * By default, the owner account will be the one that deploys the contract. This
243  * can later be changed with {transferOwnership}.
244  *
245  * This module is used through inheritance. It will make available the modifier
246  * `onlyOwner`, which can be applied to your functions to restrict their use to
247  * the owner.
248  */
249 abstract contract Ownable is Context {
250     address private _owner;
251 
252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254     /**
255      * @dev Initializes the contract setting the deployer as the initial owner.
256      */
257     constructor() {
258         _setOwner(_msgSender());
259     }
260 
261     /**
262      * @dev Returns the address of the current owner.
263      */
264     function owner() public view virtual returns (address) {
265         return _owner;
266     }
267 
268     /**
269      * @dev Throws if called by any account other than the owner.
270      */
271     modifier onlyOwner() {
272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
273         _;
274     }
275 
276     /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public virtual onlyOwner {
284         _setOwner(address(0));
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         _setOwner(newOwner);
294     }
295 
296     function _setOwner(address newOwner) private {
297         address oldOwner = _owner;
298         _owner = newOwner;
299         emit OwnershipTransferred(oldOwner, newOwner);
300     }
301 }
302 
303 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
304 
305 
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Interface of the ERC20 standard as defined in the EIP.
311  */
312 interface IERC20 {
313     /**
314      * @dev Returns the amount of tokens in existence.
315      */
316     function totalSupply() external view returns (uint256);
317 
318     /**
319      * @dev Returns the amount of tokens owned by `account`.
320      */
321     function balanceOf(address account) external view returns (uint256);
322 
323     /**
324      * @dev Moves `amount` tokens from the caller's account to `recipient`.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transfer(address recipient, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Returns the remaining number of tokens that `spender` will be
334      * allowed to spend on behalf of `owner` through {transferFrom}. This is
335      * zero by default.
336      *
337      * This value changes when {approve} or {transferFrom} are called.
338      */
339     function allowance(address owner, address spender) external view returns (uint256);
340 
341     /**
342      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * IMPORTANT: Beware that changing an allowance with this method brings the risk
347      * that someone may use both the old and the new allowance by unfortunate
348      * transaction ordering. One possible solution to mitigate this race
349      * condition is to first reduce the spender's allowance to 0 and set the
350      * desired value afterwards:
351      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
352      *
353      * Emits an {Approval} event.
354      */
355     function approve(address spender, uint256 amount) external returns (bool);
356 
357     /**
358      * @dev Moves `amount` tokens from `sender` to `recipient` using the
359      * allowance mechanism. `amount` is then deducted from the caller's
360      * allowance.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transferFrom(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) external returns (bool);
371 
372     /**
373      * @dev Emitted when `value` tokens are moved from one account (`from`) to
374      * another (`to`).
375      *
376      * Note that `value` may be zero.
377      */
378     event Transfer(address indexed from, address indexed to, uint256 value);
379 
380     /**
381      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
382      * a call to {approve}. `value` is the new allowance.
383      */
384     event Approval(address indexed owner, address indexed spender, uint256 value);
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
388 
389 
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Interface for the optional metadata functions from the ERC20 standard.
396  *
397  * _Available since v4.1._
398  */
399 interface IERC20Metadata is IERC20 {
400     /**
401      * @dev Returns the name of the token.
402      */
403     function name() external view returns (string memory);
404 
405     /**
406      * @dev Returns the symbol of the token.
407      */
408     function symbol() external view returns (string memory);
409 
410     /**
411      * @dev Returns the decimals places of the token.
412      */
413     function decimals() external view returns (uint8);
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
417 
418 
419 
420 pragma solidity ^0.8.0;
421 
422 
423 
424 
425 /**
426  * @dev Implementation of the {IERC20} interface.
427  *
428  * This implementation is agnostic to the way tokens are created. This means
429  * that a supply mechanism has to be added in a derived contract using {_mint}.
430  * For a generic mechanism see {ERC20PresetMinterPauser}.
431  *
432  * TIP: For a detailed writeup see our guide
433  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
434  * to implement supply mechanisms].
435  *
436  * We have followed general OpenZeppelin Contracts guidelines: functions revert
437  * instead returning `false` on failure. This behavior is nonetheless
438  * conventional and does not conflict with the expectations of ERC20
439  * applications.
440  *
441  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
442  * This allows applications to reconstruct the allowance for all accounts just
443  * by listening to said events. Other implementations of the EIP may not emit
444  * these events, as it isn't required by the specification.
445  *
446  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
447  * functions have been added to mitigate the well-known issues around setting
448  * allowances. See {IERC20-approve}.
449  */
450 contract ERC20 is Context, IERC20, IERC20Metadata {
451     mapping(address => uint256) private _balances;
452 
453     mapping(address => mapping(address => uint256)) private _allowances;
454 
455     uint256 private _totalSupply;
456 
457     string private _name;
458     string private _symbol;
459 
460     /**
461      * @dev Sets the values for {name} and {symbol}.
462      *
463      * The default value of {decimals} is 18. To select a different value for
464      * {decimals} you should overload it.
465      *
466      * All two of these values are immutable: they can only be set once during
467      * construction.
468      */
469     constructor(string memory name_, string memory symbol_) {
470         _name = name_;
471         _symbol = symbol_;
472     }
473 
474     /**
475      * @dev Returns the name of the token.
476      */
477     function name() public view virtual override returns (string memory) {
478         return _name;
479     }
480 
481     /**
482      * @dev Returns the symbol of the token, usually a shorter version of the
483      * name.
484      */
485     function symbol() public view virtual override returns (string memory) {
486         return _symbol;
487     }
488 
489     /**
490      * @dev Returns the number of decimals used to get its user representation.
491      * For example, if `decimals` equals `2`, a balance of `505` tokens should
492      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
493      *
494      * Tokens usually opt for a value of 18, imitating the relationship between
495      * Ether and Wei. This is the value {ERC20} uses, unless this function is
496      * overridden;
497      *
498      * NOTE: This information is only used for _display_ purposes: it in
499      * no way affects any of the arithmetic of the contract, including
500      * {IERC20-balanceOf} and {IERC20-transfer}.
501      */
502     function decimals() public view virtual override returns (uint8) {
503         return 18;
504     }
505 
506     /**
507      * @dev See {IERC20-totalSupply}.
508      */
509     function totalSupply() public view virtual override returns (uint256) {
510         return _totalSupply;
511     }
512 
513     /**
514      * @dev See {IERC20-balanceOf}.
515      */
516     function balanceOf(address account) public view virtual override returns (uint256) {
517         return _balances[account];
518     }
519 
520     /**
521      * @dev See {IERC20-transfer}.
522      *
523      * Requirements:
524      *
525      * - `recipient` cannot be the zero address.
526      * - the caller must have a balance of at least `amount`.
527      */
528     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
529         _transfer(_msgSender(), recipient, amount);
530         return true;
531     }
532 
533     /**
534      * @dev See {IERC20-allowance}.
535      */
536     function allowance(address owner, address spender) public view virtual override returns (uint256) {
537         return _allowances[owner][spender];
538     }
539 
540     /**
541      * @dev See {IERC20-approve}.
542      *
543      * Requirements:
544      *
545      * - `spender` cannot be the zero address.
546      */
547     function approve(address spender, uint256 amount) public virtual override returns (bool) {
548         _approve(_msgSender(), spender, amount);
549         return true;
550     }
551 
552     /**
553      * @dev See {IERC20-transferFrom}.
554      *
555      * Emits an {Approval} event indicating the updated allowance. This is not
556      * required by the EIP. See the note at the beginning of {ERC20}.
557      *
558      * Requirements:
559      *
560      * - `sender` and `recipient` cannot be the zero address.
561      * - `sender` must have a balance of at least `amount`.
562      * - the caller must have allowance for ``sender``'s tokens of at least
563      * `amount`.
564      */
565     function transferFrom(
566         address sender,
567         address recipient,
568         uint256 amount
569     ) public virtual override returns (bool) {
570         _transfer(sender, recipient, amount);
571 
572         uint256 currentAllowance = _allowances[sender][_msgSender()];
573         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
574         unchecked {
575             _approve(sender, _msgSender(), currentAllowance - amount);
576         }
577 
578         return true;
579     }
580 
581     /**
582      * @dev Atomically increases the allowance granted to `spender` by the caller.
583      *
584      * This is an alternative to {approve} that can be used as a mitigation for
585      * problems described in {IERC20-approve}.
586      *
587      * Emits an {Approval} event indicating the updated allowance.
588      *
589      * Requirements:
590      *
591      * - `spender` cannot be the zero address.
592      */
593     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
594         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
595         return true;
596     }
597 
598     /**
599      * @dev Atomically decreases the allowance granted to `spender` by the caller.
600      *
601      * This is an alternative to {approve} that can be used as a mitigation for
602      * problems described in {IERC20-approve}.
603      *
604      * Emits an {Approval} event indicating the updated allowance.
605      *
606      * Requirements:
607      *
608      * - `spender` cannot be the zero address.
609      * - `spender` must have allowance for the caller of at least
610      * `subtractedValue`.
611      */
612     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
613         uint256 currentAllowance = _allowances[_msgSender()][spender];
614         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
615         unchecked {
616             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
617         }
618 
619         return true;
620     }
621 
622     /**
623      * @dev Moves `amount` of tokens from `sender` to `recipient`.
624      *
625      * This internal function is equivalent to {transfer}, and can be used to
626      * e.g. implement automatic token fees, slashing mechanisms, etc.
627      *
628      * Emits a {Transfer} event.
629      *
630      * Requirements:
631      *
632      * - `sender` cannot be the zero address.
633      * - `recipient` cannot be the zero address.
634      * - `sender` must have a balance of at least `amount`.
635      */
636     function _transfer(
637         address sender,
638         address recipient,
639         uint256 amount
640     ) internal virtual {
641         require(sender != address(0), "ERC20: transfer from the zero address");
642         require(recipient != address(0), "ERC20: transfer to the zero address");
643 
644         _beforeTokenTransfer(sender, recipient, amount);
645 
646         uint256 senderBalance = _balances[sender];
647         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
648         unchecked {
649             _balances[sender] = senderBalance - amount;
650         }
651         _balances[recipient] += amount;
652 
653         emit Transfer(sender, recipient, amount);
654 
655         _afterTokenTransfer(sender, recipient, amount);
656     }
657 
658     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
659      * the total supply.
660      *
661      * Emits a {Transfer} event with `from` set to the zero address.
662      *
663      * Requirements:
664      *
665      * - `account` cannot be the zero address.
666      */
667     function _mint(address account, uint256 amount) internal virtual {
668         require(account != address(0), "ERC20: mint to the zero address");
669 
670         _beforeTokenTransfer(address(0), account, amount);
671 
672         _totalSupply += amount;
673         _balances[account] += amount;
674         emit Transfer(address(0), account, amount);
675 
676         _afterTokenTransfer(address(0), account, amount);
677     }
678 
679     /**
680      * @dev Destroys `amount` tokens from `account`, reducing the
681      * total supply.
682      *
683      * Emits a {Transfer} event with `to` set to the zero address.
684      *
685      * Requirements:
686      *
687      * - `account` cannot be the zero address.
688      * - `account` must have at least `amount` tokens.
689      */
690     function _burn(address account, uint256 amount) internal virtual {
691         require(account != address(0), "ERC20: burn from the zero address");
692 
693         _beforeTokenTransfer(account, address(0), amount);
694 
695         uint256 accountBalance = _balances[account];
696         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
697         unchecked {
698             _balances[account] = accountBalance - amount;
699         }
700         _totalSupply -= amount;
701 
702         emit Transfer(account, address(0), amount);
703 
704         _afterTokenTransfer(account, address(0), amount);
705     }
706 
707     /**
708      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
709      *
710      * This internal function is equivalent to `approve`, and can be used to
711      * e.g. set automatic allowances for certain subsystems, etc.
712      *
713      * Emits an {Approval} event.
714      *
715      * Requirements:
716      *
717      * - `owner` cannot be the zero address.
718      * - `spender` cannot be the zero address.
719      */
720     function _approve(
721         address owner,
722         address spender,
723         uint256 amount
724     ) internal virtual {
725         require(owner != address(0), "ERC20: approve from the zero address");
726         require(spender != address(0), "ERC20: approve to the zero address");
727 
728         _allowances[owner][spender] = amount;
729         emit Approval(owner, spender, amount);
730     }
731 
732     /**
733      * @dev Hook that is called before any transfer of tokens. This includes
734      * minting and burning.
735      *
736      * Calling conditions:
737      *
738      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
739      * will be transferred to `to`.
740      * - when `from` is zero, `amount` tokens will be minted for `to`.
741      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
742      * - `from` and `to` are never both zero.
743      *
744      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
745      */
746     function _beforeTokenTransfer(
747         address from,
748         address to,
749         uint256 amount
750     ) internal virtual {}
751 
752     /**
753      * @dev Hook that is called after any transfer of tokens. This includes
754      * minting and burning.
755      *
756      * Calling conditions:
757      *
758      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
759      * has been transferred to `to`.
760      * - when `from` is zero, `amount` tokens have been minted for `to`.
761      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
762      * - `from` and `to` are never both zero.
763      *
764      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
765      */
766     function _afterTokenTransfer(
767         address from,
768         address to,
769         uint256 amount
770     ) internal virtual {}
771 }
772 
773 // File: contracts/interfaces/IAxonsToken.sol
774 
775 
776 
777 /// @title Interface for AxonsToken
778 
779 pragma solidity ^0.8.6;
780 
781 
782 interface IAxonsToken is IERC20 {
783     event Claimed(address account, uint256 amount);
784     
785     function generateReward(address recipient, uint256 amount) external;
786     function isGenesisAddress(address addressToCheck) external view returns(bool);
787     function burn(uint256 amount) external;
788 }
789 // File: contracts/AxonsToken.sol
790 
791 
792 
793 pragma solidity ^0.8.0;
794 
795 
796 
797 
798 
799 
800 
801 contract AxonsToken is IAxonsToken, ERC20, Ownable {
802 
803     bytes32 public immutable merkleRoot;
804 
805     // AH contract
806     address public auctionHouse;
807 
808     // Voting contract
809     address public voting;
810 
811     // Whether the voting contract can be updated
812     bool public isVotingLocked;
813 
814     // Whether the auctionHouse can be updated
815     bool public isAuctionHouseLocked;
816 
817 	// Whether genesis mints can still occur
818     bool public isGenesisMintLocked;
819 
820     mapping(address => bool) internal genesisAddress;
821 
822     /**
823      * @notice Require that the AH has not been locked.
824      */
825     modifier whenAuctionHouseNotLocked() {
826         require(!isAuctionHouseLocked, "Auction House is locked");
827         _;
828     }
829 
830 	/**
831      * @notice Require that the Genesis Mint has not been locked.
832      */
833     modifier whenGenesisMintNotLocked() {
834         require(!isGenesisMintLocked, "Genesis mint is locked");
835         _;
836     }
837 
838     /**
839      * @notice Require that the voting has not been locked.
840      */
841     modifier whenVotingNotLocked() {
842         require(!isVotingLocked, "Voting is locked");
843         _;
844     }
845     
846     constructor(address _auctionHouse, address _voting, bytes32 _merkleRoot) ERC20("Axon", "AXON")
847     {
848         auctionHouse = _auctionHouse;
849         voting = _voting;
850         merkleRoot = _merkleRoot;
851     }
852 
853     function claim(
854         address account,
855         uint256 amount,
856         bytes32[] calldata merkleProof
857     ) public {
858         require(!AnonymiceLibrary.isContract(msg.sender));
859 
860         // Verify the merkle proof.
861         bytes32 node = keccak256(abi.encodePacked(account, amount));
862 
863         require(
864             MerkleProof.verify(merkleProof, merkleRoot, node),
865             "MerkleDistributor: Invalid proof."
866         );
867 
868         require(genesisAddress[account] == false, 'Can only claim once');
869         _genesisMintAmount(account, amount * 10**uint(decimals()));
870 
871         emit Claimed(account, amount);
872     }
873 
874     function _genesisMintAmount(address to, uint256 amount) internal {
875         genesisAddress[to] = true;
876         _mint(to, amount);
877     }
878 
879     function isGenesisAddress(address addressToCheck) public view override returns(bool) {
880         return genesisAddress[addressToCheck];
881     }
882 
883     /**
884      * @notice Generate voting reward
885      */
886     function generateReward(address recipient, uint256 amount) public override {
887         require(msg.sender == voting, "Only voting contract can generate rewards");
888         _mint(payable(recipient), amount * 10**uint(decimals()));
889     }
890 
891     /**
892      * @notice Burn token
893      */
894     function burn(uint256 amount) public override {
895         _burn(msg.sender, amount);
896     }
897 
898     /**
899      * @notice Set the voting contract.
900      * @dev Only callable by the owner when not locked.
901      */
902     function setVoting(address _voting) public onlyOwner whenVotingNotLocked {
903         voting = _voting;
904     }
905 
906     /**
907      * @notice Lock the voting contract.
908      * @dev This cannot be reversed and is only callable by the owner when not locked.
909      */
910     function lockVoting() public onlyOwner whenVotingNotLocked {
911         isVotingLocked = true;
912     }
913 
914     /**
915      * @notice Set the auction house.
916      * @dev Only callable by the owner when not locked.
917      */
918     function setAuctionHouse(address _auctionHouse) public onlyOwner whenAuctionHouseNotLocked {
919         auctionHouse = _auctionHouse;
920     }
921 
922     /**
923      * @notice Lock the auction house.
924      * @dev This cannot be reversed and is only callable by the owner when not locked.
925      */
926     function lockAuctionHouse() public onlyOwner whenAuctionHouseNotLocked {
927         isAuctionHouseLocked = true;
928     }
929 
930     function transfer(address recipient, uint256 amount) public override(IERC20,ERC20) returns (bool) {
931         require(recipient == auctionHouse || msg.sender == auctionHouse, "This token cannot be traded");
932 
933         _transfer(msg.sender, recipient, amount);
934         return true;
935     }
936     
937     function transferFrom(
938         address sender,
939         address recipient,
940         uint256 amount
941     ) public override(IERC20,ERC20) returns (bool) {
942         require(sender == msg.sender || msg.sender == auctionHouse, "Can't send tokens on someone elses behalf");
943         require(recipient == auctionHouse || sender == auctionHouse, "This token cannot be traded");
944 
945         // override approval for auction house to save gas
946         if (recipient == auctionHouse) {
947             _transfer(sender, auctionHouse, amount);
948             return true;
949         }
950         // override approval for auction house to save gas
951         if (sender == auctionHouse) {
952             _transfer(auctionHouse, recipient, amount);
953             return true;
954         }
955 
956         return super.transferFrom(sender, recipient, amount);
957     }
958 }