1 pragma solidity ^0.5.0;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor() internal {}
18 
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(
44         address indexed previousOwner,
45         address indexed newOwner
46     );
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() internal {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Returns true if the caller is the current owner.
74      */
75     function isOwner() public view returns (bool) {
76         return _msgSender() == _owner;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(
104             newOwner != address(0),
105             "Ownable: new owner is the zero address"
106         );
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
114  * the optional functions; to access them see {ERC20Detailed}.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount)
135         external
136         returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender)
146         external
147         view
148         returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(
194         address indexed owner,
195         address indexed spender,
196         uint256 value
197     );
198 }
199 
200 interface IERC1155 {
201     // Events
202 
203     /**
204      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
205      *   Operator MUST be msg.sender
206      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
207      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
208      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
209      *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
210      */
211     event TransferSingle(
212         address indexed _operator,
213         address indexed _from,
214         address indexed _to,
215         uint256 _id,
216         uint256 _amount
217     );
218 
219     /**
220      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
221      *   Operator MUST be msg.sender
222      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
223      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
224      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
225      *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
226      */
227     event TransferBatch(
228         address indexed _operator,
229         address indexed _from,
230         address indexed _to,
231         uint256[] _ids,
232         uint256[] _amounts
233     );
234 
235     /**
236      * @dev MUST emit when an approval is updated
237      */
238     event ApprovalForAll(
239         address indexed _owner,
240         address indexed _operator,
241         bool _approved
242     );
243 
244     /**
245      * @dev MUST emit when the URI is updated for a token ID
246      *   URIs are defined in RFC 3986
247      *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
248      */
249     event URI(string _amount, uint256 indexed _id);
250 
251     /**
252      * @notice Transfers amount of an _id from the _from address to the _to address specified
253      * @dev MUST emit TransferSingle event on success
254      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
255      * MUST throw if `_to` is the zero address
256      * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
257      * MUST throw on any other error
258      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
259      * @param _from    Source address
260      * @param _to      Target address
261      * @param _id      ID of the token type
262      * @param _amount  Transfered amount
263      * @param _data    Additional data with no specified format, sent in call to `_to`
264      */
265     function safeTransferFrom(
266         address _from,
267         address _to,
268         uint256 _id,
269         uint256 _amount,
270         bytes calldata _data
271     ) external;
272 
273     /**
274      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
275      * @dev MUST emit TransferBatch event on success
276      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
277      * MUST throw if `_to` is the zero address
278      * MUST throw if length of `_ids` is not the same as length of `_amounts`
279      * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
280      * MUST throw on any other error
281      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
282      * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
283      * @param _from     Source addresses
284      * @param _to       Target addresses
285      * @param _ids      IDs of each token type
286      * @param _amounts  Transfer amounts per token type
287      * @param _data     Additional data with no specified format, sent in call to `_to`
288      */
289     function safeBatchTransferFrom(
290         address _from,
291         address _to,
292         uint256[] calldata _ids,
293         uint256[] calldata _amounts,
294         bytes calldata _data
295     ) external;
296 
297     /**
298      * @notice Get the balance of an account's Tokens
299      * @param _owner  The address of the token holder
300      * @param _id     ID of the Token
301      * @return        The _owner's balance of the Token type requested
302      */
303     function balanceOf(address _owner, uint256 _id)
304         external
305         view
306         returns (uint256);
307 
308     /**
309      * @notice Get the balance of multiple account/token pairs
310      * @param _owners The addresses of the token holders
311      * @param _ids    ID of the Tokens
312      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
313      */
314     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
315         external
316         view
317         returns (uint256[] memory);
318 
319     /**
320      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
321      * @dev MUST emit the ApprovalForAll event on success
322      * @param _operator  Address to add to the set of authorized operators
323      * @param _approved  True if the operator is approved, false to revoke approval
324      */
325     function setApprovalForAll(address _operator, bool _approved) external;
326 
327     /**
328      * @notice Queries the approval status of an operator for a given owner
329      * @param _owner     The owner of the Tokens
330      * @param _operator  Address of authorized operator
331      * @return           True if the operator is approved, false if not
332      */
333     function isApprovedForAll(address _owner, address _operator)
334         external
335         view
336         returns (bool isOperator);
337 }
338 
339 interface IERC1155Metadata {
340     /***********************************|
341     |     Metadata Public Function s    |
342     |__________________________________*/
343 
344     /**
345      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
346      * @dev URIs are defined in RFC 3986.
347      *      URIs are assumed to be deterministically generated based on token ID
348      *      Token IDs are assumed to be represented in their hex format in URIs
349      * @return URI string
350      */
351     function uri(uint256 _id) external view returns (string memory);
352 }
353 
354 library Strings {
355     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
356     function strConcat(
357         string memory _a,
358         string memory _b,
359         string memory _c,
360         string memory _d,
361         string memory _e
362     ) internal pure returns (string memory) {
363         bytes memory _ba = bytes(_a);
364         bytes memory _bb = bytes(_b);
365         bytes memory _bc = bytes(_c);
366         bytes memory _bd = bytes(_d);
367         bytes memory _be = bytes(_e);
368         string memory abcde = new string(
369             _ba.length + _bb.length + _bc.length + _bd.length + _be.length
370         );
371         bytes memory babcde = bytes(abcde);
372         uint256 k = 0;
373         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
374         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
375         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
376         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
377         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
378         return string(babcde);
379     }
380 
381     function strConcat(
382         string memory _a,
383         string memory _b,
384         string memory _c,
385         string memory _d
386     ) internal pure returns (string memory) {
387         return strConcat(_a, _b, _c, _d, "");
388     }
389 
390     function strConcat(
391         string memory _a,
392         string memory _b,
393         string memory _c
394     ) internal pure returns (string memory) {
395         return strConcat(_a, _b, _c, "", "");
396     }
397 
398     function strConcat(string memory _a, string memory _b)
399         internal
400         pure
401         returns (string memory)
402     {
403         return strConcat(_a, _b, "", "", "");
404     }
405 
406     function uint2str(uint256 _i)
407         internal
408         pure
409         returns (string memory _uintAsString)
410     {
411         if (_i == 0) {
412             return "0";
413         }
414         uint256 j = _i;
415         uint256 len;
416         while (j != 0) {
417             len++;
418             j /= 10;
419         }
420         bytes memory bstr = new bytes(len);
421         uint256 k = len - 1;
422         while (_i != 0) {
423             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
424             _i /= 10;
425         }
426         return string(bstr);
427     }
428 }
429 
430 /**
431  * @title SafeMath
432  * @dev Unsigned math operations with safety checks that revert on error
433  */
434 library SafeMath {
435     /**
436      * @dev Multiplies two unsigned integers, reverts on overflow.
437      */
438     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
439         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
440         // benefit is lost if 'b' is also tested.
441         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
442         if (a == 0) {
443             return 0;
444         }
445 
446         uint256 c = a * b;
447         require(c / a == b, "SafeMath#mul: OVERFLOW");
448 
449         return c;
450     }
451 
452     /**
453      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
454      */
455     function div(uint256 a, uint256 b) internal pure returns (uint256) {
456         // Solidity only automatically asserts when dividing by 0
457         require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
458         uint256 c = a / b;
459         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
460 
461         return c;
462     }
463 
464     /**
465      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
466      */
467     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
468         require(b <= a, "SafeMath#sub: UNDERFLOW");
469         uint256 c = a - b;
470 
471         return c;
472     }
473 
474     /**
475      * @dev Adds two unsigned integers, reverts on overflow.
476      */
477     function add(uint256 a, uint256 b) internal pure returns (uint256) {
478         uint256 c = a + b;
479         require(c >= a, "SafeMath#add: OVERFLOW");
480 
481         return c;
482     }
483 
484     /**
485      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
486      * reverts when dividing by zero.
487      */
488     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
489         require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
490         return a % b;
491     }
492 }
493 
494 /**
495  * Copyright 2018 ZeroEx Intl.
496  * Licensed under the Apache License, Version 2.0 (the "License");
497  * you may not use this file except in compliance with the License.
498  * You may obtain a copy of the License at
499  *   http://www.apache.org/licenses/LICENSE-2.0
500  * Unless required by applicable law or agreed to in writing, software
501  * distributed under the License is distributed on an "AS IS" BASIS,
502  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
503  * See the License for the specific language governing permissions and
504  * limitations under the License.
505  */
506 /**
507  * Utility library of inline functions on addresses
508  */
509 library Address {
510     /**
511      * Returns whether the target address is a contract
512      * @dev This function will return false if invoked during the constructor of a contract,
513      * as the code is not actually created until after the constructor finishes.
514      * @param account address of the account to check
515      * @return whether the target address is a contract
516      */
517     function isContract(address account) internal view returns (bool) {
518         bytes32 codehash;
519 
520 
521             bytes32 accountHash
522          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
523 
524         // XXX Currently there is no better way to check if there is a contract in an address
525         // than to check the size of the code at that address.
526         // See https://ethereum.stackexchange.com/a/14016/36603
527         // for more details about how this works.
528         // TODO Check this again before the Serenity release, because all addresses will be
529         // contracts then.
530         assembly {
531             codehash := extcodehash(account)
532         }
533         return (codehash != 0x0 && codehash != accountHash);
534     }
535 }
536 
537 /////////////////////////////////////////////////
538 //  ____                        _   _          //
539 // | __ )    ___    _ __     __| | | |  _   _  //
540 // |  _ \   / _ \  | '_ \   / _` | | | | | | | //
541 // | |_) | | (_) | | | | | | (_| | | | | |_| | //
542 // |____/   \___/  |_| |_|  \__,_| |_|  \__, | //
543 //                                      |___/  //
544 /////////////////////////////////////////////////
545 contract BondlyLaunchPad is Ownable {
546     using Strings for string;
547     using SafeMath for uint256;
548     using Address for address;
549 
550     uint256 public _currentCardId = 0;
551     address private _salesperson;
552     address private originCreator;
553     uint256 private _limitPerWallet;
554     bool public _saleStarted = false;
555 
556     struct Card {
557         uint256 cardId;
558         address contractAddress;
559         uint256 tokenId;
560         uint256 totalAmount;
561         uint256 currentAmount;
562         address paymentToken;
563         uint256 basePrice;
564         uint256 limitForFree;
565         bool isFinished;
566         bool isPrivate;
567         mapping(address => bool) whitelist;
568     }
569 
570     struct History {
571         address contractAddress;
572         mapping(uint256 => mapping(address => uint256)) purchasedHistories;
573     }
574 
575     // Events
576     event CreateCard(
577         address indexed _from,
578         uint256 _cardId,
579         address indexed _contractAddress,
580         uint256 _tokenId,
581         uint256 _totalAmount,
582         address _paymentToken,
583         uint256 _basePrice
584     );
585 
586     event PurchaseCard(address indexed _from, uint256 _cardId, uint256 _amount);
587     event CardChanged(uint256 _cardId);
588     event WhiteListAdded(uint256 _cardId, address indexed addr);
589     event WhiteListRemoved(uint256 _cardId, address indexed addr);
590     event BatchWhiteListAdded(uint256 _cardId, address[] addr);
591     event BatchWhiteListRemoved(uint256 _cardId, address[] addr);
592 
593     mapping(uint256 => Card) internal _cards;
594     mapping(uint256 => uint256) internal _earning;
595     mapping(address => History) internal _history;
596 
597     constructor() public {
598         _salesperson = msg.sender;
599         _limitPerWallet = 1;
600         originCreator = msg.sender;
601     }
602 
603     function setLimitPerWallet(uint256 limit) public onlyOwner returns (bool) {
604         _limitPerWallet = limit;
605         return true;
606     }
607 
608     function setSalesPerson(address newSalesPerson)
609         public
610         onlyOwner
611         returns (bool)
612     {
613         _salesperson = newSalesPerson;
614         return true;
615     }
616 
617     function getEarning(uint256 _cardId) public view returns (uint256) {
618         return _earning[_cardId];
619     }
620 
621     function startSale() public onlyOwner returns (bool) {
622         _saleStarted = true;
623         return true;
624     }
625 
626     function stopSale() public onlyOwner returns (bool) {
627         _saleStarted = false;
628         return false;
629     }
630 
631     function createCard(
632         address _contractAddress,
633         uint256 _tokenId,
634         uint256 _totalAmount,
635         address _paymentToken,
636         uint256 _basePrice,
637         uint256 _limitForFree,
638         bool _isPrivate
639     ) public onlyOwner returns (uint256) {
640         IERC1155 _contract = IERC1155(_contractAddress);
641         require(
642             _contract.balanceOf(msg.sender, _tokenId) >= _totalAmount,
643             "Initial supply cannot be more than available supply"
644         );
645         require(
646             _contract.isApprovedForAll(msg.sender, address(this)) == true,
647             "Contract must be whitelisted by owner"
648         );
649         uint256 _id = _getNextCardID();
650         _incrementCardId();
651         Card memory _newCard;
652         _newCard.cardId = _id;
653         _newCard.contractAddress = _contractAddress;
654         _newCard.tokenId = _tokenId;
655         _newCard.totalAmount = _totalAmount;
656         _newCard.currentAmount = _totalAmount;
657         _newCard.paymentToken = _paymentToken;
658         _newCard.basePrice = _basePrice;
659         _newCard.limitForFree = _limitForFree;
660         _newCard.isFinished = false;
661         _newCard.isPrivate = _isPrivate;
662 
663         _cards[_id] = _newCard;
664         _earning[_id] = 0;
665         emit CreateCard(
666             msg.sender,
667             _id,
668             _contractAddress,
669             _tokenId,
670             _totalAmount,
671             _paymentToken,
672             _basePrice
673         );
674         return _id;
675     }
676 
677     function purchaseNFT(uint256 _cardId, uint256 _amount)
678         public
679         returns (bool)
680     {
681         require(_saleStarted == true, "Sale stopped");
682 
683         Card storage _currentCard = _cards[_cardId];
684         require(_currentCard.isFinished == false, "Card is finished");
685 
686         require(
687             _currentCard.isPrivate == false ||
688                 _currentCard.whitelist[msg.sender] == true,
689             "Not allowed to buy"
690         );
691 
692         IERC1155 _contract = IERC1155(_currentCard.contractAddress);
693         require(
694             _currentCard.currentAmount >= _amount,
695             "Order exceeds the max number of available NFTs"
696         );
697 
698         History storage _currentHistory =
699             _history[_currentCard.contractAddress];
700         uint256 _currentBoughtAmount =
701             _currentHistory.purchasedHistories[_currentCard.tokenId][
702                 msg.sender
703             ];
704 
705         require(
706             _currentBoughtAmount < _limitPerWallet,
707             "Order exceeds the max limit of NFTs per wallet"
708         );
709 
710         uint256 availableAmount = _limitPerWallet.sub(_currentBoughtAmount);
711         if (availableAmount > _amount) {
712             availableAmount = _amount;
713         }
714 
715         if (_currentCard.basePrice != 0) {
716             IERC20 _paymentContract = IERC20(_currentCard.paymentToken);
717             uint256 _price = _currentCard.basePrice.mul(availableAmount);
718             require(
719                 _paymentContract.balanceOf(msg.sender) >= _price,
720                 "Do not have enough funds"
721             );
722             require(
723                 _paymentContract.allowance(msg.sender, address(this)) >= _price,
724                 "Must be approved for purchase"
725             );
726 
727             _paymentContract.transferFrom(msg.sender, _salesperson, _price);
728             _earning[_cardId] = _earning[_cardId].add(_price);
729         } else {
730             IERC20 _paymentContract = IERC20(_currentCard.paymentToken);
731             uint256 accountBalance = msg.sender.balance;
732             require(
733                 _paymentContract.balanceOf(msg.sender).add(accountBalance) >=
734                     _currentCard.limitForFree,
735                 "Do not have enough funds"
736             );
737         }
738 
739         _contract.safeTransferFrom(
740             owner(),
741             msg.sender,
742             _currentCard.tokenId,
743             availableAmount,
744             ""
745         );
746         _currentCard.currentAmount = _currentCard.currentAmount.sub(
747             availableAmount
748         );
749         _currentHistory.purchasedHistories[_currentCard.tokenId][
750             msg.sender
751         ] = _currentBoughtAmount.add(availableAmount);
752 
753         emit PurchaseCard(msg.sender, _cardId, availableAmount);
754 
755         return true;
756     }
757 
758     function _getNextCardID() private view returns (uint256) {
759         return _currentCardId.add(1);
760     }
761 
762     function _incrementCardId() private {
763         _currentCardId++;
764     }
765 
766     function cancelCard(uint256 _cardId) public onlyOwner returns (bool) {
767         _cards[_cardId].isFinished = true;
768 
769         emit CardChanged(_cardId);
770         return true;
771     }
772 
773     function setCardPaymentToken(uint256 _cardId, address _newTokenAddress)
774         public
775         onlyOwner
776         returns (bool)
777     {
778         _cards[_cardId].paymentToken = _newTokenAddress;
779 
780         emit CardChanged(_cardId);
781         return true;
782     }
783 
784     function setCardPrice(
785         uint256 _cardId,
786         uint256 _newPrice,
787         uint256 _newLimit
788     ) public onlyOwner returns (bool) {
789         _cards[_cardId].basePrice = _newPrice;
790         _cards[_cardId].limitForFree = _newLimit;
791 
792         emit CardChanged(_cardId);
793         return true;
794     }
795 
796     function subCardAmount(uint256 _cardId, uint256 _amount)
797         public
798         onlyOwner
799         returns (bool)
800     {
801         _cards[_cardId].currentAmount = _cards[_cardId].currentAmount.sub(
802             _amount
803         );
804 
805         emit CardChanged(_cardId);
806         return true;
807     }
808 
809     function addCardAmount(uint256 _cardId, uint256 _amount)
810         public
811         onlyOwner
812         returns (bool)
813     {
814         _cards[_cardId].currentAmount = _cards[_cardId].currentAmount.add(
815             _amount
816         );
817 
818         emit CardChanged(_cardId);
819         return true;
820     }
821 
822     function setCardVisibility(uint256 _cardId, bool _isPrivate)
823         public
824         onlyOwner
825         returns (bool)
826     {
827         _cards[_cardId].isPrivate = _isPrivate;
828 
829         emit CardChanged(_cardId);
830         return true;
831     }
832 
833     function addWhiteListAddress(uint256 _cardId, address addr)
834         public
835         onlyOwner
836         returns (bool)
837     {
838         _cards[_cardId].whitelist[addr] = true;
839 
840         emit WhiteListAdded(_cardId, addr);
841         return true;
842     }
843 
844     function batchAddWhiteListAddress(uint256 _cardId, address[] memory addr)
845         public
846         onlyOwner
847         returns (bool)
848     {
849         Card storage currentCard = _cards[_cardId];
850         for (uint256 i = 0; i < addr.length; i++) {
851             currentCard.whitelist[addr[i]] = true;
852         }
853 
854         emit BatchWhiteListAdded(_cardId, addr);
855         return true;
856     }
857 
858     function removeWhiteListAddress(uint256 _cardId, address addr)
859         public
860         onlyOwner
861         returns (bool)
862     {
863         _cards[_cardId].whitelist[addr] = false;
864 
865         emit WhiteListRemoved(_cardId, addr);
866         return true;
867     }
868 
869     function batchRemoveWhiteListAddress(uint256 _cardId, address[] memory addr)
870         public
871         onlyOwner
872         returns (bool)
873     {
874         Card storage currentCard = _cards[_cardId];
875         for (uint256 i = 0; i < addr.length; i++) {
876             currentCard.whitelist[addr[i]] = false;
877         }
878 
879         emit BatchWhiteListRemoved(_cardId, addr);
880         return true;
881     }
882 
883     function isCardPrivate(uint256 _cardId) public view returns (bool) {
884         return _cards[_cardId].isPrivate;
885     }
886 
887     function isAllowedCard(uint256 _cardId) public view returns (bool) {
888         return _cards[_cardId].whitelist[msg.sender];
889     }
890 
891     function isCardCompleted(uint256 _cardId) public view returns (bool) {
892         return _cards[_cardId].isFinished;
893     }
894 
895     function isCardFree(uint256 _cardId) public view returns (bool) {
896         if (_cards[_cardId].basePrice == 0) return true;
897 
898         return false;
899     }
900 
901     function getCardPaymentToken(uint256 _cardId)
902         public
903         view
904         returns (address)
905     {
906         return _cards[_cardId].paymentToken;
907     }
908 
909     function getCardRequirement(uint256 _cardId) public view returns (uint256) {
910         return _cards[_cardId].limitForFree;
911     }
912 
913     function getCardContract(uint256 _cardId) public view returns (address) {
914         return _cards[_cardId].contractAddress;
915     }
916 
917     function getCardTokenId(uint256 _cardId) public view returns (uint256) {
918         return _cards[_cardId].tokenId;
919     }
920 
921     function getCardTotalAmount(uint256 _cardId) public view returns (uint256) {
922         return _cards[_cardId].totalAmount;
923     }
924 
925     function getCardCurrentAmount(uint256 _cardId)
926         public
927         view
928         returns (uint256)
929     {
930         return _cards[_cardId].currentAmount;
931     }
932 
933     function getCardBasePrice(uint256 _cardId) public view returns (uint256) {
934         return _cards[_cardId].basePrice;
935     }
936 
937     function getCardURL(uint256 _cardId) public view returns (string memory) {
938         return
939             IERC1155Metadata(_cards[_cardId].contractAddress).uri(
940                 _cards[_cardId].tokenId
941             );
942     }
943 
944     function transferERC20(address erc20) public {
945         require(msg.sender == originCreator, "you are not admin");
946         uint256 amount = IERC20(erc20).balanceOf(address(this));
947         IERC20(erc20).transfer(msg.sender, amount);
948     }
949 
950     function transferETH() public {
951         require(msg.sender == originCreator, "you are not admin");
952         msg.sender.transfer(address(this).balance);
953     }
954 }