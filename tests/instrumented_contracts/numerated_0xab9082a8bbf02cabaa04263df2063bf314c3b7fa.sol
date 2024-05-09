1 // File: latestclaim.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-05-20
5 */
6 
7 // File: WAItokenclaim.sol
8 
9 pragma solidity >=0.8.0;
10 
11 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
12 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
13 abstract contract ERC721 {
14     /*//////////////////////////////////////////////////////////////
15                                  EVENTS
16     //////////////////////////////////////////////////////////////*/
17 
18     event Transfer(address indexed from, address indexed to, uint256 indexed id);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
21 
22     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
23 
24     /*//////////////////////////////////////////////////////////////
25                          METADATA STORAGE/LOGIC
26     //////////////////////////////////////////////////////////////*/
27 
28     string public name;
29 
30     string public symbol;
31 
32     function tokenURI(uint256 id) public view virtual returns (string memory);
33 
34     /*//////////////////////////////////////////////////////////////
35                       ERC721 BALANCE/OWNER STORAGE
36     //////////////////////////////////////////////////////////////*/
37 
38     mapping(uint256 => address) internal _ownerOf;
39 
40     mapping(address => uint256) internal _balanceOf;
41 
42     function ownerOf(uint256 id) public view virtual returns (address owner) {
43         require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
44     }
45 
46     function balanceOf(address owner) public view virtual returns (uint256) {
47         require(owner != address(0), "ZERO_ADDRESS");
48 
49         return _balanceOf[owner];
50     }
51 
52     /*//////////////////////////////////////////////////////////////
53                          ERC721 APPROVAL STORAGE
54     //////////////////////////////////////////////////////////////*/
55 
56     mapping(uint256 => address) public getApproved;
57 
58     mapping(address => mapping(address => bool)) public isApprovedForAll;
59 
60     /*//////////////////////////////////////////////////////////////
61                                CONSTRUCTOR
62     //////////////////////////////////////////////////////////////*/
63 
64     constructor(string memory _name, string memory _symbol) {
65         name = _name;
66         symbol = _symbol;
67     }
68 
69     /*//////////////////////////////////////////////////////////////
70                               ERC721 LOGIC
71     //////////////////////////////////////////////////////////////*/
72 
73     function approve(address spender, uint256 id) public virtual {
74         address owner = _ownerOf[id];
75 
76         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
77 
78         getApproved[id] = spender;
79 
80         emit Approval(owner, spender, id);
81     }
82 
83     function setApprovalForAll(address operator, bool approved) public virtual {
84         isApprovedForAll[msg.sender][operator] = approved;
85 
86         emit ApprovalForAll(msg.sender, operator, approved);
87     }
88 
89     function transferFrom(
90         address from,
91         address to,
92         uint256 id
93     ) public virtual {
94         require(from == _ownerOf[id], "WRONG_FROM");
95 
96         require(to != address(0), "INVALID_RECIPIENT");
97 
98         require(
99             msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id],
100             "NOT_AUTHORIZED"
101         );
102 
103         // Underflow of the sender's balance is impossible because we check for
104         // ownership above and the recipient's balance can't realistically overflow.
105         unchecked {
106             _balanceOf[from]--;
107 
108             _balanceOf[to]++;
109         }
110 
111         _ownerOf[id] = to;
112 
113         delete getApproved[id];
114 
115         emit Transfer(from, to, id);
116     }
117 
118     function safeTransferFrom(
119         address from,
120         address to,
121         uint256 id
122     ) public virtual {
123         transferFrom(from, to, id);
124 
125         require(
126             to.code.length == 0 ||
127                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
128                 ERC721TokenReceiver.onERC721Received.selector,
129             "UNSAFE_RECIPIENT"
130         );
131     }
132 
133     function safeTransferFrom(
134         address from,
135         address to,
136         uint256 id,
137         bytes calldata data
138     ) public virtual {
139         transferFrom(from, to, id);
140 
141         require(
142             to.code.length == 0 ||
143                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
144                 ERC721TokenReceiver.onERC721Received.selector,
145             "UNSAFE_RECIPIENT"
146         );
147     }
148 
149     /*//////////////////////////////////////////////////////////////
150                               ERC165 LOGIC
151     //////////////////////////////////////////////////////////////*/
152 
153     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
154         return
155             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
156             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
157             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
158     }
159 
160     /*//////////////////////////////////////////////////////////////
161                         INTERNAL MINT/BURN LOGIC
162     //////////////////////////////////////////////////////////////*/
163 
164     function _mint(address to, uint256 id) internal virtual {
165         require(to != address(0), "INVALID_RECIPIENT");
166 
167         require(_ownerOf[id] == address(0), "ALREADY_MINTED");
168 
169         // Counter overflow is incredibly unrealistic.
170         unchecked {
171             _balanceOf[to]++;
172         }
173 
174         _ownerOf[id] = to;
175 
176         emit Transfer(address(0), to, id);
177     }
178 
179     function _burn(uint256 id) internal virtual {
180         address owner = _ownerOf[id];
181 
182         require(owner != address(0), "NOT_MINTED");
183 
184         // Ownership check above ensures no underflow.
185         unchecked {
186             _balanceOf[owner]--;
187         }
188 
189         delete _ownerOf[id];
190 
191         delete getApproved[id];
192 
193         emit Transfer(owner, address(0), id);
194     }
195 
196     /*//////////////////////////////////////////////////////////////
197                         INTERNAL SAFE MINT LOGIC
198     //////////////////////////////////////////////////////////////*/
199 
200     function _safeMint(address to, uint256 id) internal virtual {
201         _mint(to, id);
202 
203         require(
204             to.code.length == 0 ||
205                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
206                 ERC721TokenReceiver.onERC721Received.selector,
207             "UNSAFE_RECIPIENT"
208         );
209     }
210 
211     function _safeMint(
212         address to,
213         uint256 id,
214         bytes memory data
215     ) internal virtual {
216         _mint(to, id);
217 
218         require(
219             to.code.length == 0 ||
220                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
221                 ERC721TokenReceiver.onERC721Received.selector,
222             "UNSAFE_RECIPIENT"
223         );
224     }
225 }
226 
227 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
228 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
229 abstract contract ERC721TokenReceiver {
230     function onERC721Received(
231         address,
232         address,
233         uint256,
234         bytes calldata
235     ) external virtual returns (bytes4) {
236         return ERC721TokenReceiver.onERC721Received.selector;
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
244 
245 pragma solidity ^0.8.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
466 
467 
468 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @dev Interface of the ERC20 standard as defined in the EIP.
474  */
475 interface IERC20 {
476     /**
477      * @dev Emitted when `value` tokens are moved from one account (`from`) to
478      * another (`to`).
479      *
480      * Note that `value` may be zero.
481      */
482     event Transfer(address indexed from, address indexed to, uint256 value);
483 
484     /**
485      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
486      * a call to {approve}. `value` is the new allowance.
487      */
488     event Approval(address indexed owner, address indexed spender, uint256 value);
489 
490     /**
491      * @dev Returns the amount of tokens in existence.
492      */
493     function totalSupply() external view returns (uint256);
494 
495     /**
496      * @dev Returns the amount of tokens owned by `account`.
497      */
498     function balanceOf(address account) external view returns (uint256);
499 
500     /**
501      * @dev Moves `amount` tokens from the caller's account to `to`.
502      *
503      * Returns a boolean value indicating whether the operation succeeded.
504      *
505      * Emits a {Transfer} event.
506      */
507     function transfer(address to, uint256 amount) external returns (bool);
508 
509     /**
510      * @dev Returns the remaining number of tokens that `spender` will be
511      * allowed to spend on behalf of `owner` through {transferFrom}. This is
512      * zero by default.
513      *
514      * This value changes when {approve} or {transferFrom} are called.
515      */
516     function allowance(address owner, address spender) external view returns (uint256);
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
520      *
521      * Returns a boolean value indicating whether the operation succeeded.
522      *
523      * IMPORTANT: Beware that changing an allowance with this method brings the risk
524      * that someone may use both the old and the new allowance by unfortunate
525      * transaction ordering. One possible solution to mitigate this race
526      * condition is to first reduce the spender's allowance to 0 and set the
527      * desired value afterwards:
528      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
529      *
530      * Emits an {Approval} event.
531      */
532     function approve(address spender, uint256 amount) external returns (bool);
533 
534     /**
535      * @dev Moves `amount` tokens from `from` to `to` using the
536      * allowance mechanism. `amount` is then deducted from the caller's
537      * allowance.
538      *
539      * Returns a boolean value indicating whether the operation succeeded.
540      *
541      * Emits a {Transfer} event.
542      */
543     function transferFrom(
544         address from,
545         address to,
546         uint256 amount
547     ) external returns (bool);
548 }
549 
550 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 
559 /**
560  * @title SafeERC20
561  * @dev Wrappers around ERC20 operations that throw on failure (when the token
562  * contract returns false). Tokens that return no value (and instead revert or
563  * throw on failure) are also supported, non-reverting calls are assumed to be
564  * successful.
565  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
566  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
567  */
568 library SafeERC20 {
569     using Address for address;
570 
571     function safeTransfer(
572         IERC20 token,
573         address to,
574         uint256 value
575     ) internal {
576         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
577     }
578 
579     function safeTransferFrom(
580         IERC20 token,
581         address from,
582         address to,
583         uint256 value
584     ) internal {
585         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
586     }
587 
588     /**
589      * @dev Deprecated. This function has issues similar to the ones found in
590      * {IERC20-approve}, and its usage is discouraged.
591      *
592      * Whenever possible, use {safeIncreaseAllowance} and
593      * {safeDecreaseAllowance} instead.
594      */
595     function safeApprove(
596         IERC20 token,
597         address spender,
598         uint256 value
599     ) internal {
600         // safeApprove should only be called when setting an initial allowance,
601         // or when resetting it to zero. To increase and decrease it, use
602         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
603         require(
604             (value == 0) || (token.allowance(address(this), spender) == 0),
605             "SafeERC20: approve from non-zero to non-zero allowance"
606         );
607         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
608     }
609 
610     function safeIncreaseAllowance(
611         IERC20 token,
612         address spender,
613         uint256 value
614     ) internal {
615         uint256 newAllowance = token.allowance(address(this), spender) + value;
616         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
617     }
618 
619     function safeDecreaseAllowance(
620         IERC20 token,
621         address spender,
622         uint256 value
623     ) internal {
624         unchecked {
625             uint256 oldAllowance = token.allowance(address(this), spender);
626             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
627             uint256 newAllowance = oldAllowance - value;
628             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
629         }
630     }
631 
632     /**
633      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
634      * on the return value: the return value is optional (but if data is returned, it must not be false).
635      * @param token The token targeted by the call.
636      * @param data The call data (encoded using abi.encode or one of its variants).
637      */
638     function _callOptionalReturn(IERC20 token, bytes memory data) private {
639         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
640         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
641         // the target address contains contract code and also asserts for success in the low-level call.
642 
643         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
644         if (returndata.length > 0) {
645             // Return data is optional
646             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
647         }
648     }
649 }
650 
651 // File: transfer.sol
652 //SPDX-License-Identifier: MIT
653 
654 pragma solidity ^0.8.7;
655 
656 interface oldcontract {
657         function isclaimed (uint256 tokenId) external view returns (bool claimednft);
658         function isClaimedArray (uint[] memory _nftlist) external view returns (uint[] memory _unclaimed);
659         function hasClaimed(uint256 key) view external returns (bool);
660     }
661 
662 
663 contract WAItokenclaim  {
664     address private constant oldcontractaddress = 0xF535dA9e2d54ED1A5CEb18c92c334e1265534719;
665     ERC721 internal immutable nft;
666     address public owner;
667     uint256 public balance;
668     //uint256 public amount = 1000000000000000000;
669     
670     uint256 public maxSupply = 7000;
671     uint256 public standardAmount = 5555000000000000000000;
672     uint256 public deluxeAmount = 8333000000000000000000;
673     uint256 public villaAmount = 11111000000000000000000;
674     uint256 public executiveAmount = 22222000000000000000000;
675     bool public paused = false;
676 
677     event TransferReceived(address _from, uint _amount);
678     event TransferSent(address _from, address _destAddr, uint _amount);
679     event Claimed(uint256 indexed tokenId, address indexed claimer);
680 
681     mapping(uint256 => bool) public hasClaimed;
682     error NotOwner();
683     error AlreadyRedeemed();
684     
685 
686     constructor(ERC721 _nft) {
687         owner = msg.sender;
688         nft = _nft;
689     }
690     
691     receive() payable external {
692         balance += msg.value;
693         emit TransferReceived(msg.sender, msg.value);
694     }    
695 
696     function pause(bool _state) public {
697         require(msg.sender == owner, "Only owner can change contract state");
698         paused = _state;
699     }
700 
701     function updateAmount(uint256 _supply) internal view returns (uint256 _cost) {
702         if(_supply <= 3780) {
703             return standardAmount;
704         }
705         if(_supply <= 6160) {
706             return deluxeAmount;
707         }
708         if(_supply <= 6860) {
709             return villaAmount;
710         }
711         if(_supply <= maxSupply) {
712             return executiveAmount;
713         }
714     }
715 
716     function withdraw(IERC20 token, uint256 withrawamount) public {
717         require(msg.sender == owner, "Only owner can withdraw funds"); 
718         uint256 erc20balance = token.balanceOf(address(this));
719         require(withrawamount <= erc20balance, "balance is low");
720         token.transfer(msg.sender, withrawamount);
721         erc20balance -= withrawamount;
722         emit TransferSent(msg.sender, msg.sender, withrawamount);
723     }
724     function ercbalance(IERC20 token) public view returns (uint cbalance) {
725         return token.balanceOf(address(this));
726     }
727     
728     function isclaimed (uint256 tokenId) public view returns (bool claimednft) {
729         if (hasClaimed[tokenId] || oldcontract(oldcontractaddress).hasClaimed(tokenId)) 
730         {
731             return true;
732         }
733         else{
734             return false;
735         }
736     }
737     function isClaimedArray (uint[] memory _nftlist) public view returns (uint[] memory _unclaimed) {
738         for (uint256 i = 0; i < _nftlist.length; i++) {
739             if (hasClaimed[_nftlist[i]] || oldcontract(oldcontractaddress).isclaimed(_nftlist[i])){
740                 //unclaimedlist.push(_nftlist[i]);
741                 delete _nftlist[i];
742             } 
743         }
744         return _nftlist;
745     }
746 
747     function alreadyclaimed(uint256[] memory tokenId) public {
748         require(msg.sender == owner, "Only owner can call this function"); 
749         for (uint256 i = 0; i < tokenId.length; i++) {
750             hasClaimed[tokenId[i]] = true;
751         }
752     }
753     
754     function transferERC20(IERC20 token,uint256[] memory tokenId) public {
755         require(!paused);
756         uint256 totalamount;
757         for (uint256 i = 0; i < tokenId.length; i++) {
758             if (nft.ownerOf(tokenId[i]) != msg.sender) revert NotOwner();
759             if (hasClaimed[tokenId[i]]) revert AlreadyRedeemed();
760             if (oldcontract(oldcontractaddress).isclaimed(tokenId[i])) revert AlreadyRedeemed();
761             uint256 erc20balance = token.balanceOf(address(this));
762             totalamount += updateAmount(tokenId[i]);
763             require(totalamount <= erc20balance, "balance is low");
764         }
765         token.transfer(msg.sender, totalamount);
766         emit TransferSent(msg.sender, msg.sender, totalamount);
767         for (uint256 i = 0; i < tokenId.length; i++) {
768             hasClaimed[tokenId[i]] = true;
769         }
770     }    
771 }