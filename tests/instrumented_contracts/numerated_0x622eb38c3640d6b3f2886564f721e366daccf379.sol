1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Interface of the ERC165 standard, as defined in the
235  * https://eips.ethereum.org/EIPS/eip-165[EIP].
236  *
237  * Implementers can declare support of contract interfaces, which can then be
238  * queried by others ({ERC165Checker}).
239  *
240  * For an implementation, see {ERC165}.
241  */
242 interface IERC165 {
243     /**
244      * @dev Returns true if this contract implements the interface defined by
245      * `interfaceId`. See the corresponding
246      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
247      * to learn more about how these ids are created.
248      *
249      * This function call must use less than 30 000 gas.
250      */
251     function supportsInterface(bytes4 interfaceId) external view returns (bool);
252 }
253 
254 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Implementation of the {IERC165} interface.
264  *
265  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
266  * for the additional interface id that will be supported. For example:
267  *
268  * ```solidity
269  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
270  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
271  * }
272  * ```
273  *
274  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
275  */
276 abstract contract ERC165 is IERC165 {
277     /**
278      * @dev See {IERC165-supportsInterface}.
279      */
280     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
281         return interfaceId == type(IERC165).interfaceId;
282     }
283 }
284 
285 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
286 
287 
288 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @dev Interface for the NFT Royalty Standard.
295  *
296  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
297  * support for royalty payments across all NFT marketplaces and ecosystem participants.
298  *
299  * _Available since v4.5._
300  */
301 interface IERC2981 is IERC165 {
302     /**
303      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
304      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
305      */
306     function royaltyInfo(uint256 tokenId, uint256 salePrice)
307         external
308         view
309         returns (address receiver, uint256 royaltyAmount);
310 }
311 
312 // File: @openzeppelin/contracts/token/common/ERC2981.sol
313 
314 
315 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 
320 
321 /**
322  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
323  *
324  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
325  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
326  *
327  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
328  * fee is specified in basis points by default.
329  *
330  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
331  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
332  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
333  *
334  * _Available since v4.5._
335  */
336 abstract contract ERC2981 is IERC2981, ERC165 {
337     struct RoyaltyInfo {
338         address receiver;
339         uint96 royaltyFraction;
340     }
341 
342     RoyaltyInfo private _defaultRoyaltyInfo;
343     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
344 
345     /**
346      * @dev See {IERC165-supportsInterface}.
347      */
348     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
349         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
350     }
351 
352     /**
353      * @inheritdoc IERC2981
354      */
355     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
356         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
357 
358         if (royalty.receiver == address(0)) {
359             royalty = _defaultRoyaltyInfo;
360         }
361 
362         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
363 
364         return (royalty.receiver, royaltyAmount);
365     }
366 
367     /**
368      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
369      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
370      * override.
371      */
372     function _feeDenominator() internal pure virtual returns (uint96) {
373         return 10000;
374     }
375 
376     /**
377      * @dev Sets the royalty information that all ids in this contract will default to.
378      *
379      * Requirements:
380      *
381      * - `receiver` cannot be the zero address.
382      * - `feeNumerator` cannot be greater than the fee denominator.
383      */
384     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
385         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
386         require(receiver != address(0), "ERC2981: invalid receiver");
387 
388         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
389     }
390 
391     /**
392      * @dev Removes default royalty information.
393      */
394     function _deleteDefaultRoyalty() internal virtual {
395         delete _defaultRoyaltyInfo;
396     }
397 
398     /**
399      * @dev Sets the royalty information for a specific token id, overriding the global default.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must be already minted.
404      * - `receiver` cannot be the zero address.
405      * - `feeNumerator` cannot be greater than the fee denominator.
406      */
407     function _setTokenRoyalty(
408         uint256 tokenId,
409         address receiver,
410         uint96 feeNumerator
411     ) internal virtual {
412         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
413         require(receiver != address(0), "ERC2981: Invalid parameters");
414 
415         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
416     }
417 
418     /**
419      * @dev Resets royalty information for the token id back to the global default.
420      */
421     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
422         delete _tokenRoyaltyInfo[tokenId];
423     }
424 }
425 
426 // File: @openzeppelin/contracts/utils/Context.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev Provides information about the current execution context, including the
435  * sender of the transaction and its data. While these are generally available
436  * via msg.sender and msg.data, they should not be accessed in such a direct
437  * manner, since when dealing with meta-transactions the account sending and
438  * paying for execution may not be the actual sender (as far as an application
439  * is concerned).
440  *
441  * This contract is only required for intermediate, library-like contracts.
442  */
443 abstract contract Context {
444     function _msgSender() internal view virtual returns (address) {
445         return msg.sender;
446     }
447 
448     function _msgData() internal view virtual returns (bytes calldata) {
449         return msg.data;
450     }
451 }
452 
453 // File: @openzeppelin/contracts/access/Ownable.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 
461 /**
462  * @dev Contract module which provides a basic access control mechanism, where
463  * there is an account (an owner) that can be granted exclusive access to
464  * specific functions.
465  *
466  * By default, the owner account will be the one that deploys the contract. This
467  * can later be changed with {transferOwnership}.
468  *
469  * This module is used through inheritance. It will make available the modifier
470  * `onlyOwner`, which can be applied to your functions to restrict their use to
471  * the owner.
472  */
473 abstract contract Ownable is Context {
474     address private _owner;
475 
476     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
477 
478     /**
479      * @dev Initializes the contract setting the deployer as the initial owner.
480      */
481     constructor() {
482         _transferOwnership(_msgSender());
483     }
484 
485     /**
486      * @dev Returns the address of the current owner.
487      */
488     function owner() public view virtual returns (address) {
489         return _owner;
490     }
491 
492     /**
493      * @dev Throws if called by any account other than the owner.
494      */
495     modifier onlyOwner() {
496         require(owner() == _msgSender(), "Ownable: caller is not the owner");
497         _;
498     }
499 
500     /**
501      * @dev Leaves the contract without owner. It will not be possible to call
502      * `onlyOwner` functions anymore. Can only be called by the current owner.
503      *
504      * NOTE: Renouncing ownership will leave the contract without an owner,
505      * thereby removing any functionality that is only available to the owner.
506      */
507     function renounceOwnership() public virtual onlyOwner {
508         _transferOwnership(address(0));
509     }
510 
511     /**
512      * @dev Transfers ownership of the contract to a new account (`newOwner`).
513      * Can only be called by the current owner.
514      */
515     function transferOwnership(address newOwner) public virtual onlyOwner {
516         require(newOwner != address(0), "Ownable: new owner is the zero address");
517         _transferOwnership(newOwner);
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Internal function without access restriction.
523      */
524     function _transferOwnership(address newOwner) internal virtual {
525         address oldOwner = _owner;
526         _owner = newOwner;
527         emit OwnershipTransferred(oldOwner, newOwner);
528     }
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
532 
533 
534 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Interface of the ERC20 standard as defined in the EIP.
540  */
541 interface IERC20 {
542     /**
543      * @dev Emitted when `value` tokens are moved from one account (`from`) to
544      * another (`to`).
545      *
546      * Note that `value` may be zero.
547      */
548     event Transfer(address indexed from, address indexed to, uint256 value);
549 
550     /**
551      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
552      * a call to {approve}. `value` is the new allowance.
553      */
554     event Approval(address indexed owner, address indexed spender, uint256 value);
555 
556     /**
557      * @dev Returns the amount of tokens in existence.
558      */
559     function totalSupply() external view returns (uint256);
560 
561     /**
562      * @dev Returns the amount of tokens owned by `account`.
563      */
564     function balanceOf(address account) external view returns (uint256);
565 
566     /**
567      * @dev Moves `amount` tokens from the caller's account to `to`.
568      *
569      * Returns a boolean value indicating whether the operation succeeded.
570      *
571      * Emits a {Transfer} event.
572      */
573     function transfer(address to, uint256 amount) external returns (bool);
574 
575     /**
576      * @dev Returns the remaining number of tokens that `spender` will be
577      * allowed to spend on behalf of `owner` through {transferFrom}. This is
578      * zero by default.
579      *
580      * This value changes when {approve} or {transferFrom} are called.
581      */
582     function allowance(address owner, address spender) external view returns (uint256);
583 
584     /**
585      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
586      *
587      * Returns a boolean value indicating whether the operation succeeded.
588      *
589      * IMPORTANT: Beware that changing an allowance with this method brings the risk
590      * that someone may use both the old and the new allowance by unfortunate
591      * transaction ordering. One possible solution to mitigate this race
592      * condition is to first reduce the spender's allowance to 0 and set the
593      * desired value afterwards:
594      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
595      *
596      * Emits an {Approval} event.
597      */
598     function approve(address spender, uint256 amount) external returns (bool);
599 
600     /**
601      * @dev Moves `amount` tokens from `from` to `to` using the
602      * allowance mechanism. `amount` is then deducted from the caller's
603      * allowance.
604      *
605      * Returns a boolean value indicating whether the operation succeeded.
606      *
607      * Emits a {Transfer} event.
608      */
609     function transferFrom(
610         address from,
611         address to,
612         uint256 amount
613     ) external returns (bool);
614 }
615 
616 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @dev Interface for the optional metadata functions from the ERC20 standard.
626  *
627  * _Available since v4.1._
628  */
629 interface IERC20Metadata is IERC20 {
630     /**
631      * @dev Returns the name of the token.
632      */
633     function name() external view returns (string memory);
634 
635     /**
636      * @dev Returns the symbol of the token.
637      */
638     function symbol() external view returns (string memory);
639 
640     /**
641      * @dev Returns the decimals places of the token.
642      */
643     function decimals() external view returns (uint8);
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
647 
648 
649 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 
654 
655 
656 /**
657  * @dev Implementation of the {IERC20} interface.
658  *
659  * This implementation is agnostic to the way tokens are created. This means
660  * that a supply mechanism has to be added in a derived contract using {_mint}.
661  * For a generic mechanism see {ERC20PresetMinterPauser}.
662  *
663  * TIP: For a detailed writeup see our guide
664  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
665  * to implement supply mechanisms].
666  *
667  * We have followed general OpenZeppelin Contracts guidelines: functions revert
668  * instead returning `false` on failure. This behavior is nonetheless
669  * conventional and does not conflict with the expectations of ERC20
670  * applications.
671  *
672  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
673  * This allows applications to reconstruct the allowance for all accounts just
674  * by listening to said events. Other implementations of the EIP may not emit
675  * these events, as it isn't required by the specification.
676  *
677  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
678  * functions have been added to mitigate the well-known issues around setting
679  * allowances. See {IERC20-approve}.
680  */
681 contract ERC20 is Context, IERC20, IERC20Metadata {
682     mapping(address => uint256) private _balances;
683 
684     mapping(address => mapping(address => uint256)) private _allowances;
685 
686     uint256 private _totalSupply;
687 
688     string private _name;
689     string private _symbol;
690 
691     /**
692      * @dev Sets the values for {name} and {symbol}.
693      *
694      * The default value of {decimals} is 18. To select a different value for
695      * {decimals} you should overload it.
696      *
697      * All two of these values are immutable: they can only be set once during
698      * construction.
699      */
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703     }
704 
705     /**
706      * @dev Returns the name of the token.
707      */
708     function name() public view virtual override returns (string memory) {
709         return _name;
710     }
711 
712     /**
713      * @dev Returns the symbol of the token, usually a shorter version of the
714      * name.
715      */
716     function symbol() public view virtual override returns (string memory) {
717         return _symbol;
718     }
719 
720     /**
721      * @dev Returns the number of decimals used to get its user representation.
722      * For example, if `decimals` equals `2`, a balance of `505` tokens should
723      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
724      *
725      * Tokens usually opt for a value of 18, imitating the relationship between
726      * Ether and Wei. This is the value {ERC20} uses, unless this function is
727      * overridden;
728      *
729      * NOTE: This information is only used for _display_ purposes: it in
730      * no way affects any of the arithmetic of the contract, including
731      * {IERC20-balanceOf} and {IERC20-transfer}.
732      */
733     function decimals() public view virtual override returns (uint8) {
734         return 18;
735     }
736 
737     /**
738      * @dev See {IERC20-totalSupply}.
739      */
740     function totalSupply() public view virtual override returns (uint256) {
741         return _totalSupply;
742     }
743 
744     /**
745      * @dev See {IERC20-balanceOf}.
746      */
747     function balanceOf(address account) public view virtual override returns (uint256) {
748         return _balances[account];
749     }
750 
751     /**
752      * @dev See {IERC20-transfer}.
753      *
754      * Requirements:
755      *
756      * - `to` cannot be the zero address.
757      * - the caller must have a balance of at least `amount`.
758      */
759     function transfer(address to, uint256 amount) public virtual override returns (bool) {
760         address owner = _msgSender();
761         _transfer(owner, to, amount);
762         return true;
763     }
764 
765     /**
766      * @dev See {IERC20-allowance}.
767      */
768     function allowance(address owner, address spender) public view virtual override returns (uint256) {
769         return _allowances[owner][spender];
770     }
771 
772     /**
773      * @dev See {IERC20-approve}.
774      *
775      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
776      * `transferFrom`. This is semantically equivalent to an infinite approval.
777      *
778      * Requirements:
779      *
780      * - `spender` cannot be the zero address.
781      */
782     function approve(address spender, uint256 amount) public virtual override returns (bool) {
783         address owner = _msgSender();
784         _approve(owner, spender, amount);
785         return true;
786     }
787 
788     /**
789      * @dev See {IERC20-transferFrom}.
790      *
791      * Emits an {Approval} event indicating the updated allowance. This is not
792      * required by the EIP. See the note at the beginning of {ERC20}.
793      *
794      * NOTE: Does not update the allowance if the current allowance
795      * is the maximum `uint256`.
796      *
797      * Requirements:
798      *
799      * - `from` and `to` cannot be the zero address.
800      * - `from` must have a balance of at least `amount`.
801      * - the caller must have allowance for ``from``'s tokens of at least
802      * `amount`.
803      */
804     function transferFrom(
805         address from,
806         address to,
807         uint256 amount
808     ) public virtual override returns (bool) {
809         address spender = _msgSender();
810         _spendAllowance(from, spender, amount);
811         _transfer(from, to, amount);
812         return true;
813     }
814 
815     /**
816      * @dev Atomically increases the allowance granted to `spender` by the caller.
817      *
818      * This is an alternative to {approve} that can be used as a mitigation for
819      * problems described in {IERC20-approve}.
820      *
821      * Emits an {Approval} event indicating the updated allowance.
822      *
823      * Requirements:
824      *
825      * - `spender` cannot be the zero address.
826      */
827     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
828         address owner = _msgSender();
829         _approve(owner, spender, allowance(owner, spender) + addedValue);
830         return true;
831     }
832 
833     /**
834      * @dev Atomically decreases the allowance granted to `spender` by the caller.
835      *
836      * This is an alternative to {approve} that can be used as a mitigation for
837      * problems described in {IERC20-approve}.
838      *
839      * Emits an {Approval} event indicating the updated allowance.
840      *
841      * Requirements:
842      *
843      * - `spender` cannot be the zero address.
844      * - `spender` must have allowance for the caller of at least
845      * `subtractedValue`.
846      */
847     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
848         address owner = _msgSender();
849         uint256 currentAllowance = allowance(owner, spender);
850         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
851         unchecked {
852             _approve(owner, spender, currentAllowance - subtractedValue);
853         }
854 
855         return true;
856     }
857 
858     /**
859      * @dev Moves `amount` of tokens from `sender` to `recipient`.
860      *
861      * This internal function is equivalent to {transfer}, and can be used to
862      * e.g. implement automatic token fees, slashing mechanisms, etc.
863      *
864      * Emits a {Transfer} event.
865      *
866      * Requirements:
867      *
868      * - `from` cannot be the zero address.
869      * - `to` cannot be the zero address.
870      * - `from` must have a balance of at least `amount`.
871      */
872     function _transfer(
873         address from,
874         address to,
875         uint256 amount
876     ) internal virtual {
877         require(from != address(0), "ERC20: transfer from the zero address");
878         require(to != address(0), "ERC20: transfer to the zero address");
879 
880         _beforeTokenTransfer(from, to, amount);
881 
882         uint256 fromBalance = _balances[from];
883         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
884         unchecked {
885             _balances[from] = fromBalance - amount;
886         }
887         _balances[to] += amount;
888 
889         emit Transfer(from, to, amount);
890 
891         _afterTokenTransfer(from, to, amount);
892     }
893 
894     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
895      * the total supply.
896      *
897      * Emits a {Transfer} event with `from` set to the zero address.
898      *
899      * Requirements:
900      *
901      * - `account` cannot be the zero address.
902      */
903     function _mint(address account, uint256 amount) internal virtual {
904         require(account != address(0), "ERC20: mint to the zero address");
905 
906         _beforeTokenTransfer(address(0), account, amount);
907 
908         _totalSupply += amount;
909         _balances[account] += amount;
910         emit Transfer(address(0), account, amount);
911 
912         _afterTokenTransfer(address(0), account, amount);
913     }
914 
915     /**
916      * @dev Destroys `amount` tokens from `account`, reducing the
917      * total supply.
918      *
919      * Emits a {Transfer} event with `to` set to the zero address.
920      *
921      * Requirements:
922      *
923      * - `account` cannot be the zero address.
924      * - `account` must have at least `amount` tokens.
925      */
926     function _burn(address account, uint256 amount) internal virtual {
927         require(account != address(0), "ERC20: burn from the zero address");
928 
929         _beforeTokenTransfer(account, address(0), amount);
930 
931         uint256 accountBalance = _balances[account];
932         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
933         unchecked {
934             _balances[account] = accountBalance - amount;
935         }
936         _totalSupply -= amount;
937 
938         emit Transfer(account, address(0), amount);
939 
940         _afterTokenTransfer(account, address(0), amount);
941     }
942 
943     /**
944      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
945      *
946      * This internal function is equivalent to `approve`, and can be used to
947      * e.g. set automatic allowances for certain subsystems, etc.
948      *
949      * Emits an {Approval} event.
950      *
951      * Requirements:
952      *
953      * - `owner` cannot be the zero address.
954      * - `spender` cannot be the zero address.
955      */
956     function _approve(
957         address owner,
958         address spender,
959         uint256 amount
960     ) internal virtual {
961         require(owner != address(0), "ERC20: approve from the zero address");
962         require(spender != address(0), "ERC20: approve to the zero address");
963 
964         _allowances[owner][spender] = amount;
965         emit Approval(owner, spender, amount);
966     }
967 
968     /**
969      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
970      *
971      * Does not update the allowance amount in case of infinite allowance.
972      * Revert if not enough allowance is available.
973      *
974      * Might emit an {Approval} event.
975      */
976     function _spendAllowance(
977         address owner,
978         address spender,
979         uint256 amount
980     ) internal virtual {
981         uint256 currentAllowance = allowance(owner, spender);
982         if (currentAllowance != type(uint256).max) {
983             require(currentAllowance >= amount, "ERC20: insufficient allowance");
984             unchecked {
985                 _approve(owner, spender, currentAllowance - amount);
986             }
987         }
988     }
989 
990     /**
991      * @dev Hook that is called before any transfer of tokens. This includes
992      * minting and burning.
993      *
994      * Calling conditions:
995      *
996      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
997      * will be transferred to `to`.
998      * - when `from` is zero, `amount` tokens will be minted for `to`.
999      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1000      * - `from` and `to` are never both zero.
1001      *
1002      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003      */
1004     function _beforeTokenTransfer(
1005         address from,
1006         address to,
1007         uint256 amount
1008     ) internal virtual {}
1009 
1010     /**
1011      * @dev Hook that is called after any transfer of tokens. This includes
1012      * minting and burning.
1013      *
1014      * Calling conditions:
1015      *
1016      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1017      * has been transferred to `to`.
1018      * - when `from` is zero, `amount` tokens have been minted for `to`.
1019      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1020      * - `from` and `to` are never both zero.
1021      *
1022      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1023      */
1024     function _afterTokenTransfer(
1025         address from,
1026         address to,
1027         uint256 amount
1028     ) internal virtual {}
1029 }
1030 
1031 // File: @openzeppelin/contracts/utils/Strings.sol
1032 
1033 
1034 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1035 
1036 pragma solidity ^0.8.0;
1037 
1038 /**
1039  * @dev String operations.
1040  */
1041 library Strings {
1042     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1043 
1044     /**
1045      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1046      */
1047     function toString(uint256 value) internal pure returns (string memory) {
1048         // Inspired by OraclizeAPI's implementation - MIT licence
1049         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1050 
1051         if (value == 0) {
1052             return "0";
1053         }
1054         uint256 temp = value;
1055         uint256 digits;
1056         while (temp != 0) {
1057             digits++;
1058             temp /= 10;
1059         }
1060         bytes memory buffer = new bytes(digits);
1061         while (value != 0) {
1062             digits -= 1;
1063             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1064             value /= 10;
1065         }
1066         return string(buffer);
1067     }
1068 
1069     /**
1070      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1071      */
1072     function toHexString(uint256 value) internal pure returns (string memory) {
1073         if (value == 0) {
1074             return "0x00";
1075         }
1076         uint256 temp = value;
1077         uint256 length = 0;
1078         while (temp != 0) {
1079             length++;
1080             temp >>= 8;
1081         }
1082         return toHexString(value, length);
1083     }
1084 
1085     /**
1086      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1087      */
1088     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1089         bytes memory buffer = new bytes(2 * length + 2);
1090         buffer[0] = "0";
1091         buffer[1] = "x";
1092         for (uint256 i = 2 * length + 1; i > 1; --i) {
1093             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1094             value >>= 4;
1095         }
1096         require(value == 0, "Strings: hex length insufficient");
1097         return string(buffer);
1098     }
1099 }
1100 
1101 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1102 
1103 
1104 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1105 
1106 pragma solidity ^0.8.0;
1107 
1108 
1109 /**
1110  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1111  *
1112  * These functions can be used to verify that a message was signed by the holder
1113  * of the private keys of a given address.
1114  */
1115 library ECDSA {
1116     enum RecoverError {
1117         NoError,
1118         InvalidSignature,
1119         InvalidSignatureLength,
1120         InvalidSignatureS,
1121         InvalidSignatureV
1122     }
1123 
1124     function _throwError(RecoverError error) private pure {
1125         if (error == RecoverError.NoError) {
1126             return; // no error: do nothing
1127         } else if (error == RecoverError.InvalidSignature) {
1128             revert("ECDSA: invalid signature");
1129         } else if (error == RecoverError.InvalidSignatureLength) {
1130             revert("ECDSA: invalid signature length");
1131         } else if (error == RecoverError.InvalidSignatureS) {
1132             revert("ECDSA: invalid signature 's' value");
1133         } else if (error == RecoverError.InvalidSignatureV) {
1134             revert("ECDSA: invalid signature 'v' value");
1135         }
1136     }
1137 
1138     /**
1139      * @dev Returns the address that signed a hashed message (`hash`) with
1140      * `signature` or error string. This address can then be used for verification purposes.
1141      *
1142      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1143      * this function rejects them by requiring the `s` value to be in the lower
1144      * half order, and the `v` value to be either 27 or 28.
1145      *
1146      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1147      * verification to be secure: it is possible to craft signatures that
1148      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1149      * this is by receiving a hash of the original message (which may otherwise
1150      * be too long), and then calling {toEthSignedMessageHash} on it.
1151      *
1152      * Documentation for signature generation:
1153      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1154      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1155      *
1156      * _Available since v4.3._
1157      */
1158     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1159         // Check the signature length
1160         // - case 65: r,s,v signature (standard)
1161         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1162         if (signature.length == 65) {
1163             bytes32 r;
1164             bytes32 s;
1165             uint8 v;
1166             // ecrecover takes the signature parameters, and the only way to get them
1167             // currently is to use assembly.
1168             assembly {
1169                 r := mload(add(signature, 0x20))
1170                 s := mload(add(signature, 0x40))
1171                 v := byte(0, mload(add(signature, 0x60)))
1172             }
1173             return tryRecover(hash, v, r, s);
1174         } else if (signature.length == 64) {
1175             bytes32 r;
1176             bytes32 vs;
1177             // ecrecover takes the signature parameters, and the only way to get them
1178             // currently is to use assembly.
1179             assembly {
1180                 r := mload(add(signature, 0x20))
1181                 vs := mload(add(signature, 0x40))
1182             }
1183             return tryRecover(hash, r, vs);
1184         } else {
1185             return (address(0), RecoverError.InvalidSignatureLength);
1186         }
1187     }
1188 
1189     /**
1190      * @dev Returns the address that signed a hashed message (`hash`) with
1191      * `signature`. This address can then be used for verification purposes.
1192      *
1193      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1194      * this function rejects them by requiring the `s` value to be in the lower
1195      * half order, and the `v` value to be either 27 or 28.
1196      *
1197      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1198      * verification to be secure: it is possible to craft signatures that
1199      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1200      * this is by receiving a hash of the original message (which may otherwise
1201      * be too long), and then calling {toEthSignedMessageHash} on it.
1202      */
1203     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1204         (address recovered, RecoverError error) = tryRecover(hash, signature);
1205         _throwError(error);
1206         return recovered;
1207     }
1208 
1209     /**
1210      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1211      *
1212      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1213      *
1214      * _Available since v4.3._
1215      */
1216     function tryRecover(
1217         bytes32 hash,
1218         bytes32 r,
1219         bytes32 vs
1220     ) internal pure returns (address, RecoverError) {
1221         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1222         uint8 v = uint8((uint256(vs) >> 255) + 27);
1223         return tryRecover(hash, v, r, s);
1224     }
1225 
1226     /**
1227      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1228      *
1229      * _Available since v4.2._
1230      */
1231     function recover(
1232         bytes32 hash,
1233         bytes32 r,
1234         bytes32 vs
1235     ) internal pure returns (address) {
1236         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1237         _throwError(error);
1238         return recovered;
1239     }
1240 
1241     /**
1242      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1243      * `r` and `s` signature fields separately.
1244      *
1245      * _Available since v4.3._
1246      */
1247     function tryRecover(
1248         bytes32 hash,
1249         uint8 v,
1250         bytes32 r,
1251         bytes32 s
1252     ) internal pure returns (address, RecoverError) {
1253         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1254         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1255         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1256         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1257         //
1258         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1259         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1260         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1261         // these malleable signatures as well.
1262         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1263             return (address(0), RecoverError.InvalidSignatureS);
1264         }
1265         if (v != 27 && v != 28) {
1266             return (address(0), RecoverError.InvalidSignatureV);
1267         }
1268 
1269         // If the signature is valid (and not malleable), return the signer address
1270         address signer = ecrecover(hash, v, r, s);
1271         if (signer == address(0)) {
1272             return (address(0), RecoverError.InvalidSignature);
1273         }
1274 
1275         return (signer, RecoverError.NoError);
1276     }
1277 
1278     /**
1279      * @dev Overload of {ECDSA-recover} that receives the `v`,
1280      * `r` and `s` signature fields separately.
1281      */
1282     function recover(
1283         bytes32 hash,
1284         uint8 v,
1285         bytes32 r,
1286         bytes32 s
1287     ) internal pure returns (address) {
1288         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1289         _throwError(error);
1290         return recovered;
1291     }
1292 
1293     /**
1294      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1295      * produces hash corresponding to the one signed with the
1296      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1297      * JSON-RPC method as part of EIP-191.
1298      *
1299      * See {recover}.
1300      */
1301     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1302         // 32 is the length in bytes of hash,
1303         // enforced by the type signature above
1304         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1305     }
1306 
1307     /**
1308      * @dev Returns an Ethereum Signed Message, created from `s`. This
1309      * produces hash corresponding to the one signed with the
1310      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1311      * JSON-RPC method as part of EIP-191.
1312      *
1313      * See {recover}.
1314      */
1315     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1316         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1317     }
1318 
1319     /**
1320      * @dev Returns an Ethereum Signed Typed Data, created from a
1321      * `domainSeparator` and a `structHash`. This produces hash corresponding
1322      * to the one signed with the
1323      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1324      * JSON-RPC method as part of EIP-712.
1325      *
1326      * See {recover}.
1327      */
1328     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1329         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1330     }
1331 }
1332 
1333 // File: erc721a/contracts/IERC721A.sol
1334 
1335 
1336 // ERC721A Contracts v4.0.0
1337 // Creator: Chiru Labs
1338 
1339 pragma solidity ^0.8.4;
1340 
1341 /**
1342  * @dev Interface of an ERC721A compliant contract.
1343  */
1344 interface IERC721A {
1345     /**
1346      * The caller must own the token or be an approved operator.
1347      */
1348     error ApprovalCallerNotOwnerNorApproved();
1349 
1350     /**
1351      * The token does not exist.
1352      */
1353     error ApprovalQueryForNonexistentToken();
1354 
1355     /**
1356      * The caller cannot approve to their own address.
1357      */
1358     error ApproveToCaller();
1359 
1360     /**
1361      * The caller cannot approve to the current owner.
1362      */
1363     error ApprovalToCurrentOwner();
1364 
1365     /**
1366      * Cannot query the balance for the zero address.
1367      */
1368     error BalanceQueryForZeroAddress();
1369 
1370     /**
1371      * Cannot mint to the zero address.
1372      */
1373     error MintToZeroAddress();
1374 
1375     /**
1376      * The quantity of tokens minted must be more than zero.
1377      */
1378     error MintZeroQuantity();
1379 
1380     /**
1381      * The token does not exist.
1382      */
1383     error OwnerQueryForNonexistentToken();
1384 
1385     /**
1386      * The caller must own the token or be an approved operator.
1387      */
1388     error TransferCallerNotOwnerNorApproved();
1389 
1390     /**
1391      * The token must be owned by `from`.
1392      */
1393     error TransferFromIncorrectOwner();
1394 
1395     /**
1396      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1397      */
1398     error TransferToNonERC721ReceiverImplementer();
1399 
1400     /**
1401      * Cannot transfer to the zero address.
1402      */
1403     error TransferToZeroAddress();
1404 
1405     /**
1406      * The token does not exist.
1407      */
1408     error URIQueryForNonexistentToken();
1409 
1410     struct TokenOwnership {
1411         // The address of the owner.
1412         address addr;
1413         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1414         uint64 startTimestamp;
1415         // Whether the token has been burned.
1416         bool burned;
1417     }
1418 
1419     /**
1420      * @dev Returns the total amount of tokens stored by the contract.
1421      *
1422      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1423      */
1424     function totalSupply() external view returns (uint256);
1425 
1426     // ==============================
1427     //            IERC165
1428     // ==============================
1429 
1430     /**
1431      * @dev Returns true if this contract implements the interface defined by
1432      * `interfaceId`. See the corresponding
1433      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1434      * to learn more about how these ids are created.
1435      *
1436      * This function call must use less than 30 000 gas.
1437      */
1438     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1439 
1440     // ==============================
1441     //            IERC721
1442     // ==============================
1443 
1444     /**
1445      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1446      */
1447     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1448 
1449     /**
1450      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1451      */
1452     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1453 
1454     /**
1455      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1456      */
1457     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1458 
1459     /**
1460      * @dev Returns the number of tokens in ``owner``'s account.
1461      */
1462     function balanceOf(address owner) external view returns (uint256 balance);
1463 
1464     /**
1465      * @dev Returns the owner of the `tokenId` token.
1466      *
1467      * Requirements:
1468      *
1469      * - `tokenId` must exist.
1470      */
1471     function ownerOf(uint256 tokenId) external view returns (address owner);
1472 
1473     /**
1474      * @dev Safely transfers `tokenId` token from `from` to `to`.
1475      *
1476      * Requirements:
1477      *
1478      * - `from` cannot be the zero address.
1479      * - `to` cannot be the zero address.
1480      * - `tokenId` token must exist and be owned by `from`.
1481      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1482      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function safeTransferFrom(
1487         address from,
1488         address to,
1489         uint256 tokenId,
1490         bytes calldata data
1491     ) external;
1492 
1493     /**
1494      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1495      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1496      *
1497      * Requirements:
1498      *
1499      * - `from` cannot be the zero address.
1500      * - `to` cannot be the zero address.
1501      * - `tokenId` token must exist and be owned by `from`.
1502      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1503      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1504      *
1505      * Emits a {Transfer} event.
1506      */
1507     function safeTransferFrom(
1508         address from,
1509         address to,
1510         uint256 tokenId
1511     ) external;
1512 
1513     /**
1514      * @dev Transfers `tokenId` token from `from` to `to`.
1515      *
1516      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1517      *
1518      * Requirements:
1519      *
1520      * - `from` cannot be the zero address.
1521      * - `to` cannot be the zero address.
1522      * - `tokenId` token must be owned by `from`.
1523      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1524      *
1525      * Emits a {Transfer} event.
1526      */
1527     function transferFrom(
1528         address from,
1529         address to,
1530         uint256 tokenId
1531     ) external;
1532 
1533     /**
1534      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1535      * The approval is cleared when the token is transferred.
1536      *
1537      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1538      *
1539      * Requirements:
1540      *
1541      * - The caller must own the token or be an approved operator.
1542      * - `tokenId` must exist.
1543      *
1544      * Emits an {Approval} event.
1545      */
1546     function approve(address to, uint256 tokenId) external;
1547 
1548     /**
1549      * @dev Approve or remove `operator` as an operator for the caller.
1550      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1551      *
1552      * Requirements:
1553      *
1554      * - The `operator` cannot be the caller.
1555      *
1556      * Emits an {ApprovalForAll} event.
1557      */
1558     function setApprovalForAll(address operator, bool _approved) external;
1559 
1560     /**
1561      * @dev Returns the account approved for `tokenId` token.
1562      *
1563      * Requirements:
1564      *
1565      * - `tokenId` must exist.
1566      */
1567     function getApproved(uint256 tokenId) external view returns (address operator);
1568 
1569     /**
1570      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1571      *
1572      * See {setApprovalForAll}
1573      */
1574     function isApprovedForAll(address owner, address operator) external view returns (bool);
1575 
1576     // ==============================
1577     //        IERC721Metadata
1578     // ==============================
1579 
1580     /**
1581      * @dev Returns the token collection name.
1582      */
1583     function name() external view returns (string memory);
1584 
1585     /**
1586      * @dev Returns the token collection symbol.
1587      */
1588     function symbol() external view returns (string memory);
1589 
1590     /**
1591      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1592      */
1593     function tokenURI(uint256 tokenId) external view returns (string memory);
1594 }
1595 
1596 // File: erc721a/contracts/ERC721A.sol
1597 
1598 
1599 // ERC721A Contracts v4.0.0
1600 // Creator: Chiru Labs
1601 
1602 pragma solidity ^0.8.4;
1603 
1604 
1605 /**
1606  * @dev ERC721 token receiver interface.
1607  */
1608 interface ERC721A__IERC721Receiver {
1609     function onERC721Received(
1610         address operator,
1611         address from,
1612         uint256 tokenId,
1613         bytes calldata data
1614     ) external returns (bytes4);
1615 }
1616 
1617 /**
1618  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1619  * the Metadata extension. Built to optimize for lower gas during batch mints.
1620  *
1621  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1622  *
1623  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1624  *
1625  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1626  */
1627 contract ERC721A is IERC721A {
1628     // Mask of an entry in packed address data.
1629     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1630 
1631     // The bit position of `numberMinted` in packed address data.
1632     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1633 
1634     // The bit position of `numberBurned` in packed address data.
1635     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1636 
1637     // The bit position of `aux` in packed address data.
1638     uint256 private constant BITPOS_AUX = 192;
1639 
1640     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1641     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1642 
1643     // The bit position of `startTimestamp` in packed ownership.
1644     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1645 
1646     // The bit mask of the `burned` bit in packed ownership.
1647     uint256 private constant BITMASK_BURNED = 1 << 224;
1648     
1649     // The bit position of the `nextInitialized` bit in packed ownership.
1650     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1651 
1652     // The bit mask of the `nextInitialized` bit in packed ownership.
1653     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1654 
1655     // The tokenId of the next token to be minted.
1656     uint256 private _currentIndex;
1657 
1658     // The number of tokens burned.
1659     uint256 private _burnCounter;
1660 
1661     // Token name
1662     string private _name;
1663 
1664     // Token symbol
1665     string private _symbol;
1666 
1667     // Mapping from token ID to ownership details
1668     // An empty struct value does not necessarily mean the token is unowned.
1669     // See `_packedOwnershipOf` implementation for details.
1670     //
1671     // Bits Layout:
1672     // - [0..159]   `addr`
1673     // - [160..223] `startTimestamp`
1674     // - [224]      `burned`
1675     // - [225]      `nextInitialized`
1676     mapping(uint256 => uint256) private _packedOwnerships;
1677 
1678     // Mapping owner address to address data.
1679     //
1680     // Bits Layout:
1681     // - [0..63]    `balance`
1682     // - [64..127]  `numberMinted`
1683     // - [128..191] `numberBurned`
1684     // - [192..255] `aux`
1685     mapping(address => uint256) private _packedAddressData;
1686 
1687     // Mapping from token ID to approved address.
1688     mapping(uint256 => address) private _tokenApprovals;
1689 
1690     // Mapping from owner to operator approvals
1691     mapping(address => mapping(address => bool)) private _operatorApprovals;
1692 
1693     constructor(string memory name_, string memory symbol_) {
1694         _name = name_;
1695         _symbol = symbol_;
1696         _currentIndex = _startTokenId();
1697     }
1698 
1699     /**
1700      * @dev Returns the starting token ID. 
1701      * To change the starting token ID, please override this function.
1702      */
1703     function _startTokenId() internal view virtual returns (uint256) {
1704         return 0;
1705     }
1706 
1707     /**
1708      * @dev Returns the next token ID to be minted.
1709      */
1710     function _nextTokenId() internal view returns (uint256) {
1711         return _currentIndex;
1712     }
1713 
1714     /**
1715      * @dev Returns the total number of tokens in existence.
1716      * Burned tokens will reduce the count. 
1717      * To get the total number of tokens minted, please see `_totalMinted`.
1718      */
1719     function totalSupply() public view override returns (uint256) {
1720         // Counter underflow is impossible as _burnCounter cannot be incremented
1721         // more than `_currentIndex - _startTokenId()` times.
1722         unchecked {
1723             return _currentIndex - _burnCounter - _startTokenId();
1724         }
1725     }
1726 
1727     /**
1728      * @dev Returns the total amount of tokens minted in the contract.
1729      */
1730     function _totalMinted() internal view returns (uint256) {
1731         // Counter underflow is impossible as _currentIndex does not decrement,
1732         // and it is initialized to `_startTokenId()`
1733         unchecked {
1734             return _currentIndex - _startTokenId();
1735         }
1736     }
1737 
1738     /**
1739      * @dev Returns the total number of tokens burned.
1740      */
1741     function _totalBurned() internal view returns (uint256) {
1742         return _burnCounter;
1743     }
1744 
1745     /**
1746      * @dev See {IERC165-supportsInterface}.
1747      */
1748     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1749         // The interface IDs are constants representing the first 4 bytes of the XOR of
1750         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1751         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1752         return
1753             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1754             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1755             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1756     }
1757 
1758     /**
1759      * @dev See {IERC721-balanceOf}.
1760      */
1761     function balanceOf(address owner) public view override returns (uint256) {
1762         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1763         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1764     }
1765 
1766     /**
1767      * Returns the number of tokens minted by `owner`.
1768      */
1769     function _numberMinted(address owner) internal view returns (uint256) {
1770         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1771     }
1772 
1773     /**
1774      * Returns the number of tokens burned by or on behalf of `owner`.
1775      */
1776     function _numberBurned(address owner) internal view returns (uint256) {
1777         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1778     }
1779 
1780     /**
1781      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1782      */
1783     function _getAux(address owner) internal view returns (uint64) {
1784         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1785     }
1786 
1787     /**
1788      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1789      * If there are multiple variables, please pack them into a uint64.
1790      */
1791     function _setAux(address owner, uint64 aux) internal {
1792         uint256 packed = _packedAddressData[owner];
1793         uint256 auxCasted;
1794         assembly { // Cast aux without masking.
1795             auxCasted := aux
1796         }
1797         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1798         _packedAddressData[owner] = packed;
1799     }
1800 
1801     /**
1802      * Returns the packed ownership data of `tokenId`.
1803      */
1804     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1805         uint256 curr = tokenId;
1806 
1807         unchecked {
1808             if (_startTokenId() <= curr)
1809                 if (curr < _currentIndex) {
1810                     uint256 packed = _packedOwnerships[curr];
1811                     // If not burned.
1812                     if (packed & BITMASK_BURNED == 0) {
1813                         // Invariant:
1814                         // There will always be an ownership that has an address and is not burned
1815                         // before an ownership that does not have an address and is not burned.
1816                         // Hence, curr will not underflow.
1817                         //
1818                         // We can directly compare the packed value.
1819                         // If the address is zero, packed is zero.
1820                         while (packed == 0) {
1821                             packed = _packedOwnerships[--curr];
1822                         }
1823                         return packed;
1824                     }
1825                 }
1826         }
1827         revert OwnerQueryForNonexistentToken();
1828     }
1829 
1830     /**
1831      * Returns the unpacked `TokenOwnership` struct from `packed`.
1832      */
1833     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1834         ownership.addr = address(uint160(packed));
1835         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1836         ownership.burned = packed & BITMASK_BURNED != 0;
1837     }
1838 
1839     /**
1840      * Returns the unpacked `TokenOwnership` struct at `index`.
1841      */
1842     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1843         return _unpackedOwnership(_packedOwnerships[index]);
1844     }
1845 
1846     /**
1847      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1848      */
1849     function _initializeOwnershipAt(uint256 index) internal {
1850         if (_packedOwnerships[index] == 0) {
1851             _packedOwnerships[index] = _packedOwnershipOf(index);
1852         }
1853     }
1854 
1855     /**
1856      * Gas spent here starts off proportional to the maximum mint batch size.
1857      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1858      */
1859     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1860         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1861     }
1862 
1863     /**
1864      * @dev See {IERC721-ownerOf}.
1865      */
1866     function ownerOf(uint256 tokenId) public view override returns (address) {
1867         return address(uint160(_packedOwnershipOf(tokenId)));
1868     }
1869 
1870     /**
1871      * @dev See {IERC721Metadata-name}.
1872      */
1873     function name() public view virtual override returns (string memory) {
1874         return _name;
1875     }
1876 
1877     /**
1878      * @dev See {IERC721Metadata-symbol}.
1879      */
1880     function symbol() public view virtual override returns (string memory) {
1881         return _symbol;
1882     }
1883 
1884     /**
1885      * @dev See {IERC721Metadata-tokenURI}.
1886      */
1887     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1888         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1889 
1890         string memory baseURI = _baseURI();
1891         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1892     }
1893 
1894     /**
1895      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1896      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1897      * by default, can be overriden in child contracts.
1898      */
1899     function _baseURI() internal view virtual returns (string memory) {
1900         return '';
1901     }
1902 
1903     /**
1904      * @dev Casts the address to uint256 without masking.
1905      */
1906     function _addressToUint256(address value) private pure returns (uint256 result) {
1907         assembly {
1908             result := value
1909         }
1910     }
1911 
1912     /**
1913      * @dev Casts the boolean to uint256 without branching.
1914      */
1915     function _boolToUint256(bool value) private pure returns (uint256 result) {
1916         assembly {
1917             result := value
1918         }
1919     }
1920 
1921     /**
1922      * @dev See {IERC721-approve}.
1923      */
1924     function approve(address to, uint256 tokenId) public override {
1925         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1926         if (to == owner) revert ApprovalToCurrentOwner();
1927 
1928         if (_msgSenderERC721A() != owner)
1929             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1930                 revert ApprovalCallerNotOwnerNorApproved();
1931             }
1932 
1933         _tokenApprovals[tokenId] = to;
1934         emit Approval(owner, to, tokenId);
1935     }
1936 
1937     /**
1938      * @dev See {IERC721-getApproved}.
1939      */
1940     function getApproved(uint256 tokenId) public view override returns (address) {
1941         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1942 
1943         return _tokenApprovals[tokenId];
1944     }
1945 
1946     /**
1947      * @dev See {IERC721-setApprovalForAll}.
1948      */
1949     function setApprovalForAll(address operator, bool approved) public virtual override {
1950         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1951 
1952         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1953         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1954     }
1955 
1956     /**
1957      * @dev See {IERC721-isApprovedForAll}.
1958      */
1959     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1960         return _operatorApprovals[owner][operator];
1961     }
1962 
1963     /**
1964      * @dev See {IERC721-transferFrom}.
1965      */
1966     function transferFrom(
1967         address from,
1968         address to,
1969         uint256 tokenId
1970     ) public virtual override {
1971         _transfer(from, to, tokenId);
1972     }
1973 
1974     /**
1975      * @dev See {IERC721-safeTransferFrom}.
1976      */
1977     function safeTransferFrom(
1978         address from,
1979         address to,
1980         uint256 tokenId
1981     ) public virtual override {
1982         safeTransferFrom(from, to, tokenId, '');
1983     }
1984 
1985     /**
1986      * @dev See {IERC721-safeTransferFrom}.
1987      */
1988     function safeTransferFrom(
1989         address from,
1990         address to,
1991         uint256 tokenId,
1992         bytes memory _data
1993     ) public virtual override {
1994         _transfer(from, to, tokenId);
1995         if (to.code.length != 0)
1996             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1997                 revert TransferToNonERC721ReceiverImplementer();
1998             }
1999     }
2000 
2001     /**
2002      * @dev Returns whether `tokenId` exists.
2003      *
2004      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2005      *
2006      * Tokens start existing when they are minted (`_mint`),
2007      */
2008     function _exists(uint256 tokenId) internal view returns (bool) {
2009         return
2010             _startTokenId() <= tokenId &&
2011             tokenId < _currentIndex && // If within bounds,
2012             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
2013     }
2014 
2015     /**
2016      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2017      */
2018     function _safeMint(address to, uint256 quantity) internal {
2019         _safeMint(to, quantity, '');
2020     }
2021 
2022     /**
2023      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2024      *
2025      * Requirements:
2026      *
2027      * - If `to` refers to a smart contract, it must implement
2028      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2029      * - `quantity` must be greater than 0.
2030      *
2031      * Emits a {Transfer} event.
2032      */
2033     function _safeMint(
2034         address to,
2035         uint256 quantity,
2036         bytes memory _data
2037     ) internal {
2038         uint256 startTokenId = _currentIndex;
2039         if (to == address(0)) revert MintToZeroAddress();
2040         if (quantity == 0) revert MintZeroQuantity();
2041 
2042         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2043 
2044         // Overflows are incredibly unrealistic.
2045         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2046         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2047         unchecked {
2048             // Updates:
2049             // - `balance += quantity`.
2050             // - `numberMinted += quantity`.
2051             //
2052             // We can directly add to the balance and number minted.
2053             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
2054 
2055             // Updates:
2056             // - `address` to the owner.
2057             // - `startTimestamp` to the timestamp of minting.
2058             // - `burned` to `false`.
2059             // - `nextInitialized` to `quantity == 1`.
2060             _packedOwnerships[startTokenId] =
2061                 _addressToUint256(to) |
2062                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2063                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
2064 
2065             uint256 updatedIndex = startTokenId;
2066             uint256 end = updatedIndex + quantity;
2067 
2068             if (to.code.length != 0) {
2069                 do {
2070                     emit Transfer(address(0), to, updatedIndex);
2071                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2072                         revert TransferToNonERC721ReceiverImplementer();
2073                     }
2074                 } while (updatedIndex < end);
2075                 // Reentrancy protection
2076                 if (_currentIndex != startTokenId) revert();
2077             } else {
2078                 do {
2079                     emit Transfer(address(0), to, updatedIndex++);
2080                 } while (updatedIndex < end);
2081             }
2082             _currentIndex = updatedIndex;
2083         }
2084         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2085     }
2086 
2087     /**
2088      * @dev Mints `quantity` tokens and transfers them to `to`.
2089      *
2090      * Requirements:
2091      *
2092      * - `to` cannot be the zero address.
2093      * - `quantity` must be greater than 0.
2094      *
2095      * Emits a {Transfer} event.
2096      */
2097     function _mint(address to, uint256 quantity) internal {
2098         uint256 startTokenId = _currentIndex;
2099         if (to == address(0)) revert MintToZeroAddress();
2100         if (quantity == 0) revert MintZeroQuantity();
2101 
2102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2103 
2104         // Overflows are incredibly unrealistic.
2105         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2106         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2107         unchecked {
2108             // Updates:
2109             // - `balance += quantity`.
2110             // - `numberMinted += quantity`.
2111             //
2112             // We can directly add to the balance and number minted.
2113             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
2114 
2115             // Updates:
2116             // - `address` to the owner.
2117             // - `startTimestamp` to the timestamp of minting.
2118             // - `burned` to `false`.
2119             // - `nextInitialized` to `quantity == 1`.
2120             _packedOwnerships[startTokenId] =
2121                 _addressToUint256(to) |
2122                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2123                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
2124 
2125             uint256 updatedIndex = startTokenId;
2126             uint256 end = updatedIndex + quantity;
2127 
2128             do {
2129                 emit Transfer(address(0), to, updatedIndex++);
2130             } while (updatedIndex < end);
2131 
2132             _currentIndex = updatedIndex;
2133         }
2134         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2135     }
2136 
2137     /**
2138      * @dev Transfers `tokenId` from `from` to `to`.
2139      *
2140      * Requirements:
2141      *
2142      * - `to` cannot be the zero address.
2143      * - `tokenId` token must be owned by `from`.
2144      *
2145      * Emits a {Transfer} event.
2146      */
2147     function _transfer(
2148         address from,
2149         address to,
2150         uint256 tokenId
2151     ) private {
2152         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2153 
2154         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2155 
2156         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
2157             isApprovedForAll(from, _msgSenderERC721A()) ||
2158             getApproved(tokenId) == _msgSenderERC721A());
2159 
2160         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2161         if (to == address(0)) revert TransferToZeroAddress();
2162 
2163         _beforeTokenTransfers(from, to, tokenId, 1);
2164 
2165         // Clear approvals from the previous owner.
2166         delete _tokenApprovals[tokenId];
2167 
2168         // Underflow of the sender's balance is impossible because we check for
2169         // ownership above and the recipient's balance can't realistically overflow.
2170         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2171         unchecked {
2172             // We can directly increment and decrement the balances.
2173             --_packedAddressData[from]; // Updates: `balance -= 1`.
2174             ++_packedAddressData[to]; // Updates: `balance += 1`.
2175 
2176             // Updates:
2177             // - `address` to the next owner.
2178             // - `startTimestamp` to the timestamp of transfering.
2179             // - `burned` to `false`.
2180             // - `nextInitialized` to `true`.
2181             _packedOwnerships[tokenId] =
2182                 _addressToUint256(to) |
2183                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2184                 BITMASK_NEXT_INITIALIZED;
2185 
2186             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2187             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2188                 uint256 nextTokenId = tokenId + 1;
2189                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2190                 if (_packedOwnerships[nextTokenId] == 0) {
2191                     // If the next slot is within bounds.
2192                     if (nextTokenId != _currentIndex) {
2193                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2194                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2195                     }
2196                 }
2197             }
2198         }
2199 
2200         emit Transfer(from, to, tokenId);
2201         _afterTokenTransfers(from, to, tokenId, 1);
2202     }
2203 
2204     /**
2205      * @dev Equivalent to `_burn(tokenId, false)`.
2206      */
2207     function _burn(uint256 tokenId) internal virtual {
2208         _burn(tokenId, false);
2209     }
2210 
2211     /**
2212      * @dev Destroys `tokenId`.
2213      * The approval is cleared when the token is burned.
2214      *
2215      * Requirements:
2216      *
2217      * - `tokenId` must exist.
2218      *
2219      * Emits a {Transfer} event.
2220      */
2221     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2222         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2223 
2224         address from = address(uint160(prevOwnershipPacked));
2225 
2226         if (approvalCheck) {
2227             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
2228                 isApprovedForAll(from, _msgSenderERC721A()) ||
2229                 getApproved(tokenId) == _msgSenderERC721A());
2230 
2231             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2232         }
2233 
2234         _beforeTokenTransfers(from, address(0), tokenId, 1);
2235 
2236         // Clear approvals from the previous owner.
2237         delete _tokenApprovals[tokenId];
2238 
2239         // Underflow of the sender's balance is impossible because we check for
2240         // ownership above and the recipient's balance can't realistically overflow.
2241         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2242         unchecked {
2243             // Updates:
2244             // - `balance -= 1`.
2245             // - `numberBurned += 1`.
2246             //
2247             // We can directly decrement the balance, and increment the number burned.
2248             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
2249             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
2250 
2251             // Updates:
2252             // - `address` to the last owner.
2253             // - `startTimestamp` to the timestamp of burning.
2254             // - `burned` to `true`.
2255             // - `nextInitialized` to `true`.
2256             _packedOwnerships[tokenId] =
2257                 _addressToUint256(from) |
2258                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2259                 BITMASK_BURNED | 
2260                 BITMASK_NEXT_INITIALIZED;
2261 
2262             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2263             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2264                 uint256 nextTokenId = tokenId + 1;
2265                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2266                 if (_packedOwnerships[nextTokenId] == 0) {
2267                     // If the next slot is within bounds.
2268                     if (nextTokenId != _currentIndex) {
2269                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2270                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2271                     }
2272                 }
2273             }
2274         }
2275 
2276         emit Transfer(from, address(0), tokenId);
2277         _afterTokenTransfers(from, address(0), tokenId, 1);
2278 
2279         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2280         unchecked {
2281             _burnCounter++;
2282         }
2283     }
2284 
2285     /**
2286      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2287      *
2288      * @param from address representing the previous owner of the given token ID
2289      * @param to target address that will receive the tokens
2290      * @param tokenId uint256 ID of the token to be transferred
2291      * @param _data bytes optional data to send along with the call
2292      * @return bool whether the call correctly returned the expected magic value
2293      */
2294     function _checkContractOnERC721Received(
2295         address from,
2296         address to,
2297         uint256 tokenId,
2298         bytes memory _data
2299     ) private returns (bool) {
2300         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2301             bytes4 retval
2302         ) {
2303             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2304         } catch (bytes memory reason) {
2305             if (reason.length == 0) {
2306                 revert TransferToNonERC721ReceiverImplementer();
2307             } else {
2308                 assembly {
2309                     revert(add(32, reason), mload(reason))
2310                 }
2311             }
2312         }
2313     }
2314 
2315     /**
2316      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2317      * And also called before burning one token.
2318      *
2319      * startTokenId - the first token id to be transferred
2320      * quantity - the amount to be transferred
2321      *
2322      * Calling conditions:
2323      *
2324      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2325      * transferred to `to`.
2326      * - When `from` is zero, `tokenId` will be minted for `to`.
2327      * - When `to` is zero, `tokenId` will be burned by `from`.
2328      * - `from` and `to` are never both zero.
2329      */
2330     function _beforeTokenTransfers(
2331         address from,
2332         address to,
2333         uint256 startTokenId,
2334         uint256 quantity
2335     ) internal virtual {}
2336 
2337     /**
2338      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2339      * minting.
2340      * And also called after one token has been burned.
2341      *
2342      * startTokenId - the first token id to be transferred
2343      * quantity - the amount to be transferred
2344      *
2345      * Calling conditions:
2346      *
2347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2348      * transferred to `to`.
2349      * - When `from` is zero, `tokenId` has been minted for `to`.
2350      * - When `to` is zero, `tokenId` has been burned by `from`.
2351      * - `from` and `to` are never both zero.
2352      */
2353     function _afterTokenTransfers(
2354         address from,
2355         address to,
2356         uint256 startTokenId,
2357         uint256 quantity
2358     ) internal virtual {}
2359 
2360     /**
2361      * @dev Returns the message sender (defaults to `msg.sender`).
2362      *
2363      * If you are writing GSN compatible contracts, you need to override this function.
2364      */
2365     function _msgSenderERC721A() internal view virtual returns (address) {
2366         return msg.sender;
2367     }
2368 
2369     /**
2370      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2371      */
2372     function _toString(uint256 value) internal pure returns (string memory ptr) {
2373         assembly {
2374             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
2375             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2376             // We will need 1 32-byte word to store the length, 
2377             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2378             ptr := add(mload(0x40), 128)
2379             // Update the free memory pointer to allocate.
2380             mstore(0x40, ptr)
2381 
2382             // Cache the end of the memory to calculate the length later.
2383             let end := ptr
2384 
2385             // We write the string from the rightmost digit to the leftmost digit.
2386             // The following is essentially a do-while loop that also handles the zero case.
2387             // Costs a bit more than early returning for the zero case,
2388             // but cheaper in terms of deployment and overall runtime costs.
2389             for { 
2390                 // Initialize and perform the first pass without check.
2391                 let temp := value
2392                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2393                 ptr := sub(ptr, 1)
2394                 // Write the character to the pointer. 48 is the ASCII index of '0'.
2395                 mstore8(ptr, add(48, mod(temp, 10)))
2396                 temp := div(temp, 10)
2397             } temp { 
2398                 // Keep dividing `temp` until zero.
2399                 temp := div(temp, 10)
2400             } { // Body of the for loop.
2401                 ptr := sub(ptr, 1)
2402                 mstore8(ptr, add(48, mod(temp, 10)))
2403             }
2404             
2405             let length := sub(end, ptr)
2406             // Move the pointer 32 bytes leftwards to make room for the length.
2407             ptr := sub(ptr, 32)
2408             // Store the length.
2409             mstore(ptr, length)
2410         }
2411     }
2412 }
2413 
2414 // File: contracts/werewolves.sol
2415 
2416 
2417 
2418 pragma solidity ^0.8.14;
2419 
2420 
2421 
2422 
2423 
2424 
2425 
2426 
2427 error ErrorSaleNotOpen();
2428 error ErrorInsufficientFund();
2429 error ErrorExceedTransactionLimit();
2430 error ErrorExceedWalletLimit();
2431 error ErrorExceedMaxSupply();
2432 
2433 contract ClappedWolves is ERC2981, ERC721A, Ownable {
2434     using Address for address payable;
2435     using ECDSA for bytes32;
2436     using Strings for uint256;
2437 
2438     uint256 public immutable mintPrice_;
2439     uint32 public immutable txLimit_;
2440     uint32 public immutable maxSupply_;
2441     uint32 public immutable walletLimit_;
2442 
2443     bool public open_;
2444     string public metadataURI_ = "";
2445 
2446     constructor(
2447         uint256 mintPrice,
2448         uint32 maxSupply,
2449         uint32 txLimit,
2450         uint32 walletLimit
2451     ) ERC721A("ClappedWolves", "CP") {
2452         mintPrice_ = mintPrice;
2453         maxSupply_ = maxSupply;
2454         txLimit_ = txLimit;
2455         walletLimit_ = walletLimit;
2456 
2457         _setDefaultRoyalty(owner(), 500);
2458     }
2459 
2460     function mint(uint32 amount) external payable {
2461         if (!open_) revert ErrorSaleNotOpen();
2462         if (amount + _totalMinted() > maxSupply_) revert ErrorExceedMaxSupply();
2463         if (amount > txLimit_) revert ErrorExceedTransactionLimit();
2464 
2465         uint256 requiredValue = amount * mintPrice_;
2466         uint64 userMinted = _getAux(msg.sender);
2467         if (userMinted == 0) requiredValue -= mintPrice_;
2468 
2469         userMinted += amount;
2470         _setAux(msg.sender, userMinted);
2471         if (userMinted > walletLimit_) revert ErrorExceedWalletLimit();
2472 
2473         if (msg.value < requiredValue) revert ErrorInsufficientFund();
2474 
2475         _safeMint(msg.sender, amount);
2476     }
2477 
2478     struct State {
2479         uint256 mintPrice;
2480         uint32 txLimit;
2481         uint32 walletLimit;
2482         uint32 maxSupply;
2483         uint32 totalMinted;
2484         uint32 userMinted;
2485         bool open;
2486     }
2487 
2488     function _state(address minter) external view returns (State memory) {
2489         return
2490             State({
2491                 mintPrice: mintPrice_,
2492                 txLimit: txLimit_,
2493                 walletLimit: walletLimit_,
2494                 maxSupply: maxSupply_,
2495                 totalMinted: uint32(ERC721A._totalMinted()),
2496                 userMinted: uint32(_getAux(minter)),
2497                 open: open_
2498             });
2499     }
2500 
2501     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2502         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2503 
2504         string memory baseURI = metadataURI_;
2505         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2506     }
2507 
2508     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, ERC721A) returns (bool) {
2509         return
2510             interfaceId == type(IERC2981).interfaceId ||
2511             interfaceId == type(IERC721A).interfaceId ||
2512             super.supportsInterface(interfaceId);
2513     }
2514  
2515     function setOpen(bool open) external onlyOwner {
2516         open_ = open;
2517     }
2518 
2519     function setmetadata(string memory uri) external onlyOwner {
2520         metadataURI_ = uri;
2521     }
2522 
2523     function withdraw() external onlyOwner {
2524         payable(msg.sender).sendValue(address(this).balance);
2525     }
2526 }