1 pragma solidity ^0.4.18;
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 contract ERC721 {
6     // Required methods
7     function implementsERC721() public pure returns (bool);
8     // ERC20 compatible methods
9     function name() public pure returns (string);
10     function symbol() public pure returns (string);
11     function balanceOf(address _owner) public view returns (uint256 balance);
12     function totalSupply() public view returns (uint256 total);
13     // Methods defining ownership
14     function ownerOf(uint256 _tokenId) public view returns (address addr);
15     function approve(address _to, uint256 _tokenId) public;
16     function takeOwnership(uint256 _tokenId) public;
17     function transferFrom(address _from, address _to, uint256 _tokenId) public;
18     function transfer(address _to, uint256 _tokenId) public;
19     // Events
20     event Transfer(address indexed from, address indexed to, uint256 tokenId);
21     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
22 }
23 
24 contract YTIcons is ERC721 {
25 
26     /* CONSTANTS */
27 
28     /// Name and symbol of the non-fungible token (ERC721)
29     string public constant NAME = "YTIcons";
30     string public constant SYMBOL = "YTIcon";
31 
32     /// The corporation address that will be used for its development (giveaway, game events...)
33     address private _utilityFund = 0x6B06a2a15dCf3AE45b9F133Be6FD0Be5a9FAedC2;
34 
35     /// When a card isn't verified, the normal share given to the beneficiary linked
36     /// to the card is given to the charity fund's address instead.
37     address private _charityFund = 0xF9864660c4aa89E241d7D44903D3c8A207644332;
38 
39     uint16 public _generation = 0;
40     uint256 private _defaultPrice = 0.001 ether;
41     uint256 private firstLimit =  0.05 ether;
42     uint256 private secondLimit = 0.5 ether;
43     uint256 private thirdLimit = 1 ether;
44 
45 
46     /* STORAGE */
47 
48     /// An array containing all of the owners addresses :
49     /// those addresses are the only ones that can execute actions requiring an admin.
50     address private _owner0x = 0x8E787E0c0B05BE25Ec993C5e109881166b675b31;
51     address private _ownerA =  0x97fEA5464539bfE3810b8185E9Fa9D2D6d68a52c;
52     address private _ownerB =  0x0678Ecc4Db075F89B966DE7Ea945C4A866966b0e;
53     address private _ownerC =  0xC39574B02b76a43B03747641612c3d332Dec679B;
54     address private _ownerD =  0x1282006521647ca094503219A61995C8142a9824;
55 
56     Card[] private _cards;
57 
58     /// A mapping from cards' IDs to their prices [0], the last investment* [1] and their highest price [2].
59     /// *If someone buys an icon for 0.001 ETH, then the last investment of the card will be 0.001 ETH. If someone else buys it back at 0.002 ETH,
60     /// then the last investment will be 0.002 ETH.
61     mapping (uint256 => uint256[3]) private _cardsPrices;
62 
63     /// A mapping from cards' names to the beneficiary addresses
64     mapping (uint256 => address) private _beneficiaryAddresses;
65 
66     /// A mapping from cards' IDs to their owners
67     mapping (uint256 => address) private _cardsOwners;
68 
69     /// A mapping from owner address to count of tokens that address owns.
70     /// Used for ERC721's method 'balanceOf()' to resolve ownership count.
71     mapping (address => uint256) private _tokenPerOwners;
72 
73     /// A mapping from cards' ids to an address that has been approved to call
74     /// transferFrom(). Each Card can only have one approved address for transfer
75     /// at any time. A zero value means no approval is outstanding.
76     mapping (uint256 => address) public _allowedAddresses;
77 
78 
79     /* STRUCTURES */
80 
81     struct Card {
82         uint16  generation;
83         string  name;
84         bool    isLocked;
85     }
86 
87     /* EVENTS */
88     event YTIconSold(uint256 tokenId, uint256 newPrice, address newOwner);
89     event PriceModified(uint256 tokenId, uint256 newPrice);
90 
91 
92 
93     /* ACCESS MODIFIERS */
94 
95     /// Access modifier for owner's functionalities and actions only
96     modifier ownerOnly() {
97         require(msg.sender == _owner0x || msg.sender == _ownerA || msg.sender == _ownerB || msg.sender == _ownerC || msg.sender == _ownerD);
98         _;
99     }
100 
101 
102     /* PROTOCOL METHODS (ERC721) */
103 
104     function implementsERC721() public pure returns (bool) {
105         return true;
106     }
107 
108         /**************/
109         /* ERC20 compatible methods */
110         /**************/
111 
112     /// This function is used to tell outside contracts and applications the name of this token.
113     function name() public pure returns (string) {
114         return NAME;
115     }
116 
117     /// It provides outside programs with the token’s shorthand name, or symbol.
118     function symbol() public pure returns (string) {
119         return SYMBOL;
120     }
121 
122     /// This function returns the total number of coins available on the blockchain.
123     /// The supply does not have to be constant.
124     function totalSupply() public view returns (uint256 supply) {
125         return _cards.length;
126     }
127 
128     /// This function is used to find the number of tokens that a given address owns.
129     function balanceOf(address _owner) public view returns (uint balance) {
130         return _tokenPerOwners[_owner];
131     }
132 
133         /**************/
134         /* Ownership methods */
135         /**************/
136 
137     /// This function returns the address of the owner of a token. Because each ERC721 token is non-fungible and,
138     /// therefore, unique, it’s referenced on the blockchain via a unique ID.
139     /// We can determine the owner of a token using its ID.
140     function ownerOf(uint256 _tokenId) public view returns (address owner) {
141         require(_addressNotNull(_cardsOwners[_tokenId]));
142         return _cardsOwners[_tokenId];
143     }
144 
145     /// This function approves, or grants, another entity permission to transfer a token on the owner’s behalf.
146     function approve(address _to, uint256 _tokenId) public {
147         require(bytes(_cards[_tokenId].name).length != 0);
148         require(!_cards[_tokenId].isLocked);
149         require(_owns(msg.sender, _tokenId));
150         require(msg.sender != _to);
151         _allowedAddresses[_tokenId] = _to;
152         Approval(msg.sender, _to, _tokenId);
153     }
154 
155     /// This function acts like a withdraw function, since an outside party can call it in order
156     /// to take tokens out of another user’s account.
157     /// Therefore, takeOwnership can be used to when a user has been approved to own a certain amount of
158     /// tokens and wishes to withdraw said tokens from another user’s balance.
159     function takeOwnership(uint256 _tokenId) public {
160         require(bytes(_cards[_tokenId].name).length != 0);
161         require(!_cards[_tokenId].isLocked);
162         address newOwner = msg.sender;
163         address oldOwner = _cardsOwners[_tokenId];
164         require(_addressNotNull(newOwner));
165         require(newOwner != oldOwner);
166         require(_isAllowed(newOwner, _tokenId));
167 
168         _transfer(oldOwner, newOwner, _tokenId);
169     }
170 
171     /// "transfer" lets the owner of a token send it to another user, similar to a standalone cryptocurrency.
172     function transfer(address _to, uint256 _tokenId) public {
173         require(bytes(_cards[_tokenId].name).length != 0);
174         require(!_cards[_tokenId].isLocked);
175         require(_owns(msg.sender, _tokenId));
176         require(msg.sender != _to);
177         require(_addressNotNull(_to));
178 
179         _transfer(msg.sender, _to, _tokenId);
180     }
181 
182     function _transfer(address from, address to, uint256 tokenId) private {
183         // Transfer ownership to the new owner
184         _cardsOwners[tokenId] = to;
185         // Increase the number of tokens own by the new owner
186         _tokenPerOwners[to] += 1;
187 
188         // When creating new cards, from is address(0)
189         if (from != address(0)) {
190             _tokenPerOwners[from] -= 1;
191             // clear any previously approved ownership exchange
192             delete _allowedAddresses[tokenId];
193         }
194 
195         // Emit the transfer event.
196         Transfer(from, to, tokenId);
197     }
198 
199     /// Third-party initiates transfer of token from address from to address to
200     function transferFrom(address from, address to, uint256 tokenId) public {
201         require(!_cards[tokenId].isLocked);
202         require(_owns(from, tokenId));
203         require(_isAllowed(to, tokenId));
204         require(_addressNotNull(to));
205 
206         _transfer(from, to, tokenId);
207     }
208 
209 
210     /* MANAGEMENT FUNCTIONS -- ONLY USABLE BY ADMINS */
211 
212     function createCard(string cardName, uint price, address cardOwner, address beneficiary, bool isLocked) public ownerOnly {
213         require(bytes(cardName).length != 0);
214         price = price == 0 ? _defaultPrice : price;
215         _createCard(cardName, price, cardOwner, beneficiary, isLocked);
216     }
217 
218     function createCardFromName(string cardName) public ownerOnly {
219         require(bytes(cardName).length != 0);
220         _createCard(cardName, _defaultPrice, address(0), address(0), false);
221     }
222 
223     /// Create card
224     function _createCard(string cardName, uint price, address cardOwner, address beneficiary, bool isLocked) private {
225         require(_cards.length < 2^256 - 1);
226         Card memory card = Card({
227                                     generation: _generation,
228                                     name: cardName,
229                                     isLocked: isLocked
230                                 });
231         _cardsPrices[_cards.length][0] = price; // Current price
232         _cardsPrices[_cards.length][1] = price; // Last bought price
233         _cardsPrices[_cards.length][2] = price; // Highest
234         _cardsOwners[_cards.length] = cardOwner;
235         _beneficiaryAddresses[_cards.length] = beneficiary;
236         _tokenPerOwners[cardOwner] += 1;
237         _cards.push(card);
238     }
239 
240 
241     /// Change the current generation
242     function evolveGeneration(uint16 newGeneration) public ownerOnly {
243         _generation = newGeneration;
244     }
245 
246     /// Change the address of one owner.
247     function setOwner(address currentAddress, address newAddress) public ownerOnly {
248         require(_addressNotNull(newAddress));
249 
250         if (currentAddress == _ownerA) {
251             _ownerA = newAddress;
252         } else if (currentAddress == _ownerB) {
253             _ownerB = newAddress;
254         } else if (currentAddress == _ownerC) {
255             _ownerC = newAddress;
256         } else if (currentAddress == _ownerD) {
257             _ownerD = newAddress;
258         }
259     }
260 
261     /// Set the charity fund.
262     function setCharityFund(address newCharityFund) public ownerOnly {
263         _charityFund = newCharityFund;
264     }
265 
266     /// Set the beneficiary ETH address.
267     function setBeneficiaryAddress(uint256 tokenId, address beneficiaryAddress) public ownerOnly {
268         require(bytes(_cards[tokenId].name).length != 0);
269         _beneficiaryAddresses[tokenId] = beneficiaryAddress;
270     }
271 
272     /// Lock a card and make it unusable
273     function lock(uint256 tokenId) public ownerOnly {
274         require(!_cards[tokenId].isLocked);
275         _cards[tokenId].isLocked = true;
276     }
277 
278     /// Unlock a YTIcon and make it usable
279     function unlock(uint256 tokenId) public ownerOnly {
280         require(_cards[tokenId].isLocked);
281         _cards[tokenId].isLocked = false;
282     }
283 
284     /// Get the smart contract's balance out of the contract and transfers it to every related account.
285     function payout() public ownerOnly {
286         _payout();
287     }
288 
289     function _payout() private {
290         uint256 balance = this.balance;
291         _ownerA.transfer(SafeMath.div(SafeMath.mul(balance, 20), 100));
292         _ownerB.transfer(SafeMath.div(SafeMath.mul(balance, 20), 100));
293         _ownerC.transfer(SafeMath.div(SafeMath.mul(balance, 20), 100));
294         _ownerD.transfer(SafeMath.div(SafeMath.mul(balance, 20), 100));
295         _utilityFund.transfer(SafeMath.div(SafeMath.mul(balance, 20), 100));
296     }
297 
298 
299     /* UTILS */
300 
301     /// Check if the address is valid by checking if it is not equal to 0x0.
302     function _addressNotNull(address target) private pure returns (bool) {
303         return target != address(0);
304     }
305 
306     /// Check for token ownership
307     function _owns(address pretender, uint256 tokenId) private view returns (bool) {
308         return pretender == _cardsOwners[tokenId];
309     }
310 
311     function _isAllowed(address claimant, uint256 tokenId) private view returns (bool) {
312         return _allowedAddresses[tokenId] == claimant;
313     }
314 
315     /* PUBLIC FUNCTIONS */
316 
317     /// Get all of the useful card's informations.
318     function getCard(uint256 tokenId) public view returns (string cardName, uint16 generation, bool isLocked, uint256 price, address owner, address beneficiary, bool isVerified) {
319         Card storage card = _cards[tokenId];
320         cardName = card.name;
321         require(bytes(cardName).length != 0);
322         generation = card.generation;
323         isLocked = card.isLocked;
324         price = _cardsPrices[tokenId][0];
325         owner = _cardsOwners[tokenId];
326         beneficiary = _beneficiaryAddresses[tokenId];
327         isVerified = _addressNotNull(_beneficiaryAddresses[tokenId]) ? true : false;
328     }
329 
330     /// Set a lower price if the sender is the card's owner.
331     function setPrice(uint256 tokenId, uint256 newPrice) public {
332         require(!_cards[tokenId].isLocked);
333         // If new price > 0
334         // If the new price is higher or equal to the basic investment of the owner (e.g. if someone buys a card 0.001 ETH, then the default investment will be 0.001)
335         // If the new price is lower or equal than the highest price set by the algorithm.
336         require(newPrice > 0 && newPrice >= _cardsPrices[tokenId][1] && newPrice <= _cardsPrices[tokenId][2]);
337         require(msg.sender == _cardsOwners[tokenId]);
338 
339         _cardsPrices[tokenId][0] = newPrice;
340         PriceModified(tokenId, newPrice);
341     }
342 
343     function purchase(uint256 tokenId) public payable {
344         require(!_cards[tokenId].isLocked);
345         require(_cardsPrices[tokenId][0] > 0);
346 
347         address oldOwner = _cardsOwners[tokenId];
348         address newOwner = msg.sender;
349 
350         uint256 sellingPrice = _cardsPrices[tokenId][0];
351 
352         // Making sure the token owner isn't trying to purchase his/her own token.
353         require(oldOwner != newOwner);
354 
355         require(_addressNotNull(newOwner));
356 
357         // Making sure the amount sent is greater than or equal to the sellingPrice.
358         require(msg.value >= sellingPrice);
359 
360         uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
361         uint256 beneficiaryPayment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 3), 100));
362         uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
363         uint256 newPrice = 0;
364 
365         // Update prices
366         if (sellingPrice < firstLimit) {
367             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
368         } else if (sellingPrice < secondLimit) {
369             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, 150), 92);
370         } else if (sellingPrice < thirdLimit) {
371             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, 125), 92);
372         } else {
373             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);
374         }
375 
376         _cardsPrices[tokenId][0] = newPrice; // New price
377         _cardsPrices[tokenId][1] = sellingPrice; // Last bought price
378         _cardsPrices[tokenId][2] = newPrice; // New highest price
379 
380         _transfer(oldOwner, newOwner, tokenId);
381 
382         // Pay previous owner
383         if (oldOwner != address(this) && oldOwner != address(0)) {
384             oldOwner.transfer(payment);
385         }
386 
387         if (_beneficiaryAddresses[tokenId] != address(0)) {
388             _beneficiaryAddresses[tokenId].transfer(beneficiaryPayment);
389         } else {
390             _charityFund.transfer(beneficiaryPayment);
391         }
392 
393         YTIconSold(tokenId, newPrice, newOwner);
394 
395         msg.sender.transfer(purchaseExcess);
396     }
397 
398     function getOwnerCards(address owner) public view returns(uint256[] ownerTokens) {
399         uint256 balance = balanceOf(owner);
400         if (balance == 0) {
401             return new uint256[](0);
402         } else {
403             uint256[] memory result = new uint256[](balance);
404             uint256 total = totalSupply();
405             uint256 resultIndex = 0;
406 
407             uint256 cardId;
408             for (cardId = 0; cardId <= total; cardId++) {
409                 if (_cardsOwners[cardId] == owner) {
410                     result[resultIndex] = cardId;
411                     resultIndex++;
412                 }
413             }
414             return result;
415         }
416     }
417 
418     function getHighestPrice(uint256 tokenId) public view returns(uint256 highestPrice) {
419         highestPrice = _cardsPrices[tokenId][1];
420     }
421 
422 }
423 
424 
425 /**
426  * @title SafeMath
427  * @dev Math operations with safety checks that throw on error
428  */
429 library SafeMath {
430 
431     /**
432     * @dev Multiplies two numbers, throws on overflow.
433     */
434     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
435         if (a == 0) {
436             return 0;
437         }
438         uint256 c = a * b;
439         assert(c / a == b);
440         return c;
441     }
442 
443     /**
444     * @dev Integer division of two numbers, truncating the quotient.
445     */
446     function div(uint256 a, uint256 b) internal pure returns (uint256) {
447         // assert(b > 0); // Solidity automatically throws when dividing by 0
448         uint256 c = a / b;
449         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
450         return c;
451     }
452 
453     /**
454     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
455     */
456     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
457         assert(b <= a);
458         return a - b;
459     }
460 
461 }