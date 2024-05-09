1 pragma solidity ^0.4.23;
2 
3 // File: contracts/ParsecReferralTracking.sol
4 
5 contract ParsecReferralTracking {
6   mapping (address => address) public referrer;
7 
8   event ReferrerUpdated(address indexed _referee, address indexed _referrer);
9 
10   function _updateReferrerFor(address _referee, address _referrer) internal {
11     if (_referrer != address(0) && _referrer != _referee) {
12       referrer[_referee] = _referrer;
13       emit ReferrerUpdated(_referee, _referrer);
14     }
15   }
16 }
17 
18 // File: contracts/ParsecShipInfo.sol
19 
20 contract ParsecShipInfo {
21   uint256 public constant TOTAL_SHIP = 900;
22   uint256 public constant TOTAL_ARK = 100;
23   uint256 public constant TOTAL_HAWKING = 400;
24   uint256 public constant TOTAL_SATOSHI = 400;
25 
26   uint256 public constant NAME_NOT_AVAILABLE = 0;
27   uint256 public constant NAME_ARK = 1;
28   uint256 public constant NAME_HAWKING = 2;
29   uint256 public constant NAME_SATOSHI = 3;
30 
31   uint256 public constant TYPE_NOT_AVAILABLE = 0;
32   uint256 public constant TYPE_EXPLORER_FREIGHTER = 1;
33   uint256 public constant TYPE_EXPLORER = 2;
34   uint256 public constant TYPE_FREIGHTER = 3;
35 
36   uint256 public constant COLOR_NOT_AVAILABLE = 0;
37   uint256 public constant COLOR_CUSTOM = 1;
38   uint256 public constant COLOR_BLACK = 2;
39   uint256 public constant COLOR_BLUE = 3;
40   uint256 public constant COLOR_BROWN = 4;
41   uint256 public constant COLOR_GOLD = 5;
42   uint256 public constant COLOR_GREEN = 6;
43   uint256 public constant COLOR_GREY = 7;
44   uint256 public constant COLOR_PINK = 8;
45   uint256 public constant COLOR_RED = 9;
46   uint256 public constant COLOR_SILVER = 10;
47   uint256 public constant COLOR_WHITE = 11;
48   uint256 public constant COLOR_YELLOW = 12;
49 
50   function getShip(uint256 _shipId)
51     external
52     pure
53     returns (
54       uint256 /* _name */,
55       uint256 /* _type */,
56       uint256 /* _color */
57     )
58   {
59     return (
60       _getShipName(_shipId),
61       _getShipType(_shipId),
62       _getShipColor(_shipId)
63     );
64   }
65 
66   function _getShipName(uint256 _shipId) internal pure returns (uint256 /* _name */) {
67     if (_shipId < 1) {
68       return NAME_NOT_AVAILABLE;
69     } else if (_shipId <= TOTAL_ARK) {
70       return NAME_ARK;
71     } else if (_shipId <= TOTAL_ARK + TOTAL_HAWKING) {
72       return NAME_HAWKING;
73     } else if (_shipId <= TOTAL_SHIP) {
74       return NAME_SATOSHI;
75     } else {
76       return NAME_NOT_AVAILABLE;
77     }
78   }
79 
80   function _getShipType(uint256 _shipId) internal pure returns (uint256 /* _type */) {
81     if (_shipId < 1) {
82       return TYPE_NOT_AVAILABLE;
83     } else if (_shipId <= TOTAL_ARK) {
84       return TYPE_EXPLORER_FREIGHTER;
85     } else if (_shipId <= TOTAL_ARK + TOTAL_HAWKING) {
86       return TYPE_EXPLORER;
87     } else if (_shipId <= TOTAL_SHIP) {
88       return TYPE_FREIGHTER;
89     } else {
90       return TYPE_NOT_AVAILABLE;
91     }
92   }
93 
94   function _getShipColor(uint256 _shipId) internal pure returns (uint256 /* _color */) {
95     if (_shipId < 1) {
96       return COLOR_NOT_AVAILABLE;
97     } else if (_shipId == 1) {
98       return COLOR_CUSTOM;
99     } else if (_shipId <= 23) {
100       return COLOR_BLACK;
101     } else if (_shipId <= 37) {
102       return COLOR_BLUE;
103     } else if (_shipId <= 42) {
104       return COLOR_BROWN;
105     } else if (_shipId <= 45) {
106       return COLOR_GOLD;
107     } else if (_shipId <= 49) {
108       return COLOR_GREEN;
109     } else if (_shipId <= 64) {
110       return COLOR_GREY;
111     } else if (_shipId <= 67) {
112       return COLOR_PINK;
113     } else if (_shipId <= 77) {
114       return COLOR_RED;
115     } else if (_shipId <= 83) {
116       return COLOR_SILVER;
117     } else if (_shipId <= 93) {
118       return COLOR_WHITE;
119     } else if (_shipId <= 100) {
120       return COLOR_YELLOW;
121     } else if (_shipId <= 140) {
122       return COLOR_BLACK;
123     } else if (_shipId <= 200) {
124       return COLOR_BLUE;
125     } else if (_shipId <= 237) {
126       return COLOR_BROWN;
127     } else if (_shipId <= 247) {
128       return COLOR_GOLD;
129     } else if (_shipId <= 330) {
130       return COLOR_GREEN;
131     } else if (_shipId <= 370) {
132       return COLOR_GREY;
133     } else if (_shipId <= 380) {
134       return COLOR_PINK;
135     } else if (_shipId <= 440) {
136       return COLOR_RED;
137     } else if (_shipId <= 460) {
138       return COLOR_SILVER;
139     } else if (_shipId <= 500) {
140       return COLOR_WHITE;
141     } else if (_shipId <= 540) {
142       return COLOR_BLACK;
143     } else if (_shipId <= 600) {
144       return COLOR_BLUE;
145     } else if (_shipId <= 637) {
146       return COLOR_BROWN;
147     } else if (_shipId <= 647) {
148       return COLOR_GOLD;
149     } else if (_shipId <= 730) {
150       return COLOR_GREEN;
151     } else if (_shipId <= 770) {
152       return COLOR_GREY;
153     } else if (_shipId <= 780) {
154       return COLOR_PINK;
155     } else if (_shipId <= 840) {
156       return COLOR_RED;
157     } else if (_shipId <= 860) {
158       return COLOR_SILVER;
159     } else if (_shipId <= TOTAL_SHIP) {
160       return COLOR_WHITE;
161     } else {
162       return COLOR_NOT_AVAILABLE;
163     }
164   }
165 }
166 
167 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
168 
169 /**
170  * @title SafeMath
171  * @dev Math operations with safety checks that throw on error
172  */
173 library SafeMath {
174 
175   /**
176   * @dev Multiplies two numbers, throws on overflow.
177   */
178   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
179     if (a == 0) {
180       return 0;
181     }
182     c = a * b;
183     assert(c / a == b);
184     return c;
185   }
186 
187   /**
188   * @dev Integer division of two numbers, truncating the quotient.
189   */
190   function div(uint256 a, uint256 b) internal pure returns (uint256) {
191     // assert(b > 0); // Solidity automatically throws when dividing by 0
192     // uint256 c = a / b;
193     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194     return a / b;
195   }
196 
197   /**
198   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
199   */
200   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201     assert(b <= a);
202     return a - b;
203   }
204 
205   /**
206   * @dev Adds two numbers, throws on overflow.
207   */
208   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
209     c = a + b;
210     assert(c >= a);
211     return c;
212   }
213 }
214 
215 // File: contracts/ParsecShipPricing.sol
216 
217 contract ParsecShipPricing {
218   using SafeMath for uint256;
219 
220   uint256 public constant TOTAL_PARSEC_CREDIT_SUPPLY = 30856775800000000;
221 
222   // Starting with 30,856,775,800,000,000 (total supply of Parsec Credit, including 6 decimals),
223   // each time we multiply the number we have with 0.9995. These are results:
224   // 1: 30841347412100000
225   // 2: 30825926738393950
226   // 4: 30795108518137240.6484875
227   // 8: 30733564478368113.80826526098454678
228   // 16: 30610845140405444.1555510982248498
229   // 32: 30366874565355062.01905741115048326
230   // 64: 29884751305352135.55319509943479229
231   // 128: 28943346718121670.05118183115407839
232   // 256: 27148569399315026.57115329246779589
233   // 512: 23885995905943752.64119680273916152
234   // 1024: 18489968106737895.55394216521160879
235   // 2048: 11079541258752787.70222144092290365
236   // 4096: 3978258626243293.616409580784511455
237   // 8192: 512903285808596.2996925781077178762
238   // 16384: 8525510970373.470528186667481043039
239   // 32768: 2355538951.219861249087266462563245
240   // 65536: 179.8167049816644768546906209889074
241   // 75918: 0.9996399085102312393019871402909541
242 
243   uint256[18] private _multipliers = [
244     30841347412100000,
245     30825926738393950,
246     307951085181372406484875,
247     3073356447836811380826526098454678,
248     306108451404054441555510982248498,
249     3036687456535506201905741115048326,
250     2988475130535213555319509943479229,
251     2894334671812167005118183115407839,
252     2714856939931502657115329246779589,
253     2388599590594375264119680273916152,
254     1848996810673789555394216521160879,
255     1107954125875278770222144092290365,
256     3978258626243293616409580784511455,
257     5129032858085962996925781077178762,
258     8525510970373470528186667481043039,
259     2355538951219861249087266462563245,
260     1798167049816644768546906209889074
261   ];
262 
263   uint256[18] private _decimals = [
264     0, 0, 7, 17, 16,
265     17, 17, 17, 17, 17,
266     17, 17, 18, 19, 21,
267     24, 31
268   ];
269 
270   function _getShipPrice(
271     uint256 _initialPrice,
272     uint256 _minutesPassed
273   )
274     internal
275     view
276     returns (uint256 /* _price */)
277   {
278     require(
279       _initialPrice <= TOTAL_PARSEC_CREDIT_SUPPLY,
280       "Initial ship price must not be greater than total Parsec Credit."
281     );
282 
283     if (_minutesPassed >> _multipliers.length > 0) {
284       return 0;
285     }
286 
287     uint256 _price = _initialPrice;
288 
289     for (uint256 _powerOfTwo = 0; _powerOfTwo < _multipliers.length; _powerOfTwo++) {
290       if (_minutesPassed >> _powerOfTwo & 1 > 0) {
291         _price = _price
292           .mul(_multipliers[_powerOfTwo])
293           .div(TOTAL_PARSEC_CREDIT_SUPPLY)
294           .div(10 ** _decimals[_powerOfTwo]);
295       }
296     }
297 
298     return _price;
299   }
300 }
301 
302 // File: contracts/TokenRecipient.sol
303 
304 interface TokenRecipient {
305   function receiveApproval(
306     address _from,
307     uint256 _value,
308     address _token,
309     bytes _extraData
310   )
311     external;
312 }
313 
314 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
315 
316 /**
317  * @title Ownable
318  * @dev The Ownable contract has an owner address, and provides basic authorization control
319  * functions, this simplifies the implementation of "user permissions".
320  */
321 contract Ownable {
322   address public owner;
323 
324 
325   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327 
328   /**
329    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
330    * account.
331    */
332   function Ownable() public {
333     owner = msg.sender;
334   }
335 
336   /**
337    * @dev Throws if called by any account other than the owner.
338    */
339   modifier onlyOwner() {
340     require(msg.sender == owner);
341     _;
342   }
343 
344   /**
345    * @dev Allows the current owner to transfer control of the contract to a newOwner.
346    * @param newOwner The address to transfer ownership to.
347    */
348   function transferOwnership(address newOwner) public onlyOwner {
349     require(newOwner != address(0));
350     emit OwnershipTransferred(owner, newOwner);
351     owner = newOwner;
352   }
353 
354 }
355 
356 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
357 
358 /**
359  * @title Pausable
360  * @dev Base contract which allows children to implement an emergency stop mechanism.
361  */
362 contract Pausable is Ownable {
363   event Pause();
364   event Unpause();
365 
366   bool public paused = false;
367 
368 
369   /**
370    * @dev Modifier to make a function callable only when the contract is not paused.
371    */
372   modifier whenNotPaused() {
373     require(!paused);
374     _;
375   }
376 
377   /**
378    * @dev Modifier to make a function callable only when the contract is paused.
379    */
380   modifier whenPaused() {
381     require(paused);
382     _;
383   }
384 
385   /**
386    * @dev called by the owner to pause, triggers stopped state
387    */
388   function pause() onlyOwner whenNotPaused public {
389     paused = true;
390     emit Pause();
391   }
392 
393   /**
394    * @dev called by the owner to unpause, returns to normal state
395    */
396   function unpause() onlyOwner whenPaused public {
397     paused = false;
398     emit Unpause();
399   }
400 }
401 
402 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
403 
404 /**
405  * @title ERC20Basic
406  * @dev Simpler version of ERC20 interface
407  * @dev see https://github.com/ethereum/EIPs/issues/179
408  */
409 contract ERC20Basic {
410   function totalSupply() public view returns (uint256);
411   function balanceOf(address who) public view returns (uint256);
412   function transfer(address to, uint256 value) public returns (bool);
413   event Transfer(address indexed from, address indexed to, uint256 value);
414 }
415 
416 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
417 
418 /**
419  * @title ERC20 interface
420  * @dev see https://github.com/ethereum/EIPs/issues/20
421  */
422 contract ERC20 is ERC20Basic {
423   function allowance(address owner, address spender) public view returns (uint256);
424   function transferFrom(address from, address to, uint256 value) public returns (bool);
425   function approve(address spender, uint256 value) public returns (bool);
426   event Approval(address indexed owner, address indexed spender, uint256 value);
427 }
428 
429 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
430 
431 /**
432  * @title ERC721 Non-Fungible Token Standard basic interface
433  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
434  */
435 contract ERC721Basic {
436   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
437   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
438   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
439 
440   function balanceOf(address _owner) public view returns (uint256 _balance);
441   function ownerOf(uint256 _tokenId) public view returns (address _owner);
442   function exists(uint256 _tokenId) public view returns (bool _exists);
443 
444   function approve(address _to, uint256 _tokenId) public;
445   function getApproved(uint256 _tokenId) public view returns (address _operator);
446 
447   function setApprovalForAll(address _operator, bool _approved) public;
448   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
449 
450   function transferFrom(address _from, address _to, uint256 _tokenId) public;
451   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
452   function safeTransferFrom(
453     address _from,
454     address _to,
455     uint256 _tokenId,
456     bytes _data
457   )
458     public;
459 }
460 
461 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
462 
463 /**
464  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
465  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
466  */
467 contract ERC721Enumerable is ERC721Basic {
468   function totalSupply() public view returns (uint256);
469   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
470   function tokenByIndex(uint256 _index) public view returns (uint256);
471 }
472 
473 
474 /**
475  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
476  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
477  */
478 contract ERC721Metadata is ERC721Basic {
479   function name() public view returns (string _name);
480   function symbol() public view returns (string _symbol);
481   function tokenURI(uint256 _tokenId) public view returns (string);
482 }
483 
484 
485 /**
486  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
487  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
488  */
489 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
490 }
491 
492 // File: openzeppelin-solidity/contracts/AddressUtils.sol
493 
494 /**
495  * Utility library of inline functions on addresses
496  */
497 library AddressUtils {
498 
499   /**
500    * Returns whether the target address is a contract
501    * @dev This function will return false if invoked during the constructor of a contract,
502    *  as the code is not actually created until after the constructor finishes.
503    * @param addr address to check
504    * @return whether the target address is a contract
505    */
506   function isContract(address addr) internal view returns (bool) {
507     uint256 size;
508     // XXX Currently there is no better way to check if there is a contract in an address
509     // than to check the size of the code at that address.
510     // See https://ethereum.stackexchange.com/a/14016/36603
511     // for more details about how this works.
512     // TODO Check this again before the Serenity release, because all addresses will be
513     // contracts then.
514     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
515     return size > 0;
516   }
517 
518 }
519 
520 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
521 
522 /**
523  * @title ERC721 token receiver interface
524  * @dev Interface for any contract that wants to support safeTransfers
525  *  from ERC721 asset contracts.
526  */
527 contract ERC721Receiver {
528   /**
529    * @dev Magic value to be returned upon successful reception of an NFT
530    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
531    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
532    */
533   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
534 
535   /**
536    * @notice Handle the receipt of an NFT
537    * @dev The ERC721 smart contract calls this function on the recipient
538    *  after a `safetransfer`. This function MAY throw to revert and reject the
539    *  transfer. This function MUST use 50,000 gas or less. Return of other
540    *  than the magic value MUST result in the transaction being reverted.
541    *  Note: the contract address is always the message sender.
542    * @param _from The sending address
543    * @param _tokenId The NFT identifier which is being transfered
544    * @param _data Additional data with no specified format
545    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
546    */
547   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
548 }
549 
550 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
551 
552 /**
553  * @title ERC721 Non-Fungible Token Standard basic implementation
554  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
555  */
556 contract ERC721BasicToken is ERC721Basic {
557   using SafeMath for uint256;
558   using AddressUtils for address;
559 
560   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
561   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
562   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
563 
564   // Mapping from token ID to owner
565   mapping (uint256 => address) internal tokenOwner;
566 
567   // Mapping from token ID to approved address
568   mapping (uint256 => address) internal tokenApprovals;
569 
570   // Mapping from owner to number of owned token
571   mapping (address => uint256) internal ownedTokensCount;
572 
573   // Mapping from owner to operator approvals
574   mapping (address => mapping (address => bool)) internal operatorApprovals;
575 
576   /**
577    * @dev Guarantees msg.sender is owner of the given token
578    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
579    */
580   modifier onlyOwnerOf(uint256 _tokenId) {
581     require(ownerOf(_tokenId) == msg.sender);
582     _;
583   }
584 
585   /**
586    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
587    * @param _tokenId uint256 ID of the token to validate
588    */
589   modifier canTransfer(uint256 _tokenId) {
590     require(isApprovedOrOwner(msg.sender, _tokenId));
591     _;
592   }
593 
594   /**
595    * @dev Gets the balance of the specified address
596    * @param _owner address to query the balance of
597    * @return uint256 representing the amount owned by the passed address
598    */
599   function balanceOf(address _owner) public view returns (uint256) {
600     require(_owner != address(0));
601     return ownedTokensCount[_owner];
602   }
603 
604   /**
605    * @dev Gets the owner of the specified token ID
606    * @param _tokenId uint256 ID of the token to query the owner of
607    * @return owner address currently marked as the owner of the given token ID
608    */
609   function ownerOf(uint256 _tokenId) public view returns (address) {
610     address owner = tokenOwner[_tokenId];
611     require(owner != address(0));
612     return owner;
613   }
614 
615   /**
616    * @dev Returns whether the specified token exists
617    * @param _tokenId uint256 ID of the token to query the existance of
618    * @return whether the token exists
619    */
620   function exists(uint256 _tokenId) public view returns (bool) {
621     address owner = tokenOwner[_tokenId];
622     return owner != address(0);
623   }
624 
625   /**
626    * @dev Approves another address to transfer the given token ID
627    * @dev The zero address indicates there is no approved address.
628    * @dev There can only be one approved address per token at a given time.
629    * @dev Can only be called by the token owner or an approved operator.
630    * @param _to address to be approved for the given token ID
631    * @param _tokenId uint256 ID of the token to be approved
632    */
633   function approve(address _to, uint256 _tokenId) public {
634     address owner = ownerOf(_tokenId);
635     require(_to != owner);
636     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
637 
638     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
639       tokenApprovals[_tokenId] = _to;
640       emit Approval(owner, _to, _tokenId);
641     }
642   }
643 
644   /**
645    * @dev Gets the approved address for a token ID, or zero if no address set
646    * @param _tokenId uint256 ID of the token to query the approval of
647    * @return address currently approved for a the given token ID
648    */
649   function getApproved(uint256 _tokenId) public view returns (address) {
650     return tokenApprovals[_tokenId];
651   }
652 
653   /**
654    * @dev Sets or unsets the approval of a given operator
655    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
656    * @param _to operator address to set the approval
657    * @param _approved representing the status of the approval to be set
658    */
659   function setApprovalForAll(address _to, bool _approved) public {
660     require(_to != msg.sender);
661     operatorApprovals[msg.sender][_to] = _approved;
662     emit ApprovalForAll(msg.sender, _to, _approved);
663   }
664 
665   /**
666    * @dev Tells whether an operator is approved by a given owner
667    * @param _owner owner address which you want to query the approval of
668    * @param _operator operator address which you want to query the approval of
669    * @return bool whether the given operator is approved by the given owner
670    */
671   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
672     return operatorApprovals[_owner][_operator];
673   }
674 
675   /**
676    * @dev Transfers the ownership of a given token ID to another address
677    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
678    * @dev Requires the msg sender to be the owner, approved, or operator
679    * @param _from current owner of the token
680    * @param _to address to receive the ownership of the given token ID
681    * @param _tokenId uint256 ID of the token to be transferred
682   */
683   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
684     require(_from != address(0));
685     require(_to != address(0));
686 
687     clearApproval(_from, _tokenId);
688     removeTokenFrom(_from, _tokenId);
689     addTokenTo(_to, _tokenId);
690 
691     emit Transfer(_from, _to, _tokenId);
692   }
693 
694   /**
695    * @dev Safely transfers the ownership of a given token ID to another address
696    * @dev If the target address is a contract, it must implement `onERC721Received`,
697    *  which is called upon a safe transfer, and return the magic value
698    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
699    *  the transfer is reverted.
700    * @dev Requires the msg sender to be the owner, approved, or operator
701    * @param _from current owner of the token
702    * @param _to address to receive the ownership of the given token ID
703    * @param _tokenId uint256 ID of the token to be transferred
704   */
705   function safeTransferFrom(
706     address _from,
707     address _to,
708     uint256 _tokenId
709   )
710     public
711     canTransfer(_tokenId)
712   {
713     // solium-disable-next-line arg-overflow
714     safeTransferFrom(_from, _to, _tokenId, "");
715   }
716 
717   /**
718    * @dev Safely transfers the ownership of a given token ID to another address
719    * @dev If the target address is a contract, it must implement `onERC721Received`,
720    *  which is called upon a safe transfer, and return the magic value
721    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
722    *  the transfer is reverted.
723    * @dev Requires the msg sender to be the owner, approved, or operator
724    * @param _from current owner of the token
725    * @param _to address to receive the ownership of the given token ID
726    * @param _tokenId uint256 ID of the token to be transferred
727    * @param _data bytes data to send along with a safe transfer check
728    */
729   function safeTransferFrom(
730     address _from,
731     address _to,
732     uint256 _tokenId,
733     bytes _data
734   )
735     public
736     canTransfer(_tokenId)
737   {
738     transferFrom(_from, _to, _tokenId);
739     // solium-disable-next-line arg-overflow
740     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
741   }
742 
743   /**
744    * @dev Returns whether the given spender can transfer a given token ID
745    * @param _spender address of the spender to query
746    * @param _tokenId uint256 ID of the token to be transferred
747    * @return bool whether the msg.sender is approved for the given token ID,
748    *  is an operator of the owner, or is the owner of the token
749    */
750   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
751     address owner = ownerOf(_tokenId);
752     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
753   }
754 
755   /**
756    * @dev Internal function to mint a new token
757    * @dev Reverts if the given token ID already exists
758    * @param _to The address that will own the minted token
759    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
760    */
761   function _mint(address _to, uint256 _tokenId) internal {
762     require(_to != address(0));
763     addTokenTo(_to, _tokenId);
764     emit Transfer(address(0), _to, _tokenId);
765   }
766 
767   /**
768    * @dev Internal function to burn a specific token
769    * @dev Reverts if the token does not exist
770    * @param _tokenId uint256 ID of the token being burned by the msg.sender
771    */
772   function _burn(address _owner, uint256 _tokenId) internal {
773     clearApproval(_owner, _tokenId);
774     removeTokenFrom(_owner, _tokenId);
775     emit Transfer(_owner, address(0), _tokenId);
776   }
777 
778   /**
779    * @dev Internal function to clear current approval of a given token ID
780    * @dev Reverts if the given address is not indeed the owner of the token
781    * @param _owner owner of the token
782    * @param _tokenId uint256 ID of the token to be transferred
783    */
784   function clearApproval(address _owner, uint256 _tokenId) internal {
785     require(ownerOf(_tokenId) == _owner);
786     if (tokenApprovals[_tokenId] != address(0)) {
787       tokenApprovals[_tokenId] = address(0);
788       emit Approval(_owner, address(0), _tokenId);
789     }
790   }
791 
792   /**
793    * @dev Internal function to add a token ID to the list of a given address
794    * @param _to address representing the new owner of the given token ID
795    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
796    */
797   function addTokenTo(address _to, uint256 _tokenId) internal {
798     require(tokenOwner[_tokenId] == address(0));
799     tokenOwner[_tokenId] = _to;
800     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
801   }
802 
803   /**
804    * @dev Internal function to remove a token ID from the list of a given address
805    * @param _from address representing the previous owner of the given token ID
806    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
807    */
808   function removeTokenFrom(address _from, uint256 _tokenId) internal {
809     require(ownerOf(_tokenId) == _from);
810     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
811     tokenOwner[_tokenId] = address(0);
812   }
813 
814   /**
815    * @dev Internal function to invoke `onERC721Received` on a target address
816    * @dev The call is not executed if the target address is not a contract
817    * @param _from address representing the previous owner of the given token ID
818    * @param _to target address that will receive the tokens
819    * @param _tokenId uint256 ID of the token to be transferred
820    * @param _data bytes optional data to send along with the call
821    * @return whether the call correctly returned the expected magic value
822    */
823   function checkAndCallSafeTransfer(
824     address _from,
825     address _to,
826     uint256 _tokenId,
827     bytes _data
828   )
829     internal
830     returns (bool)
831   {
832     if (!_to.isContract()) {
833       return true;
834     }
835     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
836     return (retval == ERC721_RECEIVED);
837   }
838 }
839 
840 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
841 
842 /**
843  * @title Full ERC721 Token
844  * This implementation includes all the required and some optional functionality of the ERC721 standard
845  * Moreover, it includes approve all functionality using operator terminology
846  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
847  */
848 contract ERC721Token is ERC721, ERC721BasicToken {
849   // Token name
850   string internal name_;
851 
852   // Token symbol
853   string internal symbol_;
854 
855   // Mapping from owner to list of owned token IDs
856   mapping (address => uint256[]) internal ownedTokens;
857 
858   // Mapping from token ID to index of the owner tokens list
859   mapping(uint256 => uint256) internal ownedTokensIndex;
860 
861   // Array with all token ids, used for enumeration
862   uint256[] internal allTokens;
863 
864   // Mapping from token id to position in the allTokens array
865   mapping(uint256 => uint256) internal allTokensIndex;
866 
867   // Optional mapping for token URIs
868   mapping(uint256 => string) internal tokenURIs;
869 
870   /**
871    * @dev Constructor function
872    */
873   function ERC721Token(string _name, string _symbol) public {
874     name_ = _name;
875     symbol_ = _symbol;
876   }
877 
878   /**
879    * @dev Gets the token name
880    * @return string representing the token name
881    */
882   function name() public view returns (string) {
883     return name_;
884   }
885 
886   /**
887    * @dev Gets the token symbol
888    * @return string representing the token symbol
889    */
890   function symbol() public view returns (string) {
891     return symbol_;
892   }
893 
894   /**
895    * @dev Returns an URI for a given token ID
896    * @dev Throws if the token ID does not exist. May return an empty string.
897    * @param _tokenId uint256 ID of the token to query
898    */
899   function tokenURI(uint256 _tokenId) public view returns (string) {
900     require(exists(_tokenId));
901     return tokenURIs[_tokenId];
902   }
903 
904   /**
905    * @dev Gets the token ID at a given index of the tokens list of the requested owner
906    * @param _owner address owning the tokens list to be accessed
907    * @param _index uint256 representing the index to be accessed of the requested tokens list
908    * @return uint256 token ID at the given index of the tokens list owned by the requested address
909    */
910   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
911     require(_index < balanceOf(_owner));
912     return ownedTokens[_owner][_index];
913   }
914 
915   /**
916    * @dev Gets the total amount of tokens stored by the contract
917    * @return uint256 representing the total amount of tokens
918    */
919   function totalSupply() public view returns (uint256) {
920     return allTokens.length;
921   }
922 
923   /**
924    * @dev Gets the token ID at a given index of all the tokens in this contract
925    * @dev Reverts if the index is greater or equal to the total number of tokens
926    * @param _index uint256 representing the index to be accessed of the tokens list
927    * @return uint256 token ID at the given index of the tokens list
928    */
929   function tokenByIndex(uint256 _index) public view returns (uint256) {
930     require(_index < totalSupply());
931     return allTokens[_index];
932   }
933 
934   /**
935    * @dev Internal function to set the token URI for a given token
936    * @dev Reverts if the token ID does not exist
937    * @param _tokenId uint256 ID of the token to set its URI
938    * @param _uri string URI to assign
939    */
940   function _setTokenURI(uint256 _tokenId, string _uri) internal {
941     require(exists(_tokenId));
942     tokenURIs[_tokenId] = _uri;
943   }
944 
945   /**
946    * @dev Internal function to add a token ID to the list of a given address
947    * @param _to address representing the new owner of the given token ID
948    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
949    */
950   function addTokenTo(address _to, uint256 _tokenId) internal {
951     super.addTokenTo(_to, _tokenId);
952     uint256 length = ownedTokens[_to].length;
953     ownedTokens[_to].push(_tokenId);
954     ownedTokensIndex[_tokenId] = length;
955   }
956 
957   /**
958    * @dev Internal function to remove a token ID from the list of a given address
959    * @param _from address representing the previous owner of the given token ID
960    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
961    */
962   function removeTokenFrom(address _from, uint256 _tokenId) internal {
963     super.removeTokenFrom(_from, _tokenId);
964 
965     uint256 tokenIndex = ownedTokensIndex[_tokenId];
966     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
967     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
968 
969     ownedTokens[_from][tokenIndex] = lastToken;
970     ownedTokens[_from][lastTokenIndex] = 0;
971     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
972     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
973     // the lastToken to the first position, and then dropping the element placed in the last position of the list
974 
975     ownedTokens[_from].length--;
976     ownedTokensIndex[_tokenId] = 0;
977     ownedTokensIndex[lastToken] = tokenIndex;
978   }
979 
980   /**
981    * @dev Internal function to mint a new token
982    * @dev Reverts if the given token ID already exists
983    * @param _to address the beneficiary that will own the minted token
984    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
985    */
986   function _mint(address _to, uint256 _tokenId) internal {
987     super._mint(_to, _tokenId);
988 
989     allTokensIndex[_tokenId] = allTokens.length;
990     allTokens.push(_tokenId);
991   }
992 
993   /**
994    * @dev Internal function to burn a specific token
995    * @dev Reverts if the token does not exist
996    * @param _owner owner of the token to burn
997    * @param _tokenId uint256 ID of the token being burned by the msg.sender
998    */
999   function _burn(address _owner, uint256 _tokenId) internal {
1000     super._burn(_owner, _tokenId);
1001 
1002     // Clear metadata (if any)
1003     if (bytes(tokenURIs[_tokenId]).length != 0) {
1004       delete tokenURIs[_tokenId];
1005     }
1006 
1007     // Reorg all tokens array
1008     uint256 tokenIndex = allTokensIndex[_tokenId];
1009     uint256 lastTokenIndex = allTokens.length.sub(1);
1010     uint256 lastToken = allTokens[lastTokenIndex];
1011 
1012     allTokens[tokenIndex] = lastToken;
1013     allTokens[lastTokenIndex] = 0;
1014 
1015     allTokens.length--;
1016     allTokensIndex[_tokenId] = 0;
1017     allTokensIndex[lastToken] = tokenIndex;
1018   }
1019 
1020 }
1021 
1022 // File: contracts/ParsecShipAuction.sol
1023 
1024 // solium-disable-next-line lbrace
1025 contract ParsecShipAuction is
1026   ERC721Token("Parsec Initial Ship", "PIS"),
1027   ParsecShipInfo,
1028   ParsecShipPricing,
1029   ParsecReferralTracking,
1030   Ownable,
1031   Pausable
1032 {
1033   uint256 public constant PARSEC_CREDIT_DECIMALS = 6;
1034 
1035   uint256 public constant FIRST_AUCTIONS_MINIMUM_RAISE = 2 * uint256(10) ** (5 + PARSEC_CREDIT_DECIMALS);
1036 
1037   uint256 public constant SECOND_AUCTIONS_INITIAL_PERCENTAGE = 50;
1038   uint256 public constant LATER_AUCTIONS_INITIAL_PERCENTAGE = 125;
1039 
1040   uint256 public constant REFERRAL_REWARD_PERCENTAGE = 20;
1041 
1042   ERC20 public parsecCreditContract = ERC20(0x4373D59176891dA98CA6faaa86bd387fc9e12b6E);
1043 
1044   // May 15th, 2018 – 16:00 UTC
1045   uint256 public firstAuctionsStartDate = 1526400000;
1046 
1047   uint256 public firstAuctionsInitialDuration = 48 hours;
1048   uint256 public firstAuctionsExtendableDuration = 12 hours;
1049 
1050   uint256 public firstAuctionsExtendedChunkDuration = 1 hours;
1051   uint256 public firstAuctionsExtendedDuration = 0;
1052 
1053   uint256 public firstAuctionsHighestBid = uint256(10) ** (6 + PARSEC_CREDIT_DECIMALS);
1054   address public firstAuctionsHighestBidder = address(0);
1055   address public firstAuctionsReferrer;
1056   bool public firstAuctionConcluded = false;
1057 
1058   uint256 private _lastAuctionedShipId = 0;
1059   uint256 private _lastAuctionsWinningBid;
1060   uint256 private _lastAuctionWinsDate;
1061 
1062   event FirstShipBidded(
1063     address indexed _bidder,
1064     uint256 _value,
1065     address indexed _referrer
1066   );
1067 
1068   event LaterShipBidded(
1069     uint256 indexed _shipId,
1070     address indexed _winner,
1071     uint256 _value,
1072     address indexed _referrer
1073   );
1074 
1075   function receiveApproval(
1076     address _from,
1077     uint256 _value,
1078     address _token,
1079     bytes _extraData
1080   )
1081     external
1082     whenNotPaused
1083   {
1084     require(_token == address(parsecCreditContract));
1085     require(_extraData.length == 64);
1086 
1087     uint256 _shipId;
1088     address _referrer;
1089 
1090     // solium-disable-next-line security/no-inline-assembly
1091     assembly {
1092       _shipId := calldataload(164)
1093       _referrer := calldataload(196)
1094     }
1095 
1096     if (_shipId == 1) {
1097       _bidFirstShip(_value, _from, _referrer);
1098     } else {
1099       _bidLaterShip(_shipId, _value, _from, _referrer);
1100     }
1101   }
1102 
1103   function getFirstAuctionsRemainingDuration() external view returns (uint256 /* _duration */) {
1104     uint256 _currentDate = now;
1105     uint256 _endDate = getFirstAuctionsEndDate();
1106 
1107     if (_endDate >= _currentDate) {
1108       return _endDate - _currentDate;
1109     } else {
1110       return 0;
1111     }
1112   }
1113 
1114   function concludeFirstAuction() external {
1115     require(getLastAuctionedShipId() >= 1, "The first auction must have ended.");
1116     require(!firstAuctionConcluded, "The first auction must not have been concluded.");
1117 
1118     firstAuctionConcluded = true;
1119 
1120     if (firstAuctionsHighestBidder != address(0)) {
1121       _mint(firstAuctionsHighestBidder, 1);
1122 
1123       if (firstAuctionsReferrer != address(0)) {
1124         _sendTo(
1125           firstAuctionsReferrer,
1126           firstAuctionsHighestBid.mul(REFERRAL_REWARD_PERCENTAGE).div(100)
1127         );
1128       }
1129     } else {
1130       _mint(owner, 1);
1131     }
1132   }
1133 
1134   function getFirstAuctionsExtendableStartDate() public view returns (uint256 /* _extendableStartDate */) {
1135     return firstAuctionsStartDate
1136       // solium-disable indentation
1137       .add(firstAuctionsInitialDuration)
1138       .sub(firstAuctionsExtendableDuration);
1139       // solium-enable indentation
1140   }
1141 
1142   function getFirstAuctionsEndDate() public view returns (uint256 /* _endDate */) {
1143     return firstAuctionsStartDate
1144       .add(firstAuctionsInitialDuration)
1145       .add(firstAuctionsExtendedDuration);
1146   }
1147 
1148   function getLastAuctionedShipId() public view returns (uint256 /* _shipId */) {
1149     if (_lastAuctionedShipId == 0 && now >= getFirstAuctionsEndDate()) {
1150       return 1;
1151     } else {
1152       return _lastAuctionedShipId;
1153     }
1154   }
1155 
1156   function getLastAuctionsWinningBid() public view returns (uint256 /* _value */) {
1157     if (_lastAuctionedShipId == 0 && now >= getFirstAuctionsEndDate()) {
1158       return firstAuctionsHighestBid;
1159     } else {
1160       return _lastAuctionsWinningBid;
1161     }
1162   }
1163 
1164   function getLastAuctionWinsDate() public view returns (uint256 /* _date */) {
1165     if (_lastAuctionedShipId == 0) {
1166       uint256 _firstAuctionsEndDate = getFirstAuctionsEndDate();
1167 
1168       if (now >= _firstAuctionsEndDate) {
1169         return _firstAuctionsEndDate;
1170       }
1171     }
1172 
1173     return _lastAuctionWinsDate;
1174   }
1175 
1176   function getShipPrice(uint256 _shipId) public view returns (uint256 /* _price */) {
1177     uint256 _minutesPassed = now
1178       .sub(getLastAuctionWinsDate())
1179       .div(1 minutes);
1180 
1181     return getShipPrice(_shipId, _minutesPassed);
1182   }
1183 
1184   function getShipPrice(uint256 _shipId, uint256 _minutesPassed) public view returns (uint256 /* _price */) {
1185     require(_shipId >= 2, "Ship ID must be greater than or equal to 2.");
1186     require(_shipId <= TOTAL_SHIP, "Ship ID must be smaller than or equal to total number of ship.");
1187     require(_shipId == getLastAuctionedShipId().add(1), "Can only get price of the ship which is being auctioned.");
1188 
1189     uint256 _initialPrice = getLastAuctionsWinningBid();
1190 
1191     if (_shipId == 2) {
1192       _initialPrice = _initialPrice
1193         .mul(SECOND_AUCTIONS_INITIAL_PERCENTAGE)
1194         .div(100);
1195     } else {
1196       _initialPrice = _initialPrice
1197         .mul(LATER_AUCTIONS_INITIAL_PERCENTAGE)
1198         .div(100);
1199     }
1200 
1201     return _getShipPrice(_initialPrice, _minutesPassed);
1202   }
1203 
1204   function _bidFirstShip(uint256 _value, address _bidder, address _referrer) internal {
1205     require(now >= firstAuctionsStartDate, "Auction of the first ship is not started yet.");
1206     require(now < getFirstAuctionsEndDate(), "Auction of the first ship has ended.");
1207 
1208     require(_value >= firstAuctionsHighestBid.add(FIRST_AUCTIONS_MINIMUM_RAISE), "Not enough Parsec Credit.");
1209 
1210     _updateReferrerFor(_bidder, _referrer);
1211     _receiveFrom(_bidder, _value);
1212 
1213     if (firstAuctionsHighestBidder != address(0)) {
1214       _sendTo(firstAuctionsHighestBidder, firstAuctionsHighestBid);
1215     }
1216 
1217     firstAuctionsHighestBid = _value;
1218     firstAuctionsHighestBidder = _bidder;
1219 
1220     // To prevent the first auction's referrer being overriden,
1221     // since later auction's bidders could be the same as the first auction's bidder
1222     // but their referrers could be different.
1223     firstAuctionsReferrer = referrer[_bidder];
1224 
1225     if (now >= getFirstAuctionsExtendableStartDate()) {
1226       firstAuctionsExtendedDuration = firstAuctionsExtendedDuration
1227         .add(firstAuctionsExtendedChunkDuration);
1228     }
1229 
1230     emit FirstShipBidded(_bidder, _value, referrer[_bidder]);
1231   }
1232 
1233   function _bidLaterShip(
1234     uint256 _shipId,
1235     uint256 _value,
1236     address _bidder,
1237     address _referrer
1238   )
1239     internal
1240   {
1241     uint256 _price = getShipPrice(_shipId);
1242     require(_value >= _price, "Not enough Parsec Credit.");
1243 
1244     _updateReferrerFor(_bidder, _referrer);
1245 
1246     if (_price > 0) {
1247       _receiveFrom(_bidder, _price);
1248     }
1249 
1250     _mint(_bidder, _shipId);
1251 
1252     _lastAuctionedShipId = _shipId;
1253     _lastAuctionsWinningBid = _price;
1254     _lastAuctionWinsDate = now;
1255 
1256     if (referrer[_bidder] != address(0) && _price > 0) {
1257       _sendTo(referrer[_bidder], _price.mul(REFERRAL_REWARD_PERCENTAGE).div(100));
1258     }
1259 
1260     emit LaterShipBidded(
1261       _shipId,
1262       _bidder,
1263       _value,
1264       referrer[_bidder]
1265     );
1266   }
1267 
1268   function _receiveFrom(address _from, uint256 _value) internal {
1269     parsecCreditContract.transferFrom(_from, this, _value);
1270   }
1271 
1272   function _sendTo(address _to, uint256 _value) internal {
1273     // Not like when transferring ETH, we are not afraid of a DoS attack here
1274     // because Parsec Credit contract is trustable and there are no callbacks involved.
1275     // solium-disable-next-line security/no-low-level-calls
1276     require(address(parsecCreditContract).call(
1277       bytes4(keccak256("transfer(address,uint256)")),
1278       _to,
1279       _value
1280     ), "Parsec Credit transfer failed.");
1281   }
1282 }
1283 
1284 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
1285 
1286 /**
1287  * @title Contracts that should not own Contracts
1288  * @author Remco Bloemen <remco@2π.com>
1289  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
1290  * of this contract to reclaim ownership of the contracts.
1291  */
1292 contract HasNoContracts is Ownable {
1293 
1294   /**
1295    * @dev Reclaim ownership of Ownable contracts
1296    * @param contractAddr The address of the Ownable to be reclaimed.
1297    */
1298   function reclaimContract(address contractAddr) external onlyOwner {
1299     Ownable contractInst = Ownable(contractAddr);
1300     contractInst.transferOwnership(owner);
1301   }
1302 }
1303 
1304 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
1305 
1306 /**
1307  * @title Contracts that should not own Ether
1308  * @author Remco Bloemen <remco@2π.com>
1309  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
1310  * in the contract, it will allow the owner to reclaim this ether.
1311  * @notice Ether can still be sent to this contract by:
1312  * calling functions labeled `payable`
1313  * `selfdestruct(contract_address)`
1314  * mining directly to the contract address
1315  */
1316 contract HasNoEther is Ownable {
1317 
1318   /**
1319   * @dev Constructor that rejects incoming Ether
1320   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
1321   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
1322   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
1323   * we could use assembly to access msg.value.
1324   */
1325   function HasNoEther() public payable {
1326     require(msg.value == 0);
1327   }
1328 
1329   /**
1330    * @dev Disallows direct send by settings a default function without the `payable` flag.
1331    */
1332   function() external {
1333   }
1334 
1335   /**
1336    * @dev Transfer all Ether held by the contract to the owner.
1337    */
1338   function reclaimEther() external onlyOwner {
1339     // solium-disable-next-line security/no-send
1340     assert(owner.send(address(this).balance));
1341   }
1342 }
1343 
1344 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1345 
1346 /**
1347  * @title SafeERC20
1348  * @dev Wrappers around ERC20 operations that throw on failure.
1349  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1350  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1351  */
1352 library SafeERC20 {
1353   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1354     assert(token.transfer(to, value));
1355   }
1356 
1357   function safeTransferFrom(
1358     ERC20 token,
1359     address from,
1360     address to,
1361     uint256 value
1362   )
1363     internal
1364   {
1365     assert(token.transferFrom(from, to, value));
1366   }
1367 
1368   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1369     assert(token.approve(spender, value));
1370   }
1371 }
1372 
1373 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
1374 
1375 /**
1376  * @title Contracts that should be able to recover tokens
1377  * @author SylTi
1378  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
1379  * This will prevent any accidental loss of tokens.
1380  */
1381 contract CanReclaimToken is Ownable {
1382   using SafeERC20 for ERC20Basic;
1383 
1384   /**
1385    * @dev Reclaim all ERC20Basic compatible tokens
1386    * @param token ERC20Basic The address of the token contract
1387    */
1388   function reclaimToken(ERC20Basic token) external onlyOwner {
1389     uint256 balance = token.balanceOf(this);
1390     token.safeTransfer(owner, balance);
1391   }
1392 
1393 }
1394 
1395 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
1396 
1397 /**
1398  * @title Contracts that should not own Tokens
1399  * @author Remco Bloemen <remco@2π.com>
1400  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
1401  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
1402  * owner to reclaim the tokens.
1403  */
1404 contract HasNoTokens is CanReclaimToken {
1405 
1406  /**
1407   * @dev Reject all ERC223 compatible tokens
1408   * @param from_ address The address that is transferring the tokens
1409   * @param value_ uint256 the amount of the specified token
1410   * @param data_ Bytes The data passed from the caller.
1411   */
1412   function tokenFallback(address from_, uint256 value_, bytes data_) external {
1413     from_;
1414     value_;
1415     data_;
1416     revert();
1417   }
1418 
1419 }
1420 
1421 // File: openzeppelin-solidity/contracts/ownership/NoOwner.sol
1422 
1423 /**
1424  * @title Base contract for contracts that should not own things.
1425  * @author Remco Bloemen <remco@2π.com>
1426  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
1427  * Owned contracts. See respective base contracts for details.
1428  */
1429 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
1430 }
1431 
1432 // File: contracts/ParsecInitialShip.sol
1433 
1434 // solium-disable-next-line lbrace
1435 contract ParsecInitialShip is
1436   ParsecShipAuction,
1437   NoOwner
1438 {
1439   function reclaimToken(ERC20Basic token) external onlyOwner {
1440     require(token != parsecCreditContract); // Use `reclaimParsecCredit()` instead!
1441     uint256 balance = token.balanceOf(this);
1442     token.safeTransfer(owner, balance);
1443   }
1444 
1445   function reclaimParsecCredit() external onlyOwner {
1446     require(firstAuctionConcluded, "The first auction must have been concluded.");
1447     _sendTo(owner, parsecCreditContract.balanceOf(this));
1448   }
1449 }