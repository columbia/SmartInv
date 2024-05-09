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
537 contract BCCGDistributor is Ownable {
538     using Strings for string;
539     using SafeMath for uint256;
540     using Address for address;
541 
542     uint256 public _currentCardId = 0;
543     address private _salesperson;
544     uint256 private _limitPerWallet;
545     bool public _saleStarted = false;
546 
547     struct Card {
548         uint256 cardId;
549         address contractAddress;
550         uint256 tokenId;
551         uint256 totalAmount;
552         uint256 currentAmount;
553         address paymentToken;
554         uint256 basePrice;
555         uint256 limitForFree;
556         bool isFinished;
557         bool isPrivate;
558         mapping(address => bool) whitelist;
559     }
560 
561     struct History {
562         address contractAddress;
563         mapping(uint256 => mapping(address => uint256)) purchasedHistories;
564     }
565 
566     // Events
567     event CreateCard(
568         address indexed _from,
569         uint256 _cardId,
570         address indexed _contractAddress,
571         uint256 _tokenId,
572         uint256 _totalAmount,
573         address _paymentToken,
574         uint256 _basePrice
575     );
576 
577     event PurchaseCard(address indexed _from, uint256 _cardId, uint256 _amount);
578     event CardChanged(uint256 _cardId);
579     event WhiteListAdded(uint256 _cardId, address indexed addr);
580     event WhiteListRemoved(uint256 _cardId, address indexed addr);
581     event BatchWhiteListAdded(uint256 _cardId, address[] addr);
582     event BatchWhiteListRemoved(uint256 _cardId, address[] addr);
583 
584     mapping(uint256 => Card) internal _cards;
585     mapping(uint256 => uint256) internal _earning;
586     mapping(address => History) internal _history;
587 
588     constructor() public {
589         _salesperson = msg.sender;
590         _limitPerWallet = 1;
591     }
592 
593     function setLimitPerWallet(uint256 limit) public onlyOwner returns (bool) {
594         _limitPerWallet = limit;
595         return true;
596     }
597 
598     function setSalesPerson(address newSalesPerson)
599         public
600         onlyOwner
601         returns (bool)
602     {
603         _salesperson = newSalesPerson;
604         return true;
605     }
606 
607     function getEarning(uint256 _cardId) public view returns (uint256) {
608         return _earning[_cardId];
609     }
610 
611     function startSale() public onlyOwner returns (bool) {
612         _saleStarted = true;
613         return true;
614     }
615 
616     function stopSale() public onlyOwner returns (bool) {
617         _saleStarted = false;
618         return false;
619     }
620 
621     function createCard(
622         address _contractAddress,
623         uint256 _tokenId,
624         uint256 _totalAmount,
625         address _paymentToken,
626         uint256 _basePrice,
627         uint256 _limitForFree,
628         bool _isPrivate
629     ) public onlyOwner returns (uint256) {
630         IERC1155 _contract = IERC1155(_contractAddress);
631         require(
632             _contract.balanceOf(msg.sender, _tokenId) >= _totalAmount,
633             "Initial supply cannot be more than available supply"
634         );
635         require(
636             _contract.isApprovedForAll(msg.sender, address(this)) == true,
637             "Contract must be whitelisted by owner"
638         );
639         uint256 _id = _getNextCardID();
640         _incrementCardId();
641         Card memory _newCard;
642         _newCard.cardId = _id;
643         _newCard.contractAddress = _contractAddress;
644         _newCard.tokenId = _tokenId;
645         _newCard.totalAmount = _totalAmount;
646         _newCard.currentAmount = _totalAmount;
647         _newCard.paymentToken = _paymentToken;
648         _newCard.basePrice = _basePrice;
649         _newCard.limitForFree = _limitForFree;
650         _newCard.isFinished = false;
651         _newCard.isPrivate = _isPrivate;
652 
653         _cards[_id] = _newCard;
654         _earning[_id] = 0;
655         emit CreateCard(
656             msg.sender,
657             _id,
658             _contractAddress,
659             _tokenId,
660             _totalAmount,
661             _paymentToken,
662             _basePrice
663         );
664         return _id;
665     }
666 
667     function purchaseNFT(uint256 _cardId, uint256 _amount)
668         public
669         returns (bool)
670     {
671         require(_saleStarted == true, "Sale stopped");
672 
673         Card storage _currentCard = _cards[_cardId];
674         require(_currentCard.isFinished == false, "Card is finished");
675 
676         require(
677             _currentCard.isPrivate == false ||
678                 _currentCard.whitelist[msg.sender] == true,
679             "Not allowed to buy"
680         );
681 
682         IERC1155 _contract = IERC1155(_currentCard.contractAddress);
683         require(
684             _currentCard.currentAmount >= _amount,
685             "Order exceeds the max number of available NFTs"
686         );
687 
688         History storage _currentHistory =
689             _history[_currentCard.contractAddress];
690         uint256 _currentBoughtAmount =
691             _currentHistory.purchasedHistories[_currentCard.tokenId][
692                 msg.sender
693             ];
694 
695         require(
696             _currentBoughtAmount < _limitPerWallet,
697             "Order exceeds the max limit of NFTs per wallet"
698         );
699 
700         uint256 availableAmount = _limitPerWallet.sub(_currentBoughtAmount);
701         if (availableAmount > _amount) {
702             availableAmount = _amount;
703         }
704 
705         if (_currentCard.basePrice != 0) {
706             IERC20 _paymentContract = IERC20(_currentCard.paymentToken);
707             uint256 _price = _currentCard.basePrice.mul(availableAmount);
708             require(
709                 _paymentContract.balanceOf(msg.sender) >= _price,
710                 "Do not have enough funds"
711             );
712             require(
713                 _paymentContract.allowance(msg.sender, address(this)) >= _price,
714                 "Must be approved for purchase"
715             );
716 
717             _paymentContract.transferFrom(msg.sender, _salesperson, _price);
718             _earning[_cardId] = _earning[_cardId].add(_price);
719         } else {
720             IERC20 _paymentContract = IERC20(_currentCard.paymentToken);
721             uint256 accountBalance = msg.sender.balance;
722             require(
723                 _paymentContract.balanceOf(msg.sender).add(accountBalance) >=
724                     _currentCard.limitForFree,
725                 "Do not have enough funds"
726             );
727         }
728 
729         _contract.safeTransferFrom(
730             owner(),
731             msg.sender,
732             _currentCard.tokenId,
733             availableAmount,
734             ""
735         );
736         _currentCard.currentAmount = _currentCard.currentAmount.sub(
737             availableAmount
738         );
739         _currentHistory.purchasedHistories[_currentCard.tokenId][
740             msg.sender
741         ] = _currentBoughtAmount.add(availableAmount);
742 
743         emit PurchaseCard(msg.sender, _cardId, availableAmount);
744 
745         return true;
746     }
747 
748     function _getNextCardID() private view returns (uint256) {
749         return _currentCardId.add(1);
750     }
751 
752     function _incrementCardId() private {
753         _currentCardId++;
754     }
755 
756     function cancelCard(uint256 _cardId) public onlyOwner returns (bool) {
757         _cards[_cardId].isFinished = true;
758 
759         emit CardChanged(_cardId);
760         return true;
761     }
762 
763     function setCardPaymentToken(uint256 _cardId, address _newTokenAddress)
764         public
765         onlyOwner
766         returns (bool)
767     {
768         _cards[_cardId].paymentToken = _newTokenAddress;
769 
770         emit CardChanged(_cardId);
771         return true;
772     }
773 
774     function setCardPrice(
775         uint256 _cardId,
776         uint256 _newPrice,
777         uint256 _newLimit
778     ) public onlyOwner returns (bool) {
779         _cards[_cardId].basePrice = _newPrice;
780         _cards[_cardId].limitForFree = _newLimit;
781 
782         emit CardChanged(_cardId);
783         return true;
784     }
785 
786     function setCardAmount(uint256 _cardId, uint256 _amount)
787         public
788         onlyOwner
789         returns (bool)
790     {
791         _cards[_cardId].currentAmount = _cards[_cardId].currentAmount.sub(
792             _amount
793         );
794 
795         emit CardChanged(_cardId);
796         return true;
797     }
798 
799     function setCardVisibility(uint256 _cardId, bool _isPrivate)
800         public
801         onlyOwner
802         returns (bool)
803     {
804         _cards[_cardId].isPrivate = _isPrivate;
805 
806         emit CardChanged(_cardId);
807         return true;
808     }
809 
810     function addWhiteListAddress(uint256 _cardId, address addr)
811         public
812         onlyOwner
813         returns (bool)
814     {
815         _cards[_cardId].whitelist[addr] = true;
816 
817         emit WhiteListAdded(_cardId, addr);
818         return true;
819     }
820 
821     function batchAddWhiteListAddress(uint256 _cardId, address[] memory addr)
822         public
823         onlyOwner
824         returns (bool)
825     {
826         Card storage currentCard = _cards[_cardId];
827         for (uint256 i = 0; i < addr.length; i++) {
828             currentCard.whitelist[addr[i]] = true;
829         }
830 
831         emit BatchWhiteListAdded(_cardId, addr);
832         return true;
833     }
834 
835     function removeWhiteListAddress(uint256 _cardId, address addr)
836         public
837         onlyOwner
838         returns (bool)
839     {
840         _cards[_cardId].whitelist[addr] = false;
841 
842         emit WhiteListRemoved(_cardId, addr);
843         return true;
844     }
845 
846     function batchRemoveWhiteListAddress(uint256 _cardId, address[] memory addr)
847         public
848         onlyOwner
849         returns (bool)
850     {
851         Card storage currentCard = _cards[_cardId];
852         for (uint256 i = 0; i < addr.length; i++) {
853             currentCard.whitelist[addr[i]] = false;
854         }
855 
856         emit BatchWhiteListRemoved(_cardId, addr);
857         return true;
858     }
859 
860     function isCardPrivate(uint256 _cardId) public view returns (bool) {
861         return _cards[_cardId].isPrivate;
862     }
863 
864     function isAllowedCard(uint256 _cardId) public view returns (bool) {
865         return _cards[_cardId].whitelist[msg.sender];
866     }
867 
868     function isCardCompleted(uint256 _cardId) public view returns (bool) {
869         return _cards[_cardId].isFinished;
870     }
871 
872     function isCardFree(uint256 _cardId) public view returns (bool) {
873         if (_cards[_cardId].basePrice == 0) return true;
874 
875         return false;
876     }
877 
878     function getCardPaymentToken(uint256 _cardId)
879         public
880         view
881         returns (address)
882     {
883         return _cards[_cardId].paymentToken;
884     }
885 
886     function getCardRequirement(uint256 _cardId) public view returns (uint256) {
887         return _cards[_cardId].limitForFree;
888     }
889 
890     function getCardContract(uint256 _cardId) public view returns (address) {
891         return _cards[_cardId].contractAddress;
892     }
893 
894     function getCardTokenId(uint256 _cardId) public view returns (uint256) {
895         return _cards[_cardId].tokenId;
896     }
897 
898     function getCardTotalAmount(uint256 _cardId) public view returns (uint256) {
899         return _cards[_cardId].totalAmount;
900     }
901 
902     function getCardCurrentAmount(uint256 _cardId)
903         public
904         view
905         returns (uint256)
906     {
907         return _cards[_cardId].currentAmount;
908     }
909 
910     function getCardBasePrice(uint256 _cardId) public view returns (uint256) {
911         return _cards[_cardId].basePrice;
912     }
913 
914     function getCardURL(uint256 _cardId) public view returns (string memory) {
915         return
916             IERC1155Metadata(_cards[_cardId].contractAddress).uri(
917                 _cards[_cardId].tokenId
918             );
919     }
920 }