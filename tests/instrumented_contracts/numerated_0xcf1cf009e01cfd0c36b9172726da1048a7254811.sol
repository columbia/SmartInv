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
23 contract EtherSoccer is ERC721 {
24 
25   /*** EVENTS ***/
26 
27   /// @dev The Birth event is fired whenever a new item23 comes into existence.
28   event Birth(uint256 tokenId, string name, address owner);
29 
30   /// @dev The TokenSold event is fired whenever a token is sold.
31   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
32 
33   /// @dev Transfer event as defined in current draft of ERC721.
34   ///  ownership is assigned, including births.
35   event Transfer(address from, address to, uint256 tokenId);
36 
37   /*** CONSTANTS ***/
38   //uint256 private startingPrice = 0.001 ether;
39 
40   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
41   string public constant NAME = "CryptoTeam"; // solhint-disable-line
42   string public constant SYMBOL = "CryptoSoccer"; // solhint-disable-line
43 
44   /*** STORAGE ***/
45 
46   /// @dev A mapping from item23 IDs to the address that owns them. All item23s have
47   ///  some valid owner address.
48   mapping (uint256 => address) public item23IndexToOwner;
49 
50   // @dev A mapping from owner address to count of tokens that address owns.
51   //  Used internally inside balanceOf() to resolve ownership count.
52   mapping (address => uint256) private ownershipTokenCount;
53 
54   /// @dev A mapping from Item23IDs to an address that has been approved to call
55   ///  transferFrom(). Each Item23 can only have one approved address for transfer
56   ///  at any time. A zero value means no approval is outstanding.
57   mapping (uint256 => address) public item23IndexToApproved;
58 
59   // @dev A mapping from Item23IDs to the price of the token.
60   mapping (uint256 => uint256) private item23IndexToPrice;
61 
62   /// @dev A mapping from Item23IDs to the previpus price of the token. Used
63   /// to calculate price delta for payouts
64   mapping (uint256 => uint256) private item23IndexToPreviousPrice;
65 
66   // @dev A mapping from item23Id to the 7 last owners.
67   mapping (uint256 => address[5]) private item23IndexToPreviousOwners;
68 
69 
70   // The addresses of the accounts (or contracts) that can execute actions within each roles.
71   address public ceoAddress;
72   address public cooAddress;
73 
74   /*** DATATYPES ***/
75   struct Item23 {
76     string name;
77   }
78 
79   Item23[] private item23s;
80 
81   /*** ACCESS MODIFIERS ***/
82   /// @dev Access modifier for CEO-only functionality
83   modifier onlyCEO() {
84     require(msg.sender == ceoAddress);
85     _;
86   }
87 
88   /// @dev Access modifier for COO-only functionality
89   modifier onlyCOO() {
90     require(msg.sender == cooAddress);
91     _;
92   }
93 
94   /// Access modifier for contract owner only functionality
95   modifier onlyCLevel() {
96     require(
97       msg.sender == ceoAddress ||
98       msg.sender == cooAddress
99     );
100     _;
101   }
102 
103   /*** CONSTRUCTOR ***/
104   function EtherSoccer() public {
105     ceoAddress = msg.sender;
106     cooAddress = msg.sender;
107   }
108 
109   /*** PUBLIC FUNCTIONS ***/
110   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
111   /// @param _to The address to be granted transfer approval. Pass address(0) to
112   ///  clear all approvals.
113   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
114   /// @dev Required for ERC-721 compliance.
115   function approve(
116     address _to,
117     uint256 _tokenId
118   ) public {
119     // Caller must own token.
120     require(_owns(msg.sender, _tokenId));
121 
122     item23IndexToApproved[_tokenId] = _to;
123 
124     Approval(msg.sender, _to, _tokenId);
125   }
126 
127   /// For querying balance of a particular account
128   /// @param _owner The address for balance query
129   /// @dev Required for ERC-721 compliance.
130   function balanceOf(address _owner) public view returns (uint256 balance) {
131     return ownershipTokenCount[_owner];
132   }
133 
134   /// @dev Creates a new Item23 with the given name.
135   function createContractItem23(string _name , string _startingP ) public onlyCOO {
136     _createItem23(_name, address(this), stringToUint( _startingP));
137   }
138 
139 
140 
141 function stringToUint(string _amount) internal constant returns (uint result) {
142     bytes memory b = bytes(_amount);
143     uint i;
144     uint counterBeforeDot;
145     uint counterAfterDot;
146     result = 0;
147     uint totNum = b.length;
148     totNum--;
149     bool hasDot = false;
150 
151     for (i = 0; i < b.length; i++) {
152         uint c = uint(b[i]);
153 
154         if (c >= 48 && c <= 57) {
155             result = result * 10 + (c - 48);
156             counterBeforeDot ++;
157             totNum--;
158         }
159 
160         if(c == 46){
161             hasDot = true;
162             break;
163         }
164     }
165 
166     if(hasDot) {
167         for (uint j = counterBeforeDot + 1; j < 18; j++) {
168             uint m = uint(b[j]);
169 
170             if (m >= 48 && m <= 57) {
171                 result = result * 10 + (m - 48);
172                 counterAfterDot ++;
173                 totNum--;
174             }
175 
176             if(totNum == 0){
177                 break;
178             }
179         }
180     }
181      if(counterAfterDot < 18){
182          uint addNum = 18 - counterAfterDot;
183          uint multuply = 10 ** addNum;
184          return result = result * multuply;
185      }
186 
187      return result;
188 }
189 
190 
191   /// @notice Returns all the relevant information about a specific item23.
192   /// @param _tokenId The tokenId of the item23 of interest.
193   function getItem23(uint256 _tokenId) public view returns (
194     string item23Name,
195     uint256 sellingPrice,
196     address owner,
197     uint256 previousPrice,
198     address[5] previousOwners
199   ) {
200     Item23 storage item23 = item23s[_tokenId];
201     item23Name = item23.name;
202     sellingPrice = item23IndexToPrice[_tokenId];
203     owner = item23IndexToOwner[_tokenId];
204     previousPrice = item23IndexToPreviousPrice[_tokenId];
205     previousOwners = item23IndexToPreviousOwners[_tokenId];
206   }
207 
208 
209   function implementsERC721() public pure returns (bool) {
210     return true;
211   }
212 
213   /// @dev Required for ERC-721 compliance.
214   function name() public pure returns (string) {
215     return NAME;
216   }
217 
218   /// For querying owner of token
219   /// @param _tokenId The tokenID for owner inquiry
220   /// @dev Required for ERC-721 compliance.
221   function ownerOf(uint256 _tokenId)
222     public
223     view
224     returns (address owner)
225   {
226     owner = item23IndexToOwner[_tokenId];
227     require(owner != address(0));
228   }
229 
230   function payout(address _to) public onlyCLevel {
231     _payout(_to);
232   }
233 
234   // Allows someone to send ether and obtain the token
235   function purchase(uint256 _tokenId) public payable {
236     address oldOwner = item23IndexToOwner[_tokenId];
237     address newOwner = msg.sender;
238 
239     address[5] storage previousOwners = item23IndexToPreviousOwners[_tokenId];
240 
241     uint256 sellingPrice = item23IndexToPrice[_tokenId];
242     uint256 previousPrice = item23IndexToPreviousPrice[_tokenId];
243     // Making sure token owner is not sending to self
244     require(oldOwner != newOwner);
245 
246     // Safety check to prevent against an unexpected 0x0 default.
247     require(_addressNotNull(newOwner));
248 
249     // Making sure sent amount is greater than or equal to the sellingPrice
250     require(msg.value >= sellingPrice);
251 
252     uint256 priceDelta = SafeMath.sub(sellingPrice, previousPrice);
253     uint256 ownerPayout = SafeMath.add(previousPrice, SafeMath.mul(SafeMath.div(priceDelta, 100), 40));
254 
255 
256     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
257 
258     item23IndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
259     item23IndexToPreviousPrice[_tokenId] = sellingPrice;
260 
261     uint256 strangePrice = uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10));
262     uint256 strangePrice2 = uint256(0);
263 
264 
265     // Pay previous tokenOwner if owner is not contract
266     // and if previous price is not 0
267     if (oldOwner != address(this)) {
268       // old owner gets entire initial payment back
269       oldOwner.transfer(ownerPayout);
270     } else {
271       strangePrice = SafeMath.add(ownerPayout, strangePrice);
272     }
273 
274     // Next distribute payout Total among previous Owners
275     for (uint i = 0; i < 5; i++) {
276         if (previousOwners[i] != address(this)) {
277             strangePrice2+=uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10));
278         } else {
279             strangePrice = SafeMath.add(strangePrice, uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10)));
280         }
281     }
282 
283     ceoAddress.transfer(strangePrice+strangePrice2);
284     //ceoAddress.transfer(strangePrice2);
285     _transfer(oldOwner, newOwner, _tokenId);
286 
287     //TokenSold(_tokenId, sellingPrice, item23IndexToPrice[_tokenId], oldOwner, newOwner, item23s[_tokenId].name);
288 
289     msg.sender.transfer(purchaseExcess);
290   }
291 
292 
293   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
294     return item23IndexToPrice[_tokenId];
295   }
296 
297   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
298   /// @param _newCEO The address of the new CEO
299   function setCEO(address _newCEO) public onlyCEO {
300     require(_newCEO != address(0));
301 
302     ceoAddress = _newCEO;
303   }
304 
305   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
306   /// @param _newCOO The address of the new COO
307   function setCOO(address _newCOO) public onlyCEO {
308     require(_newCOO != address(0));
309     cooAddress = _newCOO;
310   }
311 
312   /// @dev Required for ERC-721 compliance.
313   function symbol() public pure returns (string) {
314     return SYMBOL;
315   }
316 
317   /// @notice Allow pre-approved user to take ownership of a token
318   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
319   /// @dev Required for ERC-721 compliance.
320   function takeOwnership(uint256 _tokenId) public {
321     address newOwner = msg.sender;
322     address oldOwner = item23IndexToOwner[_tokenId];
323 
324     // Safety check to prevent against an unexpected 0x0 default.
325     require(_addressNotNull(newOwner));
326 
327     // Making sure transfer is approved
328     require(_approved(newOwner, _tokenId));
329 
330     _transfer(oldOwner, newOwner, _tokenId);
331   }
332 
333   /// @param _owner The owner whose item23 tokens we are interested in.
334   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
335   ///  expensive (it walks the entire Item23s array looking for item23s belonging to owner),
336   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
337   ///  not contract-to-contract calls.
338   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
339     uint256 tokenCount = balanceOf(_owner);
340     if (tokenCount == 0) {
341         // Return an empty array
342       return new uint256[](0);
343     } else {
344       uint256[] memory result = new uint256[](tokenCount);
345       uint256 totalItem23s = totalSupply();
346       uint256 resultIndex = 0;
347       uint256 item23Id;
348       for (item23Id = 0; item23Id <= totalItem23s; item23Id++) {
349         if (item23IndexToOwner[item23Id] == _owner) {
350           result[resultIndex] = item23Id;
351           resultIndex++;
352         }
353       }
354       return result;
355     }
356   }
357 
358   /// For querying totalSupply of token
359   /// @dev Required for ERC-721 compliance.
360   function totalSupply() public view returns (uint256 total) {
361     return item23s.length;
362   }
363 
364   /// Owner initates the transfer of the token to another account
365   /// @param _to The address for the token to be transferred to.
366   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
367   /// @dev Required for ERC-721 compliance.
368   function transfer(
369     address _to,
370     uint256 _tokenId
371   ) public {
372     require(_owns(msg.sender, _tokenId));
373     require(_addressNotNull(_to));
374     _transfer(msg.sender, _to, _tokenId);
375   }
376 
377   /// Third-party initiates transfer of token from address _from to address _to
378   /// @param _from The address for the token to be transferred from.
379   /// @param _to The address for the token to be transferred to.
380   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
381   /// @dev Required for ERC-721 compliance.
382   function transferFrom(
383     address _from,
384     address _to,
385     uint256 _tokenId
386   ) public {
387     require(_owns(_from, _tokenId));
388     require(_approved(_to, _tokenId));
389     require(_addressNotNull(_to));
390     _transfer(_from, _to, _tokenId);
391   }
392 
393   /*** PRIVATE FUNCTIONS ***/
394   /// Safety check on _to address to prevent against an unexpected 0x0 default.
395   function _addressNotNull(address _to) private pure returns (bool) {
396     return _to != address(0);
397   }
398 
399   /// For checking approval of transfer for address _to
400   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
401     return item23IndexToApproved[_tokenId] == _to;
402   }
403 
404   /// For creating Item23
405   function _createItem23(string _name, address _owner, uint256 _price) private {
406     Item23 memory _item23 = Item23({
407       name: _name
408     });
409     uint256 newItem23Id = item23s.push(_item23) - 1;
410 
411     // It's probably never going to happen, 4 billion tokens are A LOT, but
412     // let's just be 100% sure we never let this happen.
413     require(newItem23Id == uint256(uint32(newItem23Id)));
414 
415     Birth(newItem23Id, _name, _owner);
416 
417     item23IndexToPrice[newItem23Id] = _price;
418     item23IndexToPreviousPrice[newItem23Id] = 0;
419     item23IndexToPreviousOwners[newItem23Id] =
420         [address(this), address(this), address(this), address(this)];
421 
422     // This will assign ownership, and also emit the Transfer event as
423     // per ERC721 draft
424     _transfer(address(0), _owner, newItem23Id);
425   }
426 
427   /// Check for token ownership
428   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
429     return claimant == item23IndexToOwner[_tokenId];
430   }
431 
432   /// For paying out balance on contract
433   function _payout(address _to) private {
434     if (_to == address(0)) {
435       ceoAddress.transfer(this.balance);
436     } else {
437       _to.transfer(this.balance);
438     }
439   }
440 
441   /// @dev Assigns ownership of a specific Item23 to an address.
442   function _transfer(address _from, address _to, uint256 _tokenId) private {
443     // Since the number of item23s is capped to 2^32 we can't overflow this
444     ownershipTokenCount[_to]++;
445     //transfer ownership
446     item23IndexToOwner[_tokenId] = _to;
447     // When creating new item23s _from is 0x0, but we can't account that address.
448     if (_from != address(0)) {
449       ownershipTokenCount[_from]--;
450       // clear any previously approved ownership exchange
451       delete item23IndexToApproved[_tokenId];
452     }
453     // Update the item23IndexToPreviousOwners
454     item23IndexToPreviousOwners[_tokenId][4]=item23IndexToPreviousOwners[_tokenId][3];
455     item23IndexToPreviousOwners[_tokenId][3]=item23IndexToPreviousOwners[_tokenId][2];
456     item23IndexToPreviousOwners[_tokenId][2]=item23IndexToPreviousOwners[_tokenId][1];
457     item23IndexToPreviousOwners[_tokenId][1]=item23IndexToPreviousOwners[_tokenId][0];
458     // the _from address for creation is 0, so instead set it to the contract address
459     if (_from != address(0)) {
460         item23IndexToPreviousOwners[_tokenId][0]=_from;
461     } else {
462         item23IndexToPreviousOwners[_tokenId][0]=address(this);
463     }
464     // Emit the transfer event.
465     Transfer(_from, _to, _tokenId);
466   }
467 }
468 
469 
470 library SafeMath {
471 
472   /**
473   * @dev Multiplies two numbers, throws on overflow.
474   */
475   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
476     if (a == 0) {
477       return 0;
478     }
479     uint256 c = a * b;
480     assert(c / a == b);
481     return c;
482   }
483 
484   /**
485   * @dev Integer division of two numbers, truncating the quotient.
486   */
487   function div(uint256 a, uint256 b) internal pure returns (uint256) {
488     // assert(b > 0); // Solidity automatically throws when dividing by 0
489     uint256 c = a / b;
490     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
491     return c;
492   }
493 
494   /**
495   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
496   */
497   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
498     assert(b <= a);
499     return a - b;
500   }
501 
502   /**
503   * @dev Adds two numbers, throws on overflow.
504   */
505   function add(uint256 a, uint256 b) internal pure returns (uint256) {
506     uint256 c = a + b;
507     assert(c >= a);
508     return c;
509   }
510 }