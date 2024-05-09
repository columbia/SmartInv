1 pragma solidity ^0.4.24;
2 
3 /**
4 
5 https://fortisgames.com https://fortisgames.com https://fortisgames.com https://fortisgames.com https://fortisgames.com
6                                                                                                     
7 FFFFFFFFFFFFFFFFFFFFFF                                           tttt            iiii                   
8 F::::::::::::::::::::F                                        ttt:::t           i::::i                  
9 F::::::::::::::::::::F                                        t:::::t            iiii                   
10 FF::::::FFFFFFFFF::::F                                        t:::::t                                   
11   F:::::F       FFFFFFooooooooooo   rrrrr   rrrrrrrrr   ttttttt:::::ttttttt    iiiiiii     ssssssssss   
12   F:::::F           oo:::::::::::oo r::::rrr:::::::::r  t:::::::::::::::::t    i:::::i   ss::::::::::s  
13   F::::::FFFFFFFFFFo:::::::::::::::or:::::::::::::::::r t:::::::::::::::::t     i::::i ss:::::::::::::s 
14   F:::::::::::::::Fo:::::ooooo:::::orr::::::rrrrr::::::rtttttt:::::::tttttt     i::::i s::::::ssss:::::s
15   F:::::::::::::::Fo::::o     o::::o r:::::r     r:::::r      t:::::t           i::::i  s:::::s  ssssss 
16   F::::::FFFFFFFFFFo::::o     o::::o r:::::r     rrrrrrr      t:::::t           i::::i    s::::::s      
17   F:::::F          o::::o     o::::o r:::::r                  t:::::t           i::::i       s::::::s   
18   F:::::F          o::::o     o::::o r:::::r                  t:::::t    tttttt i::::i ssssss   s:::::s 
19 FF:::::::FF        o:::::ooooo:::::o r:::::r                  t::::::tttt:::::ti::::::is:::::ssss::::::s
20 F::::::::FF        o:::::::::::::::o r:::::r                  tt::::::::::::::ti::::::is::::::::::::::s 
21 F::::::::FF         oo:::::::::::oo  r:::::r                    tt:::::::::::tti::::::i s:::::::::::ss  
22 FFFFFFFFFFF           ooooooooooo    rrrrrrr                      ttttttttttt  iiiiiiii  sssssssssss    
23 
24 
25 Discord:   https://discord.gg/gDtTX62                                                                              
26 
27 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
28 This contract describes those collectibles. Don't get left with a hot potato!
29 
30 
31 **/
32 
33 // Required ERC721 interface.
34 
35 contract ERC721 {
36 
37   function approve(address _to, uint _tokenId) public;
38   function balanceOf(address _owner) public view returns (uint balance);
39   function implementsERC721() public pure returns (bool);
40   function ownerOf(uint _tokenId) public view returns (address addr);
41   function takeOwnership(uint _tokenId) public;
42   function totalSupply() public view returns (uint total);
43   function transferFrom(address _from, address _to, uint _tokenId) public;
44   function transfer(address _to, uint _tokenId) public;
45 
46   event Transfer(address indexed from, address indexed to, uint tokenId);
47   event Approval(address indexed owner, address indexed approved, uint tokenId);
48 
49 }
50 
51 contract ZethrDividendCards is ERC721 {
52     using SafeMath for uint;
53 
54   /*** EVENTS ***/
55 
56   /// @dev The Birth event is fired whenever a new dividend card comes into existence.
57   event Birth(uint tokenId, string name, address owner);
58 
59   /// @dev The TokenSold event is fired whenever a token (dividend card, in this case) is sold.
60   event TokenSold(uint tokenId, uint oldPrice, uint newPrice, address prevOwner, address winner, string name);
61 
62   /// @dev Transfer event as defined in current draft of ERC721.
63   ///  Ownership is assigned, including births.
64   event Transfer(address from, address to, uint tokenId);
65 
66   /*** CONSTANTS ***/
67 
68   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
69   string public constant NAME           = "ZethrDividendCard";
70   string public constant SYMBOL         = "ZDC";
71   address public         BANKROLL;
72 
73   /*** STORAGE ***/
74 
75   /// @dev A mapping from dividend card indices to the address that owns them.
76   ///  All dividend cards have a valid owner address.
77 
78   mapping (uint => address) public      divCardIndexToOwner;
79 
80   // A mapping from a dividend rate to the card index.
81 
82   mapping (uint => uint) public         divCardRateToIndex;
83 
84   // @dev A mapping from owner address to the number of dividend cards that address owns.
85   //  Used internally inside balanceOf() to resolve ownership count.
86 
87   mapping (address => uint) private     ownershipDivCardCount;
88 
89   /// @dev A mapping from dividend card indices to an address that has been approved to call
90   ///  transferFrom(). Each dividend card can only have one approved address for transfer
91   ///  at any time. A zero value means no approval is outstanding.
92 
93   mapping (uint => address) public      divCardIndexToApproved;
94 
95   // @dev A mapping from dividend card indices to the price of the dividend card.
96 
97   mapping (uint => uint) private        divCardIndexToPrice;
98 
99   mapping (address => bool) internal    administrators;
100 
101   address public                        creator;
102   bool    public                        onSale;
103 
104   /*** DATATYPES ***/
105 
106   struct Card {
107     string name;
108     uint percentIncrease;
109   }
110 
111   Card[] private divCards;
112 
113   modifier onlyCreator() {
114     require(msg.sender == creator);
115     _;
116   }
117 
118   constructor (address _bankroll) public {
119     creator = msg.sender;
120     BANKROLL = _bankroll;
121 
122     createDivCard("2%", 1 ether, 2);
123     divCardRateToIndex[2] = 0;
124 
125     createDivCard("5%", 1 ether, 5);
126     divCardRateToIndex[5] = 1;
127 
128     createDivCard("10%", 1 ether, 10);
129     divCardRateToIndex[10] = 2;
130 
131     createDivCard("15%", 1 ether, 15);
132     divCardRateToIndex[15] = 3;
133 
134     createDivCard("20%", 1 ether, 20);
135     divCardRateToIndex[20] = 4;
136 
137     createDivCard("25%", 1 ether, 25);
138     divCardRateToIndex[25] = 5;
139 
140     createDivCard("33%", 1 ether, 33);
141     divCardRateToIndex[33] = 6;
142 
143     createDivCard("MASTER", 5 ether, 10);
144     divCardRateToIndex[999] = 7;
145 
146 	onSale = false;
147 
148     administrators[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true; // Norsefire
149     administrators[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true; // klob
150     administrators[0x20C945800de43394F70D789874a4daC9cFA57451] = true; // Etherguy
151     administrators[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true; // blurr
152 
153   }
154 
155   /*** MODIFIERS ***/
156 
157     // Modifier to prevent contracts from interacting with the flip cards
158     modifier isNotContract()
159     {
160         require (msg.sender == tx.origin);
161         _;
162     }
163 
164 	// Modifier to prevent purchases before we open them up to everyone
165 	modifier hasStarted()
166     {
167 		require (onSale == true);
168 		_;
169 	}
170 
171 	modifier isAdmin()
172     {
173 	    require(administrators[msg.sender]);
174 	    _;
175     }
176 
177   /*** PUBLIC FUNCTIONS ***/
178   // Administrative update of the bankroll contract address
179     function setBankroll(address where)
180         isAdmin
181     {
182         BANKROLL = where;
183     }
184 
185   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
186   /// @param _to The address to be granted transfer approval. Pass address(0) to
187   ///  clear all approvals.
188   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
189   /// @dev Required for ERC-721 compliance.
190   function approve(address _to, uint _tokenId)
191     public
192     isNotContract
193   {
194     // Caller must own token.
195     require(_owns(msg.sender, _tokenId));
196 
197     divCardIndexToApproved[_tokenId] = _to;
198 
199     emit Approval(msg.sender, _to, _tokenId);
200   }
201 
202   /// For querying balance of a particular account
203   /// @param _owner The address for balance query
204   /// @dev Required for ERC-721 compliance.
205   function balanceOf(address _owner)
206     public
207     view
208     returns (uint balance)
209   {
210     return ownershipDivCardCount[_owner];
211   }
212 
213   // Creates a div card with bankroll as the owner
214   function createDivCard(string _name, uint _price, uint _percentIncrease)
215     public
216     onlyCreator
217   {
218     _createDivCard(_name, BANKROLL, _price, _percentIncrease);
219   }
220 
221 	// Opens the dividend cards up for sale.
222 	function startCardSale()
223         public
224         onlyCreator
225     {
226 		onSale = true;
227 	}
228 
229   /// @notice Returns all the relevant information about a specific div card
230   /// @param _divCardId The tokenId of the div card of interest.
231   function getDivCard(uint _divCardId)
232     public
233     view
234     returns (string divCardName, uint sellingPrice, address owner)
235   {
236     Card storage divCard = divCards[_divCardId];
237     divCardName = divCard.name;
238     sellingPrice = divCardIndexToPrice[_divCardId];
239     owner = divCardIndexToOwner[_divCardId];
240   }
241 
242   function implementsERC721()
243     public
244     pure
245     returns (bool)
246   {
247     return true;
248   }
249 
250   /// @dev Required for ERC-721 compliance.
251   function name()
252     public
253     pure
254     returns (string)
255   {
256     return NAME;
257   }
258 
259   /// For querying owner of token
260   /// @param _divCardId The tokenID for owner inquiry
261   /// @dev Required for ERC-721 compliance.
262   function ownerOf(uint _divCardId)
263     public
264     view
265     returns (address owner)
266   {
267     owner = divCardIndexToOwner[_divCardId];
268     require(owner != address(0));
269 	return owner;
270   }
271 
272   // Allows someone to send Ether and obtain a card
273   function purchase(uint _divCardId)
274     public
275     payable
276     hasStarted
277     isNotContract
278   {
279     address oldOwner  = divCardIndexToOwner[_divCardId];
280     address newOwner  = msg.sender;
281 
282     // Get the current price of the card
283     uint currentPrice = divCardIndexToPrice[_divCardId];
284 
285     // Making sure token owner is not sending to self
286     require(oldOwner != newOwner);
287 
288     // Safety check to prevent against an unexpected 0x0 default.
289     require(_addressNotNull(newOwner));
290 
291     // Making sure sent amount is greater than or equal to the sellingPrice
292     require(msg.value >= currentPrice);
293 
294     // To find the total profit, we need to know the previous price
295     // currentPrice      = previousPrice * (100 + percentIncrease);
296     // previousPrice     = currentPrice / (100 + percentIncrease);
297     uint percentIncrease = divCards[_divCardId].percentIncrease;
298     uint previousPrice   = SafeMath.mul(currentPrice, 100).div(100 + percentIncrease);
299 
300     // Calculate total profit and allocate 50% to old owner, 50% to bankroll
301     uint totalProfit     = SafeMath.sub(currentPrice, previousPrice);
302     uint oldOwnerProfit  = SafeMath.div(totalProfit, 2);
303     uint bankrollProfit  = SafeMath.sub(totalProfit, oldOwnerProfit);
304     oldOwnerProfit       = SafeMath.add(oldOwnerProfit, previousPrice);
305 
306     // Refund the sender the excess he sent
307     uint purchaseExcess  = SafeMath.sub(msg.value, currentPrice);
308 
309     // Raise the price by the percentage specified by the card
310     divCardIndexToPrice[_divCardId] = SafeMath.div(SafeMath.mul(currentPrice, (100 + percentIncrease)), 100);
311 
312     // Transfer ownership
313     _transfer(oldOwner, newOwner, _divCardId);
314 
315     // Using send rather than transfer to prevent contract exploitability.
316     BANKROLL.send(bankrollProfit);
317     oldOwner.send(oldOwnerProfit);
318 
319     msg.sender.transfer(purchaseExcess);
320   }
321 
322   function priceOf(uint _divCardId)
323     public
324     view
325     returns (uint price)
326   {
327     return divCardIndexToPrice[_divCardId];
328   }
329 
330   function setCreator(address _creator)
331     public
332     onlyCreator
333   {
334     require(_creator != address(0));
335 
336     creator = _creator;
337   }
338 
339   /// @dev Required for ERC-721 compliance.
340   function symbol()
341     public
342     pure
343     returns (string)
344   {
345     return SYMBOL;
346   }
347 
348   /// @notice Allow pre-approved user to take ownership of a dividend card.
349   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
350   /// @dev Required for ERC-721 compliance.
351   function takeOwnership(uint _divCardId)
352     public
353     isNotContract
354   {
355     address newOwner = msg.sender;
356     address oldOwner = divCardIndexToOwner[_divCardId];
357 
358     // Safety check to prevent against an unexpected 0x0 default.
359     require(_addressNotNull(newOwner));
360 
361     // Making sure transfer is approved
362     require(_approved(newOwner, _divCardId));
363 
364     _transfer(oldOwner, newOwner, _divCardId);
365   }
366 
367   /// For querying totalSupply of token
368   /// @dev Required for ERC-721 compliance.
369   function totalSupply()
370     public
371     view
372     returns (uint total)
373   {
374     return divCards.length;
375   }
376 
377   /// Owner initates the transfer of the card to another account
378   /// @param _to The address for the card to be transferred to.
379   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
380   /// @dev Required for ERC-721 compliance.
381   function transfer(address _to, uint _divCardId)
382     public
383     isNotContract
384   {
385     require(_owns(msg.sender, _divCardId));
386     require(_addressNotNull(_to));
387 
388     _transfer(msg.sender, _to, _divCardId);
389   }
390 
391   /// Third-party initiates transfer of a card from address _from to address _to
392   /// @param _from The address for the card to be transferred from.
393   /// @param _to The address for the card to be transferred to.
394   /// @param _divCardId The ID of the card that can be transferred if this call succeeds.
395   /// @dev Required for ERC-721 compliance.
396   function transferFrom(address _from, address _to, uint _divCardId)
397     public
398     isNotContract
399   {
400     require(_owns(_from, _divCardId));
401     require(_approved(_to, _divCardId));
402     require(_addressNotNull(_to));
403 
404     _transfer(_from, _to, _divCardId);
405   }
406 
407   function receiveDividends(uint _divCardRate)
408     public
409     payable
410   {
411     uint _divCardId = divCardRateToIndex[_divCardRate];
412     address _regularAddress = divCardIndexToOwner[_divCardId];
413     address _masterAddress = divCardIndexToOwner[7];
414 
415     uint toMaster = msg.value.div(2);
416     uint toRegular = msg.value.sub(toMaster);
417 
418     _masterAddress.send(toMaster);
419     _regularAddress.send(toRegular);
420   }
421 
422   /*** PRIVATE FUNCTIONS ***/
423   /// Safety check on _to address to prevent against an unexpected 0x0 default.
424   function _addressNotNull(address _to)
425     private
426     pure
427     returns (bool)
428   {
429     return _to != address(0);
430   }
431 
432   /// For checking approval of transfer for address _to
433   function _approved(address _to, uint _divCardId)
434     private
435     view
436     returns (bool)
437   {
438     return divCardIndexToApproved[_divCardId] == _to;
439   }
440 
441   /// For creating a dividend card
442   function _createDivCard(string _name, address _owner, uint _price, uint _percentIncrease)
443     private
444   {
445     Card memory _divcard = Card({
446       name: _name,
447       percentIncrease: _percentIncrease
448     });
449     uint newCardId = divCards.push(_divcard) - 1;
450 
451     // It's probably never going to happen, 4 billion tokens are A LOT, but
452     // let's just be 100% sure we never let this happen.
453     require(newCardId == uint(uint32(newCardId)));
454 
455     emit Birth(newCardId, _name, _owner);
456 
457     divCardIndexToPrice[newCardId] = _price;
458 
459     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
460     _transfer(BANKROLL, _owner, newCardId);
461   }
462 
463   /// Check for token ownership
464   function _owns(address claimant, uint _divCardId)
465     private
466     view
467     returns (bool)
468   {
469     return claimant == divCardIndexToOwner[_divCardId];
470   }
471 
472   /// @dev Assigns ownership of a specific Card to an address.
473   function _transfer(address _from, address _to, uint _divCardId)
474     private
475   {
476     // Since the number of cards is capped to 2^32 we can't overflow this
477     ownershipDivCardCount[_to]++;
478     //transfer ownership
479     divCardIndexToOwner[_divCardId] = _to;
480 
481     // When creating new div cards _from is 0x0, but we can't account that address.
482     if (_from != address(0)) {
483       ownershipDivCardCount[_from]--;
484       // clear any previously approved ownership exchange
485       delete divCardIndexToApproved[_divCardId];
486     }
487 
488     // Emit the transfer event.
489     emit Transfer(_from, _to, _divCardId);
490   }
491 }
492 
493 // SafeMath library
494 library SafeMath {
495 
496   /**
497   * @dev Multiplies two numbers, throws on overflow.
498   */
499   function mul(uint a, uint b) internal pure returns (uint) {
500     if (a == 0) {
501       return 0;
502     }
503     uint c = a * b;
504     assert(c / a == b);
505     return c;
506   }
507 
508   /**
509   * @dev Integer division of two numbers, truncating the quotient.
510   */
511   function div(uint a, uint b) internal pure returns (uint) {
512     // assert(b > 0); // Solidity automatically throws when dividing by 0
513     uint c = a / b;
514     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
515     return c;
516   }
517 
518   /**
519   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
520   */
521   function sub(uint a, uint b) internal pure returns (uint) {
522     assert(b <= a);
523     return a - b;
524   }
525 
526   /**
527   * @dev Adds two numbers, throws on overflow.
528   */
529   function add(uint a, uint b) internal pure returns (uint) {
530     uint c = a + b;
531     assert(c >= a);
532     return c;
533   }
534 }
535 
536 /**
537  * Utility library of inline functions on addresses
538  */
539 library AddressUtils {
540 
541   /**
542    * Returns whether the target address is a contract
543    * @dev This function will return false if invoked during the constructor of a contract,
544    *  as the code is not actually created until after the constructor finishes.
545    * @param addr address to check
546    * @return whether the target address is a contract
547    */
548   function isContract(address addr) internal view returns (bool) {
549     uint size;
550     // XXX Currently there is no better way to check if there is a contract in an address
551     // than to check the size of the code at that address.
552     // See https://ethereum.stackexchange.com/a/14016/36603
553     // for more details about how this works.
554     // TODO Check this again before the Serenity release, because all addresses will be
555     // contracts then.
556     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
557     return size > 0;
558   }
559 
560 }