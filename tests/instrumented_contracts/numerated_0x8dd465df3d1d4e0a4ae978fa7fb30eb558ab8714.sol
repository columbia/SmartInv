1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
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
51     function toHexString(uint256 value, uint256 length) 
52         internal 
53         pure 
54         returns (string memory) 
55     {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes calldata) {
74         return msg.data;
75     }
76 }
77 
78 abstract contract Pausable is Context {
79     /**
80      * @dev Emitted when the pause is triggered by `account`.
81      */
82     event Paused(address account);
83 
84     /**
85      * @dev Emitted when the pause is lifted by `account`.
86      */
87     event Unpaused(address account);
88 
89     bool private _paused;
90 
91     /**
92      * @dev Initializes the contract in unpaused state.
93      */
94     constructor() {
95         _paused = false;
96     }
97 
98     /**
99      * @dev Returns true if the contract is paused, and false otherwise.
100      */
101     function paused() public view virtual returns (bool) {
102         return _paused;
103     }
104 
105     /**
106      * @dev Modifier to make a function callable only when the contract is not paused.
107      *
108      * Requirements:
109      *
110      * - The contract must not be paused.
111      */
112     modifier whenNotPaused() {
113         require(!paused(), "Pausable: paused");
114         _;
115     }
116 
117     /**
118      * @dev Modifier to make a function callable only when the contract is paused.
119      *
120      * Requirements:
121      *
122      * - The contract must be paused.
123      */
124     modifier whenPaused() {
125         require(paused(), "Pausable: not paused");
126         _;
127     }
128 
129     /**
130      * @dev Triggers stopped state.
131      *
132      * Requirements:
133      *
134      * - The contract must not be paused.
135      */
136     function _pause() internal virtual whenNotPaused {
137         _paused = true;
138         emit Paused(_msgSender());
139     }
140 
141     /**
142      * @dev Returns to normal state.
143      *
144      * Requirements:
145      *
146      * - The contract must be paused.
147      */
148     function _unpause() internal virtual whenPaused {
149         _paused = false;
150         emit Unpaused(_msgSender());
151     }
152 }
153 
154 interface IERC165 {
155     /**
156      * @dev Returns true if this contract implements the interface defined by
157      * `interfaceId`. See the corresponding
158      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
159      * to learn more about how these ids are created.
160      *
161      * This function call must use less than 30 000 gas.
162      */
163     function supportsInterface(bytes4 interfaceId) external view returns (bool);
164 }
165 
166 interface IERC721 is IERC165 {
167     /**
168      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
169      */
170     event Transfer(
171         address indexed from, 
172         address indexed to, 
173         uint256 indexed tokenId
174     );
175 
176     /**
177      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
178      */
179     event Approval(
180         address indexed owner, 
181         address indexed approved, 
182         uint256 indexed tokenId
183     );
184 
185     /**
186      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
187      */
188     event ApprovalForAll(
189         address indexed owner, 
190         address indexed operator, 
191         bool approved
192     );
193 
194     /**
195      * @dev Returns the number of tokens in ``owner``'s account.
196      */
197     function balanceOf(address owner) external view returns (uint256 balance);
198 
199     /**
200      * @dev Returns the owner of the `tokenId` token.
201      *
202      * Requirements:
203      *
204      * - `tokenId` must exist.
205      */
206     function ownerOf(uint256 tokenId) external view returns (address owner);
207 
208     /**
209      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
210      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must exist and be owned by `from`.
217      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
218      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
219      *
220      * Emits a {Transfer} event.
221      */
222     function safeTransferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external;
227 
228     /**
229      * @dev Transfers `tokenId` token from `from` to `to`.
230      *
231      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(
243         address from,
244         address to,
245         uint256 tokenId
246     ) external;
247 
248     /**
249      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
250      * The approval is cleared when the token is transferred.
251      *
252      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
253      *
254      * Requirements:
255      *
256      * - The caller must own the token or be an approved operator.
257      * - `tokenId` must exist.
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address to, uint256 tokenId) external;
262 
263     /**
264      * @dev Returns the account approved for `tokenId` token.
265      *
266      * Requirements:
267      *
268      * - `tokenId` must exist.
269      */
270     function getApproved(uint256 tokenId) 
271         external 
272         view 
273         returns (address operator);
274 
275     /**
276      * @dev Approve or remove `operator` as an operator for the caller.
277      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
278      *
279      * Requirements:
280      *
281      * - The `operator` cannot be the caller.
282      *
283      * Emits an {ApprovalForAll} event.
284      */
285     function setApprovalForAll(address operator, bool _approved) external;
286 
287     /**
288      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
289      *
290      * See {setApprovalForAll}
291      */
292     function isApprovedForAll(address owner, address operator) 
293         external 
294         view 
295         returns (bool);
296 
297     /**
298      * @dev Safely transfers `tokenId` token from `from` to `to`.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must exist and be owned by `from`.
305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
306      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
307      *
308      * Emits a {Transfer} event.
309      */
310     function safeTransferFrom(
311         address from,
312         address to,
313         uint256 tokenId,
314         bytes calldata data
315     ) external;
316 }
317 
318 interface IERC721Receiver {
319     /**
320      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
321      * by `operator` from `from`, this function is called.
322      *
323      * It must return its Solidity selector to confirm the token transfer.
324      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
325      *
326      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
327      */
328     function onERC721Received(
329         address operator,
330         address from,
331         uint256 tokenId,
332         bytes calldata data
333     ) external returns (bytes4);
334 }
335 
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // This method relies on extcodesize, which returns 0 for contracts in
356         // construction, since the code is only stored at the end of the
357         // constructor execution.
358 
359         uint256 size;
360         assembly {
361             size := extcodesize(account)
362         }
363         return size > 0;
364     }
365 
366     /**
367      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
368      * `recipient`, forwarding all available gas and reverting on errors.
369      *
370      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
371      * of certain opcodes, possibly making contracts go over the 2300 gas limit
372      * imposed by `transfer`, making them unable to receive funds via
373      * `transfer`. {sendValue} removes this limitation.
374      *
375      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
376      *
377      * IMPORTANT: because control is transferred to `recipient`, care must be
378      * taken to not create reentrancy vulnerabilities. Consider using
379      * {ReentrancyGuard} or the
380      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
381      */
382     function sendValue(address payable recipient, uint256 amount) internal {
383         require(
384             address(this).balance >= amount, 
385             "Address: insufficient balance"
386         );
387 
388         (bool success, ) = recipient.call{value: amount}("");
389         require(
390             success, 
391             "Address: unable to send value, recipient may have reverted"
392         );
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain `call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) 
414         internal 
415         returns (bytes memory) 
416     {
417         return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value
449     ) internal returns (bytes memory) {
450         return 
451             functionCallWithValue(
452                 target, 
453                 data, 
454                 value, 
455                 "Address: low-level call with value failed"
456             );
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
461      * with `errorMessage` as a fallback revert reason when `target` reverts.
462      *
463      * _Available since v3.1._
464      */
465     function functionCallWithValue(
466         address target,
467         bytes memory data,
468         uint256 value,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         require(
472             address(this).balance >= value, 
473             "Address: insufficient balance for call"
474         );
475         require(isContract(target), "Address: call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.call{value: value}(
478             data
479         );
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(address target, bytes memory data) 
490         internal 
491         view 
492         returns (bytes memory) 
493     {
494         return 
495             functionStaticCall(
496                 target, 
497                 data, 
498                 "Address: low-level static call failed"
499             );
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a static call.
505      *
506      * _Available since v3.3._
507      */
508     function functionStaticCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal view returns (bytes memory) {
513         require(isContract(target), "Address: static call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.staticcall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but performing a delegate call.
522      *
523      * _Available since v3.4._
524      */
525     function functionDelegateCall(address target, bytes memory data) 
526         internal 
527         returns (bytes memory) 
528     {
529         return 
530             functionDelegateCall(
531                 target, 
532                 data, 
533                 "Address: low-level delegate call failed"
534             );
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
539      * but performing a delegate call.
540      *
541      * _Available since v3.4._
542      */
543     function functionDelegateCall(
544         address target,
545         bytes memory data,
546         string memory errorMessage
547     ) internal returns (bytes memory) {
548         require(isContract(target), "Address: delegate call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.delegatecall(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
556      * revert reason using the provided one.
557      *
558      * _Available since v4.3._
559      */
560     function verifyCallResult(
561         bool success,
562         bytes memory returndata,
563         string memory errorMessage
564     ) internal pure returns (bytes memory) {
565         if (success) {
566             return returndata;
567         } else {
568             // Look for revert reason and bubble it up if present
569             if (returndata.length > 0) {
570                 // The easiest way to bubble the revert reason is using memory via assembly
571 
572                 assembly {
573                     let returndata_size := mload(returndata)
574                     revert(add(32, returndata), returndata_size)
575                 }
576             } else {
577                 revert(errorMessage);
578             }
579         }
580     }
581 }
582 
583 abstract contract Ownable is Context {
584     address private _owner;
585 
586     event OwnershipTransferred(
587         address indexed previousOwner, 
588         address indexed newOwner
589     );
590 
591     /**
592      * @dev Initializes the contract setting the deployer as the initial owner.
593      */
594     constructor() {
595         _setOwner(_msgSender());
596     }
597 
598     /**
599      * @dev Returns the address of the current owner.
600      */
601     function owner() public view virtual returns (address) {
602         return _owner;
603     }
604 
605     /**
606      * @dev Throws if called by any account other than the owner.
607      */
608     modifier onlyOwner() {
609         require(owner() == _msgSender(), "Ownable: caller is not the owner");
610         _;
611     }
612 
613     /**
614      * @dev Leaves the contract without owner. It will not be possible to call
615      * `onlyOwner` functions anymore. Can only be called by the current owner.
616      *
617      * NOTE: Renouncing ownership will leave the contract without an owner,
618      * thereby removing any functionality that is only available to the owner.
619      */
620     function renounceOwnership() public virtual onlyOwner {
621         _setOwner(address(0));
622     }
623 
624     /**
625      * @dev Transfers ownership of the contract to a new account (`newOwner`).
626      * Can only be called by the current owner.
627      */
628     function transferOwnership(address newOwner) public virtual onlyOwner {
629         require(
630             newOwner != address(0), 
631             "Ownable: new owner is the zero address"
632         );
633         _setOwner(newOwner);
634     }
635 
636     function _setOwner(address newOwner) private {
637         address oldOwner = _owner;
638         _owner = newOwner;
639         emit OwnershipTransferred(oldOwner, newOwner);
640     }
641 }
642 
643 contract NudieStaker is Ownable, IERC721Receiver{
644     IERC721 public NudieNFT;
645 
646     struct StakeInfo {
647         uint256 since;
648     }
649 
650     mapping(address => mapping(uint256 => StakeInfo)) public userTokenStakeInfo; // tokenStakeInfo[userAddress][tokenId] = StakeInfo
651     mapping(address => uint256[]) private userTokenOwnershipList; // used to iterate over `userTokenStakeInfo`
652 
653     uint128 private smallRewardTime = 604800;
654     uint128 private midRewardTime = 1296000;
655     uint128 private largeRewardTime = 2592000;
656     uint128 private intervalRewardTime = 604800;
657 
658     uint128 private smallReward = 350;
659     uint128 private midReward = 1000;
660     uint128 private largeReward = 3000;
661     uint128 private intervalReward = 700;
662 
663     address private NudieTokenAddress;
664 
665     constructor(address NudieAddress){
666         NudieNFT = IERC721(NudieAddress);
667     }
668 
669     function stakeMultiple(uint256[] calldata tokenIds_) external{
670         for (uint256 i = 0; i < tokenIds_.length; i++) {
671             require(NudieNFT.ownerOf(tokenIds_[i]) == msg.sender, "Not Your Nudie To Stake");
672             storeNudie(msg.sender, tokenIds_[i]);
673             NudieNFT.safeTransferFrom(
674                 msg.sender,
675                 address(this),
676                 tokenIds_[i]
677             );
678         }
679     }
680 
681     function unstakeMultiple(uint256[] calldata tokenIds_) external {
682 
683         for (uint256 i = 0; i < tokenIds_.length; i++) {
684             require(removeNudie(msg.sender, tokenIds_[i]) == true, "Not your Nudie Token");
685             NudieNFT.isApprovedForAll(address(this), msg.sender);
686             NudieNFT.safeTransferFrom(
687                 address(this),
688                 msg.sender,
689                 tokenIds_[i]
690             );
691         }
692     }
693 
694     function stake(uint256 tokenIds_) external{
695             require(NudieNFT.ownerOf(tokenIds_) == msg.sender, "Not Your Nudie To Stake");
696             storeNudie(msg.sender, tokenIds_);
697             NudieNFT.safeTransferFrom(
698                 msg.sender,
699                 address(this),
700                 tokenIds_
701             );
702     }
703 
704     function unstake(uint256 tokenIds_) external {
705             require(removeNudie(msg.sender, tokenIds_) == true, "Not your Nudie Token");
706             NudieNFT.isApprovedForAll(address(this), msg.sender);
707             NudieNFT.safeTransferFrom(
708                 address(this),
709                 msg.sender,
710                 tokenIds_
711             );
712     }
713 
714     function storeNudie(address _owner, uint256 tokenId_) internal
715     {       
716         userTokenStakeInfo[_owner][tokenId_] = StakeInfo({
717             since: block.timestamp
718         });
719         userTokenOwnershipList[_owner].push(tokenId_);
720     }
721 
722     function removeNudie(address _owner, uint256 tokenId_) internal returns(bool)
723     {
724         delete userTokenStakeInfo[_owner][tokenId_];
725 
726         uint256 tokensOwnedCount = userTokenOwnershipList[_owner].length;
727         for (uint256 i = 0; i < tokensOwnedCount; i++) {
728             if (userTokenOwnershipList[_owner][i] == tokenId_) {
729                 uint256 length = userTokenOwnershipList[_owner].length;
730                 userTokenOwnershipList[_owner][i] = userTokenOwnershipList[
731                     _owner
732                 ][length - 1];
733                 userTokenOwnershipList[_owner].pop();
734                 return true;
735             }
736         }
737         return false;
738     }
739 
740     function returnStakedNudies() external view returns(uint256 [] memory){
741         uint256 tokensOwnedCount = userTokenOwnershipList[msg.sender].length;
742         uint256[] memory stakedList = new uint256[](tokensOwnedCount);
743 
744         for (uint256 i = 0; i < tokensOwnedCount; i++) {
745             stakedList[i] = userTokenOwnershipList[msg.sender][i];    
746         }
747 
748         return stakedList;
749     }
750 
751     function claimStakedRewards(address owner) external returns(uint256){
752         require(msg.sender == NudieTokenAddress, "Function can only be called via token contract");
753         uint256 claimableReward = calculateRewards(owner);
754         uint256 tokensOwnedCount = userTokenOwnershipList[owner].length;
755 
756         for (uint256 i = 0; i < tokensOwnedCount; i++) {
757             uint256 tokenId = userTokenOwnershipList[owner][i];
758             userTokenStakeInfo[owner][tokenId].since = block.timestamp;
759         }
760 
761         return claimableReward;
762     }
763 
764     function calculateRewards(address _owner)
765         public
766         view
767         returns (uint256)
768     {
769         uint256 tokensOwnedCount = userTokenOwnershipList[_owner].length;
770         uint256 reward = 0;
771 
772         for (uint256 i = 0; i < tokensOwnedCount; i++) {
773             uint256 tokenId = userTokenOwnershipList[_owner][i];
774             uint256 stakedSince = userTokenStakeInfo[_owner][tokenId].since;
775 
776             if((block.timestamp - stakedSince) >= smallRewardTime  && (block.timestamp - stakedSince) < midRewardTime){
777                 reward = reward + smallReward;
778             }  
779 
780             if((block.timestamp - stakedSince) >= midRewardTime && (block.timestamp - stakedSince) < largeRewardTime){
781                 reward = reward + midReward;               
782             }     
783 
784             if((block.timestamp - stakedSince) >= largeRewardTime){
785                 reward = reward + largeReward;   
786                 uint256 additionalStakeTime = (block.timestamp - stakedSince) - largeRewardTime;
787 
788                 while(additionalStakeTime >= intervalRewardTime){
789                     reward = reward + intervalReward;
790                     additionalStakeTime = additionalStakeTime - intervalRewardTime;
791                 }           
792             }     
793         }
794         return reward;
795     }
796 
797     function setNudieToken(address NudieTokenAddress_) external onlyOwner {
798         NudieTokenAddress = NudieTokenAddress_;
799     }
800 
801     function setRewards(uint128 _smallReward, uint128 _midReward, uint128 _largeReward, uint128 _intervalReward) 
802     external onlyOwner 
803     {
804         smallReward = _smallReward;
805         midReward = _midReward;
806         largeReward = _largeReward;
807         intervalReward = _intervalReward;
808     }
809 
810     function setRewardTimes(uint128 _smallRewardTime, uint128 _midRewardTime, uint128 _largeRewardTime, uint128 _intervalRewardTime) 
811     external onlyOwner 
812     {
813         smallRewardTime = _smallRewardTime;
814         midRewardTime = _midRewardTime;
815         largeRewardTime = _largeRewardTime;
816         intervalRewardTime = _intervalRewardTime;
817     }
818 
819     function onERC721Received(
820         address,
821         address,
822         uint256,
823         bytes calldata
824     ) public pure override returns (bytes4) {
825         return this.onERC721Received.selector;
826     }
827 
828 }