1 // File: WAItokenclaim.sol
2 
3 pragma solidity >=0.8.0;
4 
5 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
6 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
7 abstract contract ERC721 {
8     /*//////////////////////////////////////////////////////////////
9                                  EVENTS
10     //////////////////////////////////////////////////////////////*/
11 
12     event Transfer(address indexed from, address indexed to, uint256 indexed id);
13 
14     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
15 
16     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
17 
18     /*//////////////////////////////////////////////////////////////
19                          METADATA STORAGE/LOGIC
20     //////////////////////////////////////////////////////////////*/
21 
22     string public name;
23 
24     string public symbol;
25 
26     function tokenURI(uint256 id) public view virtual returns (string memory);
27 
28     /*//////////////////////////////////////////////////////////////
29                       ERC721 BALANCE/OWNER STORAGE
30     //////////////////////////////////////////////////////////////*/
31 
32     mapping(uint256 => address) internal _ownerOf;
33 
34     mapping(address => uint256) internal _balanceOf;
35 
36     function ownerOf(uint256 id) public view virtual returns (address owner) {
37         require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
38     }
39 
40     function balanceOf(address owner) public view virtual returns (uint256) {
41         require(owner != address(0), "ZERO_ADDRESS");
42 
43         return _balanceOf[owner];
44     }
45 
46     /*//////////////////////////////////////////////////////////////
47                          ERC721 APPROVAL STORAGE
48     //////////////////////////////////////////////////////////////*/
49 
50     mapping(uint256 => address) public getApproved;
51 
52     mapping(address => mapping(address => bool)) public isApprovedForAll;
53 
54     /*//////////////////////////////////////////////////////////////
55                                CONSTRUCTOR
56     //////////////////////////////////////////////////////////////*/
57 
58     constructor(string memory _name, string memory _symbol) {
59         name = _name;
60         symbol = _symbol;
61     }
62 
63     /*//////////////////////////////////////////////////////////////
64                               ERC721 LOGIC
65     //////////////////////////////////////////////////////////////*/
66 
67     function approve(address spender, uint256 id) public virtual {
68         address owner = _ownerOf[id];
69 
70         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
71 
72         getApproved[id] = spender;
73 
74         emit Approval(owner, spender, id);
75     }
76 
77     function setApprovalForAll(address operator, bool approved) public virtual {
78         isApprovedForAll[msg.sender][operator] = approved;
79 
80         emit ApprovalForAll(msg.sender, operator, approved);
81     }
82 
83     function transferFrom(
84         address from,
85         address to,
86         uint256 id
87     ) public virtual {
88         require(from == _ownerOf[id], "WRONG_FROM");
89 
90         require(to != address(0), "INVALID_RECIPIENT");
91 
92         require(
93             msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id],
94             "NOT_AUTHORIZED"
95         );
96 
97         // Underflow of the sender's balance is impossible because we check for
98         // ownership above and the recipient's balance can't realistically overflow.
99         unchecked {
100             _balanceOf[from]--;
101 
102             _balanceOf[to]++;
103         }
104 
105         _ownerOf[id] = to;
106 
107         delete getApproved[id];
108 
109         emit Transfer(from, to, id);
110     }
111 
112     function safeTransferFrom(
113         address from,
114         address to,
115         uint256 id
116     ) public virtual {
117         transferFrom(from, to, id);
118 
119         require(
120             to.code.length == 0 ||
121                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
122                 ERC721TokenReceiver.onERC721Received.selector,
123             "UNSAFE_RECIPIENT"
124         );
125     }
126 
127     function safeTransferFrom(
128         address from,
129         address to,
130         uint256 id,
131         bytes calldata data
132     ) public virtual {
133         transferFrom(from, to, id);
134 
135         require(
136             to.code.length == 0 ||
137                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
138                 ERC721TokenReceiver.onERC721Received.selector,
139             "UNSAFE_RECIPIENT"
140         );
141     }
142 
143     /*//////////////////////////////////////////////////////////////
144                               ERC165 LOGIC
145     //////////////////////////////////////////////////////////////*/
146 
147     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
148         return
149             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
150             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
151             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
152     }
153 
154     /*//////////////////////////////////////////////////////////////
155                         INTERNAL MINT/BURN LOGIC
156     //////////////////////////////////////////////////////////////*/
157 
158     function _mint(address to, uint256 id) internal virtual {
159         require(to != address(0), "INVALID_RECIPIENT");
160 
161         require(_ownerOf[id] == address(0), "ALREADY_MINTED");
162 
163         // Counter overflow is incredibly unrealistic.
164         unchecked {
165             _balanceOf[to]++;
166         }
167 
168         _ownerOf[id] = to;
169 
170         emit Transfer(address(0), to, id);
171     }
172 
173     function _burn(uint256 id) internal virtual {
174         address owner = _ownerOf[id];
175 
176         require(owner != address(0), "NOT_MINTED");
177 
178         // Ownership check above ensures no underflow.
179         unchecked {
180             _balanceOf[owner]--;
181         }
182 
183         delete _ownerOf[id];
184 
185         delete getApproved[id];
186 
187         emit Transfer(owner, address(0), id);
188     }
189 
190     /*//////////////////////////////////////////////////////////////
191                         INTERNAL SAFE MINT LOGIC
192     //////////////////////////////////////////////////////////////*/
193 
194     function _safeMint(address to, uint256 id) internal virtual {
195         _mint(to, id);
196 
197         require(
198             to.code.length == 0 ||
199                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
200                 ERC721TokenReceiver.onERC721Received.selector,
201             "UNSAFE_RECIPIENT"
202         );
203     }
204 
205     function _safeMint(
206         address to,
207         uint256 id,
208         bytes memory data
209     ) internal virtual {
210         _mint(to, id);
211 
212         require(
213             to.code.length == 0 ||
214                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
215                 ERC721TokenReceiver.onERC721Received.selector,
216             "UNSAFE_RECIPIENT"
217         );
218     }
219 }
220 
221 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
222 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
223 abstract contract ERC721TokenReceiver {
224     function onERC721Received(
225         address,
226         address,
227         uint256,
228         bytes calldata
229     ) external virtual returns (bytes4) {
230         return ERC721TokenReceiver.onERC721Received.selector;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Address.sol
235 
236 
237 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
238 
239 pragma solidity ^0.8.1;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      *
262      * [IMPORTANT]
263      * ====
264      * You shouldn't rely on `isContract` to protect against flash loan attacks!
265      *
266      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
267      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
268      * constructor.
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize/address.code.length, which returns 0
273         // for contracts in construction, since the code is only stored at the end
274         // of the constructor execution.
275 
276         return account.code.length > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain `call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.call{value: value}(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
383         return functionStaticCall(target, data, "Address: low-level static call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal view returns (bytes memory) {
397         require(isContract(target), "Address: static call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.staticcall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(isContract(target), "Address: delegate call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
460 
461 
462 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @dev Interface of the ERC20 standard as defined in the EIP.
468  */
469 interface IERC20 {
470     /**
471      * @dev Emitted when `value` tokens are moved from one account (`from`) to
472      * another (`to`).
473      *
474      * Note that `value` may be zero.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 value);
477 
478     /**
479      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
480      * a call to {approve}. `value` is the new allowance.
481      */
482     event Approval(address indexed owner, address indexed spender, uint256 value);
483 
484     /**
485      * @dev Returns the amount of tokens in existence.
486      */
487     function totalSupply() external view returns (uint256);
488 
489     /**
490      * @dev Returns the amount of tokens owned by `account`.
491      */
492     function balanceOf(address account) external view returns (uint256);
493 
494     /**
495      * @dev Moves `amount` tokens from the caller's account to `to`.
496      *
497      * Returns a boolean value indicating whether the operation succeeded.
498      *
499      * Emits a {Transfer} event.
500      */
501     function transfer(address to, uint256 amount) external returns (bool);
502 
503     /**
504      * @dev Returns the remaining number of tokens that `spender` will be
505      * allowed to spend on behalf of `owner` through {transferFrom}. This is
506      * zero by default.
507      *
508      * This value changes when {approve} or {transferFrom} are called.
509      */
510     function allowance(address owner, address spender) external view returns (uint256);
511 
512     /**
513      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
514      *
515      * Returns a boolean value indicating whether the operation succeeded.
516      *
517      * IMPORTANT: Beware that changing an allowance with this method brings the risk
518      * that someone may use both the old and the new allowance by unfortunate
519      * transaction ordering. One possible solution to mitigate this race
520      * condition is to first reduce the spender's allowance to 0 and set the
521      * desired value afterwards:
522      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
523      *
524      * Emits an {Approval} event.
525      */
526     function approve(address spender, uint256 amount) external returns (bool);
527 
528     /**
529      * @dev Moves `amount` tokens from `from` to `to` using the
530      * allowance mechanism. `amount` is then deducted from the caller's
531      * allowance.
532      *
533      * Returns a boolean value indicating whether the operation succeeded.
534      *
535      * Emits a {Transfer} event.
536      */
537     function transferFrom(
538         address from,
539         address to,
540         uint256 amount
541     ) external returns (bool);
542 }
543 
544 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 
552 
553 /**
554  * @title SafeERC20
555  * @dev Wrappers around ERC20 operations that throw on failure (when the token
556  * contract returns false). Tokens that return no value (and instead revert or
557  * throw on failure) are also supported, non-reverting calls are assumed to be
558  * successful.
559  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
560  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
561  */
562 library SafeERC20 {
563     using Address for address;
564 
565     function safeTransfer(
566         IERC20 token,
567         address to,
568         uint256 value
569     ) internal {
570         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
571     }
572 
573     function safeTransferFrom(
574         IERC20 token,
575         address from,
576         address to,
577         uint256 value
578     ) internal {
579         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
580     }
581 
582     /**
583      * @dev Deprecated. This function has issues similar to the ones found in
584      * {IERC20-approve}, and its usage is discouraged.
585      *
586      * Whenever possible, use {safeIncreaseAllowance} and
587      * {safeDecreaseAllowance} instead.
588      */
589     function safeApprove(
590         IERC20 token,
591         address spender,
592         uint256 value
593     ) internal {
594         // safeApprove should only be called when setting an initial allowance,
595         // or when resetting it to zero. To increase and decrease it, use
596         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
597         require(
598             (value == 0) || (token.allowance(address(this), spender) == 0),
599             "SafeERC20: approve from non-zero to non-zero allowance"
600         );
601         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
602     }
603 
604     function safeIncreaseAllowance(
605         IERC20 token,
606         address spender,
607         uint256 value
608     ) internal {
609         uint256 newAllowance = token.allowance(address(this), spender) + value;
610         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
611     }
612 
613     function safeDecreaseAllowance(
614         IERC20 token,
615         address spender,
616         uint256 value
617     ) internal {
618         unchecked {
619             uint256 oldAllowance = token.allowance(address(this), spender);
620             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
621             uint256 newAllowance = oldAllowance - value;
622             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
623         }
624     }
625 
626     /**
627      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
628      * on the return value: the return value is optional (but if data is returned, it must not be false).
629      * @param token The token targeted by the call.
630      * @param data The call data (encoded using abi.encode or one of its variants).
631      */
632     function _callOptionalReturn(IERC20 token, bytes memory data) private {
633         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
634         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
635         // the target address contains contract code and also asserts for success in the low-level call.
636 
637         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
638         if (returndata.length > 0) {
639             // Return data is optional
640             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
641         }
642     }
643 }
644 
645 // File: transfer.sol
646 
647 pragma solidity ^0.8.7;
648 
649 
650 
651 
652 contract WAItokenclaim  {
653     ERC721 internal immutable nft;
654     address public owner;
655     uint256 public balance;
656     //uint256 public amount = 1000000000000000000;
657     
658     uint256 public maxSupply = 7000;
659     uint256 public standardAmount = 5555000000000000000000;
660     uint256 public deluxeAmount = 8333000000000000000000;
661     uint256 public villaAmount = 11111000000000000000000;
662     uint256 public executiveAmount = 22222000000000000000000;
663 
664     event TransferReceived(address _from, uint _amount);
665     event TransferSent(address _from, address _destAddr, uint _amount);
666     event Claimed(uint256 indexed tokenId, address indexed claimer);
667 
668     mapping(uint256 => bool) public hasClaimed;
669     error NotOwner();
670     error AlreadyRedeemed();
671 
672 
673     constructor(ERC721 _nft) {
674         owner = msg.sender;
675         nft = _nft;
676     }
677     
678     receive() payable external {
679         balance += msg.value;
680         emit TransferReceived(msg.sender, msg.value);
681     }    
682 
683     function updateAmount(uint256 _supply) internal view returns (uint256 _cost) {
684         if(_supply <= 3780) {
685             return standardAmount;
686         }
687         if(_supply <= 6160) {
688             return deluxeAmount;
689         }
690         if(_supply <= 6860) {
691             return villaAmount;
692         }
693         if(_supply <= maxSupply) {
694             return executiveAmount;
695         }
696     }
697 
698     function withdraw(IERC20 token, uint256 withrawamount) public {
699         require(msg.sender == owner, "Only owner can withdraw funds"); 
700         uint256 erc20balance = token.balanceOf(address(this));
701         require(withrawamount <= erc20balance, "balance is low");
702         token.transfer(msg.sender, withrawamount);
703         erc20balance -= withrawamount;
704         emit TransferSent(msg.sender, msg.sender, withrawamount);
705     }
706     function ercbalance(IERC20 token) public view returns (uint cbalance) {
707         return token.balanceOf(address(this));
708     }
709     
710     function isclaimed (uint256 tokenId) public view returns (bool claimednft) {
711         if (hasClaimed[tokenId]) 
712         {
713             return true;
714         }
715         else{
716             return false;
717         }
718     }
719     function isClaimedArray (uint[] memory _nftlist) public view returns (uint[] memory _unclaimed) {
720         for (uint256 i = 0; i < _nftlist.length; i++) {
721             if (hasClaimed[_nftlist[i]]){
722                 //unclaimedlist.push(_nftlist[i]);
723                 delete _nftlist[i];
724             } 
725         }
726         return _nftlist;
727     }
728 
729     function transferERC20(IERC20 token,uint256 tokenId) public {
730         if (nft.ownerOf(tokenId) != msg.sender) revert NotOwner();
731         if (hasClaimed[tokenId]) revert AlreadyRedeemed();
732         uint256 erc20balance = token.balanceOf(address(this));
733         require(updateAmount(tokenId) <= erc20balance, "balance is low");
734         hasClaimed[tokenId] = true;
735         token.transfer(msg.sender, updateAmount(tokenId));
736         emit TransferSent(msg.sender, msg.sender, updateAmount(tokenId));
737     }    
738 }