1 // File contracts/libraries/SafeMath.sol
2 
3 pragma solidity 0.7.5;
4 
5 
6 library SafeMath {
7 
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11 
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         return sub(a, b, "SafeMath: subtraction overflow");
17     }
18 
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33 
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40 
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         return c;
45     }
46 
47     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48         return mod(a, b, "SafeMath: modulo by zero");
49     }
50 
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b != 0, errorMessage);
53         return a % b;
54     }
55 
56     function sqrrt(uint256 a) internal pure returns (uint c) {
57         if (a > 3) {
58             c = a;
59             uint b = add( div( a, 2), 1 );
60             while (b < c) {
61                 c = b;
62                 b = div( add( div( a, b ), b), 2 );
63             }
64         } else if (a != 0) {
65             c = 1;
66         }
67     }
68 }
69 
70 
71 // File contracts/libraries/Address.sol
72 
73 pragma solidity 0.7.5;
74 
75 
76 library Address {
77 
78     function isContract(address account) internal view returns (bool) {
79 
80         uint256 size;
81         // solhint-disable-next-line no-inline-assembly
82         assembly { size := extcodesize(account) }
83         return size > 0;
84     }
85 
86     function sendValue(address payable recipient, uint256 amount) internal {
87         require(address(this).balance >= amount, "Address: insufficient balance");
88 
89         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
90         (bool success, ) = recipient.call{ value: amount }("");
91         require(success, "Address: unable to send value, recipient may have reverted");
92     }
93 
94     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
95       return functionCall(target, data, "Address: low-level call failed");
96     }
97 
98     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
99         return _functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
104     }
105 
106     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
107         require(address(this).balance >= value, "Address: insufficient balance for call");
108         require(isContract(target), "Address: call to non-contract");
109 
110         // solhint-disable-next-line avoid-low-level-calls
111         (bool success, bytes memory returndata) = target.call{ value: value }(data);
112         return _verifyCallResult(success, returndata, errorMessage);
113     }
114 
115     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
116         require(isContract(target), "Address: call to non-contract");
117 
118         // solhint-disable-next-line avoid-low-level-calls
119         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
120         if (success) {
121             return returndata;
122         } else {
123             // Look for revert reason and bubble it up if present
124             if (returndata.length > 0) {
125                 // The easiest way to bubble the revert reason is using memory via assembly
126 
127                 // solhint-disable-next-line no-inline-assembly
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 
138     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
139         return functionStaticCall(target, data, "Address: low-level static call failed");
140     }
141 
142     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
143         require(isContract(target), "Address: static call to non-contract");
144 
145         // solhint-disable-next-line avoid-low-level-calls
146         (bool success, bytes memory returndata) = target.staticcall(data);
147         return _verifyCallResult(success, returndata, errorMessage);
148     }
149 
150     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
152     }
153 
154     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
155         require(isContract(target), "Address: delegate call to non-contract");
156 
157         // solhint-disable-next-line avoid-low-level-calls
158         (bool success, bytes memory returndata) = target.delegatecall(data);
159         return _verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
163         if (success) {
164             return returndata;
165         } else {
166             if (returndata.length > 0) {
167 
168                 assembly {
169                     let returndata_size := mload(returndata)
170                     revert(add(32, returndata), returndata_size)
171                 }
172             } else {
173                 revert(errorMessage);
174             }
175         }
176     }
177 
178     function addressToString(address _address) internal pure returns(string memory) {
179         bytes32 _bytes = bytes32(uint256(_address));
180         bytes memory HEX = "0123456789abcdef";
181         bytes memory _addr = new bytes(42);
182 
183         _addr[0] = '0';
184         _addr[1] = 'x';
185 
186         for(uint256 i = 0; i < 20; i++) {
187             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
188             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
189         }
190 
191         return string(_addr);
192 
193     }
194 }
195 
196 
197 // File contracts/interfaces/IERC20.sol
198 
199 pragma solidity 0.7.5;
200 
201 interface IERC20 {
202     function decimals() external view returns (uint8);
203 
204     function totalSupply() external view returns (uint256);
205 
206     function balanceOf(address account) external view returns (uint256);
207 
208     function transfer(address recipient, uint256 amount) external returns (bool);
209 
210     function allowance(address owner, address spender) external view returns (uint256);
211 
212     function approve(address spender, uint256 amount) external returns (bool);
213 
214     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
215 
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     event Approval(address indexed owner, address indexed spender, uint256 value);
219 }
220 
221 
222 // File contracts/libraries/SafeERC20.sol
223 
224 pragma solidity 0.7.5;
225 
226 
227 library SafeERC20 {
228     using SafeMath for uint256;
229     using Address for address;
230 
231     function safeTransfer(IERC20 token, address to, uint256 value) internal {
232         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
233     }
234 
235     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
236         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
237     }
238 
239     function safeApprove(IERC20 token, address spender, uint256 value) internal {
240 
241         require((value == 0) || (token.allowance(address(this), spender) == 0),
242             "SafeERC20: approve from non-zero to non-zero allowance"
243         );
244         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
245     }
246 
247     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
248         uint256 newAllowance = token.allowance(address(this), spender).add(value);
249         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
250     }
251 
252     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
253         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
254         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
255     }
256 
257     function _callOptionalReturn(IERC20 token, bytes memory data) private {
258 
259         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
260         if (returndata.length > 0) { // Return data is optional
261             // solhint-disable-next-line max-line-length
262             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
263         }
264     }
265 }
266 
267 
268 // File contracts/interfaces/IERC165.sol
269 
270 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
271 
272 pragma solidity ^0.7.5;
273 
274 /**
275  * @dev Interface of the ERC165 standard, as defined in the
276  * https://eips.ethereum.org/EIPS/eip-165[EIP].
277  *
278  * Implementers can declare support of contract interfaces, which can then be
279  * queried by others ({ERC165Checker}).
280  *
281  * For an implementation, see {ERC165}.
282  */
283 interface IERC165 {
284     /**
285      * @dev Returns true if this contract implements the interface defined by
286      * `interfaceId`. See the corresponding
287      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
288      * to learn more about how these ids are created.
289      *
290      * This function call must use less than 30 000 gas.
291      */
292     function supportsInterface(bytes4 interfaceId) external view returns (bool);
293 }
294 
295 
296 // File contracts/mocks/ERC165.sol
297 
298 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
299 
300 pragma solidity ^0.7.5;
301 
302 /**
303  * @dev Implementation of the {IERC165} interface.
304  *
305  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
306  * for the additional interface id that will be supported. For example:
307  *
308  * ```solidity
309  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
311  * }
312  * ```
313  *
314  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
315  */
316 abstract contract ERC165 is IERC165 {
317     /**
318      * @dev See {IERC165-supportsInterface}.
319      */
320     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
321         return interfaceId == type(IERC165).interfaceId;
322     }
323 }
324 
325 
326 // File contracts/interfaces/IERC1155.sol
327 
328 pragma solidity ^0.7.5;
329 
330 /**
331     @title ERC-1155 Multi Token Standard
332     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
333     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
334  */
335 interface IERC1155 /* is ERC165 */ {
336     /**
337         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
338         The `_operator` argument MUST be msg.sender.
339         The `_from` argument MUST be the address of the holder whose balance is decreased.
340         The `_to` argument MUST be the address of the recipient whose balance is increased.
341         The `_id` argument MUST be the token type being transferred.
342         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
343         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
344         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
345     */
346     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
347 
348     /**
349         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
350         The `_operator` argument MUST be msg.sender.
351         The `_from` argument MUST be the address of the holder whose balance is decreased.
352         The `_to` argument MUST be the address of the recipient whose balance is increased.
353         The `_ids` argument MUST be the list of tokens being transferred.
354         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
355         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
356         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
357     */
358     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
359 
360     /**
361         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
362     */
363     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
364 
365     /**
366         @dev MUST emit when the URI is updated for a token ID.
367         URIs are defined in RFC 3986.
368         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
369     */
370     event URI(string _value, uint256 indexed _id);
371 
372     /**
373         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
374         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
375         MUST revert if `_to` is the zero address.
376         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
377         MUST revert on any other error.
378         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
379         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
380         @param _from    Source address
381         @param _to      Target address
382         @param _id      ID of the token type
383         @param _value   Transfer amount
384         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
385     */
386     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
387 
388     /**
389         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
390         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
391         MUST revert if `_to` is the zero address.
392         MUST revert if length of `_ids` is not the same as length of `_values`.
393         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
394         MUST revert on any other error.
395         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
396         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
397         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
398         @param _from    Source address
399         @param _to      Target address
400         @param _ids     IDs of each token type (order and length must match _values array)
401         @param _values  Transfer amounts per token type (order and length must match _ids array)
402         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
403     */
404     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
405 
406     /**
407         @notice Get the balance of an account's Tokens.
408         @param _owner  The address of the token holder
409         @param _id     ID of the Token
410         @return        The _owner's balance of the Token type requested
411      */
412     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
413 
414     /**
415         @notice Get the balance of multiple account/token pairs
416         @param _owners The addresses of the token holders
417         @param _ids    ID of the Tokens
418         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
419      */
420     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
421 
422     /**
423         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
424         @dev MUST emit the ApprovalForAll event on success.
425         @param _operator  Address to add to the set of authorized operators
426         @param _approved  True if the operator is approved, false to revoke approval
427     */
428     function setApprovalForAll(address _operator, bool _approved) external;
429 
430     /**
431         @notice Queries the approval status of an operator for a given owner.
432         @param _owner     The owner of the Tokens
433         @param _operator  Address of authorized operator
434         @return           True if the operator is approved, false if not
435     */
436     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
437 }
438 
439 
440 // File contracts/OP1155/IParagonBondingTreasury.sol
441 
442 pragma solidity 0.7.5;
443 
444 interface IParagonBondingTreasury {
445     function sendPDT(uint _amountPayoutToken) external;
446     function valueOfToken( address _principalToken, uint _amount ) external view returns ( uint value_ );
447     function PDT() external view returns (address);
448 }
449 
450 
451 // File contracts/types/Ownable.sol
452 
453 pragma solidity 0.7.5;
454 
455 contract Ownable {
456 
457     address public policy;
458 
459     constructor () {
460         policy = msg.sender;
461     }
462 
463     modifier onlyPolicy() {
464         require( policy == msg.sender, "Ownable: caller is not the owner" );
465         _;
466     }
467     
468     function transferManagment(address _newOwner) external onlyPolicy() {
469         require( _newOwner != address(0) );
470         policy = _newOwner;
471     }
472 }
473 
474 
475 // File contracts/OP1155/ParallelBondingContract.sol
476 
477 // SPDX-License-Identifier: AGPL-3.0-or-later
478 pragma solidity 0.7.5;
479 
480 
481 
482 
483 /// @title   Parallel Bonding Contract
484 /// @author  JeffX
485 /// @notice  Bonding Parallel ERC1155s in return for PDT tokens
486 contract ParallelBondingContract is Ownable {
487     using SafeERC20 for IERC20;
488     using SafeMath for uint;
489 
490     
491     /// EVENTS ///
492 
493     /// @notice Emitted when A bond is created
494     /// @param deposit Address of where bond is deposited to
495     /// @param payout Amount of PDT to be paid out
496     /// @param expires Block number bond will be fully redeemable
497     event BondCreated( uint deposit, uint payout, uint expires );
498 
499     /// @notice Emitted when a bond is redeemed
500     /// @param recipient Address receiving PDT
501     /// @param payout Amount of PDT redeemed
502     /// @param remaining Amount of PDT left to be paid out
503     event BondRedeemed( address recipient, uint payout, uint remaining );
504 
505     
506     /// STATE VARIABLES ///
507     
508     /// @notice Paragon DAO Token
509     IERC20 immutable public PDT;
510     /// @notice Parallel ERC1155
511     IERC1155 immutable public LL;
512     /// @notice Custom Treasury
513     IParagonBondingTreasury immutable public customTreasury;
514     /// @notice Olympus DAO address
515     address immutable public olympusDAO;
516     /// @notice Olympus treasury address
517     address public olympusTreasury;
518 
519     /// @notice Total Parallel tokens that have been bonded
520     uint public totalPrincipalBonded;
521     /// @notice Total PDT tokens given as payout
522     uint public totalPayoutGiven;
523     /// @notice Vesting term in blocks
524     uint public vestingTerm;
525     /// @notice Percent fee that goes to Olympus
526     uint public immutable olympusFee = 33300;
527 
528     /// @notice Array of IDs that have been bondable
529     uint[] public bondedIds;
530 
531     /// @notice Bool if bond contract has been initialized
532     bool public initialized;
533 
534     /// @notice Stores bond information for depositors
535     mapping( address => Bond ) public bondInfo;
536 
537     /// @notice Stores bond information for a Parallel ID
538     mapping( uint => IdDetails ) public idDetails;
539 
540     
541     /// STRUCTS ///
542 
543     /// @notice           Details of an addresses current bond
544     /// @param payout     PDT tokens remaining to be paid
545     /// @param vesting    Blocks left to vest
546     /// @param lastBlock  Last interaction
547     struct Bond {
548         uint payout;
549         uint vesting;
550         uint lastBlock;
551     }
552 
553     /// @notice                   Details of an ID that is to be bonded
554     /// @param bondPrice          Payout price of the ID
555     /// @param remainingToBeSold  Remaining amount of tokens that can be bonded
556     /// @param inArray            Bool if ID is in array that keeps track of IDs
557     struct IdDetails {
558         uint bondPrice;
559         uint remainingToBeSold;
560         bool inArray;
561     }
562 
563     
564     /// CONSTRUCTOR ///
565 
566     /// @param _customTreasury   Address of cusotm treasury
567     /// @param _LL               Address of the Parallel token
568     /// @param _olympusTreasury  Address of the Olympus treasury
569     /// @param _initialOwner     Address of the initial owner
570     /// @param _olympusDAO       Address of Olympus DAO
571     constructor(
572         address _customTreasury, 
573         address _LL, 
574         address _olympusTreasury,
575         address _initialOwner, 
576         address _olympusDAO
577     ) {
578         require( _customTreasury != address(0) );
579         customTreasury = IParagonBondingTreasury( _customTreasury );
580         PDT = IERC20( IParagonBondingTreasury(_customTreasury).PDT() );
581         require( _LL != address(0) );
582         LL = IERC1155( _LL );
583         require( _olympusTreasury != address(0) );
584         olympusTreasury = _olympusTreasury;
585         require( _initialOwner != address(0) );
586         policy = _initialOwner;
587         require( _olympusDAO != address(0) );
588         olympusDAO = _olympusDAO;
589     }
590 
591 
592     /// POLICY FUNCTIONS ///
593 
594     /// @notice              Initializes bond and sets vesting rate
595     /// @param _vestingTerm  Vesting term in blocks
596     function initializeBond(uint _vestingTerm) external onlyPolicy() {
597         require(!initialized, "Already initialized");
598         vestingTerm = _vestingTerm;
599         initialized = true;
600     }
601 
602     /// @notice          Updates current vesting term
603     /// @param _vesting  New vesting in blocks
604     function setVesting( uint _vesting ) external onlyPolicy() {
605         require(initialized, "Not initalized");
606         vestingTerm = _vesting;
607     }
608 
609     /// @notice           Set bond price and how many to be sold for each ID
610     /// @param _ids       Array of IDs that will be sold
611     /// @param _prices    PDT given to bond correspond ID in `_ids`
612     /// @param _toBeSold  Number of IDs looking to be acquired
613     function setIdDetails(uint[] calldata _ids, uint[] calldata _prices, uint _toBeSold) external onlyPolicy() {
614         require(_ids.length == _prices.length, "Lengths do not match");
615         for(uint i; i < _ids.length; i++) {
616             IdDetails memory idDetail = idDetails[_ids[i]];
617             idDetail.bondPrice = _prices[i];
618             idDetail.remainingToBeSold = _toBeSold;
619             if(!idDetail.inArray) {
620                 bondedIds.push(_ids[i]);
621                 idDetail.inArray = true;
622             }
623             idDetails[_ids[i]] = idDetail;
624 
625         }
626     }
627 
628     /// @notice                  Updates address to send Olympus fee to
629     /// @param _olympusTreasury  Address of new Olympus treasury
630     function changeOlympusTreasury(address _olympusTreasury) external {
631         require( msg.sender == olympusDAO, "Only Olympus DAO" );
632         olympusTreasury = _olympusTreasury;
633     }
634 
635     /// USER FUNCTIONS ///
636     
637     /// @notice            Bond Parallel ERC1155 to get PDT tokens
638     /// @param _id         ID number that is being bonded
639     /// @param _amount     Amount of sepcific `_id` to bond
640     /// @param _depositor  Address that PDT tokens will be redeemable for
641     function deposit(uint _id, uint _amount, address _depositor) external returns (uint) {
642         require(initialized, "Not initalized");
643         require( idDetails[_id].bondPrice > 0 && idDetails[_id].remainingToBeSold >= _amount, "Not bondable");
644         require( _amount > 0, "Cannot bond 0" );
645         require( _depositor != address(0), "Invalid address" );
646 
647         uint payout;
648         uint fee;
649 
650         (payout, fee) = payoutFor( _id ); // payout and fee is computed
651 
652         payout = payout.mul(_amount);
653         fee = fee.mul(_amount);
654                 
655         // depositor info is stored
656         bondInfo[ _depositor ] = Bond({ 
657             payout: bondInfo[ _depositor ].payout.add( payout ),
658             vesting: vestingTerm,
659             lastBlock: block.number
660         });
661 
662         idDetails[_id].remainingToBeSold = idDetails[_id].remainingToBeSold.sub(_amount);
663 
664         totalPrincipalBonded = totalPrincipalBonded.add(_amount); // total bonded increased
665         totalPayoutGiven = totalPayoutGiven.add(payout); // total payout increased
666 
667         customTreasury.sendPDT( payout.add(fee) );
668 
669         PDT.safeTransfer(olympusTreasury, fee);
670 
671         LL.safeTransferFrom( msg.sender, address(customTreasury), _id, _amount, "" ); // transfer principal bonded to custom treasury
672 
673         // indexed events are emitted
674         emit BondCreated( _id, payout, block.number.add( vestingTerm ) );
675 
676         return payout; 
677     }
678     
679     /// @notice            Redeem bond for `depositor`
680     /// @param _depositor  Address of depositor being redeemed
681     /// @return            Amount of PDT redeemed
682     function redeem(address _depositor) external returns (uint) {
683         Bond memory info = bondInfo[ _depositor ];
684         uint percentVested = percentVestedFor( _depositor ); // (blocks since last interaction / vesting term remaining)
685 
686         if ( percentVested >= 10000 ) { // if fully vested
687             delete bondInfo[ _depositor ]; // delete user info
688             emit BondRedeemed( _depositor, info.payout, 0 ); // emit bond data
689             PDT.safeTransfer( _depositor, info.payout );
690             return info.payout;
691 
692         } else { // if unfinished
693             // calculate payout vested
694             uint payout = info.payout.mul( percentVested ).div( 10000 );
695 
696             // store updated deposit info
697             bondInfo[ _depositor ] = Bond({
698                 payout: info.payout.sub( payout ),
699                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
700                 lastBlock: block.number
701             });
702 
703             emit BondRedeemed( _depositor, payout, bondInfo[ _depositor ].payout );
704             PDT.safeTransfer( _depositor, payout );
705             return payout;
706         }
707         
708     }
709 
710     /// VIEW FUNCTIONS ///
711     
712     /// @notice          Payout and fee for a specific bond ID
713     /// @param _id       ID to get payout and fee for
714     /// @return payout_  Amount of PDT user will recieve for bonding `_id`
715     /// @return fee_     Amount of PDT Olympus will recieve for the bonding of `_id`
716     function payoutFor( uint _id ) public view returns ( uint payout_, uint fee_) {
717         uint price = idDetails[_id].bondPrice;
718         fee_ = price.mul( olympusFee ).div( 1e6 );
719         payout_ = price.sub(fee_);
720     }
721 
722     /// @notice                 Calculate how far into vesting `_depositor` is
723     /// @param _depositor       Address of depositor
724     /// @return percentVested_  Percent `_depositor` is into vesting
725     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
726         Bond memory bond = bondInfo[ _depositor ];
727         uint blocksSinceLast = block.number.sub( bond.lastBlock );
728         uint vesting = bond.vesting;
729 
730         if ( vesting > 0 ) {
731             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
732         } else {
733             percentVested_ = 0;
734         }
735     }
736 
737     /// @notice                 Calculate amount of payout token available for claim by `_depositor`
738     /// @param _depositor       Address of depositor
739     /// @return pendingPayout_  Pending payout for `_depositor`
740     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
741         uint percentVested = percentVestedFor( _depositor );
742         uint payout = bondInfo[ _depositor ].payout;
743 
744         if ( percentVested >= 10000 ) {
745             pendingPayout_ = payout;
746         } else {
747             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
748         }
749     }
750 
751     /// @notice  Returns all the ids that are bondable and the amounts that can be bonded for each
752     /// @return  Array of all IDs that are bondable
753     /// @return  Array of amount remaining to be bonded for each bondable ID
754     function bondableIds() external view returns (uint[] memory, uint[] memory) {
755         uint numberOfBondable;
756 
757         for(uint i = 0; i < bondedIds.length; i++) {
758             uint id = bondedIds[i];
759             (bool active,) = canBeBonded(id);
760             if(active) numberOfBondable++;
761         }
762 
763         uint256[] memory ids = new uint256[](numberOfBondable);
764         uint256[] memory leftToBond = new uint256[](numberOfBondable);
765 
766         uint nonce;
767         for(uint i = 0; i < bondedIds.length; i++) {
768             uint id = bondedIds[i];
769             (bool active, uint amount) = canBeBonded(id);
770             if(active) {
771                 ids[nonce] = id;
772                 leftToBond[nonce] = amount;
773                 nonce++;
774             }
775         }
776 
777         return (ids, leftToBond);
778     }
779 
780     /// @notice     Determines if `_id` can be bonded, and if so how much is left
781     /// @param _id  ID to check if can be bonded
782     /// @return     Bool if `_id` can be bonded
783     /// @return     Amount of tokens that be bonded for `_id`
784     function canBeBonded(uint _id) public view returns (bool, uint) {
785         IdDetails memory idDetail = idDetails[_id];
786         if(idDetail.bondPrice > 0 && idDetail.remainingToBeSold > 0) {
787             return (true, idDetail.remainingToBeSold);
788         } else {
789             return (false, 0);
790         }
791     }
792 
793     
794 }