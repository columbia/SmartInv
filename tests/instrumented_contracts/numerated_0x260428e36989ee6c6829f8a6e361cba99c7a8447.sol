1 pragma solidity ^0.8.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount)
22         external
23         returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender)
33         external
34         view
35         returns (uint256);
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
80     event Approval(
81         address indexed owner,
82         address indexed spender,
83         uint256 value
84     );
85 }
86 
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 interface IERC165 {
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 }
115 
116 interface IERC721 is IERC165 {
117     /**
118      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
119      */
120     event Transfer(
121         address indexed from,
122         address indexed to,
123         uint256 indexed tokenId
124     );
125 
126     /**
127      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
128      */
129     event Approval(
130         address indexed owner,
131         address indexed approved,
132         uint256 indexed tokenId
133     );
134 
135     /**
136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(
139         address indexed owner,
140         address indexed operator,
141         bool approved
142     );
143 
144     /**
145      * @dev Returns the number of tokens in ``owner``'s account.
146      */
147     function balanceOf(address owner) external view returns (uint256 balance);
148 
149     /**
150      * @dev Returns the owner of the `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function ownerOf(uint256 tokenId) external view returns (address owner);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
160      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId
176     ) external;
177 
178     /**
179      * @dev Transfers `tokenId` token from `from` to `to`.
180      *
181      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must be owned by `from`.
188      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
200      * The approval is cleared when the token is transferred.
201      *
202      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
203      *
204      * Requirements:
205      *
206      * - The caller must own the token or be an approved operator.
207      * - `tokenId` must exist.
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address to, uint256 tokenId) external;
212 
213     /**
214      * @dev Returns the account approved for `tokenId` token.
215      *
216      * Requirements:
217      *
218      * - `tokenId` must exist.
219      */
220     function getApproved(uint256 tokenId)
221         external
222         view
223         returns (address operator);
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator)
243         external
244         view
245         returns (bool);
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId,
264         bytes calldata data
265     ) external;
266 }
267 
268 interface IERC721Metadata is IERC721 {
269     /**
270      * @dev Returns the token collection name.
271      */
272     function name() external view returns (string memory);
273 
274     /**
275      * @dev Returns the token collection symbol.
276      */
277     function symbol() external view returns (string memory);
278 
279     /**
280      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
281      */
282     function tokenURI(uint256 tokenId) external view returns (string memory);
283 }
284 
285 interface IERC721Enumerable is IERC721 {
286     /**
287      * @dev Returns the total amount of tokens stored by the contract.
288      */
289     function totalSupply() external view returns (uint256);
290 
291     /**
292      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
293      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
294      */
295     function tokenOfOwnerByIndex(address owner, uint256 index)
296         external
297         view
298         returns (uint256 tokenId);
299 
300     /**
301      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
302      * Use along with {totalSupply} to enumerate all tokens.
303      */
304     function tokenByIndex(uint256 index) external view returns (uint256);
305 }
306 
307 interface IERC721Receiver {
308     /**
309      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
310      * by `operator` from `from`, this function is called.
311      *
312      * It must return its Solidity selector to confirm the token transfer.
313      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
314      *
315      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
316      */
317     function onERC721Received(
318         address operator,
319         address from,
320         uint256 tokenId,
321         bytes calldata data
322     ) external returns (bytes4);
323 }
324 
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      */
343     function isContract(address account) internal view returns (bool) {
344         // This method relies on extcodesize, which returns 0 for contracts in
345         // construction, since the code is only stored at the end of the
346         // constructor execution.
347 
348         uint256 size;
349         // solhint-disable-next-line no-inline-assembly
350         assembly {
351             size := extcodesize(account)
352         }
353         return size > 0;
354     }
355 
356     /**
357      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358      * `recipient`, forwarding all available gas and reverting on errors.
359      *
360      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361      * of certain opcodes, possibly making contracts go over the 2300 gas limit
362      * imposed by `transfer`, making them unable to receive funds via
363      * `transfer`. {sendValue} removes this limitation.
364      *
365      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366      *
367      * IMPORTANT: because control is transferred to `recipient`, care must be
368      * taken to not create reentrancy vulnerabilities. Consider using
369      * {ReentrancyGuard} or the
370      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(
374             address(this).balance >= amount,
375             "Address: insufficient balance"
376         );
377 
378         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
379         (bool success, ) = recipient.call{value: amount}("");
380         require(
381             success,
382             "Address: unable to send value, recipient may have reverted"
383         );
384     }
385 
386     /**
387      * @dev Performs a Solidity function call using a low level `call`. A
388      * plain`call` is an unsafe replacement for a function call: use this
389      * function instead.
390      *
391      * If `target` reverts with a revert reason, it is bubbled up by this
392      * function (like regular Solidity function calls).
393      *
394      * Returns the raw returned data. To convert to the expected return value,
395      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
396      *
397      * Requirements:
398      *
399      * - `target` must be a contract.
400      * - calling `target` with `data` must not revert.
401      *
402      * _Available since v3.1._
403      */
404     function functionCall(address target, bytes memory data)
405         internal
406         returns (bytes memory)
407     {
408         return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, 0, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but also transferring `value` wei to `target`.
428      *
429      * Requirements:
430      *
431      * - the calling contract must have an ETH balance of at least `value`.
432      * - the called Solidity function must be `payable`.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value
440     ) internal returns (bytes memory) {
441         return
442             functionCallWithValue(
443                 target,
444                 data,
445                 value,
446                 "Address: low-level call with value failed"
447             );
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(
463             address(this).balance >= value,
464             "Address: insufficient balance for call"
465         );
466         require(isContract(target), "Address: call to non-contract");
467 
468         // solhint-disable-next-line avoid-low-level-calls
469         (bool success, bytes memory returndata) = target.call{value: value}(
470             data
471         );
472         return _verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data)
482         internal
483         view
484         returns (bytes memory)
485     {
486         return
487             functionStaticCall(
488                 target,
489                 data,
490                 "Address: low-level static call failed"
491             );
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a static call.
497      *
498      * _Available since v3.3._
499      */
500     function functionStaticCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal view returns (bytes memory) {
505         require(isContract(target), "Address: static call to non-contract");
506 
507         // solhint-disable-next-line avoid-low-level-calls
508         (bool success, bytes memory returndata) = target.staticcall(data);
509         return _verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(address target, bytes memory data)
519         internal
520         returns (bytes memory)
521     {
522         return
523             functionDelegateCall(
524                 target,
525                 data,
526                 "Address: low-level delegate call failed"
527             );
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a delegate call.
533      *
534      * _Available since v3.4._
535      */
536     function functionDelegateCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(isContract(target), "Address: delegate call to non-contract");
542 
543         // solhint-disable-next-line avoid-low-level-calls
544         (bool success, bytes memory returndata) = target.delegatecall(data);
545         return _verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     function _verifyCallResult(
549         bool success,
550         bytes memory returndata,
551         string memory errorMessage
552     ) private pure returns (bytes memory) {
553         if (success) {
554             return returndata;
555         } else {
556             // Look for revert reason and bubble it up if present
557             if (returndata.length > 0) {
558                 // The easiest way to bubble the revert reason is using memory via assembly
559 
560                 // solhint-disable-next-line no-inline-assembly
561                 assembly {
562                     let returndata_size := mload(returndata)
563                     revert(add(32, returndata), returndata_size)
564                 }
565             } else {
566                 revert(errorMessage);
567             }
568         }
569     }
570 }
571 
572 library Strings {
573     /**
574      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
575      */
576     function toString(uint256 value) internal pure returns (string memory) {
577         // Inspired by OraclizeAPI's implementation - MIT licence
578         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
579 
580         if (value == 0) {
581             return "0";
582         }
583         uint256 temp = value;
584         uint256 digits;
585         while (temp != 0) {
586             digits++;
587             temp /= 10;
588         }
589         bytes memory buffer = new bytes(digits);
590         while (value != 0) {
591             digits -= 1;
592             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
593             value /= 10;
594         }
595         return string(buffer);
596     }
597 }
598 
599 abstract contract Context {
600     function _msgSender() internal view virtual returns (address) {
601         return msg.sender;
602     }
603 
604     function _msgData() internal view virtual returns (bytes calldata) {
605         this;
606         return msg.data;
607     }
608 }
609 
610 abstract contract Ownable is Context {
611     address private _owner;
612 
613     event OwnershipTransferred(
614         address indexed previousOwner,
615         address indexed newOwner
616     );
617 
618     /**
619      * @dev Initializes the contract setting the deployer as the initial owner.
620      */
621     constructor() {
622         _setOwner(_msgSender());
623     }
624 
625     /**
626      * @dev Returns the address of the current owner.
627      */
628     function owner() public view virtual returns (address) {
629         return _owner;
630     }
631 
632     /**
633      * @dev Throws if called by any account other than the owner.
634      */
635     modifier onlyOwner() {
636         require(owner() == _msgSender(), "Ownable: caller is not the owner");
637         _;
638     }
639 
640     /**
641      * @dev Leaves the contract without owner. It will not be possible to call
642      * `onlyOwner` functions anymore. Can only be called by the current owner.
643      *
644      * NOTE: Renouncing ownership will leave the contract without an owner,
645      * thereby removing any functionality that is only available to the owner.
646      */
647     function renounceOwnership() public virtual onlyOwner {
648         _setOwner(address(0));
649     }
650 
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      * Can only be called by the current owner.
654      */
655     function transferOwnership(address newOwner) public virtual onlyOwner {
656         require(
657             newOwner != address(0),
658             "Ownable: new owner is the zero address"
659         );
660         _setOwner(newOwner);
661     }
662 
663     function _setOwner(address newOwner) private {
664         address oldOwner = _owner;
665         _owner = newOwner;
666         emit OwnershipTransferred(oldOwner, newOwner);
667     }
668 }
669 
670 contract ERC20 is Context, IERC20, IERC20Metadata {
671     mapping(address => uint256) private _balances;
672 
673     mapping(address => mapping(address => uint256)) private _allowances;
674 
675     uint256 private _totalSupply;
676 
677     string private _name;
678     string private _symbol;
679 
680     /**
681      * @dev Sets the values for {name} and {symbol}.
682      *
683      * The default value of {decimals} is 18. To select a different value for
684      * {decimals} you should overload it.
685      *
686      * All two of these values are immutable: they can only be set once during
687      * construction.
688      */
689     constructor(string memory name_, string memory symbol_) {
690         _name = name_;
691         _symbol = symbol_;
692     }
693 
694     /**
695      * @dev Returns the name of the token.
696      */
697     function name() public view virtual override returns (string memory) {
698         return _name;
699     }
700 
701     /**
702      * @dev Returns the symbol of the token, usually a shorter version of the
703      * name.
704      */
705     function symbol() public view virtual override returns (string memory) {
706         return _symbol;
707     }
708 
709     /**
710      * @dev Returns the number of decimals used to get its user representation.
711      * For example, if `decimals` equals `2`, a balance of `505` tokens should
712      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
713      *
714      * Tokens usually opt for a value of 18, imitating the relationship between
715      * Ether and Wei. This is the value {ERC20} uses, unless this function is
716      * overridden;
717      *
718      * NOTE: This information is only used for _display_ purposes: it in
719      * no way affects any of the arithmetic of the contract, including
720      * {IERC20-balanceOf} and {IERC20-transfer}.
721      */
722     function decimals() public view virtual override returns (uint8) {
723         return 18;
724     }
725 
726     /**
727      * @dev See {IERC20-totalSupply}.
728      */
729     function totalSupply() public view virtual override returns (uint256) {
730         return _totalSupply;
731     }
732 
733     /**
734      * @dev See {IERC20-balanceOf}.
735      */
736     function balanceOf(address account)
737         public
738         view
739         virtual
740         override
741         returns (uint256)
742     {
743         return _balances[account];
744     }
745 
746     /**
747      * @dev See {IERC20-transfer}.
748      *
749      * Requirements:
750      *
751      * - `recipient` cannot be the zero address.
752      * - the caller must have a balance of at least `amount`.
753      */
754     function transfer(address recipient, uint256 amount)
755         public
756         virtual
757         override
758         returns (bool)
759     {
760         _transfer(_msgSender(), recipient, amount);
761         return true;
762     }
763 
764     /**
765      * @dev See {IERC20-allowance}.
766      */
767     function allowance(address owner, address spender)
768         public
769         view
770         virtual
771         override
772         returns (uint256)
773     {
774         return _allowances[owner][spender];
775     }
776 
777     /**
778      * @dev See {IERC20-approve}.
779      *
780      * Requirements:
781      *
782      * - `spender` cannot be the zero address.
783      */
784     function approve(address spender, uint256 amount)
785         public
786         virtual
787         override
788         returns (bool)
789     {
790         _approve(_msgSender(), spender, amount);
791         return true;
792     }
793 
794     /**
795      * @dev See {IERC20-transferFrom}.
796      *
797      * Emits an {Approval} event indicating the updated allowance. This is not
798      * required by the EIP. See the note at the beginning of {ERC20}.
799      *
800      * Requirements:
801      *
802      * - `sender` and `recipient` cannot be the zero address.
803      * - `sender` must have a balance of at least `amount`.
804      * - the caller must have allowance for ``sender``'s tokens of at least
805      * `amount`.
806      */
807     function transferFrom(
808         address sender,
809         address recipient,
810         uint256 amount
811     ) public virtual override returns (bool) {
812         _transfer(sender, recipient, amount);
813 
814         uint256 currentAllowance = _allowances[sender][_msgSender()];
815         require(
816             currentAllowance >= amount,
817             "ERC20: transfer amount exceeds allowance"
818         );
819         unchecked {
820             _approve(sender, _msgSender(), currentAllowance - amount);
821         }
822 
823         return true;
824     }
825 
826     /**
827      * @dev Atomically increases the allowance granted to `spender` by the caller.
828      *
829      * This is an alternative to {approve} that can be used as a mitigation for
830      * problems described in {IERC20-approve}.
831      *
832      * Emits an {Approval} event indicating the updated allowance.
833      *
834      * Requirements:
835      *
836      * - `spender` cannot be the zero address.
837      */
838     function increaseAllowance(address spender, uint256 addedValue)
839         public
840         virtual
841         returns (bool)
842     {
843         _approve(
844             _msgSender(),
845             spender,
846             _allowances[_msgSender()][spender] + addedValue
847         );
848         return true;
849     }
850 
851     /**
852      * @dev Atomically decreases the allowance granted to `spender` by the caller.
853      *
854      * This is an alternative to {approve} that can be used as a mitigation for
855      * problems described in {IERC20-approve}.
856      *
857      * Emits an {Approval} event indicating the updated allowance.
858      *
859      * Requirements:
860      *
861      * - `spender` cannot be the zero address.
862      * - `spender` must have allowance for the caller of at least
863      * `subtractedValue`.
864      */
865     function decreaseAllowance(address spender, uint256 subtractedValue)
866         public
867         virtual
868         returns (bool)
869     {
870         uint256 currentAllowance = _allowances[_msgSender()][spender];
871         require(
872             currentAllowance >= subtractedValue,
873             "ERC20: decreased allowance below zero"
874         );
875         unchecked {
876             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
877         }
878 
879         return true;
880     }
881 
882     /**
883      * @dev Moves `amount` of tokens from `sender` to `recipient`.
884      *
885      * This internal function is equivalent to {transfer}, and can be used to
886      * e.g. implement automatic token fees, slashing mechanisms, etc.
887      *
888      * Emits a {Transfer} event.
889      *
890      * Requirements:
891      *
892      * - `sender` cannot be the zero address.
893      * - `recipient` cannot be the zero address.
894      * - `sender` must have a balance of at least `amount`.
895      */
896     function _transfer(
897         address sender,
898         address recipient,
899         uint256 amount
900     ) internal virtual {
901         require(sender != address(0), "ERC20: transfer from the zero address");
902         require(recipient != address(0), "ERC20: transfer to the zero address");
903 
904         _beforeTokenTransfer(sender, recipient, amount);
905 
906         uint256 senderBalance = _balances[sender];
907         require(
908             senderBalance >= amount,
909             "ERC20: transfer amount exceeds balance"
910         );
911         unchecked {
912             _balances[sender] = senderBalance - amount;
913         }
914         _balances[recipient] += amount;
915 
916         emit Transfer(sender, recipient, amount);
917 
918         _afterTokenTransfer(sender, recipient, amount);
919     }
920 
921     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
922      * the total supply.
923      *
924      * Emits a {Transfer} event with `from` set to the zero address.
925      *
926      * Requirements:
927      *
928      * - `account` cannot be the zero address.
929      */
930     function _mint(address account, uint256 amount) internal virtual {
931         require(account != address(0), "ERC20: mint to the zero address");
932 
933         _beforeTokenTransfer(address(0), account, amount);
934 
935         _totalSupply += amount;
936         _balances[account] += amount;
937         emit Transfer(address(0), account, amount);
938 
939         _afterTokenTransfer(address(0), account, amount);
940     }
941 
942     /**
943      * @dev Destroys `amount` tokens from `account`, reducing the
944      * total supply.
945      *
946      * Emits a {Transfer} event with `to` set to the zero address.
947      *
948      * Requirements:
949      *
950      * - `account` cannot be the zero address.
951      * - `account` must have at least `amount` tokens.
952      */
953     function _burn(address account, uint256 amount) internal virtual {
954         require(account != address(0), "ERC20: burn from the zero address");
955 
956         _beforeTokenTransfer(account, address(0), amount);
957 
958         uint256 accountBalance = _balances[account];
959         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
960         unchecked {
961             _balances[account] = accountBalance - amount;
962         }
963         _totalSupply -= amount;
964 
965         emit Transfer(account, address(0), amount);
966 
967         _afterTokenTransfer(account, address(0), amount);
968     }
969 
970     /**
971      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
972      *
973      * This internal function is equivalent to `approve`, and can be used to
974      * e.g. set automatic allowances for certain subsystems, etc.
975      *
976      * Emits an {Approval} event.
977      *
978      * Requirements:
979      *
980      * - `owner` cannot be the zero address.
981      * - `spender` cannot be the zero address.
982      */
983     function _approve(
984         address owner,
985         address spender,
986         uint256 amount
987     ) internal virtual {
988         require(owner != address(0), "ERC20: approve from the zero address");
989         require(spender != address(0), "ERC20: approve to the zero address");
990 
991         _allowances[owner][spender] = amount;
992         emit Approval(owner, spender, amount);
993     }
994 
995     /**
996      * @dev Hook that is called before any transfer of tokens. This includes
997      * minting and burning.
998      *
999      * Calling conditions:
1000      *
1001      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1002      * will be transferred to `to`.
1003      * - when `from` is zero, `amount` tokens will be minted for `to`.
1004      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1005      * - `from` and `to` are never both zero.
1006      *
1007      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1008      */
1009     function _beforeTokenTransfer(
1010         address from,
1011         address to,
1012         uint256 amount
1013     ) internal virtual {}
1014 
1015     /**
1016      * @dev Hook that is called after any transfer of tokens. This includes
1017      * minting and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1022      * has been transferred to `to`.
1023      * - when `from` is zero, `amount` tokens have been minted for `to`.
1024      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1025      * - `from` and `to` are never both zero.
1026      *
1027      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1028      */
1029     function _afterTokenTransfer(
1030         address from,
1031         address to,
1032         uint256 amount
1033     ) internal virtual {}
1034 }
1035 
1036 abstract contract ERC165 is IERC165 {
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(bytes4 interfaceId)
1041         public
1042         view
1043         virtual
1044         override
1045         returns (bool)
1046     {
1047         return interfaceId == type(IERC165).interfaceId;
1048     }
1049 }
1050 
1051 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1052     using Address for address;
1053     using Strings for uint256;
1054 
1055     // Token name
1056     string internal _name;
1057 
1058     // Token symbol
1059     string private _symbol;
1060 
1061     // Base URI
1062     string private _tokenBaseURI;
1063 
1064     // Mapping from token ID to owner address
1065     mapping(uint256 => address) private _owners;
1066 
1067     // Mapping owner address to token count
1068     mapping(address => uint256) private _balances;
1069 
1070     // Mapping from token ID to approved address
1071     mapping(uint256 => address) private _tokenApprovals;
1072 
1073     // Mapping from owner to operator approvals
1074     mapping(address => mapping(address => bool)) private _operatorApprovals;
1075 
1076     /**
1077      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1078      */
1079     constructor(string memory name_, string memory symbol_) {
1080         _name = name_;
1081         _symbol = symbol_;
1082     }
1083 
1084     /**
1085      * @dev See {IERC165-supportsInterface}.
1086      */
1087     function supportsInterface(bytes4 interfaceId)
1088         public
1089         view
1090         virtual
1091         override(ERC165, IERC165)
1092         returns (bool)
1093     {
1094         return
1095             interfaceId == type(IERC721).interfaceId ||
1096             interfaceId == type(IERC721Metadata).interfaceId ||
1097             super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-balanceOf}.
1102      */
1103     function balanceOf(address owner)
1104         public
1105         view
1106         virtual
1107         override
1108         returns (uint256)
1109     {
1110         require(
1111             owner != address(0),
1112             "ERC721: balance query for the zero address"
1113         );
1114         return _balances[owner];
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-ownerOf}.
1119      */
1120     function ownerOf(uint256 tokenId)
1121         public
1122         view
1123         virtual
1124         override
1125         returns (address)
1126     {
1127         address owner = _owners[tokenId];
1128         require(
1129             owner != address(0),
1130             "ERC721: owner query for nonexistent token"
1131         );
1132         return owner;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Metadata-name}.
1137      */
1138     function name() public view virtual override returns (string memory) {
1139         return _name;
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Metadata-symbol}.
1144      */
1145     function symbol() public view virtual override returns (string memory) {
1146         return _symbol;
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Metadata-tokenURI}.
1151      */
1152     function tokenURI(uint256 tokenId)
1153         public
1154         view
1155         virtual
1156         override
1157         returns (string memory)
1158     {
1159         require(
1160             _exists(tokenId),
1161             "ERC721Metadata: URI query for nonexistent token"
1162         );
1163 
1164         string memory baseURI = _baseURI();
1165         return
1166             bytes(baseURI).length > 0
1167                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1168                 : "";
1169     }
1170 
1171     /**
1172      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1173      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1174      * by default, can be overriden in child contracts.
1175      */
1176     function _baseURI() internal view virtual returns (string memory) {
1177         return _tokenBaseURI;
1178     }
1179 
1180     function _setBaseURI(string memory baseURI_) internal virtual {
1181         _tokenBaseURI = baseURI_;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-approve}.
1186      */
1187     function approve(address to, uint256 tokenId) public virtual override {
1188         address owner = ERC721.ownerOf(tokenId);
1189         require(to != owner, "ERC721: approval to current owner");
1190 
1191         require(
1192             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1193             "ERC721: approve caller is not owner nor approved for all"
1194         );
1195 
1196         _approve(to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev See {IERC721-getApproved}.
1201      */
1202     function getApproved(uint256 tokenId)
1203         public
1204         view
1205         virtual
1206         override
1207         returns (address)
1208     {
1209         require(
1210             _exists(tokenId),
1211             "ERC721: approved query for nonexistent token"
1212         );
1213 
1214         return _tokenApprovals[tokenId];
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-setApprovalForAll}.
1219      */
1220     function setApprovalForAll(address operator, bool approved)
1221         public
1222         virtual
1223         override
1224     {
1225         _setApprovalForAll(_msgSender(), operator, approved);
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-isApprovedForAll}.
1230      */
1231     function isApprovedForAll(address owner, address operator)
1232         public
1233         view
1234         virtual
1235         override
1236         returns (bool)
1237     {
1238         return _operatorApprovals[owner][operator];
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-transferFrom}.
1243      */
1244     function transferFrom(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) public virtual override {
1249         //solhint-disable-next-line max-line-length
1250         require(
1251             _isApprovedOrOwner(_msgSender(), tokenId),
1252             "ERC721: transfer caller is not owner nor approved"
1253         );
1254 
1255         _transfer(from, to, tokenId);
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-safeTransferFrom}.
1260      */
1261     function safeTransferFrom(
1262         address from,
1263         address to,
1264         uint256 tokenId
1265     ) public virtual override {
1266         safeTransferFrom(from, to, tokenId, "");
1267     }
1268 
1269     /**
1270      * @dev See {IERC721-safeTransferFrom}.
1271      */
1272     function safeTransferFrom(
1273         address from,
1274         address to,
1275         uint256 tokenId,
1276         bytes memory _data
1277     ) public virtual override {
1278         require(
1279             _isApprovedOrOwner(_msgSender(), tokenId),
1280             "ERC721: transfer caller is not owner nor approved"
1281         );
1282         _safeTransfer(from, to, tokenId, _data);
1283     }
1284 
1285     /**
1286      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1287      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1288      *
1289      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1290      *
1291      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1292      * implement alternative mechanisms to perform token transfer, such as signature-based.
1293      *
1294      * Requirements:
1295      *
1296      * - `from` cannot be the zero address.
1297      * - `to` cannot be the zero address.
1298      * - `tokenId` token must exist and be owned by `from`.
1299      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function _safeTransfer(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory _data
1308     ) internal virtual {
1309         _transfer(from, to, tokenId);
1310         require(
1311             _checkOnERC721Received(from, to, tokenId, _data),
1312             "ERC721: transfer to non ERC721Receiver implementer"
1313         );
1314     }
1315 
1316     /**
1317      * @dev Returns whether `tokenId` exists.
1318      *
1319      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1320      *
1321      * Tokens start existing when they are minted (`_mint`),
1322      * and stop existing when they are burned (`_burn`).
1323      */
1324     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1325         return _owners[tokenId] != address(0);
1326     }
1327 
1328     /**
1329      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1330      *
1331      * Requirements:
1332      *
1333      * - `tokenId` must exist.
1334      */
1335     function _isApprovedOrOwner(address spender, uint256 tokenId)
1336         internal
1337         view
1338         virtual
1339         returns (bool)
1340     {
1341         require(
1342             _exists(tokenId),
1343             "ERC721: operator query for nonexistent token"
1344         );
1345         address owner = ERC721.ownerOf(tokenId);
1346         return (spender == owner ||
1347             getApproved(tokenId) == spender ||
1348             isApprovedForAll(owner, spender));
1349     }
1350 
1351     /**
1352      * @dev Safely mints `tokenId` and transfers it to `to`.
1353      *
1354      * Requirements:
1355      *
1356      * - `tokenId` must not exist.
1357      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _safeMint(address to, uint256 tokenId) internal virtual {
1362         _safeMint(to, tokenId, "");
1363     }
1364 
1365     /**
1366      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1367      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1368      */
1369     function _safeMint(
1370         address to,
1371         uint256 tokenId,
1372         bytes memory _data
1373     ) internal virtual {
1374         _mint(to, tokenId);
1375         require(
1376             _checkOnERC721Received(address(0), to, tokenId, _data),
1377             "ERC721: transfer to non ERC721Receiver implementer"
1378         );
1379     }
1380 
1381     /**
1382      * @dev Mints `tokenId` and transfers it to `to`.
1383      *
1384      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1385      *
1386      * Requirements:
1387      *
1388      * - `tokenId` must not exist.
1389      * - `to` cannot be the zero address.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function _mint(address to, uint256 tokenId) internal virtual {
1394         require(to != address(0), "ERC721: mint to the zero address");
1395         require(!_exists(tokenId), "ERC721: token already minted");
1396 
1397         _beforeTokenTransfer(address(0), to, tokenId);
1398 
1399         _balances[to] += 1;
1400         _owners[tokenId] = to;
1401 
1402         emit Transfer(address(0), to, tokenId);
1403     }
1404 
1405     /**
1406      * @dev Destroys `tokenId`.
1407      * The approval is cleared when the token is burned.
1408      *
1409      * Requirements:
1410      *
1411      * - `tokenId` must exist.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function _burn(uint256 tokenId) internal virtual {
1416         address owner = ERC721.ownerOf(tokenId);
1417 
1418         _beforeTokenTransfer(owner, address(0), tokenId);
1419 
1420         // Clear approvals
1421         _approve(address(0), tokenId);
1422 
1423         _balances[owner] -= 1;
1424         delete _owners[tokenId];
1425 
1426         emit Transfer(owner, address(0), tokenId);
1427     }
1428 
1429     /**
1430      * @dev Transfers `tokenId` from `from` to `to`.
1431      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1432      *
1433      * Requirements:
1434      *
1435      * - `to` cannot be the zero address.
1436      * - `tokenId` token must be owned by `from`.
1437      *
1438      * Emits a {Transfer} event.
1439      */
1440     function _transfer(
1441         address from,
1442         address to,
1443         uint256 tokenId
1444     ) internal virtual {
1445         require(
1446             ERC721.ownerOf(tokenId) == from,
1447             "ERC721: transfer of token that is not own"
1448         );
1449         require(to != address(0), "ERC721: transfer to the zero address");
1450 
1451         _beforeTokenTransfer(from, to, tokenId);
1452 
1453         // Clear approvals from the previous owner
1454         _approve(address(0), tokenId);
1455 
1456         _balances[from] -= 1;
1457         _balances[to] += 1;
1458         _owners[tokenId] = to;
1459 
1460         emit Transfer(from, to, tokenId);
1461     }
1462 
1463     /**
1464      * @dev Approve `to` to operate on `tokenId`
1465      *
1466      * Emits a {Approval} event.
1467      */
1468     function _approve(address to, uint256 tokenId) internal virtual {
1469         _tokenApprovals[tokenId] = to;
1470         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev Approve `operator` to operate on all of `owner` tokens
1475      *
1476      * Emits a {ApprovalForAll} event.
1477      */
1478     function _setApprovalForAll(
1479         address owner,
1480         address operator,
1481         bool approved
1482     ) internal virtual {
1483         require(owner != operator, "ERC721: approve to caller");
1484         _operatorApprovals[owner][operator] = approved;
1485         emit ApprovalForAll(owner, operator, approved);
1486     }
1487 
1488     /**
1489      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1490      * The call is not executed if the target address is not a contract.
1491      *
1492      * @param from address representing the previous owner of the given token ID
1493      * @param to target address that will receive the tokens
1494      * @param tokenId uint256 ID of the token to be transferred
1495      * @param _data bytes optional data to send along with the call
1496      * @return bool whether the call correctly returned the expected magic value
1497      */
1498     function _checkOnERC721Received(
1499         address from,
1500         address to,
1501         uint256 tokenId,
1502         bytes memory _data
1503     ) private returns (bool) {
1504         if (to.isContract()) {
1505             try
1506                 IERC721Receiver(to).onERC721Received(
1507                     _msgSender(),
1508                     from,
1509                     tokenId,
1510                     _data
1511                 )
1512             returns (bytes4 retval) {
1513                 return retval == IERC721Receiver.onERC721Received.selector;
1514             } catch (bytes memory reason) {
1515                 if (reason.length == 0) {
1516                     revert(
1517                         "ERC721: transfer to non ERC721Receiver implementer"
1518                     );
1519                 } else {
1520                     assembly {
1521                         revert(add(32, reason), mload(reason))
1522                     }
1523                 }
1524             }
1525         } else {
1526             return true;
1527         }
1528     }
1529 
1530     /**
1531      * @dev Hook that is called before any token transfer. This includes minting
1532      * and burning.
1533      *
1534      * Calling conditions:
1535      *
1536      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1537      * transferred to `to`.
1538      * - When `from` is zero, `tokenId` will be minted for `to`.
1539      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1540      * - `from` and `to` are never both zero.
1541      *
1542      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1543      */
1544     function _beforeTokenTransfer(
1545         address from,
1546         address to,
1547         uint256 tokenId
1548     ) internal virtual {}
1549 }
1550 
1551 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1552     // Mapping from owner to list of owned token IDs
1553     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1554 
1555     // Mapping from token ID to index of the owner tokens list
1556     mapping(uint256 => uint256) private _ownedTokensIndex;
1557 
1558     // Array with all token ids, used for enumeration
1559     uint256[] private _allTokens;
1560 
1561     // Mapping from token id to position in the allTokens array
1562     mapping(uint256 => uint256) private _allTokensIndex;
1563 
1564     /**
1565      * @dev See {IERC165-supportsInterface}.
1566      */
1567     function supportsInterface(bytes4 interfaceId)
1568         public
1569         view
1570         virtual
1571         override(IERC165, ERC721)
1572         returns (bool)
1573     {
1574         return
1575             interfaceId == type(IERC721Enumerable).interfaceId ||
1576             super.supportsInterface(interfaceId);
1577     }
1578 
1579     /**
1580      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1581      */
1582     function tokenOfOwnerByIndex(address owner, uint256 index)
1583         public
1584         view
1585         virtual
1586         override
1587         returns (uint256)
1588     {
1589         require(
1590             index < ERC721.balanceOf(owner),
1591             "ERC721Enumerable: owner index out of bounds"
1592         );
1593         return _ownedTokens[owner][index];
1594     }
1595 
1596     /**
1597      * @dev See {IERC721Enumerable-totalSupply}.
1598      */
1599     function totalSupply() public view virtual override returns (uint256) {
1600         return _allTokens.length;
1601     }
1602 
1603     /**
1604      * @dev See {IERC721Enumerable-tokenByIndex}.
1605      */
1606     function tokenByIndex(uint256 index)
1607         public
1608         view
1609         virtual
1610         override
1611         returns (uint256)
1612     {
1613         require(
1614             index < ERC721Enumerable.totalSupply(),
1615             "ERC721Enumerable: global index out of bounds"
1616         );
1617         return _allTokens[index];
1618     }
1619 
1620     /**
1621      * @dev Hook that is called before any token transfer. This includes minting
1622      * and burning.
1623      *
1624      * Calling conditions:
1625      *
1626      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1627      * transferred to `to`.
1628      * - When `from` is zero, `tokenId` will be minted for `to`.
1629      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1630      * - `from` cannot be the zero address.
1631      * - `to` cannot be the zero address.
1632      *
1633      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1634      */
1635     function _beforeTokenTransfer(
1636         address from,
1637         address to,
1638         uint256 tokenId
1639     ) internal virtual override {
1640         super._beforeTokenTransfer(from, to, tokenId);
1641 
1642         if (from == address(0)) {
1643             _addTokenToAllTokensEnumeration(tokenId);
1644         } else if (from != to) {
1645             _removeTokenFromOwnerEnumeration(from, tokenId);
1646         }
1647         if (to == address(0)) {
1648             _removeTokenFromAllTokensEnumeration(tokenId);
1649         } else if (to != from) {
1650             _addTokenToOwnerEnumeration(to, tokenId);
1651         }
1652     }
1653 
1654     /**
1655      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1656      * @param to address representing the new owner of the given token ID
1657      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1658      */
1659     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1660         uint256 length = ERC721.balanceOf(to);
1661         _ownedTokens[to][length] = tokenId;
1662         _ownedTokensIndex[tokenId] = length;
1663     }
1664 
1665     /**
1666      * @dev Private function to add a token to this extension's token tracking data structures.
1667      * @param tokenId uint256 ID of the token to be added to the tokens list
1668      */
1669     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1670         _allTokensIndex[tokenId] = _allTokens.length;
1671         _allTokens.push(tokenId);
1672     }
1673 
1674     /**
1675      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1676      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1677      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1678      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1679      * @param from address representing the previous owner of the given token ID
1680      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1681      */
1682     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1683         private
1684     {
1685         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1686         // then delete the last slot (swap and pop).
1687 
1688         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1689         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1690 
1691         // When the token to delete is the last token, the swap operation is unnecessary
1692         if (tokenIndex != lastTokenIndex) {
1693             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1694 
1695             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1696             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1697         }
1698 
1699         // This also deletes the contents at the last position of the array
1700         delete _ownedTokensIndex[tokenId];
1701         delete _ownedTokens[from][lastTokenIndex];
1702     }
1703 
1704     /**
1705      * @dev Private function to remove a token from this extension's token tracking data structures.
1706      * This has O(1) time complexity, but alters the order of the _allTokens array.
1707      * @param tokenId uint256 ID of the token to be removed from the tokens list
1708      */
1709     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1710         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1711         // then delete the last slot (swap and pop).
1712 
1713         uint256 lastTokenIndex = _allTokens.length - 1;
1714         uint256 tokenIndex = _allTokensIndex[tokenId];
1715 
1716         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1717         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1718         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1719         uint256 lastTokenId = _allTokens[lastTokenIndex];
1720 
1721         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1722         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1723 
1724         // This also deletes the contents at the last position of the array
1725         delete _allTokensIndex[tokenId];
1726         _allTokens.pop();
1727     }
1728 }
1729 
1730 interface Token is IERC20 {
1731     function burn(address account, uint256 amount) external returns (bool);
1732 }
1733 
1734 contract Collection is ERC721Enumerable, Ownable {
1735     using Strings for uint256;
1736 
1737     uint256 public constant TOTAL_LIMIT = 8888;
1738     uint256 public constant BATCH_LIMIT = 8;
1739 
1740     bool private constant RESERVED = true;
1741     bool private constant FREE = false;
1742 
1743     bool public utilityEnabled;
1744 
1745     uint256 public tokenNameChangePrice;
1746     uint256 public tokenBiogChangePrice;
1747     uint256 public tokenClanChangePrice;
1748 
1749     uint256 public price = 0.06 ether; //60000000000000000 Wei, You are welcome :)
1750     uint256 public reserved = 100;
1751 
1752     bool public activated;
1753     uint256 public activatedAt;
1754 
1755     string[4] public clans;
1756     uint8[] private availableClans;
1757 
1758     mapping(uint8 => uint256) public clanMemberCount;
1759 
1760     mapping(uint256 => string) private _tokenName;
1761     mapping(uint256 => string) private _tokenBiog;
1762     mapping(uint256 => uint8) private _tokenClanId;
1763 
1764     mapping(string => bool) private _tokenNameReserved;
1765 
1766     mapping(uint256 => bool) private _genesisMints;
1767     uint256 private _genesisMintsTotal;
1768 
1769     //contract address, total supply, and headstart for genesis only ape collection
1770     address private constant _GENESIS_APE_ONLY_CA =
1771         0xf1e0bEcA4eac65F902466881CDfDD0099D91e47b;
1772     uint256 private constant _GENESIS_APE_ONLY_TS = 999;
1773     uint256 private constant _GENESIS_APE_ONLY_PP = 86400;
1774 
1775     //contract address of the ape only island yield token
1776     address public tokenAddress;
1777 
1778     event Activated(address indexed account, uint256 timestamp);
1779 
1780     event Changed(address indexed account, uint256 id);
1781 
1782     constructor() ERC721("ApeOnly Island", "Island Apes") {
1783         _setBaseURI("https://metadata.apeonlyisland.com/");
1784 
1785         tokenNameChangePrice = 150 ether;
1786         tokenBiogChangePrice = 50 ether;
1787         tokenClanChangePrice = 300 ether;
1788 
1789         clans[0] = "coconut bashers";
1790         clans[1] = "wave riders";
1791         clans[2] = "banana rippers";
1792         clans[3] = "seashell drifters";
1793 
1794         availableClans.push(0);
1795         availableClans.push(1);
1796         availableClans.push(2);
1797         availableClans.push(3);
1798     }
1799 
1800     function setUtilityStatus(bool newStatus)
1801         external
1802         onlyOwner
1803         returns (bool isUtilityEnabled)
1804     {
1805         utilityEnabled = newStatus;
1806         return utilityEnabled;
1807     }
1808 
1809     function setTokenNameChangePrice(uint256 newPrice)
1810         external
1811         onlyOwner
1812         returns (bool)
1813     {
1814         tokenNameChangePrice = newPrice;
1815         return true;
1816     }
1817 
1818     function setTokenBiogChangePrice(uint256 newPrice)
1819         external
1820         onlyOwner
1821         returns (bool)
1822     {
1823         tokenBiogChangePrice = newPrice;
1824         return true;
1825     }
1826 
1827     function setTokenClanChangePrice(uint256 newPrice)
1828         external
1829         onlyOwner
1830         returns (bool)
1831     {
1832         tokenClanChangePrice = newPrice;
1833         return true;
1834     }
1835 
1836     function setTokenAddress(address tokenAddressArg)
1837         external
1838         onlyOwner
1839         returns (bool)
1840     {
1841         tokenAddress = tokenAddressArg;
1842         return true;
1843     }
1844 
1845     function setPrice(uint256 amount) external onlyOwner returns (bool) {
1846         require(amount > 0, "Collection: must be a valid amount");
1847 
1848         price = amount;
1849         return true;
1850     }
1851 
1852     function setReserve(uint16 amount) external onlyOwner returns (bool) {
1853         require(amount <= 100, "Collection: must be a valid amount");
1854         reserved = amount;
1855         return true;
1856     }
1857 
1858     function setBaseURI(string memory newURI)
1859         external
1860         onlyOwner
1861         returns (bool)
1862     {
1863         _setBaseURI(newURI);
1864         return true;
1865     }
1866 
1867     function activate() external onlyOwner returns (bool) {
1868         require(!activated, "Collection: minting must be activated");
1869 
1870         activatedAt = block.timestamp;
1871         activated = true;
1872 
1873         emit Activated(_msgSender(), block.timestamp);
1874         return true;
1875     }
1876 
1877     function airdrop(address account, uint256 amount)
1878         external
1879         onlyOwner
1880         returns (bool)
1881     {
1882         require(amount > 0, "Collection: must be a valid amount");
1883 
1884         uint256 current = totalSupply();
1885 
1886         require(
1887             current + amount <= TOTAL_LIMIT,
1888             "Collection: supply must be available for minting"
1889         );
1890 
1891         for (uint256 i = 1; i <= amount; i++) {
1892             uint256 next = current + i;
1893             if (next <= TOTAL_LIMIT) {
1894                 _mintApe(account, next);
1895             }
1896         }
1897         return true;
1898     }
1899 
1900     function withdraw() external onlyOwner returns (bool) {
1901         uint256 balance = address(this).balance;
1902 
1903         require(balance > 0, "Collection: no withdrawable funds found");
1904 
1905         payable(_msgSender()).transfer(balance);
1906 
1907         return true;
1908     }
1909 
1910     function priorityMint(uint256[] calldata ids) external returns (bool) {
1911         require(activated, "Collection: minting must be activated");
1912 
1913         require(
1914             block.timestamp < activatedAt + _GENESIS_APE_ONLY_PP,
1915             "Collection: public minting have started"
1916         );
1917 
1918         uint256 counter = ids.length;
1919         address account = _msgSender();
1920 
1921         require(
1922             counter <= BATCH_LIMIT,
1923             "Collection: minted amount must not exceed batch limit"
1924         );
1925 
1926         uint256 next = totalSupply() + 1;
1927 
1928         for (uint256 i = 0; i < counter; i++) {
1929             require(
1930                 !_genesisMints[ids[i]],
1931                 "Collection: genesis ape <ID> free mint have been claimed"
1932             );
1933 
1934             require(
1935                 IERC721(_GENESIS_APE_ONLY_CA).ownerOf(ids[i]) == account,
1936                 "Collection: account must be the owner of the genesis ape <ID>"
1937             );
1938 
1939             if (next <= _GENESIS_APE_ONLY_TS) {
1940                 _genesisMints[ids[i]] = true;
1941                 _mintApe(account, next);
1942                 next++;
1943                 _genesisMintsTotal++;
1944             }
1945         }
1946 
1947         return true;
1948     }
1949 
1950     function publicMint(uint256 amount) external payable returns (bool) {
1951         require(activated, "Collection: minting must be activated");
1952 
1953         require(
1954             block.timestamp >= activatedAt + _GENESIS_APE_ONLY_PP,
1955             "Collection: public minting not started"
1956         );
1957 
1958         require(
1959             amount <= BATCH_LIMIT,
1960             "Collection: minted amount must not exceed batch limit"
1961         );
1962 
1963         uint256 current = totalSupply();
1964 
1965         require(
1966             current + amount <= TOTAL_LIMIT,
1967             "Collection: supply must be available for minting"
1968         );
1969 
1970         require(
1971             current + amount <= (TOTAL_LIMIT - reserved),
1972             "Collection: supply reached reserved tokens"
1973         );
1974 
1975         require(
1976             price * amount == msg.value,
1977             "Collection: account must pay the correct mint price"
1978         );
1979 
1980         for (uint256 i = 1; i <= amount; i++) {
1981             uint256 next = current + i;
1982 
1983             if (next <= TOTAL_LIMIT) {
1984                 _mintApe(_msgSender(), next);
1985             }
1986         }
1987 
1988         return true;
1989     }
1990 
1991     function changeTokenName(string calldata newName, uint256 tokenId)
1992         external
1993         returns (bool)
1994     {
1995         require(utilityEnabled, "Collection: Shilling not enabled");
1996 
1997         address account = _msgSender();
1998 
1999         require(
2000             ownerOf(tokenId) == account,
2001             "Collection: account must be owner of token"
2002         );
2003 
2004         require(_validateName(newName), "Collection: name must be valid");
2005 
2006         // name is not already reserved and not the same current one
2007         require(isUniqueName(newName), "Collection: name must be unique");
2008 
2009         require(
2010             Token(tokenAddress).balanceOf(account) >= tokenNameChangePrice,
2011             "Collection: account must have sufficient tokens"
2012         );
2013 
2014         //free old name before renaming token
2015         if (bytes(_tokenName[tokenId]).length > 0) {
2016             _changeNameReserveStatus(_tokenName[tokenId], FREE);
2017         }
2018 
2019         Token(tokenAddress).burn(account, tokenNameChangePrice);
2020 
2021         _tokenName[tokenId] = newName;
2022         _changeNameReserveStatus(newName, RESERVED);
2023 
2024         emit Changed(account, tokenId);
2025         return true;
2026     }
2027 
2028     function changeTokenBiog(string calldata newBio, uint256 tokenId)
2029         external
2030         returns (bool)
2031     {
2032         require(utilityEnabled, "Collection: Shilling not enabled");
2033 
2034         address account = _msgSender();
2035 
2036         require(
2037             ownerOf(tokenId) == account,
2038             "Collection: account must be owner of token"
2039         );
2040         require(
2041             Token(tokenAddress).balanceOf(account) >= tokenBiogChangePrice,
2042             "Collection: account must have sufficient tokens"
2043         );
2044 
2045         Token(tokenAddress).burn(account, tokenBiogChangePrice);
2046         _tokenBiog[tokenId] = newBio;
2047 
2048         emit Changed(account, tokenId);
2049         return true;
2050     }
2051 
2052     function changeTokenClan(uint8 clanId, uint256 tokenId)
2053         external
2054         returns (bool)
2055     {
2056         require(utilityEnabled, "Collection: Shilling not enabled");
2057 
2058         address account = _msgSender();
2059 
2060         require(
2061             ownerOf(tokenId) == account,
2062             "Collection: account must be owner of token"
2063         );
2064         require(
2065             Token(tokenAddress).balanceOf(account) >= tokenClanChangePrice,
2066             "XX"
2067         );
2068 
2069         require(clanId < 4, "Collection: invalid clan index [0-3]");
2070 
2071         // reduce previous clan total member count
2072         clanMemberCount[_tokenClanId[tokenId]]--;
2073 
2074         Token(tokenAddress).burn(account, tokenClanChangePrice);
2075         _tokenClanId[tokenId] = clanId;
2076 
2077         // increase new clan total member count
2078         clanMemberCount[clanId]++;
2079 
2080         emit Changed(account, tokenId);
2081         return true;
2082     }
2083 
2084     function getGenesisMintedID(uint256 id) external view returns (bool) {
2085         //return valid genesis free mint
2086         return _genesisMints[id];
2087     }
2088 
2089     function getGenesisMintedTotal() external view returns (uint256) {
2090         //return valid genesis collection supply
2091         return _genesisMintsTotal;
2092     }
2093 
2094     function getTokenNameByIndex(uint256 index)
2095         external
2096         view
2097         returns (string memory)
2098     {
2099         //return valid token name by index
2100         return _tokenName[index];
2101     }
2102 
2103     function isPublicSaleActivated() external view returns (bool) {
2104         return
2105             activated && block.timestamp >= activatedAt + _GENESIS_APE_ONLY_PP;
2106     }
2107 
2108     function isUniqueName(string memory str) public view returns (bool) {
2109         //return valid name
2110         return !_tokenNameReserved[_toLower(str)];
2111     }
2112 
2113     function getTokenName(uint256 id) public view returns (string memory) {
2114         //return token name
2115         string memory tokenName = _tokenName[id];
2116         if (bytes(tokenName).length > 0) {
2117             return tokenName;
2118         }
2119         return string(abi.encodePacked("island ape #", id.toString()));
2120     }
2121 
2122     function getTokenBiography(uint256 id) public view returns (string memory) {
2123         //return token biography
2124         return _tokenBiog[id];
2125     }
2126 
2127     function getTokenClan(uint256 id) public view returns (string memory) {
2128         //return token clan
2129         return clans[getTokenClanId(id)];
2130     }
2131 
2132     function getTokenClanId(uint256 id) public view returns (uint8) {
2133         //return token clan id
2134         return _tokenClanId[id];
2135     }
2136 
2137     function tokenURI(uint256 tokenId)
2138         public
2139         view
2140         override
2141         returns (string memory)
2142     {
2143         require(
2144             _exists(tokenId),
2145             "Collection: URI query for nonexistent token"
2146         );
2147 
2148         string memory baseURI = _baseURI();
2149         uint256 clanId = getTokenClanId(tokenId);
2150         return
2151             string(
2152                 abi.encodePacked(
2153                     baseURI,
2154                     tokenId.toString(),
2155                     "?c=",
2156                     clanId.toString()
2157                 )
2158             );
2159     }
2160 
2161     function _mintApe(address to, uint256 tokenId) private {
2162         _mint(to, tokenId);
2163         _onMintAddTokenToRandomClan(tokenId);
2164     }
2165 
2166     /**
2167      * @dev This Hook will randomly add a token to a clan by linking the Token with clanId using `_tokenClanId`
2168      * Requirements:
2169      *  - Max clan members is 2222 during mint and user cant change clan only after mint is closed.
2170      */
2171     function _onMintAddTokenToRandomClan(uint256 tokenId)
2172         private
2173         returns (bool)
2174     {
2175         uint256 _random = _generateRandom(tokenId);
2176 
2177         uint256 availableClansCount = availableClans.length;
2178         uint256 availableClanIndex = _random % availableClansCount;
2179 
2180         uint8 _clanId = availableClans[availableClanIndex];
2181         _tokenClanId[tokenId] = _clanId;
2182         clanMemberCount[_clanId]++;
2183 
2184         if (clanMemberCount[_clanId] == 2222) {
2185             // swap the clan reached maximum count with the last element;
2186             availableClans[availableClanIndex] = availableClans[
2187                 availableClansCount - 1
2188             ];
2189             // delete the last element which will be the swapped element;
2190             availableClans.pop();
2191         }
2192         return true;
2193     }
2194 
2195     function _generateRandom(uint256 tokenId) private view returns (uint256) {
2196         return
2197             uint256(
2198                 keccak256(
2199                     abi.encodePacked(
2200                         tokenId,
2201                         _msgSender(),
2202                         block.timestamp,
2203                         block.difficulty,
2204                         gasleft()
2205                     )
2206                 )
2207             );
2208     }
2209 
2210     function _changeNameReserveStatus(string memory str, bool state) private {
2211         _tokenNameReserved[_toLower(str)] = state;
2212     }
2213 
2214     function _validateName(string memory str) private pure returns (bool) {
2215         bytes memory b = bytes(str);
2216 
2217         if (b.length < 1) return false;
2218         if (b.length > 25) return false; //must be shorter than 25 characters
2219         if (b[0] == 0x20) return false; //no leading space
2220         if (b[b.length - 1] == 0x20) return false; //no trailing space
2221 
2222         bytes1 lastChar = b[0];
2223 
2224         for (uint256 i; i < b.length; i++) {
2225             bytes1 char = b[i];
2226 
2227             //no continous spaces
2228             if (char == 0x20 && lastChar == 0x20) return false;
2229 
2230             if (
2231                 !(char >= 0x30 && char <= 0x39) && //9-0
2232                 !(char >= 0x41 && char <= 0x5A) && //A-Z
2233                 !(char >= 0x61 && char <= 0x7A) && //a-z
2234                 !(char == 0x20) //space
2235             ) return false;
2236 
2237             lastChar = char;
2238         }
2239         //return valid name
2240         return true;
2241     }
2242 
2243     function _toLower(string memory str) private pure returns (string memory) {
2244         bytes memory bStr = bytes(str);
2245         bytes memory bLower = new bytes(bStr.length);
2246 
2247         for (uint256 i = 0; i < bStr.length; i++) {
2248             //no uppercase characters
2249             if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
2250                 bLower[i] = bytes1(uint8(bStr[i]) + 32);
2251             } else {
2252                 bLower[i] = bStr[i];
2253             }
2254         }
2255         //return all lowercase
2256         return string(bLower);
2257     }
2258 }