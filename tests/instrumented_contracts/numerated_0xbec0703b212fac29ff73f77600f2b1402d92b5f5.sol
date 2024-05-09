1 pragma solidity ^0.4.24;
2 
3 /**
4 
5  __    __  __      __  ________  ________  ________  __    __  _______  
6 |  \  |  \|  \    /  \|        \|        \|        \|  \  |  \|       \ 
7 | $$  | $$ \$$\  /  $$ \$$$$$$$$| $$$$$$$$ \$$$$$$$$| $$  | $$| $$$$$$$\
8  \$$\/  $$  \$$\/  $$     /  $$ | $$__       | $$   | $$__| $$| $$__| $$
9   >$$  $$    \$$  $$     /  $$  | $$  \      | $$   | $$    $$| $$    $$
10  /  $$$$\     \$$$$     /  $$   | $$$$$      | $$   | $$$$$$$$| $$$$$$$\
11 |  $$ \$$\    | $$     /  $$___ | $$_____    | $$   | $$  | $$| $$  | $$
12 | $$  | $$    | $$    |  $$    \| $$     \   | $$   | $$  | $$| $$  | $$
13  \$$   \$$     \$$     \$$$$$$$$ \$$$$$$$$    \$$    \$$   \$$ \$$   \$$
14                                                                         
15                                                                         
16                                                                         
17 
18 
19 .------..------..------..------.     .------..------..------..------..------..------..------.
20 |M.--. ||O.--. ||R.--. ||E.--. |.-.  |L.--. ||E.--. ||T.--. ||T.--. ||E.--. ||R.--. ||S.--. |
21 | (\/) || :/\: || :(): || (\/) ((5)) | :/\: || (\/) || :/\: || :/\: || (\/) || :(): || :/\: |
22 | :\/: || :\/: || ()() || :\/: |'-.-.| (__) || :\/: || (__) || (__) || :\/: || ()() || :\/: |
23 | '--'M|| '--'O|| '--'R|| '--'E| ((1)) '--'L|| '--'E|| '--'T|| '--'T|| '--'E|| '--'R|| '--'S|
24 `------'`------'`------'`------'  '-'`------'`------'`------'`------'`------'`------'`------'
25 
26 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
27 This contract describes those collectibles. Don't get left with a hot potato!
28 
29 
30 **/
31 
32 // Required ERC721 interface.
33 
34 contract ERC721 {
35 
36   function approve(address _to, uint _tokenId) public;
37   function balanceOf(address _owner) public view returns (uint balance);
38   function implementsERC721() public pure returns (bool);
39   function ownerOf(uint _tokenId) public view returns (address addr);
40   function takeOwnership(uint _tokenId) public;
41   function totalSupply() public view returns (uint total);
42   function transferFrom(address _from, address _to, uint _tokenId) public;
43   function transfer(address _to, uint _tokenId) public;
44 
45   event Transfer(address indexed from, address indexed to, uint tokenId);
46   event Approval(address indexed owner, address indexed approved, uint tokenId);
47 
48 }
49 
50 contract XYZethrDividendCards is ERC721 {
51     using SafeMath for uint;
52 
53   /*** EVENTS ***/
54 
55   /// @dev The Birth event is fired whenever a new dividend card comes into existence.
56   event Birth(uint tokenId, string name, address owner);
57 
58   /// @dev The TokenSold event is fired whenever a token (dividend card, in this case) is sold.
59   event TokenSold(uint tokenId, uint oldPrice, uint newPrice, address prevOwner, address winner, string name);
60 
61   /// @dev Transfer event as defined in current draft of ERC721.
62   ///  Ownership is assigned, including births.
63   event Transfer(address from, address to, uint tokenId);
64 
65   /*** CONSTANTS ***/
66 
67   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
68   string public constant NAME           = "XYZethrDividendCard";
69   string public constant SYMBOL         = "XYZDC";
70   address public         BANKROLL;
71 
72   /*** STORAGE ***/
73 
74   /// @dev A mapping from dividend card indices to the address that owns them.
75   ///  All dividend cards have a valid owner address.
76 
77   mapping (uint => address) public      divCardIndexToOwner;
78 
79   // A mapping from a dividend rate to the card index.
80 
81   mapping (uint => uint) public         divCardRateToIndex;
82 
83   // @dev A mapping from owner address to the number of dividend cards that address owns.
84   //  Used internally inside balanceOf() to resolve ownership count.
85 
86   mapping (address => uint) private     ownershipDivCardCount;
87 
88   /// @dev A mapping from dividend card indices to an address that has been approved to call
89   ///  transferFrom(). Each dividend card can only have one approved address for transfer
90   ///  at any time. A zero value means no approval is outstanding.
91 
92   mapping (uint => address) public      divCardIndexToApproved;
93 
94   // @dev A mapping from dividend card indices to the price of the dividend card.
95 
96   mapping (uint => uint) private        divCardIndexToPrice;
97 
98   mapping (address => bool) internal    administrators;
99 
100   address public                        creator;
101   bool    public                        onSale;
102 
103   /*** DATATYPES ***/
104 
105   struct Card {
106     string name;
107     uint percentIncrease;
108   }
109 
110   Card[] private divCards;
111 
112   modifier onlyCreator() {
113     require(msg.sender == creator);
114     _;
115   }
116 
117   constructor (address _bankroll) public {
118     creator = msg.sender;
119     BANKROLL = _bankroll;
120 
121     createDivCard("2%", 1 ether, 2);
122     divCardRateToIndex[2] = 0;
123 
124     createDivCard("5%", 1 ether, 5);
125     divCardRateToIndex[5] = 1;
126 
127     createDivCard("10%", 1 ether, 10);
128     divCardRateToIndex[10] = 2;
129 
130     createDivCard("15%", 1 ether, 15);
131     divCardRateToIndex[15] = 3;
132 
133     createDivCard("20%", 1 ether, 20);
134     divCardRateToIndex[20] = 4;
135 
136     createDivCard("25%", 1 ether, 25);
137     divCardRateToIndex[25] = 5;
138 
139     createDivCard("33%", 1 ether, 33);
140     divCardRateToIndex[33] = 6;
141 
142     createDivCard("MASTER", 5 ether, 10);
143     divCardRateToIndex[999] = 7;
144 
145 	onSale = false;
146 
147     administrators[msg.sender] = true; 
148 
149 
150   }
151 
152   /*** MODIFIERS ***/
153 
154     // Modifier to prevent contracts from interacting with the flip cards
155     modifier isNotContract()
156     {
157         require (msg.sender == tx.origin);
158         _;
159     }
160 
161 	// Modifier to prevent purchases before we open them up to everyone
162 	modifier hasStarted()
163     {
164 		require (onSale == true);
165 		_;
166 	}
167 
168 	modifier isAdmin()
169     {
170 	    require(administrators[msg.sender]);
171 	    _;
172     }
173 
174   /*** PUBLIC FUNCTIONS ***/
175   // Administrative update of the bankroll contract address
176     function setBankroll(address where)
177         isAdmin
178     {
179         BANKROLL = where;
180     }
181 
182   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
183   /// @param _to The address to be granted transfer approval. Pass address(0) to
184   ///  clear all approvals.
185   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
186   /// @dev Required for ERC-721 compliance.
187   function approve(address _to, uint _tokenId)
188     public
189     isNotContract
190   {
191     // Caller must own token.
192     require(_owns(msg.sender, _tokenId));
193 
194     divCardIndexToApproved[_tokenId] = _to;
195 
196     emit Approval(msg.sender, _to, _tokenId);
197   }
198 
199   /// For querying balance of a particular account
200   /// @param _owner The address for balance query
201   /// @dev Required for ERC-721 compliance.
202   function balanceOf(address _owner)
203     public
204     view
205     returns (uint balance)
206   {
207     return ownershipDivCardCount[_owner];
208   }
209 
210   // Creates a div card with bankroll as the owner
211   function createDivCard(string _name, uint _price, uint _percentIncrease)
212     public
213     onlyCreator
214   {
215     _createDivCard(_name, BANKROLL, _price, _percentIncrease);
216   }
217 
218 	// Opens the dividend cards up for sale.
219 	function startCardSale()
220         public
221         onlyCreator
222     {
223 		onSale = true;
224 	}
225 
226   /// @notice Returns all the relevant information about a specific div card
227   /// @param _divCardId The tokenId of the div card of interest.
228   function getDivCard(uint _divCardId)
229     public
230     view
231     returns (string divCardName, uint sellingPrice, address owner)
232   {
233     Card storage divCard = divCards[_divCardId];
234     divCardName = divCard.name;
235     sellingPrice = divCardIndexToPrice[_divCardId];
236     owner = divCardIndexToOwner[_divCardId];
237   }
238 
239   function implementsERC721()
240     public
241     pure
242     returns (bool)
243   {
244     return true;
245   }
246 
247   /// @dev Required for ERC-721 compliance.
248   function name()
249     public
250     pure
251     returns (string)
252   {
253     return NAME;
254   }
255 
256   /// For querying owner of token
257   /// @param _divCardId The tokenID for owner inquiry
258   /// @dev Required for ERC-721 compliance.
259   function ownerOf(uint _divCardId)
260     public
261     view
262     returns (address owner)
263   {
264     owner = divCardIndexToOwner[_divCardId];
265     require(owner != address(0));
266 	return owner;
267   }
268 
269   // Allows someone to send Ether and obtain a card
270   function purchase(uint _divCardId)
271     public
272     payable
273     hasStarted
274     isNotContract
275   {
276     address oldOwner  = divCardIndexToOwner[_divCardId];
277     address newOwner  = msg.sender;
278 
279     // Get the current price of the card
280     uint currentPrice = divCardIndexToPrice[_divCardId];
281 
282     // Making sure token owner is not sending to self
283     require(oldOwner != newOwner);
284 
285     // Safety check to prevent against an unexpected 0x0 default.
286     require(_addressNotNull(newOwner));
287 
288     // Making sure sent amount is greater than or equal to the sellingPrice
289     require(msg.value >= currentPrice);
290 
291     // To find the total profit, we need to know the previous price
292     // currentPrice      = previousPrice * (100 + percentIncrease);
293     // previousPrice     = currentPrice / (100 + percentIncrease);
294     uint percentIncrease = divCards[_divCardId].percentIncrease;
295     uint previousPrice   = SafeMath.mul(currentPrice, 100).div(100 + percentIncrease);
296 
297     // Calculate total profit and allocate 50% to old owner, 50% to bankroll
298     uint totalProfit     = SafeMath.sub(currentPrice, previousPrice);
299     uint oldOwnerProfit  = SafeMath.div(totalProfit, 2);
300     uint bankrollProfit  = SafeMath.sub(totalProfit, oldOwnerProfit);
301     oldOwnerProfit       = SafeMath.add(oldOwnerProfit, previousPrice);
302 
303     // Refund the sender the excess he sent
304     uint purchaseExcess  = SafeMath.sub(msg.value, currentPrice);
305 
306     // Raise the price by the percentage specified by the card
307     divCardIndexToPrice[_divCardId] = SafeMath.div(SafeMath.mul(currentPrice, (100 + percentIncrease)), 100);
308 
309     // Transfer ownership
310     _transfer(oldOwner, newOwner, _divCardId);
311 
312     // Using send rather than transfer to prevent contract exploitability.
313     BANKROLL.send(bankrollProfit);
314     oldOwner.send(oldOwnerProfit);
315 
316     msg.sender.transfer(purchaseExcess);
317   }
318 
319   function priceOf(uint _divCardId)
320     public
321     view
322     returns (uint price)
323   {
324     return divCardIndexToPrice[_divCardId];
325   }
326 
327   function setCreator(address _creator)
328     public
329     onlyCreator
330   {
331     require(_creator != address(0));
332 
333     creator = _creator;
334   }
335 
336   /// @dev Required for ERC-721 compliance.
337   function symbol()
338     public
339     pure
340     returns (string)
341   {
342     return SYMBOL;
343   }
344 
345   /// @notice Allow pre-approved user to take ownership of a dividend card.
346   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
347   /// @dev Required for ERC-721 compliance.
348   function takeOwnership(uint _divCardId)
349     public
350     isNotContract
351   {
352     address newOwner = msg.sender;
353     address oldOwner = divCardIndexToOwner[_divCardId];
354 
355     // Safety check to prevent against an unexpected 0x0 default.
356     require(_addressNotNull(newOwner));
357 
358     // Making sure transfer is approved
359     require(_approved(newOwner, _divCardId));
360 
361     _transfer(oldOwner, newOwner, _divCardId);
362   }
363 
364   /// For querying totalSupply of token
365   /// @dev Required for ERC-721 compliance.
366   function totalSupply()
367     public
368     view
369     returns (uint total)
370   {
371     return divCards.length;
372   }
373 
374   /// Owner initates the transfer of the card to another account
375   /// @param _to The address for the card to be transferred to.
376   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
377   /// @dev Required for ERC-721 compliance.
378   function transfer(address _to, uint _divCardId)
379     public
380     isNotContract
381   {
382     require(_owns(msg.sender, _divCardId));
383     require(_addressNotNull(_to));
384 
385     _transfer(msg.sender, _to, _divCardId);
386   }
387 
388   /// Third-party initiates transfer of a card from address _from to address _to
389   /// @param _from The address for the card to be transferred from.
390   /// @param _to The address for the card to be transferred to.
391   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
392   /// @dev Required for ERC-721 compliance.
393   function transferFrom(address _from, address _to, uint _divCardId)
394     public
395     isNotContract
396   {
397     require(_owns(_from, _divCardId));
398     require(_approved(_to, _divCardId));
399     require(_addressNotNull(_to));
400 
401     _transfer(_from, _to, _divCardId);
402   }
403 
404   function receiveDividends(uint _divCardRate)
405     public
406     payable
407   {
408     uint _divCardId = divCardRateToIndex[_divCardRate];
409     address _regularAddress = divCardIndexToOwner[_divCardId];
410     address _masterAddress = divCardIndexToOwner[7];
411 
412     uint toMaster = msg.value.div(2);
413     uint toRegular = msg.value.sub(toMaster);
414 
415     _masterAddress.send(toMaster);
416     _regularAddress.send(toRegular);
417   }
418 
419   /*** PRIVATE FUNCTIONS ***/
420   /// Safety check on _to address to prevent against an unexpected 0x0 default.
421   function _addressNotNull(address _to)
422     private
423     pure
424     returns (bool)
425   {
426     return _to != address(0);
427   }
428 
429   /// For checking approval of transfer for address _to
430   function _approved(address _to, uint _divCardId)
431     private
432     view
433     returns (bool)
434   {
435     return divCardIndexToApproved[_divCardId] == _to;
436   }
437 
438   /// For creating a dividend card
439   function _createDivCard(string _name, address _owner, uint _price, uint _percentIncrease)
440     private
441   {
442     Card memory _divcard = Card({
443       name: _name,
444       percentIncrease: _percentIncrease
445     });
446     uint newCardId = divCards.push(_divcard) - 1;
447 
448     // It's probably never going to happen, 4 billion tokens are A LOT, but
449     // let's just be 100% sure we never let this happen.
450     require(newCardId == uint(uint32(newCardId)));
451 
452     emit Birth(newCardId, _name, _owner);
453 
454     divCardIndexToPrice[newCardId] = _price;
455 
456     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
457     _transfer(BANKROLL, _owner, newCardId);
458   }
459 
460   /// Check for token ownership
461   function _owns(address claimant, uint _divCardId)
462     private
463     view
464     returns (bool)
465   {
466     return claimant == divCardIndexToOwner[_divCardId];
467   }
468 
469   /// @dev Assigns ownership of a specific Card to an address.
470   function _transfer(address _from, address _to, uint _divCardId)
471     private
472   {
473     // Since the number of cards is capped to 2^32 we can't overflow this
474     ownershipDivCardCount[_to]++;
475     //transfer ownership
476     divCardIndexToOwner[_divCardId] = _to;
477 
478     // When creating new div cards _from is 0x0, but we can't account that address.
479     if (_from != address(0)) {
480       ownershipDivCardCount[_from]--;
481       // clear any previously approved ownership exchange
482       delete divCardIndexToApproved[_divCardId];
483     }
484 
485     // Emit the transfer event.
486     emit Transfer(_from, _to, _divCardId);
487   }
488 }
489 
490 // SafeMath library
491 library SafeMath {
492 
493   /**
494   * @dev Multiplies two numbers, throws on overflow.
495   */
496   function mul(uint a, uint b) internal pure returns (uint) {
497     if (a == 0) {
498       return 0;
499     }
500     uint c = a * b;
501     assert(c / a == b);
502     return c;
503   }
504 
505   /**
506   * @dev Integer division of two numbers, truncating the quotient.
507   */
508   function div(uint a, uint b) internal pure returns (uint) {
509     // assert(b > 0); // Solidity automatically throws when dividing by 0
510     uint c = a / b;
511     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
512     return c;
513   }
514 
515   /**
516   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
517   */
518   function sub(uint a, uint b) internal pure returns (uint) {
519     assert(b <= a);
520     return a - b;
521   }
522 
523   /**
524   * @dev Adds two numbers, throws on overflow.
525   */
526   function add(uint a, uint b) internal pure returns (uint) {
527     uint c = a + b;
528     assert(c >= a);
529     return c;
530   }
531 }
532 
533 /**
534  * Utility library of inline functions on addresses
535  */
536 library AddressUtils {
537 
538   /**
539    * Returns whether the target address is a contract
540    * @dev This function will return false if invoked during the constructor of a contract,
541    *  as the code is not actually created until after the constructor finishes.
542    * @param addr address to check
543    * @return whether the target address is a contract
544    */
545   function isContract(address addr) internal view returns (bool) {
546     uint size;
547     // XXX Currently there is no better way to check if there is a contract in an address
548     // than to check the size of the code at that address.
549     // See https://ethereum.stackexchange.com/a/14016/36603
550     // for more details about how this works.
551     // TODO Check this again before the Serenity release, because all addresses will be
552     // contracts then.
553     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
554     return size > 0;
555   }
556 
557 }