1 pragma solidity ^0.4.18;
2 
3 /// Item23s :3
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8   // Required methods
9   function approve(address _to, uint256 _tokenId) public;
10   function balanceOf(address _owner) public view returns (uint256 balance);
11   function implementsERC721() public pure returns (bool);
12   function ownerOf(uint256 _tokenId) public view returns (address addr);
13   function takeOwnership(uint256 _tokenId) public;
14   function totalSupply() public view returns (uint256 total);
15   function transferFrom(address _from, address _to, uint256 _tokenId) public;
16   function transfer(address _to, uint256 _tokenId) public;
17 
18   event Transfer(address indexed from, address indexed to, uint256 tokenId);
19   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
20 
21 }
22 
23 /// Modified from the CryptoCelebrities contract And EmojiBlockhain and 50shadesETH
24 contract EtherHoroscope is ERC721 {
25 
26   /*** EVENTS ***/
27 
28   /// @dev The Birth event is fired whenever a new item23 comes into existence.
29   event Birth(uint256 tokenId, string name, address owner);
30 
31   /// @dev The TokenSold event is fired whenever a token is sold.
32   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
33 
34   /// @dev Transfer event as defined in current draft of ERC721.
35   ///  ownership is assigned, including births.
36   event Transfer(address from, address to, uint256 tokenId);
37 
38   /*** CONSTANTS ***/
39   //uint256 private startingPrice = 0.001 ether;
40 
41   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
42   string public constant NAME = "CryptoHoroscopes"; // solhint-disable-line
43   string public constant SYMBOL = "CryptoHoroscope"; // solhint-disable-line
44 
45   /*** STORAGE ***/
46 
47   /// @dev A mapping from item23 IDs to the address that owns them. All item23s have
48   ///  some valid owner address.
49   mapping (uint256 => address) public item23IndexToOwner;
50 
51   // @dev A mapping from owner address to count of tokens that address owns.
52   //  Used internally inside balanceOf() to resolve ownership count.
53   mapping (address => uint256) private ownershipTokenCount;
54 
55   /// @dev A mapping from Item23IDs to an address that has been approved to call
56   ///  transferFrom(). Each Item23 can only have one approved address for transfer
57   ///  at any time. A zero value means no approval is outstanding.
58   mapping (uint256 => address) public item23IndexToApproved;
59 
60   // @dev A mapping from Item23IDs to the price of the token.
61   mapping (uint256 => uint256) private item23IndexToPrice;
62 
63   /// @dev A mapping from Item23IDs to the previpus price of the token. Used
64   /// to calculate price delta for payouts
65   mapping (uint256 => uint256) private item23IndexToPreviousPrice;
66 
67   // @dev A mapping from item23Id to the 7 last owners.
68   mapping (uint256 => address[5]) private item23IndexToPreviousOwners;
69 
70 
71   // The addresses of the accounts (or contracts) that can execute actions within each roles.
72   address public ceoAddress;
73   address public cooAddress;
74 
75   /*** DATATYPES ***/
76   struct Item23 {
77     string name;
78   }
79 
80   Item23[] private item23s;
81 
82   /*** ACCESS MODIFIERS ***/
83   /// @dev Access modifier for CEO-only functionality
84   modifier onlyCEO() {
85     require(msg.sender == ceoAddress);
86     _;
87   }
88 
89   /// @dev Access modifier for COO-only functionality
90   modifier onlyCOO() {
91     require(msg.sender == cooAddress);
92     _;
93   }
94 
95   /// Access modifier for contract owner only functionality
96   modifier onlyCLevel() {
97     require(
98       msg.sender == ceoAddress ||
99       msg.sender == cooAddress
100     );
101     _;
102   }
103 
104   /*** CONSTRUCTOR ***/
105   function EtherHoroscope() public {
106     ceoAddress = msg.sender;
107     cooAddress = msg.sender;
108   }
109 
110   /*** PUBLIC FUNCTIONS ***/
111   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
112   /// @param _to The address to be granted transfer approval. Pass address(0) to
113   ///  clear all approvals.
114   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
115   /// @dev Required for ERC-721 compliance.
116   function approve(
117     address _to,
118     uint256 _tokenId
119   ) public {
120     // Caller must own token.
121     require(_owns(msg.sender, _tokenId));
122 
123     item23IndexToApproved[_tokenId] = _to;
124 
125     Approval(msg.sender, _to, _tokenId);
126   }
127 
128   /// For querying balance of a particular account
129   /// @param _owner The address for balance query
130   /// @dev Required for ERC-721 compliance.
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return ownershipTokenCount[_owner];
133   }
134 
135   /// @dev Creates a new Item23 with the given name.
136   function createContractItem23(string _name , string _startingP ) public onlyCOO {
137     _createItem23(_name, address(this), stringToUint( _startingP));
138   }
139 
140 
141 
142 function stringToUint(string _amount) internal constant returns (uint result) {
143     bytes memory b = bytes(_amount);
144     uint i;
145     uint counterBeforeDot;
146     uint counterAfterDot;
147     result = 0;
148     uint totNum = b.length;
149     totNum--;
150     bool hasDot = false;
151 
152     for (i = 0; i < b.length; i++) {
153         uint c = uint(b[i]);
154 
155         if (c >= 48 && c <= 57) {
156             result = result * 10 + (c - 48);
157             counterBeforeDot ++;
158             totNum--;
159         }
160 
161         if(c == 46){
162             hasDot = true;
163             break;
164         }
165     }
166 
167     if(hasDot) {
168         for (uint j = counterBeforeDot + 1; j < 18; j++) {
169             uint m = uint(b[j]);
170 
171             if (m >= 48 && m <= 57) {
172                 result = result * 10 + (m - 48);
173                 counterAfterDot ++;
174                 totNum--;
175             }
176 
177             if(totNum == 0){
178                 break;
179             }
180         }
181     }
182      if(counterAfterDot < 18){
183          uint addNum = 18 - counterAfterDot;
184          uint multuply = 10 ** addNum;
185          return result = result * multuply;
186      }
187 
188      return result;
189 }
190 
191 
192   /// @notice Returns all the relevant information about a specific item23.
193   /// @param _tokenId The tokenId of the item23 of interest.
194   function getItem23(uint256 _tokenId) public view returns (
195     string item23Name,
196     uint256 sellingPrice,
197     address owner,
198     uint256 previousPrice,
199     address[5] previousOwners
200   ) {
201     Item23 storage item23 = item23s[_tokenId];
202     item23Name = item23.name;
203     sellingPrice = item23IndexToPrice[_tokenId];
204     owner = item23IndexToOwner[_tokenId];
205     previousPrice = item23IndexToPreviousPrice[_tokenId];
206     previousOwners = item23IndexToPreviousOwners[_tokenId];
207   }
208 
209 
210   function implementsERC721() public pure returns (bool) {
211     return true;
212   }
213 
214   /// @dev Required for ERC-721 compliance.
215   function name() public pure returns (string) {
216     return NAME;
217   }
218 
219   /// For querying owner of token
220   /// @param _tokenId The tokenID for owner inquiry
221   /// @dev Required for ERC-721 compliance.
222   function ownerOf(uint256 _tokenId)
223     public
224     view
225     returns (address owner)
226   {
227     owner = item23IndexToOwner[_tokenId];
228     require(owner != address(0));
229   }
230 
231   function payout(address _to) public onlyCLevel {
232     _payout(_to);
233   }
234 
235   // Allows someone to send ether and obtain the token
236   function purchase(uint256 _tokenId) public payable {
237     address oldOwner = item23IndexToOwner[_tokenId];
238     address newOwner = msg.sender;
239 
240     address[5] storage previousOwners = item23IndexToPreviousOwners[_tokenId];
241 
242     uint256 sellingPrice = item23IndexToPrice[_tokenId];
243     uint256 previousPrice = item23IndexToPreviousPrice[_tokenId];
244     // Making sure token owner is not sending to self
245     require(oldOwner != newOwner);
246 
247     // Safety check to prevent against an unexpected 0x0 default.
248     require(_addressNotNull(newOwner));
249 
250     // Making sure sent amount is greater than or equal to the sellingPrice
251     require(msg.value >= sellingPrice);
252 
253     uint256 priceDelta = SafeMath.sub(sellingPrice, previousPrice);
254     uint256 ownerPayout = SafeMath.add(previousPrice, SafeMath.mul(SafeMath.div(priceDelta, 100), 40));
255 
256 
257     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
258 
259     item23IndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
260     item23IndexToPreviousPrice[_tokenId] = sellingPrice;
261 
262     uint256 strangePrice = uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10));
263     uint256 strangePrice2 = uint256(0);
264 
265 
266     // Pay previous tokenOwner if owner is not contract
267     // and if previous price is not 0
268     if (oldOwner != address(this)) {
269       // old owner gets entire initial payment back
270       oldOwner.transfer(ownerPayout);
271     } else {
272       strangePrice = SafeMath.add(ownerPayout, strangePrice);
273     }
274 
275     // Next distribute payout Total among previous Owners
276     for (uint i = 0; i < 5; i++) {
277         if (previousOwners[i] != address(this)) {
278             strangePrice2+=uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10));
279         } else {
280             strangePrice = SafeMath.add(strangePrice, uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10)));
281         }
282     }
283 
284     ceoAddress.transfer(strangePrice+strangePrice2);
285     //ceoAddress.transfer(strangePrice2);
286     _transfer(oldOwner, newOwner, _tokenId);
287 
288     //TokenSold(_tokenId, sellingPrice, item23IndexToPrice[_tokenId], oldOwner, newOwner, item23s[_tokenId].name);
289 
290     msg.sender.transfer(purchaseExcess);
291   }
292 
293 
294   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
295     return item23IndexToPrice[_tokenId];
296   }
297 
298   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
299   /// @param _newCEO The address of the new CEO
300   function setCEO(address _newCEO) public onlyCEO {
301     require(_newCEO != address(0));
302 
303     ceoAddress = _newCEO;
304   }
305 
306   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
307   /// @param _newCOO The address of the new COO
308   function setCOO(address _newCOO) public onlyCEO {
309     require(_newCOO != address(0));
310     cooAddress = _newCOO;
311   }
312 
313   /// @dev Required for ERC-721 compliance.
314   function symbol() public pure returns (string) {
315     return SYMBOL;
316   }
317 
318   /// @notice Allow pre-approved user to take ownership of a token
319   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
320   /// @dev Required for ERC-721 compliance.
321   function takeOwnership(uint256 _tokenId) public {
322     address newOwner = msg.sender;
323     address oldOwner = item23IndexToOwner[_tokenId];
324 
325     // Safety check to prevent against an unexpected 0x0 default.
326     require(_addressNotNull(newOwner));
327 
328     // Making sure transfer is approved
329     require(_approved(newOwner, _tokenId));
330 
331     _transfer(oldOwner, newOwner, _tokenId);
332   }
333 
334   /// @param _owner The owner whose item23 tokens we are interested in.
335   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
336   ///  expensive (it walks the entire Item23s array looking for item23s belonging to owner),
337   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
338   ///  not contract-to-contract calls.
339   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
340     uint256 tokenCount = balanceOf(_owner);
341     if (tokenCount == 0) {
342         // Return an empty array
343       return new uint256[](0);
344     } else {
345       uint256[] memory result = new uint256[](tokenCount);
346       uint256 totalItem23s = totalSupply();
347       uint256 resultIndex = 0;
348       uint256 item23Id;
349       for (item23Id = 0; item23Id <= totalItem23s; item23Id++) {
350         if (item23IndexToOwner[item23Id] == _owner) {
351           result[resultIndex] = item23Id;
352           resultIndex++;
353         }
354       }
355       return result;
356     }
357   }
358 
359   /// For querying totalSupply of token
360   /// @dev Required for ERC-721 compliance.
361   function totalSupply() public view returns (uint256 total) {
362     return item23s.length;
363   }
364 
365   /// Owner initates the transfer of the token to another account
366   /// @param _to The address for the token to be transferred to.
367   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
368   /// @dev Required for ERC-721 compliance.
369   function transfer(
370     address _to,
371     uint256 _tokenId
372   ) public {
373     require(_owns(msg.sender, _tokenId));
374     require(_addressNotNull(_to));
375     _transfer(msg.sender, _to, _tokenId);
376   }
377 
378   /// Third-party initiates transfer of token from address _from to address _to
379   /// @param _from The address for the token to be transferred from.
380   /// @param _to The address for the token to be transferred to.
381   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
382   /// @dev Required for ERC-721 compliance.
383   function transferFrom(
384     address _from,
385     address _to,
386     uint256 _tokenId
387   ) public {
388     require(_owns(_from, _tokenId));
389     require(_approved(_to, _tokenId));
390     require(_addressNotNull(_to));
391     _transfer(_from, _to, _tokenId);
392   }
393 
394   /*** PRIVATE FUNCTIONS ***/
395   /// Safety check on _to address to prevent against an unexpected 0x0 default.
396   function _addressNotNull(address _to) private pure returns (bool) {
397     return _to != address(0);
398   }
399 
400   /// For checking approval of transfer for address _to
401   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
402     return item23IndexToApproved[_tokenId] == _to;
403   }
404 
405   /// For creating Item23
406   function _createItem23(string _name, address _owner, uint256 _price) private {
407     Item23 memory _item23 = Item23({
408       name: _name
409     });
410     uint256 newItem23Id = item23s.push(_item23) - 1;
411 
412     // It's probably never going to happen, 4 billion tokens are A LOT, but
413     // let's just be 100% sure we never let this happen.
414     require(newItem23Id == uint256(uint32(newItem23Id)));
415 
416     Birth(newItem23Id, _name, _owner);
417 
418     item23IndexToPrice[newItem23Id] = _price;
419     item23IndexToPreviousPrice[newItem23Id] = 0;
420     item23IndexToPreviousOwners[newItem23Id] =
421         [address(this), address(this), address(this), address(this)];
422 
423     // This will assign ownership, and also emit the Transfer event as
424     // per ERC721 draft
425     _transfer(address(0), _owner, newItem23Id);
426   }
427 
428   /// Check for token ownership
429   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
430     return claimant == item23IndexToOwner[_tokenId];
431   }
432 
433   /// For paying out balance on contract
434   function _payout(address _to) private {
435     if (_to == address(0)) {
436       ceoAddress.transfer(this.balance);
437     } else {
438       _to.transfer(this.balance);
439     }
440   }
441 
442   /// @dev Assigns ownership of a specific Item23 to an address.
443   function _transfer(address _from, address _to, uint256 _tokenId) private {
444     // Since the number of item23s is capped to 2^32 we can't overflow this
445     ownershipTokenCount[_to]++;
446     //transfer ownership
447     item23IndexToOwner[_tokenId] = _to;
448     // When creating new item23s _from is 0x0, but we can't account that address.
449     if (_from != address(0)) {
450       ownershipTokenCount[_from]--;
451       // clear any previously approved ownership exchange
452       delete item23IndexToApproved[_tokenId];
453     }
454     // Update the item23IndexToPreviousOwners
455     item23IndexToPreviousOwners[_tokenId][4]=item23IndexToPreviousOwners[_tokenId][3];
456     item23IndexToPreviousOwners[_tokenId][3]=item23IndexToPreviousOwners[_tokenId][2];
457     item23IndexToPreviousOwners[_tokenId][2]=item23IndexToPreviousOwners[_tokenId][1];
458     item23IndexToPreviousOwners[_tokenId][1]=item23IndexToPreviousOwners[_tokenId][0];
459     // the _from address for creation is 0, so instead set it to the contract address
460     if (_from != address(0)) {
461         item23IndexToPreviousOwners[_tokenId][0]=_from;
462     } else {
463         item23IndexToPreviousOwners[_tokenId][0]=address(this);
464     }
465     // Emit the transfer event.
466     Transfer(_from, _to, _tokenId);
467   }
468 }
469 
470 
471 library SafeMath {
472 
473   /**
474   * @dev Multiplies two numbers, throws on overflow.
475   */
476   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
477     if (a == 0) {
478       return 0;
479     }
480     uint256 c = a * b;
481     assert(c / a == b);
482     return c;
483   }
484 
485   /**
486   * @dev Integer division of two numbers, truncating the quotient.
487   */
488   function div(uint256 a, uint256 b) internal pure returns (uint256) {
489     // assert(b > 0); // Solidity automatically throws when dividing by 0
490     uint256 c = a / b;
491     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
492     return c;
493   }
494 
495   /**
496   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
497   */
498   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
499     assert(b <= a);
500     return a - b;
501   }
502 
503   /**
504   * @dev Adds two numbers, throws on overflow.
505   */
506   function add(uint256 a, uint256 b) internal pure returns (uint256) {
507     uint256 c = a + b;
508     assert(c >= a);
509     return c;
510   }
511 }