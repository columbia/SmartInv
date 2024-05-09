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
79   string public constant NAME           = "ZethrDividendCard";
80   string public constant SYMBOL         = "ZDC";
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
132     createDivCard("2%", 1 ether, 2);
133     divCardRateToIndex[2] = 0;
134 
135     createDivCard("5%", 1 ether, 5);
136     divCardRateToIndex[5] = 1;
137 
138     createDivCard("10%", 1 ether, 10);
139     divCardRateToIndex[10] = 2;
140 
141     createDivCard("15%", 1 ether, 15);
142     divCardRateToIndex[15] = 3;
143 
144     createDivCard("20%", 1 ether, 20);
145     divCardRateToIndex[20] = 4;
146 
147     createDivCard("25%", 1 ether, 25);
148     divCardRateToIndex[25] = 5;
149 
150     createDivCard("33%", 1 ether, 33);
151     divCardRateToIndex[33] = 6;
152 
153     createDivCard("MASTER", 5 ether, 10);
154     divCardRateToIndex[999] = 7;
155 
156 	onSale = false;
157 
158     administrators[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true; // Norsefire
159     administrators[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true; // klob
160     administrators[0x20C945800de43394F70D789874a4daC9cFA57451] = true; // Etherguy
161     administrators[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true; // blurr
162 
163   }
164 
165   /*** MODIFIERS ***/
166 
167     // Modifier to prevent contracts from interacting with the flip cards
168     modifier isNotContract()
169     {
170         require (msg.sender == tx.origin);
171         _;
172     }
173 
174 	// Modifier to prevent purchases before we open them up to everyone
175 	modifier hasStarted()
176     {
177 		require (onSale == true);
178 		_;
179 	}
180 
181 	modifier isAdmin()
182     {
183 	    require(administrators[msg.sender]);
184 	    _;
185     }
186 
187   /*** PUBLIC FUNCTIONS ***/
188   // Administrative update of the bankroll contract address
189     function setBankroll(address where)
190         isAdmin
191     {
192         BANKROLL = where;
193     }
194 
195   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
196   /// @param _to The address to be granted transfer approval. Pass address(0) to
197   ///  clear all approvals.
198   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
199   /// @dev Required for ERC-721 compliance.
200   function approve(address _to, uint _tokenId)
201     public
202     isNotContract
203   {
204     // Caller must own token.
205     require(_owns(msg.sender, _tokenId));
206 
207     divCardIndexToApproved[_tokenId] = _to;
208 
209     emit Approval(msg.sender, _to, _tokenId);
210   }
211 
212   /// For querying balance of a particular account
213   /// @param _owner The address for balance query
214   /// @dev Required for ERC-721 compliance.
215   function balanceOf(address _owner)
216     public
217     view
218     returns (uint balance)
219   {
220     return ownershipDivCardCount[_owner];
221   }
222 
223   // Creates a div card with bankroll as the owner
224   function createDivCard(string _name, uint _price, uint _percentIncrease)
225     public
226     onlyCreator
227   {
228     _createDivCard(_name, BANKROLL, _price, _percentIncrease);
229   }
230 
231 	// Opens the dividend cards up for sale.
232 	function startCardSale()
233         public
234         onlyCreator
235     {
236 		onSale = true;
237 	}
238 
239   /// @notice Returns all the relevant information about a specific div card
240   /// @param _divCardId The tokenId of the div card of interest.
241   function getDivCard(uint _divCardId)
242     public
243     view
244     returns (string divCardName, uint sellingPrice, address owner)
245   {
246     Card storage divCard = divCards[_divCardId];
247     divCardName = divCard.name;
248     sellingPrice = divCardIndexToPrice[_divCardId];
249     owner = divCardIndexToOwner[_divCardId];
250   }
251 
252   function implementsERC721()
253     public
254     pure
255     returns (bool)
256   {
257     return true;
258   }
259 
260   /// @dev Required for ERC-721 compliance.
261   function name()
262     public
263     pure
264     returns (string)
265   {
266     return NAME;
267   }
268 
269   /// For querying owner of token
270   /// @param _divCardId The tokenID for owner inquiry
271   /// @dev Required for ERC-721 compliance.
272   function ownerOf(uint _divCardId)
273     public
274     view
275     returns (address owner)
276   {
277     owner = divCardIndexToOwner[_divCardId];
278     require(owner != address(0));
279 	return owner;
280   }
281 
282   // Allows someone to send Ether and obtain a card
283   function purchase(uint _divCardId)
284     public
285     payable
286     hasStarted
287     isNotContract
288   {
289     address oldOwner  = divCardIndexToOwner[_divCardId];
290     address newOwner  = msg.sender;
291 
292     // Get the current price of the card
293     uint currentPrice = divCardIndexToPrice[_divCardId];
294 
295     // Making sure token owner is not sending to self
296     require(oldOwner != newOwner);
297 
298     // Safety check to prevent against an unexpected 0x0 default.
299     require(_addressNotNull(newOwner));
300 
301     // Making sure sent amount is greater than or equal to the sellingPrice
302     require(msg.value >= currentPrice);
303 
304     // To find the total profit, we need to know the previous price
305     // currentPrice      = previousPrice * (100 + percentIncrease);
306     // previousPrice     = currentPrice / (100 + percentIncrease);
307     uint percentIncrease = divCards[_divCardId].percentIncrease;
308     uint previousPrice   = SafeMath.mul(currentPrice, 100).div(100 + percentIncrease);
309 
310     // Calculate total profit and allocate 50% to old owner, 50% to bankroll
311     uint totalProfit     = SafeMath.sub(currentPrice, previousPrice);
312     uint oldOwnerProfit  = SafeMath.div(totalProfit, 2);
313     uint bankrollProfit  = SafeMath.sub(totalProfit, oldOwnerProfit);
314     oldOwnerProfit       = SafeMath.add(oldOwnerProfit, previousPrice);
315 
316     // Refund the sender the excess he sent
317     uint purchaseExcess  = SafeMath.sub(msg.value, currentPrice);
318 
319     // Raise the price by the percentage specified by the card
320     divCardIndexToPrice[_divCardId] = SafeMath.div(SafeMath.mul(currentPrice, (100 + percentIncrease)), 100);
321 
322     // Transfer ownership
323     _transfer(oldOwner, newOwner, _divCardId);
324 
325     // Using send rather than transfer to prevent contract exploitability.
326     BANKROLL.send(bankrollProfit);
327     oldOwner.send(oldOwnerProfit);
328 
329     msg.sender.transfer(purchaseExcess);
330   }
331 
332   function priceOf(uint _divCardId)
333     public
334     view
335     returns (uint price)
336   {
337     return divCardIndexToPrice[_divCardId];
338   }
339 
340   function setCreator(address _creator)
341     public
342     onlyCreator
343   {
344     require(_creator != address(0));
345 
346     creator = _creator;
347   }
348 
349   /// @dev Required for ERC-721 compliance.
350   function symbol()
351     public
352     pure
353     returns (string)
354   {
355     return SYMBOL;
356   }
357 
358   /// @notice Allow pre-approved user to take ownership of a dividend card.
359   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
360   /// @dev Required for ERC-721 compliance.
361   function takeOwnership(uint _divCardId)
362     public
363     isNotContract
364   {
365     address newOwner = msg.sender;
366     address oldOwner = divCardIndexToOwner[_divCardId];
367 
368     // Safety check to prevent against an unexpected 0x0 default.
369     require(_addressNotNull(newOwner));
370 
371     // Making sure transfer is approved
372     require(_approved(newOwner, _divCardId));
373 
374     _transfer(oldOwner, newOwner, _divCardId);
375   }
376 
377   /// For querying totalSupply of token
378   /// @dev Required for ERC-721 compliance.
379   function totalSupply()
380     public
381     view
382     returns (uint total)
383   {
384     return divCards.length;
385   }
386 
387   /// Owner initates the transfer of the card to another account
388   /// @param _to The address for the card to be transferred to.
389   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
390   /// @dev Required for ERC-721 compliance.
391   function transfer(address _to, uint _divCardId)
392     public
393     isNotContract
394   {
395     require(_owns(msg.sender, _divCardId));
396     require(_addressNotNull(_to));
397 
398     _transfer(msg.sender, _to, _divCardId);
399   }
400 
401   /// Third-party initiates transfer of a card from address _from to address _to
402   /// @param _from The address for the card to be transferred from.
403   /// @param _to The address for the card to be transferred to.
404   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
405   /// @dev Required for ERC-721 compliance.
406   function transferFrom(address _from, address _to, uint _divCardId)
407     public
408     isNotContract
409   {
410     require(_owns(_from, _divCardId));
411     require(_approved(_to, _divCardId));
412     require(_addressNotNull(_to));
413 
414     _transfer(_from, _to, _divCardId);
415   }
416 
417   function receiveDividends(uint _divCardRate)
418     public
419     payable
420   {
421     uint _divCardId = divCardRateToIndex[_divCardRate];
422     address _regularAddress = divCardIndexToOwner[_divCardId];
423     address _masterAddress = divCardIndexToOwner[7];
424 
425     uint toMaster = msg.value.div(2);
426     uint toRegular = msg.value.sub(toMaster);
427 
428     _masterAddress.send(toMaster);
429     _regularAddress.send(toRegular);
430   }
431 
432   /*** PRIVATE FUNCTIONS ***/
433   /// Safety check on _to address to prevent against an unexpected 0x0 default.
434   function _addressNotNull(address _to)
435     private
436     pure
437     returns (bool)
438   {
439     return _to != address(0);
440   }
441 
442   /// For checking approval of transfer for address _to
443   function _approved(address _to, uint _divCardId)
444     private
445     view
446     returns (bool)
447   {
448     return divCardIndexToApproved[_divCardId] == _to;
449   }
450 
451   /// For creating a dividend card
452   function _createDivCard(string _name, address _owner, uint _price, uint _percentIncrease)
453     private
454   {
455     Card memory _divcard = Card({
456       name: _name,
457       percentIncrease: _percentIncrease
458     });
459     uint newCardId = divCards.push(_divcard) - 1;
460 
461     // It's probably never going to happen, 4 billion tokens are A LOT, but
462     // let's just be 100% sure we never let this happen.
463     require(newCardId == uint(uint32(newCardId)));
464 
465     emit Birth(newCardId, _name, _owner);
466 
467     divCardIndexToPrice[newCardId] = _price;
468 
469     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
470     _transfer(BANKROLL, _owner, newCardId);
471   }
472 
473   /// Check for token ownership
474   function _owns(address claimant, uint _divCardId)
475     private
476     view
477     returns (bool)
478   {
479     return claimant == divCardIndexToOwner[_divCardId];
480   }
481 
482   /// @dev Assigns ownership of a specific Card to an address.
483   function _transfer(address _from, address _to, uint _divCardId)
484     private
485   {
486     // Since the number of cards is capped to 2^32 we can't overflow this
487     ownershipDivCardCount[_to]++;
488     //transfer ownership
489     divCardIndexToOwner[_divCardId] = _to;
490 
491     // When creating new div cards _from is 0x0, but we can't account that address.
492     if (_from != address(0)) {
493       ownershipDivCardCount[_from]--;
494       // clear any previously approved ownership exchange
495       delete divCardIndexToApproved[_divCardId];
496     }
497 
498     // Emit the transfer event.
499     emit Transfer(_from, _to, _divCardId);
500   }
501 }
502 
503 // SafeMath library
504 library SafeMath {
505 
506   /**
507   * @dev Multiplies two numbers, throws on overflow.
508   */
509   function mul(uint a, uint b) internal pure returns (uint) {
510     if (a == 0) {
511       return 0;
512     }
513     uint c = a * b;
514     assert(c / a == b);
515     return c;
516   }
517 
518   /**
519   * @dev Integer division of two numbers, truncating the quotient.
520   */
521   function div(uint a, uint b) internal pure returns (uint) {
522     // assert(b > 0); // Solidity automatically throws when dividing by 0
523     uint c = a / b;
524     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
525     return c;
526   }
527 
528   /**
529   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
530   */
531   function sub(uint a, uint b) internal pure returns (uint) {
532     assert(b <= a);
533     return a - b;
534   }
535 
536   /**
537   * @dev Adds two numbers, throws on overflow.
538   */
539   function add(uint a, uint b) internal pure returns (uint) {
540     uint c = a + b;
541     assert(c >= a);
542     return c;
543   }
544 }
545 
546 /**
547  * Utility library of inline functions on addresses
548  */
549 library AddressUtils {
550 
551   /**
552    * Returns whether the target address is a contract
553    * @dev This function will return false if invoked during the constructor of a contract,
554    *  as the code is not actually created until after the constructor finishes.
555    * @param addr address to check
556    * @return whether the target address is a contract
557    */
558   function isContract(address addr) internal view returns (bool) {
559     uint size;
560     // XXX Currently there is no better way to check if there is a contract in an address
561     // than to check the size of the code at that address.
562     // See https://ethereum.stackexchange.com/a/14016/36603
563     // for more details about how this works.
564     // TODO Check this again before the Serenity release, because all addresses will be
565     // contracts then.
566     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
567     return size > 0;
568   }
569 
570 }