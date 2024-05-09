1 pragma solidity ^0.4.23;
2 
3 /**
4 
5                                   ███████╗███████╗████████╗██╗  ██╗██████╗
6                                   ╚══███╔╝██╔════╝╚══██╔══╝██║  ██║██╔══██╗
7                                     ███╔╝ █████╗     ██║   ███████║██████╔╝
8                                    ███╔╝  ██╔══╝     ██║   ██╔══██║██╔══██╗
9                                   ███████╗███████╗   ██║   ██║  ██║██║  ██║
10                                   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
11 
12 .------..------..------..------..------..------..------..------.     .------..------..------..------..------.
13 |D.--. ||I.--. ||V.--. ||I.--. ||D.--. ||E.--. ||N.--. ||D.--. |.-.  |C.--. ||A.--. ||R.--. ||D.--. ||S.--. |
14 | :/\: || (\/) || :(): || (\/) || :/\: || (\/) || :(): || :/\: ((5)) | :/\: || (\/) || :(): || :/\: || :/\: |
15 | (__) || :\/: || ()() || :\/: || (__) || :\/: || ()() || (__) |'-.-.| :\/: || :\/: || ()() || (__) || :\/: |
16 | '--'D|| '--'I|| '--'V|| '--'I|| '--'D|| '--'E|| '--'N|| '--'D| ((1)) '--'C|| '--'A|| '--'R|| '--'D|| '--'S|
17 `------'`------'`------'`------'`------'`------'`------'`------'  '-'`------'`------'`------'`------'`------'
18 
19 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
20 This contract describes those collectibles. Don't get left with a hot potato!
21 
22 Launched at 00:00 GMT on 12th May 2018.
23 
24 Credits
25 =======
26 
27 Analysis:
28     blurr
29     Randall
30 
31 Contract Developers:
32     Etherguy
33     klob
34     Norsefire
35 
36 Front-End Design:
37     cryptodude
38     oguzhanox
39     TropicalRogue
40 
41 **/
42 
43 // Required ERC721 interface.
44 
45 contract ERC721 {
46 
47   function approve(address _to, uint _tokenId) public;
48   function balanceOf(address _owner) public view returns (uint balance);
49   function implementsERC721() public pure returns (bool);
50   function ownerOf(uint _tokenId) public view returns (address addr);
51   function takeOwnership(uint _tokenId) public;
52   function totalSupply() public view returns (uint total);
53   function transferFrom(address _from, address _to, uint _tokenId) public;
54   function transfer(address _to, uint _tokenId) public;
55 
56   event Transfer(address indexed from, address indexed to, uint tokenId);
57   event Approval(address indexed owner, address indexed approved, uint tokenId);
58 
59 }
60 
61 contract ZethrDividendCards is ERC721 {
62     using SafeMath for uint;
63 
64   /*** EVENTS ***/
65 
66   /// @dev The Birth event is fired whenever a new dividend card comes into existence.
67   event Birth(uint tokenId, string name, address owner);
68 
69   /// @dev The TokenSold event is fired whenever a token (dividend card, in this case) is sold.
70   event TokenSold(uint tokenId, uint oldPrice, uint newPrice, address prevOwner, address winner, string name);
71 
72   /// @dev Transfer event as defined in current draft of ERC721.
73   ///  Ownership is assigned, including births.
74   event Transfer(address from, address to, uint tokenId);
75 
76   /*** CONSTANTS ***/
77 
78   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
79   string public constant NAME           = "ZethrGameDividendCard";
80   string public constant SYMBOL         = "ZGDC";
81   address public         BANKROLL;
82 
83   /*** STORAGE ***/
84 
85   /// @dev A mapping from dividend card indices to the address that owns them.
86   ///  All dividend cards have a valid owner address.
87 
88   mapping (uint => address) public      divCardIndexToOwner;
89 
90   // A mapping from a dividend rate to the card index.
91 
92   mapping (uint => uint) public         divCardRateToIndex;
93 
94   // @dev A mapping from owner address to the number of dividend cards that address owns.
95   //  Used internally inside balanceOf() to resolve ownership count.
96 
97   mapping (address => uint) private     ownershipDivCardCount;
98 
99   /// @dev A mapping from dividend card indices to an address that has been approved to call
100   ///  transferFrom(). Each dividend card can only have one approved address for transfer
101   ///  at any time. A zero value means no approval is outstanding.
102 
103   mapping (uint => address) public      divCardIndexToApproved;
104 
105   // @dev A mapping from dividend card indices to the price of the dividend card.
106 
107   mapping (uint => uint) private        divCardIndexToPrice;
108 
109   mapping (address => bool) internal    administrators;
110 
111   address public                        creator;
112   bool    public                        onSale;
113 
114   /*** DATATYPES ***/
115 
116   struct Card {
117     string name;
118     uint percentIncrease;
119   }
120 
121   Card[] private divCards;
122 
123   modifier onlyCreator() {
124     require(msg.sender == creator);
125     _;
126   }
127 
128   constructor (address _bankroll) public {
129     creator = msg.sender;
130     BANKROLL = _bankroll;
131 
132     createDivCard("2%", 3 ether, 2);
133     divCardRateToIndex[2] = 0;
134 
135     createDivCard("5%", 4 ether, 5);
136     divCardRateToIndex[5] = 1;
137 
138     createDivCard("10%", 5 ether, 10);
139     divCardRateToIndex[10] = 2;
140 
141     createDivCard("15%", 6 ether, 15);
142     divCardRateToIndex[15] = 3;
143 
144     createDivCard("20%", 7 ether, 20);
145     divCardRateToIndex[20] = 4;
146 
147     createDivCard("25%", 8 ether, 25);
148     divCardRateToIndex[25] = 5;
149 
150     createDivCard("33%", 10 ether, 33);
151     divCardRateToIndex[33] = 6;
152 
153     createDivCard("MASTER", 30 ether, 10);
154     divCardRateToIndex[999] = 7;
155 
156 	onSale = false;
157 
158     administrators[creator] = true;
159 
160   }
161 
162   /*** MODIFIERS ***/
163 
164     // Modifier to prevent contracts from interacting with the flip cards
165     modifier isNotContract()
166     {
167         require (msg.sender == tx.origin);
168         _;
169     }
170 
171 	// Modifier to prevent purchases before we open them up to everyone
172 	modifier hasStarted()
173     {
174 		require (onSale == true);
175 		_;
176 	}
177 
178 	modifier isAdmin()
179     {
180 	    require(administrators[msg.sender]);
181 	    _;
182     }
183 
184   /*** PUBLIC FUNCTIONS ***/
185   // Administrative update of the bankroll contract address
186     function setBankroll(address where)
187         isAdmin
188      public {
189         BANKROLL = where;
190     }
191 
192   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
193   /// @param _to The address to be granted transfer approval. Pass address(0) to
194   ///  clear all approvals.
195   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
196   /// @dev Required for ERC-721 compliance.
197   function approve(address _to, uint _tokenId)
198     public
199     isNotContract
200   {
201     // Caller must own token.
202     require(_owns(msg.sender, _tokenId));
203 
204     divCardIndexToApproved[_tokenId] = _to;
205 
206     emit Approval(msg.sender, _to, _tokenId);
207   }
208 
209   /// For querying balance of a particular account
210   /// @param _owner The address for balance query
211   /// @dev Required for ERC-721 compliance.
212   function balanceOf(address _owner)
213     public
214     view
215     returns (uint balance)
216   {
217     return ownershipDivCardCount[_owner];
218   }
219 
220   // Creates a div card with bankroll as the owner
221   function createDivCard(string _name, uint _price, uint _percentIncrease)
222     public
223     onlyCreator
224   {
225     _createDivCard(_name, BANKROLL, _price, _percentIncrease);
226   }
227 
228 	// Opens the dividend cards up for sale.
229 	function startCardSale()
230         public
231         onlyCreator
232     {
233 		onSale = true;
234 	}
235 
236   /// @notice Returns all the relevant information about a specific div card
237   /// @param _divCardId The tokenId of the div card of interest.
238   function getDivCard(uint _divCardId)
239     public
240     view
241     returns (string divCardName, uint sellingPrice, address owner)
242   {
243     Card storage divCard = divCards[_divCardId];
244     divCardName = divCard.name;
245     sellingPrice = divCardIndexToPrice[_divCardId];
246     owner = divCardIndexToOwner[_divCardId];
247   }
248 
249   function implementsERC721()
250     public
251     pure
252     returns (bool)
253   {
254     return true;
255   }
256 
257   /// @dev Required for ERC-721 compliance.
258   function name()
259     public
260     pure
261     returns (string)
262   {
263     return NAME;
264   }
265 
266   /// For querying owner of token
267   /// @param _divCardId The tokenID for owner inquiry
268   /// @dev Required for ERC-721 compliance.
269   function ownerOf(uint _divCardId)
270     public
271     view
272     returns (address owner)
273   {
274     owner = divCardIndexToOwner[_divCardId];
275     require(owner != address(0));
276 	return owner;
277   }
278 
279   // Allows someone to send Ether and obtain a card
280   function purchase(uint _divCardId)
281     public
282     payable
283     hasStarted
284     isNotContract
285   {
286     address oldOwner  = divCardIndexToOwner[_divCardId];
287     address newOwner  = msg.sender;
288 
289     // Get the current price of the card
290     uint currentPrice = divCardIndexToPrice[_divCardId];
291 
292     // Making sure token owner is not sending to self
293     require(oldOwner != newOwner);
294 
295     // Safety check to prevent against an unexpected 0x0 default.
296     require(_addressNotNull(newOwner));
297 
298     // Making sure sent amount is greater than or equal to the sellingPrice
299     require(msg.value >= currentPrice);
300 
301     // To find the total profit, we need to know the previous price
302     // currentPrice      = previousPrice * (100 + percentIncrease);
303     // previousPrice     = currentPrice / (100 + percentIncrease);
304     uint percentIncrease = divCards[_divCardId].percentIncrease;
305     uint previousPrice   = SafeMath.mul(currentPrice, 100).div(100 + percentIncrease);
306 
307     // Calculate total profit and allocate 50% to old owner, 50% to bankroll
308     uint totalProfit     = SafeMath.sub(currentPrice, previousPrice);
309     uint oldOwnerProfit  = SafeMath.div(totalProfit, 2);
310     uint bankrollProfit  = SafeMath.sub(totalProfit, oldOwnerProfit);
311     oldOwnerProfit       = SafeMath.add(oldOwnerProfit, previousPrice);
312 
313     // Refund the sender the excess he sent
314     uint purchaseExcess  = SafeMath.sub(msg.value, currentPrice);
315 
316     // Raise the price by the percentage specified by the card
317     divCardIndexToPrice[_divCardId] = SafeMath.div(SafeMath.mul(currentPrice, (100 + percentIncrease)), 100);
318 
319     // Transfer ownership
320     _transfer(oldOwner, newOwner, _divCardId);
321 
322     // Using send rather than transfer to prevent contract exploitability.
323     BANKROLL.send(bankrollProfit);
324     oldOwner.send(oldOwnerProfit);
325 
326     msg.sender.transfer(purchaseExcess);
327   }
328 
329   function priceOf(uint _divCardId)
330     public
331     view
332     returns (uint price)
333   {
334     return divCardIndexToPrice[_divCardId];
335   }
336 
337   function setCreator(address _creator)
338     public
339     onlyCreator
340   {
341     require(_creator != address(0));
342 
343     creator = _creator;
344   }
345 
346   /// @dev Required for ERC-721 compliance.
347   function symbol()
348     public
349     pure
350     returns (string)
351   {
352     return SYMBOL;
353   }
354 
355   /// @notice Allow pre-approved user to take ownership of a dividend card.
356   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
357   /// @dev Required for ERC-721 compliance.
358   function takeOwnership(uint _divCardId)
359     public
360     isNotContract
361   {
362     address newOwner = msg.sender;
363     address oldOwner = divCardIndexToOwner[_divCardId];
364 
365     // Safety check to prevent against an unexpected 0x0 default.
366     require(_addressNotNull(newOwner));
367 
368     // Making sure transfer is approved
369     require(_approved(newOwner, _divCardId));
370 
371     _transfer(oldOwner, newOwner, _divCardId);
372   }
373 
374   /// For querying totalSupply of token
375   /// @dev Required for ERC-721 compliance.
376   function totalSupply()
377     public
378     view
379     returns (uint total)
380   {
381     return divCards.length;
382   }
383 
384   /// Owner initates the transfer of the card to another account
385   /// @param _to The address for the card to be transferred to.
386   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
387   /// @dev Required for ERC-721 compliance.
388   function transfer(address _to, uint _divCardId)
389     public
390     isNotContract
391   {
392     require(_owns(msg.sender, _divCardId));
393     require(_addressNotNull(_to));
394 
395     _transfer(msg.sender, _to, _divCardId);
396   }
397 
398   /// Third-party initiates transfer of a card from address _from to address _to
399   /// @param _from The address for the card to be transferred from.
400   /// @param _to The address for the card to be transferred to.
401   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
402   /// @dev Required for ERC-721 compliance.
403   function transferFrom(address _from, address _to, uint _divCardId)
404     public
405     isNotContract
406   {
407     require(_owns(_from, _divCardId));
408     require(_approved(_to, _divCardId));
409     require(_addressNotNull(_to));
410 
411     _transfer(_from, _to, _divCardId);
412   }
413 
414   function receiveDividends(uint _divCardRate)
415     public
416     payable
417   {
418     uint _divCardId = divCardRateToIndex[_divCardRate];
419     address _regularAddress = divCardIndexToOwner[_divCardId];
420     address _masterAddress = divCardIndexToOwner[7];
421 
422     uint toMaster = msg.value.div(2);
423     uint toRegular = msg.value.sub(toMaster);
424 
425     _masterAddress.send(toMaster);
426     _regularAddress.send(toRegular);
427   }
428 
429   /*** PRIVATE FUNCTIONS ***/
430   /// Safety check on _to address to prevent against an unexpected 0x0 default.
431   function _addressNotNull(address _to)
432     private
433     pure
434     returns (bool)
435   {
436     return _to != address(0);
437   }
438 
439   /// For checking approval of transfer for address _to
440   function _approved(address _to, uint _divCardId)
441     private
442     view
443     returns (bool)
444   {
445     return divCardIndexToApproved[_divCardId] == _to;
446   }
447 
448   /// For creating a dividend card
449   function _createDivCard(string _name, address _owner, uint _price, uint _percentIncrease)
450     private
451   {
452     Card memory _divcard = Card({
453       name: _name,
454       percentIncrease: _percentIncrease
455     });
456     uint newCardId = divCards.push(_divcard) - 1;
457 
458     // It's probably never going to happen, 4 billion tokens are A LOT, but
459     // let's just be 100% sure we never let this happen.
460     require(newCardId == uint(uint32(newCardId)));
461 
462     emit Birth(newCardId, _name, _owner);
463 
464     divCardIndexToPrice[newCardId] = _price;
465 
466     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
467     _transfer(BANKROLL, _owner, newCardId);
468   }
469 
470   /// Check for token ownership
471   function _owns(address claimant, uint _divCardId)
472     private
473     view
474     returns (bool)
475   {
476     return claimant == divCardIndexToOwner[_divCardId];
477   }
478 
479   /// @dev Assigns ownership of a specific Card to an address.
480   function _transfer(address _from, address _to, uint _divCardId)
481     private
482   {
483     // Since the number of cards is capped to 2^32 we can't overflow this
484     ownershipDivCardCount[_to]++;
485     //transfer ownership
486     divCardIndexToOwner[_divCardId] = _to;
487 
488     // When creating new div cards _from is 0x0, but we can't account that address.
489     if (_from != address(0)) {
490       ownershipDivCardCount[_from]--;
491       // clear any previously approved ownership exchange
492       delete divCardIndexToApproved[_divCardId];
493     }
494 
495     // Emit the transfer event.
496     emit Transfer(_from, _to, _divCardId);
497   }
498 }
499 
500 // SafeMath library
501 library SafeMath {
502 
503   /**
504   * @dev Multiplies two numbers, throws on overflow.
505   */
506   function mul(uint a, uint b) internal pure returns (uint) {
507     if (a == 0) {
508       return 0;
509     }
510     uint c = a * b;
511     assert(c / a == b);
512     return c;
513   }
514 
515   /**
516   * @dev Integer division of two numbers, truncating the quotient.
517   */
518   function div(uint a, uint b) internal pure returns (uint) {
519     // assert(b > 0); // Solidity automatically throws when dividing by 0
520     uint c = a / b;
521     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
522     return c;
523   }
524 
525   /**
526   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
527   */
528   function sub(uint a, uint b) internal pure returns (uint) {
529     assert(b <= a);
530     return a - b;
531   }
532 
533   /**
534   * @dev Adds two numbers, throws on overflow.
535   */
536   function add(uint a, uint b) internal pure returns (uint) {
537     uint c = a + b;
538     assert(c >= a);
539     return c;
540   }
541 }
542 
543 /**
544  * Utility library of inline functions on addresses
545  */
546 library AddressUtils {
547 
548   /**
549    * Returns whether the target address is a contract
550    * @dev This function will return false if invoked during the constructor of a contract,
551    *  as the code is not actually created until after the constructor finishes.
552    * @param addr address to check
553    * @return whether the target address is a contract
554    */
555   function isContract(address addr) internal view returns (bool) {
556     uint size;
557     // XXX Currently there is no better way to check if there is a contract in an address
558     // than to check the size of the code at that address.
559     // See https://ethereum.stackexchange.com/a/14016/36603
560     // for more details about how this works.
561     // TODO Check this again before the Serenity release, because all addresses will be
562     // contracts then.
563     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
564     return size > 0;
565   }
566 
567 }