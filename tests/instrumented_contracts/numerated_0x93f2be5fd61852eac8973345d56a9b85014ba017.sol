1 pragma solidity ^0.4.18; // solhint-disable-line
2 // .
3 //                       .:.
4 //                       :|:
5 //                      .:|:.
6 //                      ::|::
7 //       :.             ::|::             .:
8 //       :|:.          .::|::.          .:|:
9 //       ::|:.         :::|:::         .:|:;
10 //       `::|:.        :::|:::        .:|::'
11 //        ::|::.       :::|:::       .::|:;
12 //        `::|::.      :::|:::      .::|::'
13 //         :::|::.     :::|:::     .::|::;
14 //         `:::|::.    :::|:::    .::|::;'
15 //`::.      `:::|::.   :::|:::   .::|::;'      .:;'
16 // `:::..     ¹::|::.  :::|:::  .::|::¹    ..::;'
17 //   `:::::.    ':|::. :::|::: .::|:'   ,::::;'
18 //     `:::::.    ':|:::::|:::::|:'   :::::;'
19 //       `:::::.:::::|::::|::::|::::.,:::;'
20 //          ':::::::::|:::|:::|:::::::;:'
21 //             ':::::::|::|::|:::::::''
22 //                  `::::::::::;'
23 //                 .:;'' ::: ``::.
24 //                      :':':
25 //
26 // EtherDank.com - Marijuana Crypto Collectibes & Hot Potato Style Game
27 //
28 //
29 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
30 /// @author  <EtherDank> (http://etherdank.com)
31 contract ERC721 {
32   // Required methods
33   function approve(address _to, uint256 _tokenId) public;
34   function balanceOf(address _owner) public view returns (uint256 balance);
35   function implementsERC721() public pure returns (bool);
36   function ownerOf(uint256 _tokenId) public view returns (address addr);
37   function takeOwnership(uint256 _tokenId) public;
38   function totalSupply() public view returns (uint256 total);
39   function transferFrom(address _from, address _to, uint256 _tokenId) public;
40   function transfer(address _to, uint256 _tokenId) public;
41 
42   event Transfer(address indexed from, address indexed to, uint256 tokenId);
43   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
44 
45   // Optional
46   // function name() public view returns (string name);
47   // function symbol() public view returns (string symbol);
48   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
49   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
50 }
51 
52 contract EtherDank is ERC721 {
53 
54   /*** EVENTS ***/
55 
56   /// @dev The Birth event is fired whenever a new Dank comes into existence.
57   event Birth(uint256 tokenId, string name, address owner);
58 
59   /// @dev The TokenSold event is fired whenever a token is sold.
60   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
61 
62   /// @dev Transfer event as defined in current draft of ERC721.
63   ///  ownership is assigned, including births.
64   event Transfer(address from, address to, uint256 tokenId);
65 
66   /*** CONSTANTS ***/
67 
68   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
69   string public constant NAME = "EtherDank.com"; // solhint-disable-line
70   string public constant SYMBOL = "Dank"; // solhint-disable-line
71 
72   uint256 private startingPrice = 0.00420 ether;
73   uint256 private firstStepLimit =  0.042000 ether;
74   uint256 private secondStepLimit = 0.420000 ether;
75 
76   /*** STORAGE ***/
77 
78   /// @dev A mapping from dank IDs to the address that owns them. All dank have
79   ///  some valid owner address.
80   mapping (uint256 => address) public dankIndexToOwner;
81 
82   // @dev A mapping from owner address to count of tokens that address owns.
83   //  Used internally inside balanceOf() to resolve ownership count.
84   mapping (address => uint256) private ownershipTokenCount;
85 
86   /// @dev A mapping from DankIDs to an address that has been approved to call
87   ///  transferFrom(). Each Dank can only have one approved address for transfer
88   ///  at any time. A zero value means no approval is outstanding.
89   mapping (uint256 => address) public dankIndexToApproved;
90 
91   // @dev A mapping from DankIDs to the price of the token.
92   mapping (uint256 => uint256) private dankIndexToPrice;
93 
94   // The addresses of the accounts (or contracts) that can execute actions within each roles.
95   address public ceoAddress;
96   address public cooAddress;
97 
98   /*** DATATYPES ***/
99   struct Dank {
100     string name;
101   }
102 
103   Dank[] private danks;
104 
105   /*** ACCESS MODIFIERS ***/
106   /// @dev Access modifier for CEO-only functionality
107   modifier onlyCEO() {
108     require(msg.sender == ceoAddress);
109     _;
110   }
111 
112   /// @dev Access modifier for COO-only functionality
113   modifier onlyCOO() {
114     require(msg.sender == cooAddress);
115     _;
116   }
117 
118   /// Access modifier for contract owner only functionality
119   modifier onlyCLevel() {
120     require(
121       msg.sender == ceoAddress ||
122       msg.sender == cooAddress
123     );
124     _;
125   }
126 
127   /*** CONSTRUCTOR ***/
128   function EtherDank() public {
129     ceoAddress = msg.sender;
130     cooAddress = msg.sender;
131   }
132 
133   /*** PUBLIC FUNCTIONS ***/
134   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
135   /// @param _to The address to be granted transfer approval. Pass address(0) to
136   ///  clear all approvals.
137   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
138   /// @dev Required for ERC-721 compliance.
139   function approve(
140     address _to,
141     uint256 _tokenId
142   ) public {
143     // Caller must own token.
144     require(_owns(msg.sender, _tokenId));
145 
146     dankIndexToApproved[_tokenId] = _to;
147 
148     Approval(msg.sender, _to, _tokenId);
149   }
150 
151   /// For querying balance of a particular account
152   /// @param _owner The address for balance query
153   /// @dev Required for ERC-721 compliance.
154   function balanceOf(address _owner) public view returns (uint256 balance) {
155     return ownershipTokenCount[_owner];
156   }
157 
158   /// @dev Creates a new Dank with the given name.
159   function createContractDank(string _name) public onlyCLevel {
160     _createDank(_name, address(ceoAddress), startingPrice);
161   }
162 
163   /// @notice Returns all the relevant information about a specific dank.
164   /// @param _tokenId The tokenId of the dank of interest.
165   function getDank(uint256 _tokenId) public view returns (
166     string dankName,
167     uint256 sellingPrice,
168     address owner
169   ) {
170     Dank storage dank = danks[_tokenId];
171     dankName = dank.name;
172     sellingPrice = dankIndexToPrice[_tokenId];
173     owner = dankIndexToOwner[_tokenId];
174   }
175 
176   function implementsERC721() public pure returns (bool) {
177     return true;
178   }
179 
180   /// @dev Required for ERC-721 compliance.
181   function name() public pure returns (string) {
182     return NAME;
183   }
184 
185   /// For querying owner of token
186   /// @param _tokenId The tokenID for owner inquiry
187   /// @dev Required for ERC-721 compliance.
188   function ownerOf(uint256 _tokenId)
189     public
190     view
191     returns (address owner)
192   {
193     owner = dankIndexToOwner[_tokenId];
194     require(owner != address(0));
195   }
196 
197   function payout(address _to) public onlyCLevel {
198     _payout(_to);
199   }
200 
201   // Allows someone to send ether and obtain the token
202   function purchase(uint256 _tokenId) public payable {
203     address oldOwner = dankIndexToOwner[_tokenId];
204     address newOwner = msg.sender;
205 
206     uint256 sellingPrice = dankIndexToPrice[_tokenId];
207 
208     // Making sure token owner is not sending to self
209     require(oldOwner != newOwner);
210 
211     // Safety check to prevent against an unexpected 0x0 default.
212     require(_addressNotNull(newOwner));
213 
214     // Making sure sent amount is greater than or equal to the sellingPrice
215     require(msg.value >= sellingPrice);
216 
217     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
218     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
219 
220     // Update prices
221     if (sellingPrice < firstStepLimit) {
222       // first stage
223       dankIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
224     } else if (sellingPrice < secondStepLimit) {
225       // second stage
226       dankIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
227     } else {
228       // third stage
229       dankIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);
230     }
231 
232     _transfer(oldOwner, newOwner, _tokenId);
233 
234     // Pay previous tokenOwner if owner is not contract
235     if (oldOwner != address(this)) {
236       oldOwner.transfer(payment); //(1-0.08)
237     }
238 
239     TokenSold(_tokenId, sellingPrice, dankIndexToPrice[_tokenId], oldOwner, newOwner, danks[_tokenId].name);
240 
241     msg.sender.transfer(purchaseExcess);
242   }
243 
244   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
245     return dankIndexToPrice[_tokenId];
246   }
247 
248   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
249   /// @param _newCEO The address of the new CEO
250   function setCEO(address _newCEO) public onlyCEO {
251     require(_newCEO != address(0));
252 
253     ceoAddress = _newCEO;
254   }
255 
256   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
257   /// @param _newCOO The address of the new COO
258   function setCOO(address _newCOO) public onlyCEO {
259     require(_newCOO != address(0));
260 
261     cooAddress = _newCOO;
262   }
263 
264   /// @dev Required for ERC-721 compliance.
265   function symbol() public pure returns (string) {
266     return SYMBOL;
267   }
268 
269   /// @notice Allow pre-approved user to take ownership of a token
270   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
271   /// @dev Required for ERC-721 compliance.
272   function takeOwnership(uint256 _tokenId) public {
273     address newOwner = msg.sender;
274     address oldOwner = dankIndexToOwner[_tokenId];
275 
276     // Safety check to prevent against an unexpected 0x0 default.
277     require(_addressNotNull(newOwner));
278 
279     // Making sure transfer is approved
280     require(_approved(newOwner, _tokenId));
281 
282     _transfer(oldOwner, newOwner, _tokenId);
283   }
284 
285   /// @param _owner The owner whose celebrity tokens we are interested in.
286   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
287   ///  expensive (it walks the entire danks array looking for danks belonging to owner),
288   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
289   ///  not contract-to-contract calls.
290   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
291     uint256 tokenCount = balanceOf(_owner);
292     if (tokenCount == 0) {
293         // Return an empty array
294       return new uint256[](0);
295     } else {
296       uint256[] memory result = new uint256[](tokenCount);
297       uint256 totaldanks = totalSupply();
298       uint256 resultIndex = 0;
299 
300       uint256 dankId;
301       for (dankId = 0; dankId <= totaldanks; dankId++) {
302         if (dankIndexToOwner[dankId] == _owner) {
303           result[resultIndex] = dankId;
304           resultIndex++;
305         }
306       }
307       return result;
308     }
309   }
310 
311   /// For querying totalSupply of token
312   /// @dev Required for ERC-721 compliance.
313   function totalSupply() public view returns (uint256 total) {
314     return danks.length;
315   }
316 
317   /// Owner initates the transfer of the token to another account
318   /// @param _to The address for the token to be transferred to.
319   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
320   /// @dev Required for ERC-721 compliance.
321   function transfer(
322     address _to,
323     uint256 _tokenId
324   ) public {
325     require(_owns(msg.sender, _tokenId));
326     require(_addressNotNull(_to));
327 
328     _transfer(msg.sender, _to, _tokenId);
329   }
330 
331   /// Third-party initiates transfer of token from address _from to address _to
332   /// @param _from The address for the token to be transferred from.
333   /// @param _to The address for the token to be transferred to.
334   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
335   /// @dev Required for ERC-721 compliance.
336   function transferFrom(
337     address _from,
338     address _to,
339     uint256 _tokenId
340   ) public {
341     require(_owns(_from, _tokenId));
342     require(_approved(_to, _tokenId));
343     require(_addressNotNull(_to));
344 
345     _transfer(_from, _to, _tokenId);
346   }
347 
348   /*** PRIVATE FUNCTIONS ***/
349   /// Safety check on _to address to prevent against an unexpected 0x0 default.
350   function _addressNotNull(address _to) private pure returns (bool) {
351     return _to != address(0);
352   }
353 
354   /// For checking approval of transfer for address _to
355   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
356     return dankIndexToApproved[_tokenId] == _to;
357   }
358 
359   /// For creating Dank
360   function _createDank(string _name, address _owner, uint256 _price) private {
361     Dank memory _dank = Dank({
362       name: _name
363     });
364     uint256 newDankId = danks.push(_dank) - 1;
365 
366     // It's probably never going to happen, 4 billion tokens are A LOT, but
367     // let's just be 100% sure we never let this happen.
368     require(newDankId == uint256(uint32(newDankId)));
369 
370     Birth(newDankId, _name, _owner);
371 
372     dankIndexToPrice[newDankId] = _price;
373 
374     // This will assign ownership, and also emit the Transfer event as
375     // per ERC721 draft
376     _transfer(address(0), _owner, newDankId);
377   }
378 
379   /// Check for token ownership
380   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
381     return claimant == dankIndexToOwner[_tokenId];
382   }
383 
384   /// For paying out balance on contract
385   function _payout(address _to) private {
386     if (_to == address(0)) {
387       ceoAddress.transfer(this.balance);
388     } else {
389       _to.transfer(this.balance);
390     }
391   }
392 
393   /// @dev Assigns ownership of a specific Dank to an address.
394   function _transfer(address _from, address _to, uint256 _tokenId) private {
395     // Since the number of danks is capped to 2^32 we can't overflow this
396     ownershipTokenCount[_to]++;
397     //transfer ownership
398     dankIndexToOwner[_tokenId] = _to;
399 
400     // When creating new danks _from is 0x0, but we can't account that address.
401     if (_from != address(0)) {
402       ownershipTokenCount[_from]--;
403       // clear any previously approved ownership exchange
404       delete dankIndexToApproved[_tokenId];
405     }
406 
407     // Emit the transfer event.
408     Transfer(_from, _to, _tokenId);
409   }
410 }
411 library SafeMath {
412 
413   /**
414   * @dev Multiplies two numbers, throws on overflow.
415   */
416   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
417     if (a == 0) {
418       return 0;
419     }
420     uint256 c = a * b;
421     assert(c / a == b);
422     return c;
423   }
424 
425   /**
426   * @dev Integer division of two numbers, truncating the quotient.
427   */
428   function div(uint256 a, uint256 b) internal pure returns (uint256) {
429     // assert(b > 0); // Solidity automatically throws when dividing by 0
430     uint256 c = a / b;
431     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
432     return c;
433   }
434 
435   /**
436   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
437   */
438   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
439     assert(b <= a);
440     return a - b;
441   }
442 
443   /**
444   * @dev Adds two numbers, throws on overflow.
445   */
446   function add(uint256 a, uint256 b) internal pure returns (uint256) {
447     uint256 c = a + b;
448     assert(c >= a);
449     return c;
450   }
451 }